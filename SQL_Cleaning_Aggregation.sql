CREATE SCHEMA cscsql;
USE cscsql;
SET GLOBAL local_infile = 1;

-- Part 1: Data cleaning and segmentation
	-- PA_File_A cleaning
	
-- use Data Import Wizard tool to import PA_File_A.csv into a table called "pa_a"
DELETE FROM pa_a; -- clear all contents, only keep columns and data types
LOAD DATA LOCAL INFILE 'C:\\Users\\thach\\OneDrive\\Desktop\\SQL Exercise\\PA_File_A.csv' 
	INTO TABLE pa_a 
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;

CREATE TABLE pa_a_cleaned
AS (SELECT
	`Customer ID No`,
	nullif(trim(trim(leading ', ' from `Agreement Suffix No`)), '') as `Agreement Suffix No`,
    nullif(trim(trim(both ',' from `Customer Pre Name`)), '') as `Customer Pre Name`,
    nullif(trim(trim(both ',' from `Customer Suffix Code`)), '') as `Customer Suffix Code`,
    nullif(trim(trim(both ',' from `Address Box No`)), '') as `Address Box No`,
    nullif(trim(substring_index(replace(replace(replace(`Address TX`, '(', ''), ')', ''), '-', ''), ',', -1)), '') as `Address TX`,
    null as `City`,
    nullif(trim(trim(both ',' from `Provincial Code`)), '') as `Provincial Code`,
    nullif(trim(trim(both ',' from `Postal Number`)), '') as `Postal Code`,
    case
		when locate(',', `Item Suffix Number`, 4) > 0 then nullif(trim(substring_index(substring(`Item Suffix Number`, 2), ',', 1)), '')
        else nullif(trim(substring_index(`Item Suffix Number`, ',', -1)), '')
	end as `Item Suffix Number`,
    `Mechandise Code` as `Merchandise Code`,
    `Item Gross Sale Amount`,
    case 
		when locate(',', `PA Start Date`, 4) > 0 then date_format(substring_index(substring(`PA Start Date`, 2), ',', 1), "%Y-%m-%d")
        else date_format(substring(`PA Start Date`, 2), "%Y-%m-%d")
	end as `PA Start Date`,
    case
		when locate(',', `PA End Date`)  > 1 then date_format(substring_index(`PA End Date`, ',', 1), "%Y-%m-%d")
        else date_format(substring_index(substring(`PA End Date`, 2), ',', 1), "%Y-%m-%d")
	end as `PA End Date`,
    nullif(trim(substring_index(`Merch Division Number`, ',', 1)), '') as `Merch Division Number`,
    if(locate(',', `Item Number`) = 1, nullif(trim(substring(`Item Number`, 2)), ''), nullif(trim(substring_index(`Item Number`, ',', 1)), '')) as `Item Number`,
    if(locate(',', `Model Number`) = 1, nullif(trim(substring(`Model Number`, 2)), ''), nullif(trim(substring_index(`Model Number`, ',', 1)), '')) as `Model Number`,
    case
		when locate(',', `Model Description`) = 1 then nullif(trim(substring(`Model Description`, 2)), '')
        when locate(' ,', `Model Description`) > 1 then nullif(trim(substring_index(`Model Description`, ' ,', 1)), '')
        else null
	end as `Model Description`,
    nullif(trim(trim(both ',' from substring(`Brand Name`, 2))), '') as `Brand Name`
from pa_a);

