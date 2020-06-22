
from django.shortcuts import render
import pymysql as ms
import datetime


def Show_Index(request):
    database=ms.connect("localhost","root","root","mail",port=3306,cursorclass=ms.cursors.DictCursor)
    cursor=database.cursor()
    ctx = {}
    mention=""
    login=""
    if request.POST:
        try:
            login=request.POST['login']
        except:
            pass
        name=request.POST['name']
        sql="select * from goods where Goods_Name like %s"
        cursor.execute(sql,['%'+name+'%'])
        if name!="":
            mention="Result of "+name
        pass
    else:
        sql="select * from goods;"
        cursor.execute(sql)
    data=cursor.fetchall()
    content={}
    if login!="":
        content['login']=login;
    content['Result']=mention
    content['Goods']=data
    return render(request,'index.html',content)

# def Register(request):
#     return render(request,'register.html')
#
# def Finish_Register(request):
#     database = ms.connect("localhost", "root", "root", "mail", port=3306, cursorclass=ms.cursors.DictCursor)
#     cursor = database.cursor()
#     ctx = {}
#     status=False
#     result="False: "
#     if request.POST:
#         telephone=request.POST['Tel']
#         name=request.POST['name']
#         nick=request.POST['Nickname']
#         email=request.POST['email']
#         gender=request.POST['gender']
#         password=request.POST['Password']
#         pwd=request.POST['Pwd']
#         date=str(datetime.datetime.now())[0:19]
#         if pwd==password:
#             sql="insert into customer values('0',%s,%s,%s,%s,md5(%s),'0',%s);"
#             cursor.execute(sql,[name,nick,email,gender,password,date])
#             cache=cursor.fetchall()
#             id=""
#             sql="select from customer where customer_name like %s and customer_register_time like %s"
#             cursor.execute(sql,[name,date])
#             temp=cursor.fetchall()
#             sql="insert into customer_telephone values(%s,);"
#             status=True
#         else:
#             result+="Two password are not the same. Try again please."
#     if status:
#         content={}
#         content['register']="You have registered successfully. Please login."
#         return render(request,'login.html',content)
#     else:
#         content={}
#         content['Result']=result
#         return render(request,'register.html',content)


def Login(request):
    return render(request,'login.html')

def Finish_Login(request):
    status=False
    account=request.POST['Account']
    password=request.POST['Password']
    database = ms.connect("localhost", "root", "root", "mail", port=3306, cursorclass=ms.cursors.DictCursor)
    cursor = database.cursor()
    ctx = {}
    sql="select * from customer where customer_id like %s and customer_password like md5(%s);"
    result=cursor.execute(sql,[account,password])
    status=cursor.fetchall()
    if status:
        sql="select * from goods;"
        cursor.execute(sql)
        info=cursor.fetchall()
        # return render(request,'index.html',{'login':account})
        return render(request,'index.html',{'login':account,'Goods':info})
    else:
        return render(request,'login.html',{'wrong':"Login false."})

def User(request):
    database = ms.connect("localhost", "root", "root", "mail", port=3306, cursorclass=ms.cursors.DictCursor)
    cursor = database.cursor()
    ctx = {}
    if str(request.POST['button'])=="Logout":
        sql="select * from goods;"
        cursor.execute(sql)
        info=cursor.fetchall()
        return render(request,"index.html",{'Goods':info})
    if str(request.POST['button'])=="My Order":
        login=request.POST['login']
        content={}
        content['login']=login
        sql="select * from customer_order where customer_order_customer_id like %s order by customer_order_time desc;"
        cursor.execute(sql,[login])
        order=cursor.fetchall()
        if order:
            content['order']=order
        else:
            content['empty']="Your do not have any order before."
        return render(request,'order.html',content)
    if str(request.POST['button'])=="Shopping Cart":
        login=request.POST['login']
        content={}
        content['login']=login
        sql="select * from shopping_cart where shopping_cart_customer_id like %s order by shopping_cart_time desc;"
        lines=cursor.execute(sql,[login])
        data=cursor.fetchall()
        if data:
            for i in range(len(data)):
                sql="select * from goods where Goods_ID like %s;"
                cursor.execute(sql, [data[i]['Shopping_Cart_Goods_ID']])
                good_info=cursor.fetchall()
                print(good_info[0])
                data[i].update(good_info[0])
            # item=[]
            # for i in data:
            #     print(i)
            #     sql="select * from goods where Goods_ID like %s;"
            #     cursor.execute(sql,[i['Shopping_Cart_Goods_ID']])
            #     item+=cursor.fetchall()
            # content['goods']=item
            content['shopping_cart']=data
            # content['shopping_cart']+=item
        else:
            content['empty']="Your Shopping Cart is Empty."
        return render(request,'shopping_cart.html',content)

