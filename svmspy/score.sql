--
-- score.sql
--

-- usage: score.sql 

-- A script which feeds data to SVM and captures the results in table svmc_apply_prep

-- DEFINE target     = 'gatt'
-- DEFINE model_name = 'svmspy100'
-- DEFINE bldtable   = 'bme'
-- DEFINE scoretable = 'sme'
-- DEFINE case_id    = 'tkrdate'

DEFINE target     = '&1'
DEFINE model_name = '&2'
DEFINE bldtable   = '&3'
DEFINE scoretable = '&4'
DEFINE case_id    = '&5'

-- Define a variable to help me exclude some columns from some data mining calls
DEFINE exclude1 = "'&target','&case_id'"

-- Builds an SVM model using pl/sql.

-----------------------------------------------------------------------
--                            BUILD THE MODEL
-----------------------------------------------------------------------

-- Cleanup old build data preparation objects for repeat runs
DELETE svmc_miss_num;
DELETE svmc_miss_cat;
DELETE svmc_clip;
DELETE svmc_norm;


-- CREATE AND POPULATE A SETTINGS TABLE
--
-- DROP   TABLE svmc_settings ;
-- CREATE TABLE svmc_settings ( setting_name  VARCHAR2(30), setting_value VARCHAR2(30));
-- DELETE svmc_settings;

-- The default classification algorithm is Naive Bayes. So override
-- this choice to SVM using a settings table.
-- SVM chooses a kernel type automatically. This choice can be overriden
-- by the user. Linear kernel is preferred high dimensional data, and
-- Gaussian kernel for low dimensional data. Here we use linear kernel
-- to demonstrate the get_model_details_svm() API, which applies only for
-- models.
--

-- Do this once and then comment it out.
-- That makes script go faster.
-- BEGIN
-- -- Populate settings table
--   INSERT INTO svmc_settings (setting_name, setting_value) VALUES
--   (dbms_data_mining.algo_name, dbms_data_mining.algo_support_vector_machines);
-- 
--   INSERT INTO svmc_settings (setting_name, setting_value) VALUES
--   (dbms_data_mining.svms_kernel_function, dbms_data_mining.svms_gaussian);
-- 
--   INSERT INTO svmc_settings (setting_name, setting_value) VALUES
--   (dbms_data_mining.svms_kernel_cache_size,190123123);
--   COMMIT;
-- END;
-- /

SELECT * FROM svmc_settings;

BEGIN EXECUTE IMMEDIATE 'DROP VIEW svmc_winsor';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW svmc_build_prep';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW xformed_build_miss_num';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

BEGIN EXECUTE IMMEDIATE 'DROP VIEW xformed_build_miss_cat';
EXCEPTION WHEN OTHERS THEN NULL; END;
/

--------------------------------
-- PREPARE BUILD (TRAINING) DATA
--

-- 1. Missing Value treatment for all Predictors and
-- 2. Outlier Treatment and
-- 3. Normalization are performed below.
--    NOTE: that unlike SVM regression, the classification target is NOT
--    normalized here.

