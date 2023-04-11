from django.shortcuts import render

# Create your views here.
# Django 中 view 用於處理http請求 / 回傳http回應
# 大概流程如下

# 請求處理    : 處理瀏覽器傳來的 http 請求 
# 模型資料存取: 可以透過 ORM 存取資料庫中的資料
# 邏輯處理    : 對取得的資料進行邏輯處理
# 回應產生    : 生成回應

# request -> response
# request handler
# action

from django.http import HttpResponse


def say_hello(request):
    return render(request, "hello.html", {"name":"Henry"})