def Add(request):
    login=request.POST['login']
    content={}
    content['login']=login
    id=request.POST['goods_id']
    database=ms.connect("localhost","root","root","mail",port=3306,cursorclass=ms.cursors.DictCursor)
    database=ms.connect("localhost","root","root","mail",port=3306,cursorclass=ms.cursors.DictCursor)
    database.begin()
    cursor=database.cursor()
    ctx={}
    sql="select * from shopping_cart where shopping_cart_customer_id like %s and shopping_cart_goods_id like %s;"
    cursor.execute(sql,[login,id])
    inCart=cursor.fetchall()
    if inCart:
        sql="update shopping_cart set shopping_cart_time=%s where shopping_cart_customer_id like %s and shopping_cart_goods_id like %s;"
        cursor.execute(sql,[str(datetime.datetime.now())[:19],login,id])
        cursor.fetchall()
        database.commit()
        sql = "select * from shopping_cart where shopping_cart_customer_id like %s order by shopping_cart_time desc;"
        lines = cursor.execute(sql, [login])
        data = cursor.fetchall()
        if data:
            for i in range(len(data)):
                sql="select * from goods where Goods_ID like %s;"
                cursor.execute(sql, [data[i]['Shopping_Cart_Goods_ID']])
                good_info = cursor.fetchall()
                print(good_info[0])
                data[i].update(good_info[0])
            content['shopping_cart'] = data
        else:
            content['empty']="Your Shopping Cart is Empty."
        return render(request,'shopping_cart.html',content)
    else:
        sql="insert into shopping_cart values(%s,%s,%s,1);"
        cursor.execute(sql,[login,id,str(datetime.datetime.now())[:19]])
        cursor.fetchall()
        database.commit()
        sql="select * from shopping_cart where shopping_cart_customer_id like %s order by shopping_cart_time desc;"
        lines=cursor.execute(sql,[login])
        data=cursor.fetchall()
        if data:
            for i in range(len(data)):
                sql="select * from goods where Goods_ID like %s;"
                cursor.execute(sql,[data[i]['Shopping_Cart_Goods_ID']])
                good_info=cursor.fetchall()
                print(good_info[0])
                data[i].update(good_info[0])
            content['shopping_cart']=data
        else:
            content['empty']="Your Shopping Cart is Empty."
        return render(request,'shopping_cart.html',content)

def Buy(request):
    login=request.POST['login']
    content={}
    content['login']=login
    id=request.POST['goods_id']
    database=ms.connect("localhost","root","root","mail",port=3306,cursorclass=ms.cursors.DictCursor)
    database.begin()
    cursor=database.cursor()
    sql="insert into customer_order values(0,%s,'D',%s);"
    current_time=str(datetime.datetime.now())[:19]
    cursor.execute(sql,[login,current_time])
    cursor.fetchall()
    # database.commit()
    sql="select customer_order_ID from customer_order where customer_order_customer_ID like %s and customer_order_time like %s;"
    cursor.execute(sql,[login,current_time])
    orderID=cursor.fetchall()
    # print(orderID[0])
    # print(orderID[0]['customer_order_ID'])
    sql="select goods_price from goods where goods_id like %s;"
    cursor.execute(sql,[id])
    price=cursor.fetchall()
    # print(price[0])
    # print(price[0]['goods_price'])
    sql="insert into order_detial values(%s,%s,1,%s,1,'D',%s);"
    cursor.execute(sql,[orderID[0]['customer_order_ID'],id,price[0]['goods_price'],current_time])
    cursor.fetchall()
    database.commit()
    sql="select * from customer_order order by customer_order_time desc;"
    cursor.execute(sql)
    content['order']=cursor.fetchall()
    return render(request,'order.html',content)

