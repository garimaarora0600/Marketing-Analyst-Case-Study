select *
from dbo.customers;

select *
from dbo.geography;

-- *****************************************************************************************************************************************************************************************************************************************************
-- *****************************************************************************************************************************************************************************************************************************************************

-- SQL statement to join dim_customers with dim_geography to enrich customer data with geographic information

with customer_with_geo_locations as 
(select 
c.CustomerID,
c.CustomerName,
c.Email,
c.Gender,
c.Age,
g.Country,
g.City
from dbo.customers as c
left join dbo.geography as g
on c.GeographyID = g.GeographyID)

-- query to categorize customers based on their age

select 
*,
case 
	when Age between 18 and 29 then 'Young Adults'
	when Age between 30 and 59 then 'Middle-Aged Adults'
	when Age > 60 then 'Senior Adults'
end as Age_Group
from customer_with_geo_locations