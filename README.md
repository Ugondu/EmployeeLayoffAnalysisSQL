# Global Employee LayOff Analysis Using MySQL and PowerBI

![image](https://github.com/user-attachments/assets/9f79b542-ab35-4edc-92ac-ee5c26aa86e2)

## Table of Contents
- [Objective](#objective)
- [Data Source](#data-source)
- [Data Processing Steps](#data-processing-steps)
	- [Data Cleaning](#data-cleaning)
	- [Data Transformation](#data-transformation)
- [Visualization](#visualization)
	- [Results](#results)
	- [PowerBi DAX Measures](#powerbi-dax-measures)
- [Analysis](#analysis)
	- [Findings](#findings)
- [Conclusion](#conclusion)

# Objective
The primary objective of this project is to conduct an analysis of global employee layoff over the years available in the dataset. Our client a non-governmental organisation appreciates a detailed, comprehensive analysis to identify patterns, causes, and impacts and provide insights to inform decision making and planning.
-	To achieve this objective
We would create a dashboard that provides insight to the KPIs and charts required.
*Total Employee count
*Total Fund Raised
*Trend of employee layoff
*Layoff by industry
*Layoff by country
*Layoff by company

## Data Source
-	What data is needed to achieve our objective?
The data required will include:
-	Company
-	Industry
-	Location
-	Total laid off
-	Percentage Laid Off
-	Stage
-	Date
-	Country
-	Funds Raised 

### Where has the dataset originated from?
The data is sourced from “Alex the Analyst” GitHub page, and the link can be seen [see here to find it.](https://github.com/AlexTheAnalyst/MySQL-YouTube-Series/blob/main/layoffs.csv)
## Data Processing Steps
To prepare the dataset for analysis, we will examine for errors, inconsistencies, whitespaces, blank, and null fields that may arise due to data entry and collection.
### Data Cleaning
To Refine and structure the dataset suitable for further exploratory data analysis, 
*Standardise dataset
*Remove duplicates
*Remove null and blank fields
*Removing columns not relevant to our analysis
### Data Transformation
```sql
/* 
# 1. Remove the whitespaces in the 'company' column using TRIM () function
# 2. Using a consistent term in each column
# 3. Eliminate the period (.) at end of the texts
# 4. Converting Date column to DATETIME data type
# 5. Filling the null and blank fields with information available in the dataset
# 6. Deleting columns not relevant to the analysis
# 7. Removing duplicates 
*/

--1.  UPDATE 
layoffs_copy2
SET company = TRIM(company);
--2. SELECT	
 	DISTINCT industry
FROM layoffs_copy2
ORDER BY industry;
-- 'Crypto' appeared in different forms, so this is to be updated
SELECT *
FROM layoffs_copy2
WHERE industry LIKE 'Crypto%';
-- UPDATE THE COLUMN
UPDATE
 layoffs_copy2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
-- Overview of location and Country
SELECT
 DISTINCT country
FROM layoffs_copy2
WHERE country LIKE 'United Stat__.';

--3. SELECT 
DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_copy2;
--4. UPDATE 
layoffs_copy2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');
ALTER TABLE 
layoffs_copy2
MODIFY COLUMN `date` DATE;
--5.  SELECT 
TB1.industry, TB2.industry
FROM layoffs_copy2 AS TB1
JOIN layoffs_copy2 AS TB2
		ON TB1.company=TB2.company
WHERE (TB1.industry IS NULL OR TB1.industry = '')
AND TB2.industry IS NOT NULL;

	UPDATE 
layoffs_copy2
SET industry = NULL
WHERE industry ='';

UPDATE
 layoffs_copy2 AS TB1
JOIN layoffs_copy2 AS TB2
		ON TB1.company = TB2.company
SET TB1.industry = TB2.industry
WHERE TB1.industry IS NULL 
AND TB2.industry IS NOT NULL;
	--6. SELECT *
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

DELETE 
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;
```
#Visualization
## Results
-	What does the dashboard look like?
![image](https://github.com/user-attachments/assets/072b0ec1-ed5e-4b78-81bf-9c8d28e5055e)

This shows employee layoff by industries and companies globally.
## PowerBI DAX Measures
### 1. Total Laid Off
```sql
TOTAL_LAID_OFF = 
VAR filteredLayOff = FILTER(CLEANED_DATA_SET, NOT  ISBLANK(CLEANED_DATA_SET[total_laid_off]))
VAR sumOfLayOff = SUMX(filteredLayOff, CLEANED_DATA_SET[total_laid_off])
RETURN sumOfLayOff

```

### 2. Total Fund Raised (B)
```sql
TOTAL_FUNDS_RAISED(B) = 
VAR billion = 1000
VAR filteredFunds = FILTER(CLEANED_DATA_SET, NOT  ISBLANK(CLEANED_DATA_SET[funds_raised_millions]))
VAR sumOfFunds = SUMX(filteredFunds, CLEANED_DATA_SET[funds_raised_millions])
VAR totalFundsInBillions = DIVIDE(sumOfFunds, billion)
VAR roundedFundsInBillions = ROUND(totalFundsInBillions, 2)

RETURN roundedFundsInBillions

```
# Analysis
##Findings
Our Analysis will be guided by the following business questions below-
1.	Which industries have the highest layoff rates?
2.	How has employee lay off progressed over time?
3.	Which country and location has the highest layoff?
4.	Which company has the highest staff layoff and the possible reasons?

### 1. Which industries have the highest layoff rates?
| Rank | Industry      | Layoff |
|------|----------------------|-----------------|
| 1    | Retail    | 28k    |
| 2    | Consumer              | 15K    |
| 3    | Other         | 12k          |
| 4    | Finance          | 10K         |
| 5    | Transportation        | 9K           |
| 6    | Food                | 8K        |
| 7    | Crypto             | 8k         |
| 8    | Real Estate          | 8K       |
| 9    | Healthcare              | 5K      |
| 10   | Infrastructure           | 5K |
### 2. Which company have the top 10 lay offs
| Rank | Company     | Layoff|
|------|----------------------|-----------------|
| 1    | Amazon    | 18.0K |
| 2    | Google | 12.0K |
| 3    | Ericsson| 8.5K|
| 4    | Cisco | 4.1K|
| 5    | Carvana| 4.0K |
| 6    | Better.com| 3.9K |
| 7    | Groupon | 3.3K|
| 8    | Katerra| 3.1K |
| 9    | Byju’s | 2.5K|
| 10   | Crypto.com| 2.3K |

### 3. Which Country with top 10 layoffs
| Rank | Country     | Layoff |
|------|----------------------|-----------------|
| 1    | United States   | 256K      |
| 2    | India | 35.9K |
| 3    | Netherlands | 17.2K |
| 4    | Sweden     | 11.2K   |
| 5    | Brazil   | 10.3K   |
| 6    | Germany  | 8.7K      |
| 7    | United Kingdom     | 6.4K         |
| 8    | Canada           | 6.3K       |
| 9    | Singapore          | 5.9K        |
| 10   | China           | 5.9K         |

### 4. Which year has the highest employee layoff
| Rank | Year     | Layoff|
|------|----------------------|-----------------|
| 1    | 2022      |160K       |
| 2    | 2023           | 125K    |
| 3    | 2020         | 80K       |
| 4    | 2021       | 15K           |

1.	Retail, consumer, and other industries not grouped are the industries with most employee layoffs globally.
2.	Amazon, Google, and Ericsson are the companies with the highest staff layoff.
3.	For countries with the most layoffs, United States, India, and The Netherlands are top of the list.
4.	The year 2022 has the highest number of employee layoff in the dataset made available.

##Conclusion
From 2021 to 2024, high employee layoffs were driven by COVID-19 impacts, supply chain disruptions, economic uncertainty, inflation, and the shift to e-commerce due to lockdowns. These factors heavily affected retail and consumer industries, particularly in the US and India, where major companies like Amazon and Google led staff reductions due to overexpansion and changing market conditions.