def Shopping_Cart_Manage(request):
    database=ms.connect("localhost","root","root","mail",port=3306,cursorclass=ms.cursors.DictCursor)
    database.begin()
    cursor=database.cursor()
    login=request.POST['login']
    content={}
    goods_id=request.POST['goods_id']
    content['login']=login
    if request.POST['button']=="-":
        sql="select shopping_cart_goods_number from shopping_cart where shopping_cart_customer_id like %s and shopping_cart_goods_id like %s;"
        cursor.execute(sql,[login,goods_id])
        number=cursor.fetchall()
        number=number[0]['shopping_cart_goods_number']-1
        if number==0:
            pass
        else:
            sql="update shopping_cart set shopping_cart_goods_number=%s where shopping_cart_customer_id like %s and shopping_cart_goods_id like %s;"
            cursor.execute(sql,[str(number),login,goods_id])
            database.commit()
        # print(number[0]['shopping_cart_goods_number']+1)

        pass
    if request.POST['button']=="+":
        sql="select shopping_cart_goods_number from shopping_cart where shopping_cart_customer_id like %s and shopping_cart_goods_id like %s;"
        cursor.execute(sql,[login,goods_id])
        number=cursor.fetchall()
        number=number[0]['shopping_cart_goods_number']+1
        sql="update shopping_cart set shopping_cart_goods_number=%s where shopping_cart_customer_id like %s and shopping_cart_goods_id like %s;"
        cursor.execute(sql,[str(number),login,goods_id])
        database.commit()
        pass
    if request.POST['button']=="Delete":
        sql="delete from shopping_cart where shopping_cart_customer_id like %s and shopping_cart_goods_id like %s;"
        cursor.execute(sql,[login,goods_id])
        cursor.fetchall()
        database.commit()
        pass

    sql = "select * from shopping_cart where shopping_cart_customer_id like %s order by shopping_cart_time desc;"
    lines = cursor.execute(sql, [login])
    data = cursor.fetchall()
    if data:
        for i in range(len(data)):
            sql = "select * from goods where Goods_ID like %s;"
            cursor.execute(sql, [data[i]['Shopping_Cart_Goods_ID']])
            good_info = cursor.fetchall()
            print(good_info[0])
            data[i].update(good_info[0])
        content['shopping_cart'] = data
    else:
        content['empty'] = "Your Shopping Cart is Empty."
    return render(request,'shopping_cart.html',content)
    pass

