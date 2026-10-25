-- query to categorize products based on their price
select 
ProductID,
ProductName,
Price,
-- Category,
case 
	when Price<50 then 'Low'
	when Price between 50 and 200 then 'Medium'
	else 'High'
end as PriceCategory
from dbo.products; 