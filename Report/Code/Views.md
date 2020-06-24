```SQL


create view Goods_Display (goods_id, goods_name, goods_type, goods_price, goods_information, shop_name, goods_number) as select goods_id, goods_name, goods_type, goods_price, goods_information, shop_name, goods_number from goods, shop where goods.goods_shop_id=shop.shop_id;



```

```SQL


create view Orders (order_id, goods_id , goods_name, goods_type, goods_price, goods_number, price, seller_name, time) as select order_detial_customer_order_id, order_detial_goods_id, goods_name, goods_type, order_detial_price, order_detial_number, order_detial_price*order_detial_number, seller_name, order_detial_time from order_detial, goods, seller where order_detial.order_detial_goods_id=goods.goods_id and order_detial.order_detial_seller_id=seller.seller_id;



```

```SQL


drop procedure if exists viewSaleListWeek;
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

call viewSaleListWeek();
select * from saleList;


drop procedure if exists viewSaleListMonth;
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

```