def Order_Manage(request):
    login=request.POST['login']
    content={}
    content['login']=login
    operation=request.POST['orderOperations']
    orderID=request.POST['order']
    content['orderID']=orderID
    status=request.POST['status']
    database = ms.connect("localhost", "root", "root", "mail", port=3306, cursorclass=ms.cursors.DictCursor)
    database.begin()
    cursor = database.cursor()
    if operation=="Detail":
        sql="select * from order_information where customer_order_id like %s;"
        cursor.execute(sql,[orderID])
        data=cursor.fetchall()
        content['order']=data
        return render(request,'order_detial.html',content)
        pass
    if operation=="Back":
        sql = "select order_detial_goods_id, order_detial_price, order_detial_number from order_detial where order_detial_customer_order_id like %s;"
        cursor.execute(sql, [orderID])
        goodsInfo = cursor.fetchall()
        for i in goodsInfo:
            # Shop need decrease money here.
            id = i['order_detial_goods_id']
            singlePrice = i['order_detial_price']
            pieces = i['order_detial_number']
            sql = "select goods_shop_id from goods where goods_id like %s;"
            cursor.execute(sql, [id])
            shopId = cursor.fetchall()
            sql = "select shop_funds from shop where shop_id like %s;"
            cursor.execute(sql, [shopId[0]['goods_shop_id']])
            shop_fund = cursor.fetchall()
            sql = "update shop set shop_funds=%s where shop_id like %s;"
            cursor.execute(sql, [float(shop_fund[0]['shop_funds'] - pieces * singlePrice), shopId[0]['goods_shop_id']])
            sql = "select goods_number from goods where goods_id like %s;"
            cursor.execute(sql, [id])
            remaining = cursor.fetchall()
            # Verify Remaining
            sql = "update goods set goods_number=%s where goods_id like %s;"
            cursor.execute(sql, [int(remaining[0]['goods_number'] + pieces), id])
            cursor.fetchall()
            sql = "select customer_funds from customer where customer_id like %s;"
            cursor.execute(sql, [login])
            funds = cursor.fetchall()
            # Verify User's Funds
            sql = "update customer set customer_funds=%s where customer_id like %s;"
            cursor.execute(sql, [float(funds[0]['customer_funds'] + pieces * singlePrice), login])
            cursor.fetchall()
        sql = "update customer_order set customer_order_status='B' where customer_order_id like %s;"
        cursor.execute(sql, [orderID])
        cursor.fetchall()
        sql = "update order_detial set order_detial_status='B' where order_detial_customer_order_id like %s;"
        cursor.execute(sql, [orderID])
        cursor.fetchall()
        database.commit()
        pass
    if operation=="Exchange":
        sql = "update customer_order set customer_order_status='E' where customer_order_id like %s;"
        cursor.execute(sql, [orderID])
        cursor.fetchall()
        sql = "update order_detial set order_detial_status='E' where order_detial_customer_order_id like %s;"
        cursor.execute(sql, [orderID])
        cursor.fetchall()
        database.commit()
        pass
    if operation=="Receive":
        # Shop add money here.
        sql = "select order_detial_goods_id, order_detial_price, order_detial_number from order_detial where order_detial_customer_order_id like %s;"
        cursor.execute(sql, [orderID])
        goodsInfo = cursor.fetchall()
        for i in goodsInfo:
            id = i['order_detial_goods_id']
            singlePrice = i['order_detial_price']
            pieces = i['order_detial_number']
            sql = "select goods_shop_id from goods where goods_id like %s;"
            cursor.execute(sql, [id])
            shopId = cursor.fetchall()
            sql="select shop_funds from shop where shop_id like %s;"
            cursor.execute(sql,[shopId[0]['goods_shop_id']])
            shop_fund=cursor.fetchall()
            sql="update shop set shop_funds=%s where shop_id like %s;"
            cursor.execute(sql,[float(shop_fund[0]['shop_funds']+pieces*singlePrice),shopId[0]['goods_shop_id']])
        sql = "update customer_order set customer_order_status='F' where customer_order_id like %s;"
        cursor.execute(sql, [orderID])
        cursor.fetchall()
        sql = "update order_detial set order_detial_status='F' where order_detial_customer_order_id like %s;"
        cursor.execute(sql, [orderID])
        cursor.fetchall()
        database.commit()
        pass
    if operation=="Cancel":
        print(status)
        if status=="D" or "R":
            if status=="R":
                sql = "select order_detial_goods_id, order_detial_price, order_detial_number from order_detial where order_detial_customer_order_id like %s;"
                cursor.execute(sql, [orderID])
                goodsInfo = cursor.fetchall()
                for i in goodsInfo:
                    id = i['order_detial_goods_id']
                    singlePrice = i['order_detial_price']
                    pieces = i['order_detial_number']
                    sql = "select goods_number from goods where goods_id like %s;"
                    cursor.execute(sql, [id])
                    remaining = cursor.fetchall()
                    # Verify Remaining
                    sql = "update goods set goods_number=%s where goods_id like %s;"
                    cursor.execute(sql, [int(remaining[0]['goods_number'] + pieces), id])
                    cursor.fetchall()
                    sql = "select customer_funds from customer where customer_id like %s;"
                    cursor.execute(sql, [login])
                    funds = cursor.fetchall()
                    # Verify User's Funds
                    sql = "update customer set customer_funds=%s where customer_id like %s;"
                    cursor.execute(sql, [float(funds[0]['customer_funds'] + pieces * singlePrice), login])
                    cursor.fetchall()
            sql = "update customer_order set customer_order_status='C' where customer_order_id like %s;"
            cursor.execute(sql, [orderID])
            cursor.fetchall()
            sql = "update order_detial set order_detial_status='C' where order_detial_customer_order_id like %s;"
            cursor.execute(sql, [orderID])
            cursor.fetchall()
            database.commit()
        else:
            sql = "update customer_order set customer_order_status='F' where customer_order_id like %s;"
            cursor.execute(sql, [orderID])
            cursor.fetchall()
            sql = "update order_detial set order_detial_status='F' where order_detial_customer_order_id like %s;"
            cursor.execute(sql, [orderID])
            cursor.fetchall()
            database.commit()
        pass
    if operation=="Confirm":
        sql="select order_detial_goods_id, order_detial_price, order_detial_number from order_detial where order_detial_customer_order_id like %s;"
        cursor.execute(sql,[orderID])
        goodsInfo=cursor.fetchall()
        ableMoney=True
        ablePieces=True
        for i in goodsInfo:
            id=i['order_detial_goods_id']
            singlePrice=i['order_detial_price']
            pieces=i['order_detial_number']
            sql="select goods_number from goods where goods_id like %s;"
            cursor.execute(sql,[id])
            remaining=cursor.fetchall()
        # Verify Remaining
            if remaining[0]['goods_number']<pieces:
                ablePieces=False
                break
            else:
                sql="update goods set goods_number=%s where goods_id like %s;"
                cursor.execute(sql,[int(remaining[0]['goods_number']-pieces),id])
                cursor.fetchall()
            sql="select customer_funds from customer where customer_id like %s;"
            cursor.execute(sql,[login])
            funds=cursor.fetchall()
        # Verify User's Funds
            if funds[0]['customer_funds']<pieces*singlePrice:
                ableMoney=False
                break
            else:
                sql="update customer set customer_funds=%s where customer_id like %s;"
                cursor.execute(sql,[float(funds[0]['customer_funds']-pieces*singlePrice),login])
                cursor.fetchall()
        if not ableMoney or not ablePieces:
            error=""
            if not ablePieces:
                error="You buy too many goods."
            if not ableMoney:
                error="You do not have enough money to buy it."
            sql = "select * from customer_order order by customer_order_time desc;"
            cursor.execute(sql)
            order = cursor.fetchall()
            return render(request,'order.html',{'login':login,'order':order,'error':error})
        sql = "update customer_order set customer_order_status='R' where customer_order_id like %s;"
        cursor.execute(sql, [orderID])
        cursor.fetchall()
        sql = "update order_detial set order_detial_status='R' where order_detial_customer_order_id like %s;"
        cursor.execute(sql, [orderID])
        cursor.fetchall()
        database.commit()
        pass
    sql="select * from customer_order order by customer_order_time desc;"
    cursor.execute(sql)
    order=cursor.fetchall()
    return render(request,'order.html',{'login':login,'order':order})
    pass

