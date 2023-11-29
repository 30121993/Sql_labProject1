SELECT * FROM supplier;
SELECT * FROM customer;
SELECT * FROM category;
SELECT * FROM product;
SELECT * FROM supplier_pricing;
SELECT * FROM `order` order by ORD_ID asc; 
SELECT * FROM rating;

-- 1) Display the total number of customers based on gender who have placed individual orders of worth at least Rs.3000.
SELECT c.cus_gender, count(c.cus_gender) as count
 FROM customer c
INNER JOIN 
(
SELECT c.cus_id as customerId
FROM customer c
INNER JOIN hitesh.order o ON o.cus_id=c.cus_id
where o.ord_amount>=3000
group by c.cus_id
) as V ON v.customerId=c.cus_id
group by c.cus_gender;

-- 2) Display all the orders along with product name ordered by a customer having Customer_Id=2
SELECT p.pro_name, o.* FROM `order` o
INNER JOIN customer c ON c.cus_id=o.cus_id
INNER JOIN supplier_pricing sp ON sp.pricing_id=o.pricing_id
INNER JOIN product p ON p.pro_id=sp.pro_id
where c.cus_id=2;

-- 3) Display the Supplier details who can supply more than one product.
SELECT s.* , v.totalProducts
FROM supplier s
INNER JOIN (
SELECT sp.supp_id, COUNT(sp.pro_id) as totalProducts
FROM supplier_pricing sp
GROUP BY sp.supp_id
)as v ON v.supp_id=s.supp_id
where v.totalProducts > 1;

-- 4) Find the least expensive product from each category and print the table with category id, name, product name and price of the product
-- DESC PRODUCT => pro_id, pro_name,pro_desc,cat_id
-- DESC CATOGORY => cat_id,cat_name
-- DESC SUPPLIER_PRICING => pricing_id,pro_id,supp_id,supp_price
SELECT c.cat_id,c.cat_name,min(vv.min_price) as min_price FROM category c
INNER JOIN(
    SELECT p.*,v.min_price
    FROM PRODUCT p
    INNER JOIN (
      SELECT sp.pro_id, MIN(sp.supp_Price) as min_Price
      FROM SUPPLIER_PRICING sp
      group by sp.pro_id
      )as v ON p.pro_id=v.pro_id
      )as vv ON vv.cat_id=c.cat_id
      group by c.cat_id;
      
-- 5) Display the Id and Name of the Product ordered after “2021-10-05”.
-- order, supplier_pricing,product
SELECT p.pro_id, p.pro_name
FROM `order` o
INNER JOIN supplier_pricing sp ON sp.pricing_id=o.pricing_id
INNER JOIN product p ON p.pro_id=sp.pro_id
where o.ord_date > '2021-10-5';

-- 6)  Display customer name and gender whose names start or end with character 'A'.
SELECT * FROM customer c
where c.cus_name like 'A%'
OR c.cus_name like '%A'; 

-- 7)  Create a stored procedure to display supplier id, name, Rating(Average rating of all the products sold by every customer) and
-- Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average
-- Service” else print “Poor Service”. Note that there should be one rating per supplie

SELECT
report.supp_id, report.supp_name,
CASE
    WHEN report.average=5 THEN 'Excellent Service'
    WHEN report.average>4 THEN 'Good Service'
    WHEN report.average>3 THEN 'Average Service'
    ELSE 'Poor service'
    
    END as Type_of_Service
    FROM
    (
        SELECT s.*,final.average
        FROM Supplier s 
        INNER JOIN(
            SELECT vv.supp_id, AVG(vv.rat_ratstars) as average FROM (
               SELECT sp.pricing_id, sp.pro_id, sp.supp_id, sp.supp_price,v.ord_id,v.rat_ratstars FROM
		supplier_pricing sp
            INNER JOIN (
            SELECT o.ord_id,o.pricing_id,r.rat_ratstars
            FROM `order` o 
            INNER JOIN rating r ON r.ord_id=o.ord_id
            )as v ON sp.pricing_id=v.pricing_id
		)as vv
        group by vv.supp_id
	) as final ON final.supp_id=s.supp_id
)as report
            