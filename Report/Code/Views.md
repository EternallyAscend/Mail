```SQL


create view Goods_Display (goods_id, goods_name, goods_type, goods_price, goods_information, shop_name, goods_number) as select goods_id, goods_name, goods_type, goods_price, goods_information, shop_name, goods_number from goods, shop where goods.goods_shop_id=shop.shop_id;



```

```


create view Orders (order_id, goods_name, goods_type, goods_price, goods_number, price, seller_name, time) as select order_detial_goods_id, goods_name, goods_type, order_detial_price, order_detial_number, order_detial_price*order_detial_number, seller_name, order_detial_time from order_detial, goods, seller where order_detial.order_detial_goods_id=goods.goods_id and order_detial.order_detial_seller_id=seller.seller_id;



```

