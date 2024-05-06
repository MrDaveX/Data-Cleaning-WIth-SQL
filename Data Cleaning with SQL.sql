-- SQL Project - Data Cleaning


SELECT * 
FROM layoffs


-- first thing we want to do is create a duplicate table. This is the one we will work in and clean the data. We want a table with the raw data in case something happens

SELECT * 
INTO rough_layoffs
FROM layoffs  

SELECT * 
FROM rough_layoffs



-- 1. Remove Duplicates

SELECT *,
ROW_NUMBER () OVER 
(PARTITION BY company,
			location,
			industry,
			total_laid_off,
			date,
			stage,
			country,
			funds_raised_millions 
			ORDER BY date) RowNUmber
FROM rough_layoffs

WITH duplicates_CTE AS (
SELECT *,
ROW_NUMBER () OVER 
(PARTITION BY company,
			location,
			industry,
			total_laid_off,
			date,
			stage,
			country,
			funds_raised_millions 
			ORDER BY date) RowNUmber
FROM rough_layoffs
)
SELECT *
FROM duplicates_CTE
WHERE RowNUmber >1


--SELECT *
--FROM rough_layoffs
--WHERE company = 'casper'

WITH duplicates_CTE AS (
SELECT *,
ROW_NUMBER () OVER 
(PARTITION BY company,
			location,
			industry,
			total_laid_off,
			date,
			stage,
			country,
			funds_raised_millions 
			ORDER BY date) RowNUmber
FROM rough_layoffs
)
DELETE 
FROM duplicates_CTE
WHERE RowNUmber >1

--Duplicates are gone!!!


--Standardizing Data

-- 2. Standardize Date

SELECT*
FROM rough_layoffs

SELECT date, CONVERT(Date,date) 
FROM rough_layoffs
 
 ALTER TABLE rough_layoffs
 ADD Dates date

 UPDATE rough_layoffs
SET Dates =  CONVERT(Date,date)

ALTER TABLE rough_layoffs
DROP COLUMN SaleDate

--Standardize Company

SELECT*,
TRIM (company) as Trimcompany
FROM rough_layoffs 
Order By company

UPDATE rough_layoffs
SET company =  TRIM (company)

-- I noticed the Crypto has multiple different variations. We need to standardize that - let's say all to Crypto
SELECT Distinct industry
FROM layoffs

SELECT *
FROM layoffs
WHERE industry LIKE 'Crypto%'

UPDATE layoffs
SET Industry = 'Crypto'
WHERE industry LIKE 'Crypto%'

SELECT * 
FROM rough_layoffs 

-- if we look at industry it looks like we have some null and empty rows, let's take a look at these

SELECT *
FROM layoffs
WHERE industry IS NULL
OR industry = 'Null'

SELECT *
FROM layoffs
WHERE company = 'airbnb'
OR industry = Null
ORDER BY 1

UPDATE layoffs
SET industry = 'Travel'
WHERE company = 'airbnb'

-- and if we check it looks like Bally's was the only one without a populated row to populate this null values
SELECT *
FROM world_layoffs.layoffs_staging2
WHERE industry IS NULL 
OR industry = ''
ORDER BY industry;


-- everything looks good except apparently we have some "United States" and some "United States." with a period at the end. Let's standardize this.

SELECT DISTINCT country
FROM rough_layoffs
ORDER BY country;

UPDATE rough_layoffs
SET country = United States
WHERE country LIKE 'Unitedstates'


-- now if we run this again it is fixed
SELECT DISTINCT country
FROM rough_layoffs
ORDER BY country;


-- 3. Look at Null Values

-- the null values in total_laid_off, percentage_laid_off, and funds_raised_millions all look normal. I don't think I want to change that
-- I like having them null because it makes it easier for calculations during the EDA phase

-- so there isn't anything I want to change with the null values
























