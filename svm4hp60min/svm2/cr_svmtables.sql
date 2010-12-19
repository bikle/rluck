--
-- cr_svmtables.sql
--

-- I use this script when I setup SVM on a new host.
-- So, I rarely run this script.

-- The scripts listed below depend on the SVM tables:
-- score.sql
-- score_gattn.sql

BEGIN
  DBMS_DATA_MINING_TRANSFORM.CREATE_MISS_NUM (miss_table_name => 'svmc_miss_num');
  DBMS_DATA_MINING_TRANSFORM.CREATE_MISS_CAT (miss_table_name => 'svmc_miss_cat');
  DBMS_DATA_MINING_TRANSFORM.CREATE_CLIP (clip_table_name => 'svmc_clip');
  DBMS_DATA_MINING_TRANSFORM.CREATE_NORM_LIN (norm_table_name => 'svmc_norm');
END;
/

-- DROP TABLE svmc_settings;
CREATE TABLE svmc_settings ( setting_name  VARCHAR2(30), setting_value VARCHAR2(30));
-- DELETE svmc_settings;


BEGIN
-- Populate settings table
  INSERT INTO svmc_settings (setting_name, setting_value) VALUES
  (dbms_data_mining.algo_name, dbms_data_mining.algo_support_vector_machines);

  INSERT INTO svmc_settings (setting_name, setting_value) VALUES
  (dbms_data_mining.svms_kernel_function, dbms_data_mining.svms_gaussian);

  INSERT INTO svmc_settings (setting_name, setting_value) VALUES
  (dbms_data_mining.svms_kernel_cache_size,300123123);
  COMMIT;
END;
/

-- SELECT * FROM svmc_miss_cat;
-- SELECT * FROM svmc_clip;
-- SELECT * FROM svmc_norm;
SELECT * FROM svmc_settings;
