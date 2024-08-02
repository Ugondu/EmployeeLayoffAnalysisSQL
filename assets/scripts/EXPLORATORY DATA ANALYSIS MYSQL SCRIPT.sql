/*EXPLORATIRY DATA ANALYSIS.
PROBLEM OVERVIEW
Recent widespread layoffs across various industries highlight the need for a comprehensive analysis to understand their patterns, causes, and impacts. 
This project uses a detailed dataset on companies, locations, industries, layoff statistics, and financial backgrounds to uncover trends, compare affected sectors and regions, and examine the relationship between company characteristics and layoffs. 
The aim is to identify key insights, predict future layoffs, and inform strategic decision-making and policy formulation. By understanding layoff dynamics, businesses and policymakers can better manage 
 and mitigate the adverse effects on employees, companies, and the economy.
*/
-- BUSINESS PROBLEM
-- 1. Which industries have the highest layoff rates
-- 2. How has employee lay off progressed over time
-- 3. Which country and location has the highest layoffs
-- 4. Which company has the highest staff layoff and the possible reasons

-- DATASET OVERVIEW
SELECT * 
FROM layoffs_copy2
;
-- WHICH INDUSTRIES HAVE THE HIGHEST LAYOFF RATE
SELECT DISTINCT industry, SUM(TOTAL_LAID_OFF) AS LAY_OFF
FROM layoffs_copy2
WHERE industry IS NOT NULL
GROUP BY industry
ORDER BY LAY_OFF;
-- WHICH COUNTRY HAS THE HIGHEST AND LEAST LAYOFF 
SELECT DISTINCT country, SUM(total_laid_off) AS LAY_OFF
FROM layoffs_copy2
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY LAY_OFF DESC
LIMIT 20;
SELECT DISTINCT country, SUM(total_laid_off) AS LAY_OFF
FROM layoffs_copy2
WHERE total_laid_off IS NOT NULL
GROUP BY country
ORDER BY LAY_OFF ASC
LIMIT 20;

-- EVALUATE LAY OFF BY TIME
SELECT YEAR(`date`) AS Years, SUM(total_laid_off) AS LAY_OFF
FROM layoffs_copy2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY Years
ORDER BY years;

-- TO EXAMINE EMPLOYEE LAYOFFS BY YEAR PER INDUSTRY, LOCATION, AND COUNTRY
SELECT company, YEAR(`date`) AS year_layoff, 
	location, country, SUM(total_laid_off) AS LAY_OFF
FROM layoffs_copy2
WHERE industry IS NOT NULL
AND total_laid_off IS NOT NULL
GROUP BY company, year_layoff, location, country
ORDER BY LAY_OFF DESC
LIMIT 10;

SELECT company, YEAR(`date`) AS year_layoff, 
	location, country, SUM(total_laid_off) AS LAY_OFF
FROM layoffs_copy2
WHERE industry IS NOT NULL
AND total_laid_off IS NOT NULL
GROUP BY company, year_layoff, location, country
ORDER BY LAY_OFF ASC
LIMIT 10;

-- RELATIONSHIP BETWEEN FUNDS RAISED AND STAFF LAYOFF
SELECT DISTINCT stage, ROUND(AVG(funds_raised_millions),2) AS FUNDS_MILLIONS, ROUND(AVG(total_laid_off),0) AS LAY_OFF 
FROM layoffs_copy2
WHERE funds_raised_millions IS NOT NULL 
AND total_laid_off IS NOT NULL
AND stage IS NOT NULL
GROUP BY stage
ORDER BY FUNDS_MILLIONS, LAY_OFF DESC;

SELECT DISTINCT industry AS INDUSTRIES, stage, ROUND(AVG(funds_raised_millions),2) AS FUNDS_MILLIONS, ROUND(AVG(total_laid_off),0) AS LAY_OFF
FROM layoffs_copy2
WHERE funds_raised_millions IS NOT NULL 
AND total_laid_off IS NOT NULL
AND stage IS NOT NULL
AND industry IS NOT NULL
GROUP BY INDUSTRIES, stage
HAVING stage = 'POST-IPO'
ORDER BY LAY_OFF DESC;

-- COMPANIES THAT WENT OUT OF BUSINESS
SELECT company, INDUSTRY, location, stage, funds_raised_millions, percentage_laid_off
FROM layoffs_copy2
WHERE percentage_laid_off = 1
AND funds_raised_millions IS NOT NULL
ORDER BY funds_raised_millions DESC
LIMIT 10;





