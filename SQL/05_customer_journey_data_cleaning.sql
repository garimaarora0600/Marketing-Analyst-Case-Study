select *
from dbo.customer_journey;

-- *****************************************************************************************************************************************************************************************************************************************************
-- *****************************************************************************************************************************************************************************************************************************************************

-- 1. Common Table Expression (CTE) to identify and tag duplicate records
-- Identify and handle potential duplicate records
-- Standardize Stage values to uppercase for consistency.
-- Calculate average duration by VisitDate to use as a
-- fallback for records with missing Duration values.
-- Assign row numbers to identify repeated interactions
-- based on customer, product, date, stage, and action.
with DuplicateRecords as (
select 
JourneyID,
CustomerID,
ProductID,
VisitDate,
Stage,
Action,
Duration,
-- use ROW_NUMBER() to assign a unique number to each record within the partition defined below
ROW_NUMBER() OVER(
-- PARTITION BY groups the rows based on the specified columns that should be unique
PARTITION BY CustomerID, ProductID, VisitDate, Stage, Action 
-- ORDER BY defines how to order the rows within each partition (usually by a unqiue identifier like JourneyID)
ORDER BY JourneyID
) as rnk
from dbo.customer_journey
)

-- select all the records from the CTE where rnk>1, which indicates the duplicate entries
select *
from DuplicateRecords
where rnk>1;


-- 2. Keep one record per interaction group and handle missing Duration values using the daily average.
with subquery as (
select 
JourneyID,
CustomerID,
ProductID,
VisitDate,
UPPER(Stage) as Stage,
Action,
Duration,
ROUND(AVG(Duration) OVER( PARTITION BY VisitDate),2) as avg_duration,
ROW_NUMBER() OVER(
-- PARTITION BY groups the rows based on the specified columns that should be unique
PARTITION BY CustomerID, ProductID, VisitDate, UPPER(Stage), Action 
-- ORDER BY defines how to order the rows within each partition (usually by a unqiue identifier like JourneyID)
ORDER BY JourneyID
) as rnk
from dbo.customer_journey
)

select 
JourneyID,
CustomerID,
ProductID,
VisitDate,
Stage,
Action,
COALESCE(Duration, avg_duration) as Duration
from subquery
where rnk =1 