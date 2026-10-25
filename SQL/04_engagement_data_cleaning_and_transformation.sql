select 
*
from dbo.engagement_data;

-- *****************************************************************************************************************************************************************************************************************************************************
-- *****************************************************************************************************************************************************************************************************************************************************

-- Query to clean and normalize the engagement data table
-- 1. to make the column with general case 
-- 2. need to convert the engagement date to dd.mm.yyyy format
-- 3. extract views and clicks separately from ViewsClicksCombined

select 
EngagementID,
ContentID,
CampaignID,
ProductID,
UPPER(REPLACE(ContentType,'Socialmedia','Social Media')) as ContentType,
LEFT(ViewsClicksCombined,CHARINDEX('-',ViewsClicksCombined)-1) as Views,
RIGHT(ViewsClicksCombined,LEN(ViewsClicksCombined)-CHARINDEX('-',ViewsClicksCombined)) as Clicks
from dbo.engagement_data
where ContentType!='Newsletter';