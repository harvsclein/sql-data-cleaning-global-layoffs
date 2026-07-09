-- REMOVING DUPLICATES

SELECT * 
FROM layoffs;

CREATE TABLE layoffs_prac
LIKE layoffs;

SELECT *
FROM layoffs_prac;

INSERT INTO layoffs_prac
SELECT *
FROM layoffs;

CREATE TABLE `layoffs_prac2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO layoffs_prac2
SELECT *,
ROW_NUMBER()
OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions) AS row_num
FROM layoffs_prac;

SELECT *
FROM layoffs_prac2;

SELECT *
FROM layoffs_prac2
WHERE row_num > 1;

DELETE
FROM layoffs_prac2
WHERE row_num > 1;

-- END OF REMOVING DUPLICATES

-- STANDARDIZE THE DATA

SELECT *
FROM layoffs_prac2;

SELECT company, TRIM(company)
FROM layoffs_prac2;

UPDATE layoffs_prac2
SET company = TRIM(company);

SELECT DISTINCT industry
FROM layoffs_prac2
ORDER BY 1;

SELECT DISTINCT industry
FROM layoffs_prac2
WHERE industry LIKE 'Crypto%';

UPDATE layoffs_prac2
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT `date`,
STR_TO_DATE (`date`, '%m/%d/%Y')
FROM layoffs_prac2;

UPDATE layoffs_prac2
SET `date` = STR_TO_DATE (`date`, '%m/%d/%Y');

ALTER TABLE layoffs_prac2
MODIFY COLUMN `date` DATE;

SELECT distinct country
FROM layoffs_prac2
ORDER BY 1;

SELECT distinct country, TRIM(TRAILING '.' FROM country)
FROM layoffs_prac2;

UPDATE layoffs_prac2
SET country = TRIM(TRAILING '.' FROM country);

-- END OF STANDARDIZE THE DATA

-- NULL VALUES OR BLANK VALUES

SELECT *
FROM layoffs_prac2
WHERE industry IS NULL OR industry = '';

UPDATE layoffs_prac2
SET industry = NULL
WHERE industry = '';

SELECT *
FROM layoffs_prac2
WHERE company = 'Carvana';

SELECT t1.industry, t2.industry
FROM layoffs_prac2 t1
JOIN layoffs_prac2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
;

UPDATE layoffs_prac2 t1
JOIN layoffs_prac2 t2
	ON t1.company = t2.company
    AND t1.location = t2.location
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL
;


-- END OF NULL VALUES OR BLANK VALUES

-- REMOVE ANY COLUMNS

SELECT *
FROM layoffs_prac2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL
;

DELETE
FROM layoffs_prac2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

ALTER TABLE layoffs_prac2
DROP COLUMN row_num;

SELECT *
FROM layoffs_prac2;

SELECT distinct stage
FROM layoffs_prac2
ORDER BY 1;

-- END OF REMOVE ANY COLUMNS
