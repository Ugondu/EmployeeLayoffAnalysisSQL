-- DATA CLEANING IN SQL USING MYSQL WORKBENCH 

-- Steps in the Cleaning of Dataset
-- 1. Removing duplicates
-- 2. Standardisation of the DataSet
-- 3. Dealing with Null and Blank Values
-- 4. Removing Irrelevant columns

-- DataSet Overview
SELECT * 
FROM employee_layoffs.layoffs
;

-- Create a duplicate copy of the dataset for manipulation
CREATE TABLE layoffs_copy
LIKE employee_layoffs.layoffs;

-- Check if the table is created
SELECT *
FROM layoffs_copy;

-- Insert data into the new table
INSERT layoffs_copy
SELECT *
FROM employee_layoffs.layoffs
;

-- Now we created the duplicate "layoffs_copy", we will manipulate the data from this table.

-- STEP 1. Remove Duplicates

-- Due to lack of index, we apply ROW() to assign numbers to the data column to identify duplicates.
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS index_number
FROM layoffs_copy
;
-- CREATE A CTE 
WITH duplicated_cte AS
(
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS index_number
FROM layoffs_copy
)
SELECT *
FROM duplicated_cte
WHERE index_number > 1;
-- SINCE CTE cannot be updated, we create a new table for the partiton by to delete
CREATE TABLE `layoffs_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `index_number` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- TO CHECK IF THE TABLE WAS CREATED
SELECT *
FROM layoffs_copy2;
-- INSERT THE CTE INTO THE CREATED TABLE
INSERT INTO layoffs_copy2
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, 
percentage_laid_off, `date`, stage, country, funds_raised_millions) AS index_number
FROM layoffs_copy;
-- Overview of the new table
SELECT *
FROM layoffs_copy2;
-- To delete the duplicates in the new table,
DELETE
FROM layoffs_copy2
WHERE index_number > 1;

-- 2. Standardisation of the Dataset
-- To remove the whitespaces in the 'company' column using TRIM() function
UPDATE layoffs_copy2
SET company = TRIM(company)
;
-- Overview of Industry column
SELECT DISTINCT industry
FROM layoffs_copy2
ORDER BY industry;
-- 'Crypto' appeared in different forms, so this is to be updated
SELECT *
FROM layoffs_copy2
WHERE industry LIKE 'Crypto%';
-- UPDATE THE COLUMN
UPDATE layoffs_copy2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Overview of location and Country
SELECT DISTINCT country
FROM layoffs_copy2
WHERE country LIKE 'United Stat__.';

-- TO ELIMINATE THE PERIOD AT END OF THE TEXT
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_copy2;
-- UPDATE THE COUNTRY COLUMN
UPDATE layoffs_copy2
SET country = TRIM(TRAILING '.' FROM country)
;
-- CONFIRM IF THE COLUMN HAS CHANGED
SELECT DISTINCT country
FROM layoffs_copy2;

-- DEALING WITH DATETIME DATA TYPE USING STR_TO_DATE()
SELECT `date`
-- STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_copy2;

-- TO UPDATE THE COLUMN 
UPDATE layoffs_copy2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- TO MODIFY DATA TYPE IN A DATASET
ALTER TABLE layoffs_copy2
MODIFY COLUMN `date` DATE;

-- 3. NULLS AND BLANKS

SELECT *
FROM layoffs_copy2
WHERE industry IS NULL
OR industry =  '';

-- OUR OUTPUT SHOWS THAT WE CAN FILL SOME OF THE BLANK USING THE INFORMATION FROM SIMILAR ROWS
-- TO ACHIEVE THIS, WE USE SELF JOIN TO POPULATE THESE MISSING COLUMNS
SELECT TB1.industry, TB2.industry
FROM layoffs_copy2 AS TB1
JOIN layoffs_copy2 AS TB2
	ON TB1.company=TB2.company
WHERE (TB1.industry IS NULL OR TB1.industry = '')
AND TB2.industry IS NOT NULL;

-- TO UPDATE THE BLANK AND NULL FIELDS
-- Set the blank fields to Null
UPDATE layoffs_copy2
SET industry = NULL
WHERE industry ='';

UPDATE layoffs_copy2 AS TB1
JOIN layoffs_copy2 AS TB2
	ON TB1.company = TB2.company
SET TB1.industry = TB2.industry
WHERE TB1.industry IS NULL 
AND TB2.industry IS NOT NULL
;
-- DELETE 'TOTAL_LAID_OFF' and 'PERCENTAGE_LAID_OFF' COLUMNS

SELECT *
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

DELETE 
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- DROP INDEX_NUMBER COLUMN USING ALTER TABLE AND DROP COLUMN 
ALTER TABLE layoffs_copy2
DROP COLUMN index_number;

-- FINAL CLEANED DATA SET
SELECT *
FROM layoffs_copy2
;


