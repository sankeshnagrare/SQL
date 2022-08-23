
use fastkart;

show tables;

/*
 1. List Top 3 products based on QuantityAvailable. (productid, productname, QuantityAvailable ). (3 Rows) [Note: Products]
 */
 select * from Products order by QuantityAvailable desc
 limit 3;

/* 
 2. Display EmailId of those customers who have done more than ten purchases. (EmailId, Total_Transactions). (5 Rows) [Note: Purchasedetails, products]
 */
 select emailid , count(QuantityPurchased) Total_Transactions 
 from Purchasedetails
 group by emailid
 having count(QuantityPurchased) > 10;
 
 /*
 3. List the Total QuantityAvailable category wise in descending order. (Name of the category, QuantityAvailable) (7 Rows) [Note: products, categories]
 */
 select CategoryName, sum(QuantityAvailable) Quantity_Available from categories c inner join products using (categoryid)
 group by c.CategoryName 
 order by Quantity_Available desc ;

/*
4. Display ProductId, ProductName, CategoryName, Total_Purchased_Quantity for the product which has been sold maximum in terms of quantity? (1 Row) [Note: purchasedetails, products, categories]
*/
select ProductId, ProductName, CategoryName, sum(QuantityPurchased) Total_Purchased_Quantity
	from purchasedetails inner join products using (productid) inner join categories using (categoryid)
group by ProductId, ProductName, CategoryName
order by Total_Purchased_Quantity desc
limit 1 ;

/*
5. Display the number of male and female customers in fastkart. (2 Rows) [Note: roles, users]
*/
select Gender, count(*) from users a inner join roles b using (roleid)
where b.rolename = 'Customer'
group by gender;

/*
6. Display ProductId, ProductName, Price and Item_Classes of all the products where Item_Classes are as follows: If the price of an item is less than 2,000 then “Affordable”, If the price of an item is in between 2,000 and 50,000 then “High End Stuff”, If the price of an item is more than 50,000 then “Luxury”. (57 Rows)
*/

select ProductId, ProductName, Price, 
case 
	when price < 2000 then 'Affordable'
    when price between 2000 and 50000 then 'High End Stuff'
    else 'Luxury'
end as Item_Classes
from products
order by Item_Classes ;

/*
7. Write a query to display ProductId, ProductName, CategoryName, Old_Price(price) and New_Price as per the following criteria a. If the category is “Motors”, decrease the price by 3000 b. If the category is “Electronics”, increase the price by 50 c. If the category is “Fashion”, increase the price by 150 For the rest of the categories price remains same. Hint: Use case statement, there should be no permanent change done in table/DB. (57 Rows) [Note: products, categories]
*/

select ProductId, ProductName, CategoryName , price Old_Price,
case 
	when CategoryName =  'Motors' then price - 3000
    when CategoryName =  'Electronics' then price + 50
	when CategoryName =  'Fashion' then price + 150   
    else price
end as New_price
from products inner join categories using (categoryid);

/*
8. Display the percentage of females present among all Users. (Round up to 2 decimal places) Add “%” sign while displaying the percentage. (1 Row) [Note: users]
*/

select  concat (round( ((count(*) / (select count(*) from users )) * 100), 2 ), '%')  
from users where gender = 'F';

/*
9. Display the average balance for both card types for those records only where CVVNumber > 333 and NameOnCard ends with the alphabet “e”. (2 Rows) [Note: carddetails]
*/
select CardType, avg(balance) average_balance from carddetails
where CVVnumber > 333 
and NameOnCard like '%e'
group by CardType ;

/*
10. What is the 2nd most valuable item available which does not belong to the “Motor” category. Value of an item = Price * QuantityAvailable. Display ProductName, CategoryName, value. (1 Row) [Note: products, categories]
*/

select productname, categoryname, Price * QuantityAvailable Value  from products inner join categories using (categoryid)
where categoryname <> 'Motors'
order by Value desc
limit 1,1
;