BEGIN
  -- Perform missing value treatment for all predictors
  -- create miss tables
  --  DBMS_DATA_MINING_TRANSFORM.CREATE_MISS_NUM (miss_table_name => 'svmc_miss_num');
  --  DBMS_DATA_MINING_TRANSFORM.CREATE_MISS_CAT (miss_table_name => 'svmc_miss_cat');

  -- populate miss tables
  DBMS_DATA_MINING_TRANSFORM.INSERT_MISS_NUM_MEAN (
    miss_table_name => 'svmc_miss_num',
    data_table_name => '&bldtable',
    exclude_list    => DBMS_DATA_MINING_TRANSFORM.COLUMN_LIST (&exclude1));

  DBMS_DATA_MINING_TRANSFORM.INSERT_MISS_CAT_MODE (
    miss_table_name => 'svmc_miss_cat',
    data_table_name => '&bldtable',
    exclude_list    => DBMS_DATA_MINING_TRANSFORM.COLUMN_LIST (&exclude1));

  -- xform input data to replace missing values
  DBMS_DATA_MINING_TRANSFORM.XFORM_MISS_NUM(
    miss_table_name => 'svmc_miss_num',
    data_table_name => '&bldtable',
    xform_view_name => 'xformed_build_miss_num');
  DBMS_DATA_MINING_TRANSFORM.XFORM_MISS_CAT(
    miss_table_name => 'svmc_miss_cat',
    data_table_name => '&bldtable',
    xform_view_name => 'xformed_build_miss_cat');

  -- Perform outlier treatment.
  -- create clip table
  -- DBMS_DATA_MINING_TRANSFORM.CREATE_CLIP (clip_table_name => 'svmc_clip');

  -- populate clip table
  DBMS_DATA_MINING_TRANSFORM.INSERT_CLIP_WINSOR_TAIL (
    clip_table_name => 'svmc_clip',
    data_table_name => '&bldtable',
    tail_frac       => 0.025,
    exclude_list    => DBMS_DATA_MINING_TRANSFORM.COLUMN_LIST (&exclude1));

  -- xform input data to winsorized data
  DBMS_DATA_MINING_TRANSFORM.XFORM_CLIP(
    clip_table_name => 'svmc_clip',
    data_table_name => '&bldtable',
    xform_view_name => 'svmc_winsor');

  -- create normalization table
  -- DBMS_DATA_MINING_TRANSFORM.CREATE_NORM_LIN (norm_table_name => 'svmc_norm');

  -- populate normalization table based on winsorized data
  DBMS_DATA_MINING_TRANSFORM.INSERT_NORM_LIN_MINMAX (
    norm_table_name => 'svmc_norm',
    data_table_name => 'svmc_winsor',
    exclude_list    => DBMS_DATA_MINING_TRANSFORM.COLUMN_LIST (&exclude1));

  -- normalize the original data
  DBMS_DATA_MINING_TRANSFORM.XFORM_NORM_LIN (
    norm_table_name => 'svmc_norm',
    data_table_name => '&bldtable',
    xform_view_name => 'svmc_build_prep');
END;
/

---------------------
-- CREATE A NEW MODEL
--
-- Cleanup old model with the same name for repeat runs
BEGIN DBMS_DATA_MINING.DROP_MODEL('&model_name');
EXCEPTION WHEN OTHERS THEN NULL; END;
/

-- Build a new SVM Model
BEGIN
  DBMS_DATA_MINING.CREATE_MODEL(
    model_name          => '&model_name',
    mining_function     => dbms_data_mining.classification,
    data_table_name     => 'svmc_build_prep',
    case_id_column_name => '&case_id',
    target_column_name  => '&target',
    settings_table_name => 'svmc_settings');
END;
/

-----------------------------------------------------------------------
--                               APPLY/score THE MODEL
-----------------------------------------------------------------------

-- Cleanup old scoring data preparation objects for repeat runs
BEGIN EXECUTE IMMEDIATE 'DROP VIEW xformed_apply_miss_num';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW xformed_apply_miss_cat';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
BEGIN EXECUTE IMMEDIATE 'DROP VIEW svmc_apply_prep';
EXCEPTION WHEN OTHERS THEN NULL; END;
/
-----------------------
-- PREPARE SCORING DATA
--
-- If the data for model creation has been prepared, then the data
-- to be scored using the model must be prepared in the same manner
-- in order to obtain meaningful results.
--
-- 1. Missing Value treatment for all Predictors and
-- 2. Normalization
-- No outlier treatment will be performed during test and apply. The
-- normalization step is sufficient, since the normalization parameters
-- already capture the effects of outlier treatment done with build data.
--
BEGIN
  -- Xform Test data to replace missing values
  DBMS_DATA_MINING_TRANSFORM.XFORM_MISS_NUM(
    miss_table_name => 'svmc_miss_num',
    data_table_name => '&scoretable',
    xform_view_name => 'xformed_apply_miss_num');

  DBMS_DATA_MINING_TRANSFORM.XFORM_MISS_CAT(
    miss_table_name => 'svmc_miss_cat',
    data_table_name => '&scoretable',
    xform_view_name => 'xformed_apply_miss_cat');

  -- Normalize the data to be scored
  DBMS_DATA_MINING_TRANSFORM.XFORM_NORM_LIN (
    norm_table_name => 'svmc_norm',
    data_table_name => '&scoretable',
    xform_view_name => 'svmc_apply_prep');
END;
/
