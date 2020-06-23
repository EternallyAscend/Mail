```SQL


create view Goods_Display (goods_id, goods_name, goods_type, goods_price, goods_information, shop_name, goods_number) as select goods_id, goods_name, goods_type, goods_price, goods_information, shop_name, goods_number from goods, shop where goods.goods_shop_id=shop.shop_id;



```

