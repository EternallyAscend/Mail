"""OnlineMail URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf.urls import url
from . import OnlineMail

urlpatterns = [
    # path('admin/', admin.site.urls),
    url(r'^index$', OnlineMail.Show_Index),
    # url(r'^register$',OnlineMail.Register),
    # url(r'^finish_register$',OnlineMail.Finish_Register),
    url(r'^login$',OnlineMail.Login),
    url(r'^finish_login$',OnlineMail.Finish_Login),
    url(r'^user$',OnlineMail.User), # Index User to User Page.
    url(r'^add$',OnlineMail.Add),
    url(r'^buy$',OnlineMail.Buy),
    url(r'^order_manage$',OnlineMail.Order_Manage),
    url(r'^manageCart',OnlineMail.Shopping_Cart_Manage),
    url(r'^settlement$',OnlineMail.Settlement),
    url(r'^list$',OnlineMail.Show_List),
    url(r'',OnlineMail.Show_Index),
]