def Settlement(request):
    login = request.POST['login']
    content = {}
    content['login'] = login
    database = ms.connect("localhost", "root", "root", "mail", port=3306, cursorclass=ms.cursors.DictCursor)
    database.begin()
    cursor = database.cursor()
    sql = "insert into customer_order values(0,%s,'D',%s);"
    current_time = str(datetime.datetime.now())[:19]
    cursor.execute(sql, [login, current_time])
    cursor.fetchall()
    sql = "select customer_order_ID from customer_order where customer_order_customer_ID like %s and customer_order_time like %s;"
    cursor.execute(sql, [login, current_time])
    orderID = cursor.fetchall()

    sql="select shopping_cart_goods_id, shopping_cart_goods_number from shopping_cart where shopping_cart_customer_id like %s;"
    cursor.execute(sql,[login])
    goods_list=cursor.fetchall()

    for i in goods_list:
        id=i['shopping_cart_goods_id']
        number=i['shopping_cart_goods_number']

        # print(orderID[0])
        # print(orderID[0]['customer_order_ID'])
        sql = "select goods_price from goods where goods_id like %s;"
        cursor.execute(sql, [id])
        price = cursor.fetchall()
        # print(price[0])
        # print(price[0]['goods_price'])
        sql = "insert into order_detial values(%s,%s,1,%s,%s,'D',%s);"
        cursor.execute(sql, [orderID[0]['customer_order_ID'], id, price[0]['goods_price'], number, current_time])
        cursor.fetchall()

    sql="delete from shopping_cart where shopping_cart_customer_id like %s;"
    cursor.execute(sql,[login])
    cursor.fetchall()
    database.commit()
    sql = "select * from customer_order order by customer_order_time desc;"
    cursor.execute(sql)
    content['order'] = cursor.fetchall()
    return render(request, 'order.html', content)

