# SQL Data Cleaning Project: Global Layoffs Dataset

## Project Overview
In this project, I cleaned a global layoffs dataset using MySQL to address common data quality issues and prepare the data for analysis. Before making any modifications, I created a separate working table from the original dataset to preserve the raw data. This project demonstrates a structured data cleaning workflow commonly used in real-world data analytics.

## Dataset Columns
The dataset contains the following information:

- Company
- Location
- Industry
- Total Laid Off
- Percentage Laid Off
- Date
- Stage
- Country
- Funds Raised (Millions)

## Data Cleaning Tasks Performed
In this project, I:

- Removed duplicate records using window functions
- Standardized inconsistent text values
- Converted text dates into the `DATE` data type
- Handled missing and blank values
- Removed unnecessary rows and columns
- Created project metrics to compare the dataset before and after cleaning

## SQL Concepts Used
- Window Functions (`ROW_NUMBER()`)
- String Functions (`TRIM()`)
- Date Functions (`STR_TO_DATE()`)
- Self Joins
- `UPDATE` and `DELETE` Statements
- `ALTER TABLE`
- Temporary Tables

## Project Screenshots

### Original Dataset Preview
Before performing any data cleaning, I explored the raw dataset to understand its structure and identify potential data quality issues.

To preserve the original data, I first created a separate working table (`layoffs_prac2`) from the raw dataset (`layoffs_prac`). This allowed me to perform all cleaning operations on a copy while keeping the original dataset unchanged for comparison and validation.

![Original Dataset Preview](images/original_datasets.png)

**Key SQL Query**

```sql
CREATE TABLE layoffs_prac2
LIKE layoffs_prac;

INSERT layoffs_prac2
SELECT *
FROM layoffs_prac;
```
---


### Duplicate Records Identified
I used the `ROW_NUMBER()` window function to identify duplicate records before removing them from the dataset.

![Duplicate Records Identified](images/duplicate_records.png)

**Key SQL Query**
```sql
INSERT INTO layoffs_prac2
SELECT *,
ROW_NUMBER() OVER (
    PARTITION BY company,
                 location,
                 industry,
                 total_laid_off,
                 percentage_laid_off,
                 `date`,
                 stage,
                 country,
                 funds_raised_millions
) AS row_num
FROM layoffs_prac;

DELETE
FROM layoffs_prac2
WHERE row_num > 1;
```

---

### Data Standardization Example 1
I found inconsistent values in the `industry` column, such as `Cryptocurrency` and `Crypto Currency`. To improve consistency, I standardized these variations into a single value: `Crypto`.

![Data Standardization Example 1](images/standardization_1.png)

**Key SQL Query**
```sql
UPDATE layoffs_prac2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```

---

### Data Standardization Example 2
I found that some values in the `country` column contained a trailing period, such as `United States.`. I removed the extra punctuation to ensure that country names were stored consistently throughout the dataset.

![Data Standardization Example 2](images/standardization_2.png)

**Key SQL Query**
```sql
UPDATE layoffs_prac2
SET country = TRIM(TRAILING '.' FROM country);
```

---

### Project Metrics Summary
I created project metrics to compare the dataset before and after cleaning and to measure the improvements made during the cleaning process.

![Project Metrics Summary](images/project_metric.png)

**Key SQL Query**
```sql
CREATE TEMPORARY TABLE project_metrics
(
    metric VARCHAR(100),
    before_cleaning INT,
    after_cleaning INT
);

SELECT *
FROM project_metrics;
```

---

### Cleaned Dataset Preview
This screenshot shows a sample of the final cleaned dataset after completing all the data cleaning steps. The dataset is now more consistent and ready for further analysis.

![Cleaned Dataset Preview](images/cleaned_dataset.png)

**Additional SQL Used During Cleaning**

```sql
UPDATE layoffs_prac2
SET company = TRIM(company);

UPDATE layoffs_prac2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

ALTER TABLE layoffs_prac2
MODIFY COLUMN `date` DATE;

UPDATE layoffs_prac2
SET industry = NULL
WHERE industry = '';

UPDATE layoffs_prac2 t1
JOIN layoffs_prac2 t2
    ON t1.company = t2.company
   AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
  AND t2.industry IS NOT NULL;

DELETE
FROM layoffs_prac2
WHERE total_laid_off IS NULL
  AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_prac2
DROP COLUMN row_num;
```
---

## Project Files
- `data_cleaning.sql` – Complete SQL data cleaning script
- `layoffs.csv` – Original dataset
- `README.md` – Project documentation and screenshots

## Dataset Source
The Global Layoffs dataset used in this project was obtained from Kaggle and contains information about company layoffs across different industries and countries.

Source: https://www.kaggle.com/datasets/swaptr/layoffs-2022
