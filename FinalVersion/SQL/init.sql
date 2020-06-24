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
insert into goods values(0,"Computer","1",10000,"MacBook Pro","A new Mac Laptop.",3000);
insert into goods values(0,"Phone","2",2000,"MagicPhone","A new Phone.",2000);
insert into goods values(0,"Phone","2",1000,"iPhone","A new iPhone.",1000);
insert into goods values(0,"Phone","2",3000,"P40 Pro","A new Huawei Phone.",10000);
insert into goods values(0,"Food","3",100,"Dinner","A new Dinner.",10);
insert into goods values(0,"Food","3",10,"Lunch","A new Lunch.",10);
insert into goods values(0,"Tool","4",10,"Light","A new Light.",1000);
insert into goods values(0,"Tool","4",10,"Box","A new Box.",10000);
insert into goods values(0,"Tool","4",20,"Hammer","A new Hammer",2000);
insert into goods values(0,"Clothes","5",20,"Clothes","A new Clothes.",100);
insert into goods values(0,"Clothes","5",20,"New Clothes","A newer Clothes.",200);
insert into goods values(0,"Clothes","5",50,"Uniform","Uniform",300);

-- 6. Create some customers.
-- 
insert into customer values(0,"Pual","The Beatles","Pual@123.com","Male",md5('Pual'),100,"2019-06-20 10:50:27");
insert into customer values(0,"Jackson","Jackson","Mj@Outlock.com","Male",md5('Jackson'),10000,"2019-06-20 10:52:26");


-- 7. Create some views.
--
create view Goods_Display (goods_id, goods_name, goods_type, goods_price, goods_information, shop_name, goods_number) as select goods_id, goods_name, goods_type, goods_price, goods_information, shop_name, goods_number from goods, shop where goods.goods_shop_id=shop.shop_id;
create view Orders (order_id, goods_id , goods_name, goods_type, goods_price, goods_number, price, seller_name, time) as select order_detial_customer_order_id, order_detial_goods_id, goods_name, goods_type, order_detial_price, order_detial_number, order_detial_price*order_detial_number, seller_name, order_detial_time from order_detial, goods, seller where order_detial.order_detial_goods_id=goods.goods_id and order_detial.order_detial_seller_id=seller.seller_id;

-- 8. Create some triggers.
--
delimiter //
-- drop trigger if exists updateOrderStatus;
create trigger `updateOrderStatus` after update on `customer_order` for each row
begin
	update order_detial set order_detial_status=NEW.`customer_order_status` where order_detial_customer_order_id=OLD.`customer_order_id`;
end //
delimiter ;


-- 9. Create some functions.
--
-- drop procedure if exists viewSaleListWeek;
delimiter //
create procedure viewSaleListWeek()
begin
	drop table if exists saleList;
	create temporary table saleList(number int unsigned not null, id int unsigned not null primary key, name varchar(45) not null);
	drop table if exists typeList;
	create temporary table typeList(number int unsigned not null, type varchar(45) not null primary key);
	insert into saleList select sum(order_detial_number),order_detial_goods_id, goods_name from order_detial, goods where order_detial_status='F' and order_detial_time>date_sub(now(),interval 7 Day) and goods.goods_id=order_detial.order_detial_goods_id group by order_detial_goods_id limit 10;
	insert into typeList select sum(number), goods_type from saleList, goods where saleList.id=goods.goods_id group by goods_type limit 10;
end //
delimiter ;

-- drop procedure if exists viewSaleListMonth;
delimiter //
create procedure viewSaleListMonth()
begin
	drop table if exists saleList;
	create temporary table saleList(number int unsigned not null, id int unsigned not null primary key, name varchar(45) not null);
	drop table if exists typeList;
	create temporary table typeList(number int unsigned not null, type varchar(45) not null primary key);
	insert into saleList select sum(order_detial_number),order_detial_goods_id, goods_name from order_detial, goods where order_detial_status='F' and  order_detial_time>date_sub(now(),interval 1 Month) and goods.goods_id=order_detial.order_detial_goods_id group by order_detial_goods_id limit 10;
	insert into typeList select sum(number), goods_type from saleList, goods where saleList.id=goods.goods_id group by goods_type limit 10;
end //
delimiter ;

call viewSaleListWeek();
call viewSaleListMonth();

-- Abandoned. Insert some goods into shopping_cart for customers.
-- 
-- insert into shopping_cart values(1,1,'2020-06-20 16:41:24',1);
-- insert into shopping_cart values(1,3,'2020-06-20 16:59:55',2);


-- 10. Insert into customer_order old order.
-- 
insert into customer_order values(0,1,'F','2019-11-18 01:23:45'); 
insert into order_detial values(1,1,2,5000,100,'F','2019-11-18 01:23:45');
insert into order_detial values(1,4,1,3000,100,'F','2019-11-18 01:23:45');
insert into order_detial values(1,13,2,60,1000,'F','2019-11-18 01:23:45');

insert into customer_order values(0,1,'F','2020-06-01 12:34:56');
insert into order_detial values(2,1,2,5000,100,'F','2020-06-01 12:34:56');
insert into order_detial values(2,4,1,3000,100,'F','2020-06-01 12:34:56');

insert into customer_order values(0,1,'F','2020-06-18 12:34:56');
insert into order_detial values(3,9,1,20,20,'F','2020-06-18 12:34:56');
insert into order_detial values(3,10,2,20,10,'F','2020-06-18 12:34:56');
insert into order_detial values(3,11,1,30,10,'F','2020-06-18 12:34:56');

insert into customer_order values(0,1,'F','2020-06-20 12:34:56');
insert into order_detial values(4,1,1,5000,20,'F','2020-06-20 12:34:56');
insert into order_detial values(4,4,2,2000,10,'F','2020-06-20 12:34:56');
insert into order_detial values(4,11,1,30,10,'F','2020-06-20 12:34:56');

insert into customer_order values(0,1,'C','2020-06-21 01:23:45');
insert into order_detial values(5,5,1,1000,1,'C','2020-06-21 01:23:45');

insert into customer_order values(0,1,'B','2020-06-21 12:34:56');
insert into order_detial values(6,12,2,20,2,'B','2020-06-21 12:34:56');

insert into customer_order values(0,1,'R','2020-06-22 01:23:45');
insert into order_detial values(7,13,1,20,2,'R','2020-06-22 01:23:45');

insert into customer_order values(0,1,'E','2020-06-22 01:23:45');
insert into order_detial values(8,12,1,20,1,'E','2020-06-22 01:23:45');

insert into customer_order values(0,1,'D','2020-06-22 12:34:56');
insert into order_detial values(9,11,1,20,1,'D','2020-06-22 12:34:56');
-- create view order_information as select * from customer_order, order_detial, goods where customer_order.Customer_Order_ID=order_detial.Order_Detial_Customer_Order_ID and goods.Goods_ID=order_detial.Order_Detial_Goods_ID;