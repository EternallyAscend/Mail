-- Prepare for running.

use mail;

-- 1. Create some goods_type for goods.
-- 
insert into goods_type value("Computer");
insert into goods_type value("Phone");
insert into goods_type value("Clothes");
insert into goods_type value("Food");
insert into goods_type value("Tool");


-- 2. Create some shop owners.
-- 
insert into owner values(0,"Tom",0);
insert into owner values(0,"Jack",0);
insert into owner values(0,"Peter",0);


-- 3. Create some shops with owners.
-- 
insert into shop values(0,"Tom Computer Shop",1,100);
insert into shop values(0,"Tom Phone Shop",1,200);
insert into shop values(0,"Jack Food Shop",2,10);
insert into shop values(0,"Peter Tool Shop",3,10);
insert into shop values(0,"Peter Clothes Shop",3,10);


-- 4. Create some sellers.
-- 
insert into seller values(0,"Seller John");
insert into seller values(0,"Seller Lisa");


-- 5. Create some goods.
-- 
insert into goods values(0,"Computer","1",5000,"Matebook X","A new Laptop.",1000);
insert into goods values(0,"Computer","1",3000,"Magicbook","A new Laptop.",5000);
insert into goods values(0,"Phone","2",2000,"MagicPhone","A new Phone.",2000);
insert into goods values(0,"Phone","2",1000,"iPhone","A new iPhone.",1000);
insert into goods values(0,"Food","3",100,"Dinner","A new Dinner.",10);
insert into goods values(0,"Food","3",10,"Lunch","A new Lunch.",10);
insert into goods values(0,"Tool","4",10,"Light","A new Light.",1000);
insert into goods values(0,"Tool","4",10,"Box","A new Box.",10000);
insert into goods values(0,"Clothes","5",20,"Clothes","A new Clothes.",100);


-- 6. Create some customers.
-- 
insert into customer values(0,"Pual","The Beatles","Pual@123.com","Male",md5('Pual'),100,"2020-06-20 10:50:27");
insert into customer values(0,"Jackson","Mj","Mj@Outlock.com","Male",md5('Mj'),10000,"2020-06-20 10:51:27");


-- 7. Insert some goods into shopping_cart for customers.
-- 
-- insert into shopping_cart values(1,1,'2020-06-20 16:41:24',1);
-- insert into shopping_cart values(1,3,'2020-06-20 16:59:55',2);


-- 8. Insert into customer_order old order.
-- 
-- insert into customer_order values(0,1,'F','2020-06-18 01:23:45'); 


-- create view order_information as select * from customer_order, order_detial, goods where customer_order.Customer_Order_ID=order_detial.Order_Detial_Customer_Order_ID and goods.Goods_ID=order_detial.Order_Detial_Goods_ID;