USE Soyabean;
GO

-- 1. ADD THE COLUMNS WE ACTUALLY NEED

IF COL_LENGTH('dbo.backup_df', 'Total_Soy_China') IS NULL
    ALTER TABLE dbo.backup_df ADD Total_Soy_China FLOAT;
GO

-- 2. CLEAN + UPDATE DATA

UPDATE dbo.backup_df
SET
    Report_Year = YEAR(TRY_CONVERT(DATE, [Date], 103)),
    Is_Post_Trade_War = CASE
        WHEN TRY_CONVERT(DATE, [Date], 103) >= '2018-01-01' THEN 1
        ELSE 0
    END,

    -- Only calculate the total soy (this is the one that works)
    Total_Soy_China = 
        TRY_CAST(NULLIF(LTRIM(RTRIM(REPLACE(Brazil_Soy_Exports_China, ',', ''))), '') AS FLOAT) +
        TRY_CAST(NULLIF(LTRIM(RTRIM(REPLACE(USA_Soy_Exports_China,    ',', ''))), '') AS FLOAT) +
        TRY_CAST(NULLIF(LTRIM(RTRIM(REPLACE(Argentina_Soy_Exports_China, ',', ''))), '') AS FLOAT)

WHERE TRY_CONVERT(DATE, [Date], 103) IS NOT NULL;
GO


-- 3. ANNUAL GROWTH 

CREATE OR ALTER VIEW dbo.vw_Annual_Growth AS
SELECT
    Report_Year,
    SUM(Total_Soy_China) AS Total_Soy_China,
    SUM(TRY_CAST(Deforestation_Brazil AS FLOAT)) AS Total_Deforestation,
    LAG(SUM(Total_Soy_China)) OVER (ORDER BY Report_Year) AS Last_Year,
    CAST(
        100.0 * (
            SUM(Total_Soy_China) -
            LAG(SUM(Total_Soy_China)) OVER (ORDER BY Report_Year)
        ) / NULLIF(
            LAG(SUM(Total_Soy_China)) OVER (ORDER BY Report_Year), 0
        )
    AS DECIMAL(10,2)) AS YoY_Growth
FROM dbo.backup_df
WHERE Report_Year IS NOT NULL
GROUP BY Report_Year;
GO


-- 4. TRADE WAR COMPARISON 

CREATE OR ALTER VIEW dbo.vw_TradeWar_Comparison AS
SELECT
    CASE
        WHEN Is_Post_Trade_War = 1 THEN 'Post-2018'
        ELSE 'Pre-2018'
    END AS Period,
    SUM(Total_Soy_China) AS Total_Soy,
    AVG(TRY_CAST(Deforestation_Brazil AS FLOAT)) AS Avg_Deforestation
FROM dbo.backup_df
GROUP BY Is_Post_Trade_War;
GO


-- 5. OUTPUT

SELECT TOP 10 * FROM dbo.vw_Annual_Growth;
SELECT TOP 10 * FROM dbo.vw_TradeWar_Comparison;
GO