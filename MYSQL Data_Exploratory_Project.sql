-- Exploratory Data Analysis (EDA) of the Covid-19 Pandemic


SELECT *
FROM layoffs_staging2;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;  -- maximum total_laid_off is 12000, and the maximum percentage_laid_off is 1

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC; -- here, highest total_laid_off is 2434

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC; -- here, highest funds_raised_millions is 2400

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC; -- Amazon has the highest total_laid_off followed by Google and Meta

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2; -- started from 2020-03-11 till 2023-03-06, almost 3 years during the pandemic

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC; -- Consumer industry has the highest laid_off followed by Retail. least is manufacturing

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY  country
ORDER BY 2 DESC; -- United States has the highest laid_off, a wooping 256559 lost their job, followed by India (35993). 
-- Least is Poland (25)

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC; -- 80998, 15823, 160661, and 125677 folks were laid_off in 2020,2021,2022,2023 respectively.

-- total_laif_off by month using rolling sum
SELECT SUBSTRING(`date`, 1,7) AS Month, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY SUBSTRING(`date`, 1,7)
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1,7) AS Month, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY Month
ORDER BY 1 ASC
)
SELECT Month, total_off, SUM(total_off) OVER(ORDER BY Month) AS rolling_total
FROM Rolling_Total;

-- filtering the top 5 industry by ranking per year

SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (Company, years, total_laid_off)  AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *,
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
) 
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;

 -- here, Uber, Bytedance, Meta, and Google rank first in their lay off in 2020, 2021, 2022, and 
-- 2023 respectively, with google having the biggest (12000) in 2023.