ALTER TABLE pa_a_cleaned
	MODIFY COLUMN `Customer ID No` bigint,
	MODIFY COLUMN `Agreement Suffix No` int,
	MODIFY COLUMN `Customer Pre Name` varchar(10),
	MODIFY COLUMN `Customer Suffix Code` varchar(20),
	MODIFY COLUMN `Address Box No` varchar(40),
	MODIFY COLUMN `Address TX` varchar(40),
	MODIFY COLUMN `City` varchar(40),
	MODIFY COLUMN `Provincial Code` varchar(10),
	MODIFY COLUMN `Postal Code` varchar(10),
	MODIFY COLUMN `Item Suffix Number` varchar(40),
	MODIFY COLUMN `Merchandise Code` int,
	MODIFY COLUMN `Item Gross Sale Amount` float,
	MODIFY COLUMN `PA Start Date` date,
	MODIFY COLUMN `PA End Date` date,
	MODIFY COLUMN `Merch Division Number` int,
	MODIFY COLUMN `Item Number` int,
	MODIFY COLUMN `Model Number` varchar(40),
	MODIFY COLUMN `Model Description` varchar(40),
	MODIFY COLUMN `Brand Name` varchar(40);
    
		-- PA_File_B cleaning

-- use Data Import Wizard tool to import PA_File_B.csv into a table called "pa_b"
DELETE FROM pa_b; -- clear all contents, only keep columns and data types
LOAD DATA LOCAL INFILE 'C:\\Users\\thach\\OneDrive\\Desktop\\SQL Exercise\\PA_File_B.csv' 
	INTO TABLE pa_b
    CHARACTER SET latin1
    FIELDS TERMINATED BY ',' 
    ENCLOSED BY '"' 
    LINES TERMINATED BY '\r\n' 
    IGNORE 1 LINES;
    
CREATE TABLE pa_b_cleaned
AS (SELECT
	`Customer ID No`,
	`Agreement Suffix No`,
    nullif(trim(trim(both ',' from `Customer Pre Name`)), '') as `Customer Pre Name`,
    nullif(substring_index(`Customer Suffix Code`, ',', -1), '') as `Customer Suffix Code`,
    nullif(trim(trim(both ',' from `Street`)), '') as `Address Box No`,
    nullif(trim(replace(replace(replace(replace(concat(`Street Name`, substring_index(`City`, ',', 1)), '(', ''), ')', ''), '-', ''), ',', '')), '') as `Address TX`,
    nullif(trim(substring_index(`City`, ',', -1)), '') as `City`,
    substring(`Prov`, 2) as `Provincial Code`,
    nullif(trim(trim(both ',' from `Postal Code`)), '') as `Postal Code`,
    nullif(trim(substring_index(`Item Suffix Number`, ',', -1)), '') as `Item Suffix Number`,
    `Mechandise Code` as `Merchandise Code`,
    `Model ID Number` as `Item Gross Sale Amount`,
    date_format(trim(both ',' from `Item Gross Sale Amount`), "%Y-%m-%d") as `PA Start Date`,
    date_format(trim(both ',' from `PA Start Date`), "%Y-%m-%d") as `PA End Date`,
    nullif(trim(trim(both ',' from `PA End Date`)), '') as `Merch Division Number`,
    nullif(trim(trim(both ',' from `Merch Divi Number`)), '') as `Item Number`,
    nullif(trim(trim(both '*' from concat(`Item Number`, substring_index(`Model Number`, ',', 1)))), '') as `Model Number`,
    nullif(substring(`Model Number`, locate(',', `Model Number`)+1), '') as `Model Description`,
    nullif(trim(substring_index(`Brand Name`, ',', -1)), '') as `Brand Name`
from pa_b);

ALTER TABLE pa_b_cleaned
	MODIFY COLUMN `Customer ID No` bigint,
	MODIFY COLUMN `Agreement Suffix No` int,
	MODIFY COLUMN `Customer Pre Name` varchar(10),
	MODIFY COLUMN `Customer Suffix Code` varchar(20),
	MODIFY COLUMN `Address Box No` varchar(40),
	MODIFY COLUMN `Address TX` varchar(40),
	MODIFY COLUMN `City` varchar(40),
	MODIFY COLUMN `Provincial Code` varchar(10),
	MODIFY COLUMN `Postal Code` varchar(10),
	MODIFY COLUMN `Item Suffix Number` varchar(40),
	MODIFY COLUMN `Merchandise Code` int,
	MODIFY COLUMN `Item Gross Sale Amount` float,
	MODIFY COLUMN `PA Start Date` date,
	MODIFY COLUMN `PA End Date` date,
	MODIFY COLUMN `Merch Division Number` int,
	MODIFY COLUMN `Item Number` int,
	MODIFY COLUMN `Model Number` varchar(40),
	MODIFY COLUMN `Model Description` varchar(40),
	MODIFY COLUMN `Brand Name` varchar(40);
    
