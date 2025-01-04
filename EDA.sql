-- Exploratory Data Analysis


SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off) , MAX(percentage_laid_off)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off = '' ;

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '' ;

UPDATE layoffs_staging2
SET funds_raised = NULL
WHERE funds_raised = '' ;

ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off INT;

ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off INT;

ALTER TABLE layoffs_staging2
MODIFY COLUMN funds_raised INT;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY SUM(total_laid_off) DESC ;

SELECT MIN(date) , MAX(date)
FROM layoffs_staging2;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC ;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY SUM(total_laid_off) DESC ;

SELECT YEAR(date), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(date)
ORDER BY SUM(total_laid_off) DESC  ;


SELECT SUBSTRING(date, 1,7) AS month, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(date, 1,7) IS NOT NULL
GROUP BY month
ORDER BY 1 ASC ;

WITH Rolling_Total AS
(
SELECT SUBSTRING(date, 1,7) AS month, SUM(total_laid_off) AS total_layed
FROM layoffs_staging2
WHERE SUBSTRING(date, 1,7) IS NOT NULL
GROUP BY month
ORDER BY 1 ASC 
)
SELECT month, total_layed,
SUM(total_layed) OVER(ORDER BY month) AS rolling_total
FROM Rolling_Total;


SELECT company, YEAR(date) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(date)
ORDER BY company ASC ;

WITH Company_Year (company, years,total_laid_off) AS
(
SELECT company, YEAR(date) , SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(date)
), Company_Year_Rank AS 
(SELECT *,
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS ranking
FROM Company_Year
WHERE years IS NOT NULL)
SELECT *
FROM Company_Year_Rank
WHERE ranking <= 5;