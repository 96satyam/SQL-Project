SELECT *
FROM layoffs;

CREATE TABLE layoffs_staging
LIKE layoffs ;

SELECT *
FROM layoffs_staging ;

INSERT layoffs_staging
SELECT *
FROM layoffs ;

SELECT *
FROM layoffs_staging ;


-- REMOVING DUPLICATES

SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised) AS row_num
FROM layoffs_staging ;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised) AS row_num
FROM layoffs_staging 
)
SELECT *
FROM duplicate_cte 
WHERE row_num > 1 ;


CREATE TABLE layoffs_staging2
LIKE layoffs_staging ;

ALTER TABLE layoffs_staging2
ADD row_num INT ;


SELECT *
FROM layoffs_staging2;

INSERT INTO layoffs_staging2
SELECT *,
ROW_NUMBER () OVER (
PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, 'date', stage, country, funds_raised) AS row_num
FROM layoffs_staging ;

DELETE
FROM layoffs_staging2
WHERE row_num > 1;

SELECT *
FROM layoffs_staging2
WHERE row_num >1;

SELECT *
FROM layoffs_staging2;

-- STANDARDIZING DATA

UPDATE layoffs_staging2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;

SELECT *
FROM layoffs_staging2
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_staging2;

SELECT date,
STR_TO_DATE(date, '%Y-%m-%d') 
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET date = STR_TO_DATE(date, '%Y-%m-%d') ;

ALTER TABLE layoffs_staging2
MODIFY COLUMN date  DATE;


SELECT DISTINCT total_laid_off
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE industry = ''
OR industry IS NULL ;

SELECT *
FROM layoffs_staging2
WHERE company = 'Appsmith';

UPDATE layoffs_staging2
SET industry = 'software services'
WHERE company = 'Appsmith' ;

SELECT *
FROM layoffs_staging2
WHERE total_laid_off = ''
AND percentage_laid_off = '' ;

DELETE
FROM layoffs_staging2
WHERE total_laid_off = ''
AND percentage_laid_off = '' ;

SELECT *
FROM layoffs_staging2;

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

SELECT * 
FROM layoffs_staging2;