def Show_List(request):
    content = {}
    try:
        login = request.POST['login']
        content['login'] = login
    except:
        pass

    database = ms.connect("localhost", "root", "root", "mail", port=3306, cursorclass=ms.cursors.DictCursor)
    cursor = database.cursor()
    database.begin()
    sql="call viewSaleListWeek();"
    cursor.execute(sql)
    cursor.fetchall()
    sql="select * from salelist;"
    cursor.execute(sql)
    weekGoods=cursor.fetchall()
    content['weekGoods']=weekGoods
    sql="select * from typelist;"
    cursor.execute(sql)
    weekTypes=cursor.fetchall()
    content['weekTypes']=weekTypes

    sql = "call viewSaleListMonth();"
    cursor.execute(sql)
    cursor.fetchall()
    sql = "select * from salelist;"
    cursor.execute(sql)
    MonthGoods = cursor.fetchall()
    content['MonthGoods']=MonthGoods
    sql = "select * from typelist;"
    cursor.execute(sql)
    MonthTypes = cursor.fetchall()
    content['MonthTypes']=MonthTypes

    sql="select count(Order_detial_Number) as count,order_detial_goods_id from order_detial where order_detial_status='F' group by order_detial_goods_id order by count(Order_Detial_Number) desc limit 3;"
    cursor.execute(sql)
    top=cursor.fetchall()
    content['top']=top

    sql="select goods_id from goods left join order_detial on goods.goods_id=order_detial.order_detial_goods_id and order_detial.order_detial_status='F'  where order_detial.order_detial_goods_id is null;"
    lines=cursor.execute(sql)
    unsold=cursor.fetchall()
    if lines>=3:
        content['unsold']=unsold[0:3]
    else:
        sql="select count(Order_detial_Number) as count,order_detial_goods_id from order_detial where order_detial_status='F' group by order_detial_goods_id order by count(Order_Detial_Number) limit %s;"
        cursor.execute(sql,[int(3-lines)])
        bottom=cursor.fetchall()
        content['bottom']=bottom
        content['unsold']=unsold
    database.commit()
    return render(request,'list.html',content)

#  db = pymysql.connect("localhost", "root", “password", "test", port=3306, cursorclass = pymysql.cursors.DictCursor)
#  cursor = db.cursor()
#  ctx = {}
#  if request.POST:
#  name = request.POST['name']
#  sql = "select * from student where name like %s"
#  cursor.execute(sql, ['%'+name+'%'])
#  else:
#  sql = "select * from student"
#  cursor.execute(sql)
#  data = cursor.fetchall()
#  context = {}
#  context['students'] = data
#  return render(request, 'student.html', context)