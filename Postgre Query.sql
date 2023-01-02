DATA CONNECTIONS. CREATE YOUR OWN STORE. Joins, Temp Tables, Windows Functions, Aggregate Functions, Converting Data Types
-------------------------------------------------------------CREATE DATABASE
postgres=# create database shop;
-------------------------------------------------------------Create TABLE "Customer"
create table customer(
id serial primary key,
name varchar(255),
phone varchar(30),
email varchar(255));
-------------------------------------------------------------Create TABLE "product"
create table product(
id serial primary key,
name varchar(255),
description text,
price integer);
-------------------------------------------------------------Create TABLE "Product_photo" and Relation(Green line)
create table product_photo(
id serial primary key,
url varchar(255),
product_id integer references product(id));
-------------------------------------------------------------Create TABLE "cart" and Relation (Orange line) 
create table cart(
customer_id integer references customer(id),
id serial primary key);
-------------------------------------------------------------Create TABLE "cart_product" and Relation (Green and Blue line)
 create table cart_product(
cart_id integer references cart(id), 
product_id integer references product(id));
------------------------------------------------------------- Lets create customers
insert into customer(name, phone, email) values ('Kim','+555888777','kim@gmail.com');
insert into customer(name, phone, email) values ('Dan','+324423277','dan@gmail.com');

--To check this use 
 select * from customer;
\\\\\What you will see/////
 id | name |   phone    |     email
----+------+------------+---------------
  1 | Kim  | +555888777 | kim@gmail.com
  2 | Dan  | +324423277 | dan@gmail.com
(2 rows)

------------------------------------------------------------- Lets make some products

insert into product (name, description, price) values ('Iphone14', 'BEST phone', '1000');
insert into product (name, description, price) values ('Apple_Watch_9', 'BEST watch', '500');

--To check this use 
 select * from product;
 
\\\\\What you will see/////

 id |     name      | description | price
----+---------------+-------------+-------
  1 | Iphone14      | BEST phone  |  1000
  2 | Apple_Watch_9 | BEST watch  |   500
(2 rows)



------------------------------------------------------------- TASK 1.1  (Get the table that contains URL, Product_ID and Name) 
                                               ///LEFT JOIN///

select pp.*, p.name from product_photo AS pp left join product AS p on p.id=pp.product_id; 
-- 'pp' short Alias to product_photo 
-- 'p' short Alias to product

\\\\\What you will see/////

 id |     url      | product_id |   name
  1 | iphone_photo |          1 | Iphone14
  2 | Watch034     |          2 | Apple_Watch_9
(2 rows)

------------------------------------------------------------- TASK 1.2 ( Update URL photo)

update product_photo set url='iphone_image2' where id=1;
update product_photo set url='applewatch_image12' where id=2;

\\\\\Before changes/////
 id |     url      | product_id |
  1 | iphone_photo |          1 | 
  2 | Watch034     |          2 | 
(2 rows)

\\\\\After changes/////

 id |        url         | product_id
----+--------------------+------------
  1 | iphone_image2      |          1
  2 | applewatch_image12 |          2
(2 rows)

------------------------------------------------------------- TASK 1.3 (Simulate order in cart)

insert into cart (customer_id) values(1); 
insert into cart_product (cart_id, product_id) values (1,1), (1,2);

--Check order
select * from cart_product;

 cart_id | product_id
---------+------------
       1 |          1
       1 |          2

-------------------------------------------------------------TASK 2.0  ( Get the table that contains the Name and the Total amount of the order)

Let's do Join tables

select c.name,sum(p.price) from customer as c 
left join cart on cart.customer_id=c.id 
left join cart_product as cp on cp.cart_id=cart.id 
left join product as p on p.id=cp.product_id group by c.name;

\\\\\What you will see///// (customer Kim has two orders with a price) But customer Dan has a value of Null. Let's add a value to it and use coalesce

name | sum
------+------
 Dan  |
 Kim  | 1500
(2 rows)

\\\\\What you will see/////(Dan instead of Null has a value of 0, which is more convenient to work with)

select c.name, coalesce(sum(p.price), 0) as orders_sum from customer as c 
left join cart on cart.customer_id=c.id left join cart_product as cp on cp.cart_id=cart.id 
left join product as p on p.id=cp.product_id group by c.name order by orders_sum desc;
 name | orders_sum
------+------------
 Dan  |          0
 Kim  |       1500
(2 rows)

-------------------------------------------------------------TASK 2.1 (Find the clients with the highest order amounts) 

just add 'order by' to formula

\\\\\What you will see/////
 name | orders_sum
------+------------
 Kim  |       1500
 Dan  |          0
(2 rows)


-------------------------------------------------------------TASK 2.2 (Find customers who have a purchase amount greater than zero 0) 

just add 'having'

select c.name, coalesce(sum(p.price), 0) as orders_sum from customer as c 
left join cart on cart.customer_id=c.id left join cart_product as cp on cp.cart_id=cart.id 
left join product as p on p.id=cp.product_id group by c.name having sum(p.price)>0;

\\\\\What you will see/////
------+------------
 Kim  |       1500
(1 row)

-------------------------------------------------------------TASK 2.3 ( Output limit 1 record, output limit second record by account, sort by name) 

just add 'limit 1 + order by name'
select * from customer order by name limit 1;
 id | name |   phone    |     email
----+------+------------+---------------
  2 | Dan  | +324423277 | dan@gmail.com


just add 'limit 1 + order by name and offset 1'
select * from customer order by name limit 1 offset 1;
 id | name |   phone    |     email
----+------+------------+---------------
  1 | Kim  | +555888777 | kim@gmail.com










