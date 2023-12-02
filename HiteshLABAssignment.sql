CREATE TABLE `category` (
  `CAT_ID` int NOT NULL,
  `CAT_NAME` varchar(20) NOT NULL,
  PRIMARY KEY (`CAT_ID`)
)
INSERT INTO `category` VALUES (1,'BOOKS'),(2,'GAMES'),(3,'GROCERIES'),(4,'ELECTRONICS'),(5,'CLOTHES');

CREATE TABLE `customer` (
  `CUS_ID` int NOT NULL AUTO_INCREMENT,
  `CUS_NAME` varchar(20) NOT NULL,
  `CUS_PHONE` varchar(10) NOT NULL,
  `CUS_CITY` varchar(30) NOT NULL,
  `CUS_GENDER` char(1) DEFAULT NULL,
  PRIMARY KEY (`CUS_ID`)
)
INSERT INTO `customer` VALUES (1,'AAKASH','9999999999','DELHI','M'),(2,'AMAN','9785463215','NOIDA','M'),(3,'NEHA','9999999999','MUMBAI ','F'),(4,'MEGHA ','9994562399','KOLKATA','F'),(5,'PULKIT','7895999999','LUCKNOW','M');


CREATE TABLE `order` (
  `ORD_ID` int NOT NULL AUTO_INCREMENT,
  `ORD_AMOUNT` int NOT NULL,
  `ORD_DATE` date NOT NULL,
  `CUS_ID` int NOT NULL,
  `PRICING_ID` int NOT NULL,
  PRIMARY KEY (`ORD_ID`),
  KEY `fk_idx` (`CUS_ID`),
  KEY `pricing_fk_idx` (`PRICING_ID`),
  CONSTRAINT `customer_fk` FOREIGN KEY (`CUS_ID`) REFERENCES `customer` (`CUS_ID`),
  CONSTRAINT `pricing_fk` FOREIGN KEY (`PRICING_ID`) REFERENCES `supplier_pricing` (`PRICING_ID`)
)
INSERT INTO `order` VALUES (101,1500,'2021-10-06',2,1),(102,1000,'2021-10-12',3,5),(103,30000,'2021-09-16',5,2),(104,1500,'2021-10-05',1,1),(105,3000,'2021-08-16',4,3),(106,1450,'2021-08-18',1,9),(107,789,'2021-09-01',3,7),(108,780,'2021-09-07',5,6),(109,3000,'2021-09-10',5,3),(110,2500,'2021-09-10',2,4),(111,1000,'2021-09-15',4,5),(112,789,'2021-09-16',4,7),(113,31000,'2021-09-16',1,8),(114,1000,'2021-09-16',3,5),(115,3000,'2021-09-16',5,3),(116,99,'2021-09-17',2,14);


CREATE TABLE `product` (
  `PRO_ID` int NOT NULL,
  `PRO_NAME` varchar(45) NOT NULL DEFAULT 'Dummy',
  `PRO_DESC` varchar(60) NOT NULL,
  `CAT_ID` int NOT NULL,
  PRIMARY KEY (`PRO_ID`),
  KEY `CAT_ID_fk_idx` (`CAT_ID`),
  CONSTRAINT `CAT_ID_fk` FOREIGN KEY (`CAT_ID`) REFERENCES `category` (`CAT_ID`)
)
INSERT INTO `product` VALUES (1,'GTA V','Windows 7 and above with i5 processor and 8GB RAM',2),(2,'TSHIRT ','SIZE-L with Black, Blue and White variations',5),(3,'ROG LAPTOP ','Windows 10 with 15inch screen, i7 processor, 1TB SSD',4),(4,'OATS ','Highly Nutritious from Nestle',3),(5,'HARRY POTTER','Best Collection of all time by J.K Rowling ',1),(6,'MILK','1L Toned MIlk',3),(7,'Boat Earphones','1.5Meter long Dolby Atmos',4),(8,'Jeans','Stretchable Denim Jeans with various sizes and color',5),(9,'Project IGI','compatible with windows 7 and above ',2),(10,'Hoodie ','Black GUCCI for 13 yrs and above',5),(11,'Rich Dad Poor Dad','Written by RObert Kiyosaki',1),(12,'Train Your Brain ','By Shireen Stephen ',1);


CREATE TABLE `rating` (
  `RAT_ID` int NOT NULL,
  `ORD_ID` int DEFAULT NULL,
  `RAT_RATSTARS` int NOT NULL,
  PRIMARY KEY (`RAT_ID`),
  KEY `order_id _idx` (`ORD_ID`),
  CONSTRAINT `order_id ` FOREIGN KEY (`ORD_ID`) REFERENCES `order` (`ORD_ID`)
)
INSERT INTO `rating` VALUES (1,101,4),(2,102,3),(3,103,1),(4,104,2),(5,105,4),(6,106,3),(7,107,4),(8,108,4),(9,109,3),(10,110,5),(11,111,3),(12,112,4),(13,113,2),(14,114,1),(15,115,1),(16,116,0);


CREATE TABLE `supplier` (
  `SUPP_ID` int NOT NULL AUTO_INCREMENT,
  `SUPP_NAME` varchar(50) NOT NULL,
  `SUPP_CITY` varchar(50) NOT NULL,
  `SUPP_PHONE` varchar(50) NOT NULL,
  PRIMARY KEY (`SUPP_ID`)
)
INSERT INTO `supplier` VALUES (1,'Rajesh Retails ','Delhi','1234567890'),(2,'Appario Ltd.','Mumbai','9785462315'),(3,'Knome products','Banglore','8975463285'),(4,'Bansal Retails','Kochi','1234567890'),(5,'Mittal Ltd.','Lucknow','7898456532');


CREATE TABLE `supplier_pricing` (
  `PRICING_ID` int NOT NULL,
  `PRO_ID` int DEFAULT NULL,
  `SUPP_ID` int DEFAULT NULL,
  `SUPP_PRICE` int DEFAULT '0',
  PRIMARY KEY (`PRICING_ID`),
  KEY `proid_idx` (`PRO_ID`),
  KEY `SUPP_ID_idx` (`SUPP_ID`),
  CONSTRAINT `proid` FOREIGN KEY (`PRO_ID`) REFERENCES `product` (`PRO_ID`),
  CONSTRAINT `SUPP_ID` FOREIGN KEY (`SUPP_ID`) REFERENCES `supplier` (`SUPP_ID`)
)
INSERT INTO `supplier_pricing` VALUES (1,1,2,1500),(2,3,5,30000),(3,5,1,3000),(4,2,3,2500),(5,4,1,1000),(6,12,2,780),(7,12,4,789),(8,3,1,31000),(9,1,5,1450),(10,4,2,999),(11,7,3,549),(12,7,4,529),(13,6,2,105),(14,6,1,99),(15,2,5,2999),(16,5,2,2999);


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
            
