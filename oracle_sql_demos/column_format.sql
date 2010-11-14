-- A search of the web reveals a good source for the column format syntax:
-- http://www.adp-gmbh.ch/ora/sqlplus/column.html
-- 
-- 
-- René Nyffenegger's collection of things on the web
-- 	René Nyffenegger on Oracle - Most wanted - Feedback
--  
-- 		
-- column [SQL*Plus]
-- 		
-- 
-- SQL> column colum_name alias alias_name
-- SQL> column colum_name clear
-- 
-- SQL> column colum_name entmap on
-- SQL> column colum_name entmap off
-- 
-- SQL> column colum_name fold_after
-- SQL> column colum_name fold_before
-- SQL> column colum_name format a25
-- SQL> column colum_name heading header_text
-- 
-- SQL> column colum_name justify left
-- SQL> column colum_name justify right
-- SQL> column colum_name justify center
-- 
-- SQL> column colum_name like expr|alias
-- SQL> column colum_name newline
-- SQL> column colum_name new_value variable
-- SQL> column colum_name print 
-- SQL> column colum_name noprint 
-- SQL> column colum_name old_value 
-- 
-- SQL> column colum_name on 
-- SQL> column colum_name off 
-- 
-- SQL> column colum_name wrapped 
-- SQL> column colum_name word_wrapped 
-- SQL> column colum_name truncated 
-- 
-- This command can be used to make the output in SQL*Plus prettier.
-- format
-- Specifies the format for a column (that is, how the data of the column is printed).
-- 
-- column column_name format a20
-- column column_name format a50 word_wrapped
-- column column_name format 999.999  -- Decimal sign
-- column column_name format 999,999  -- Seperate thousands
-- column column_name format $999     -- Include leading $ sign
-- 
-- noprint
-- A column that is defined noprint will, not so strangly, not be printed at all. 
--               

-- Demo:
COLUMN hw FORMAT A6
SELECT 'Hello World' hw FROM dual;
COLUMN hw FORMAT A16
SELECT 'Hello World' hw FROM dual;
