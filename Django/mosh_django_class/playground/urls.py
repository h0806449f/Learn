from django.urls import path
from . import views
# 當前文件所在的目錄 ??


# URL 配置
urlpatterns = [
    path('hello/', views.say_hello)
]