-- Combine 2 datasets into 1 file, using union to remove duplicates
CREATE TABLE pa_ab_agg
AS (SELECT * from pa_a_cleaned union select * from pa_b_cleaned);

-- Export the combined dataset into CSV file using MySQL Data Export Wizard

-- Part 2: Data Manipulation

create table pa_p2_1
as (select 
	`Customer ID No`,
    count(`Item Gross Sale Amount`) as `Total Warranty Count`,
    round(sum(`Item Gross Sale Amount`), 2) as `Total Sales`,
    round(sum(datediff(`PA End Date`, `PA Start Date`)*`Item Gross Sale Amount`)/sum(`Item Gross Sale Amount`), 2) as `Weighted Averaged Warranty Life`
from pa_ab_agg
group by `Customer ID No`
order by `Customer ID No`);

SET @rownr=0;
create table pa_p2_temp 
as (SELECT @rownr:=@rownr+1 AS `indexer`, t.*
FROM (select
	`Customer ID No`,
    concat(`Brand Name`,'-',`Model Description`,'-',date_format(`PA Start Date`, '%m/%Y'),'-',date_format(`PA End Date`, '%m/%Y'),'-$',`Item Gross Sale Amount`) as Warranty
    from pa_ab_agg) AS t);
SET @posn:=0;
SET @pid:=0;
create table pa_p2_temp2
as (SELECT  
	IF(@pid=pa_p2_temp.`Customer ID No`,@posn:=@posn+1,@posn:=1) `W_no`,
	@pid:=pa_p2_temp.`Customer ID No` as `Customer ID No`,
    `Warranty`
FROM pa_p2_temp 
ORDER BY `Customer ID No`);

create table pa_p2_output
as
(select t1.`Total Warranty Count`, t1.`Total Sales`, t1.`Weighted Averaged Warranty Life`, t2.*
from pa_p2_1 as t1
inner join (select
	`Customer ID No`,
	max(case when `W_no` = 1 then `Warranty` else null end) as `Warranty 1`,
    max(case when `W_no` = 2 then `Warranty` else null end) as `Warranty 2`,
    max(case when `W_no` = 3 then `Warranty` else null end) as `Warranty 3`,
    max(case when `W_no` = 4 then `Warranty` else null end) as `Warranty 4`,
    max(case when `W_no` = 5 then `Warranty` else null end) as `Warranty 5`,
    max(case when `W_no` = 6 then `Warranty` else null end) as `Warranty 6`,
    max(case when `W_no` = 7 then `Warranty` else null end) as `Warranty 7`,
    max(case when `W_no` = 8 then `Warranty` else null end) as `Warranty 8`,
    max(case when `W_no` = 9 then `Warranty` else null end) as `Warranty 9`,
    max(case when `W_no` = 10 then `Warranty` else null end) as `Warranty 10`,
    max(case when `W_no` = 11 then `Warranty` else null end) as `Warranty 11`,
    max(case when `W_no` = 12 then `Warranty` else null end) as `Warranty 12`,
    max(case when `W_no` = 13 then `Warranty` else null end) as `Warranty 13`
from pa_p2_temp2
group by `Customer ID No`) as t2
on t1.`Customer ID No` = t2.`Customer ID No`
order by t1.`Customer ID No`);

-- Export the final output into CSV file using MySQL Data Export Wizard

-- End of work