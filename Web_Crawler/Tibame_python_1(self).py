# 思考順序1. 第一個問題 (網址) > 答案 (原始碼)
# 思考順序2. 1. 在原始碼有找到所有需要的資料 > 網址列 (https:// ...)
#           2. 沒找到所有資訊 > 開發人員工具 > Network

# 爬取網頁內資料
"""
    from urllib.request import urlopen,urlretrieve
    # 如果為MAC 需要加下列兩行
    # import ssl
    # ssl._create_default_https_context = ssl._create_unverified_context

    url = "https://www.google.com/doodles/json/2023/2?hl=zh-TW"
    response = urlopen(url)

    # print(response.read())   # 使用 response 內建功能 .read() 但此功能輸出為b (二進位制檔案)

    # 思考順序3. 我們需要何種回應形式 (資料型態)
    #           1. 網頁
    #           2. 多媒體
    #           3. JSON : [] or {} / 語法有兩種 json.load (原始 .read前), json.loads (字串 .read後)
    import json
    doodles = json.load(response)  # 現在我們需要走過list中所有資料 for in 
    for d in doodles:              # 取得 list 中的 dictionary
        url = "https:" + d["url"]
        print(d["title"])          # 我們需要 dictionary 中的 url值
        print(url) # 自己補上 https: 直接變成完整網址

        fname = r"Tibame_Python/doodles/" + url.split("/")[-1]  # 讀出讀片的檔案名稱 (在網址的最後面，用 split 分割後，取最後值)

        # 加上指定資料夾位置 r"Tibame_Python/doodles/"   r 是wind是windows的絕對綠路徑修改為相對路徑
        
        # 接下來針對圖片做處理 (多媒體)   response.read()
        # 須預先創立資料夾 (此用doodles)
        # response = urlopen(url)
        # img = response.read()
        # f = open(fname,"wb")   # 文字檔需r / w / a + encoding = "utf-8" // 圖片檔 rb / wb 圖片本為二進位資料
        # f.write(img)
        # f.close()

        # import 新function：urlretrive 整合:open, read, open(), write(), close()
        urlretrieve(url,fname)
"""

# 爬取網頁內資料 - 練習：取一整年份的圖片
"""
    from urllib.request import urlopen, urlretrieve
    import json
    import os   # os 可以協助路徑處理，檔案是否存在 等等 ... 

    for month in range(3):   # 0,1 ....n-1
        url = f"https://www.google.com/doodles/json/2022/{month+1}?hl=zh-TW"
        print(f"現在處理月份:{month+1}")   # 紀錄處理到哪月份
        page = urlopen(url)

        doodles = json.load(page)   json.load()

        for d in doodles:
            url = "http:" + d["url"]

            dirname = r"Tibame_Python/doodles/" + str(month+1) + "/"   # 依照月份收納，但此時還沒有資料夾
            if not os.path.exists(dirname):   # import os & 創立資料夾
                os.mkdir(dirname)

            fname = dirname + url.split("/")[-1]
            urlretrieve(url,fname)
"""

# 網頁結構
# 網頁排版 : CSS     網頁動態 : JS
# 網頁資料 : HTML (結構大約如下)
"""
    <城堡>
        <公主 髮 = "黑">
            <狗> 汪汪汪! </狗>
        </公主>

        <王子> </王子>
    </城堡>
"""

# HTML 常用標籤
# 有特別功能 : <a> : 超連結 / <img> : 圖片 / <video> : 影片
# 無特別功能 : <div> : 自成一區塊，會強迫換行 / <span> : 文字

# HTML 特定功能特徵              通用功能特徵
# <a> - href = "url"            class = "職業1 職業2 ..."   # 需隔一個空白
# <img> - src = "url"           id = "身分證"   # 此值不重複
# <video> - src = "url"         

# 再複習一下 爬蟲邏輯
# step1 找原始碼
# step2 網頁找原始碼 or 開發人員工具
# step3 開啟URL 的三種型態
#       1. 網頁   -> BeautifulSoup
#       2. JSON   -> json.load(url)
#       3. 多媒體 -> response.read(url)
"""
    from urllib.request import urlopen
    from urllib.error import HTTPError
    from bs4 import BeautifulSoup

    page = 55
    while True:
        url = f"https://tabelog.com/tw/tokyo/rstLst/{page}/?SrtT=rt"
        try:
            response = urlopen(url)   # 發現第60頁以上會有400 Error
        except HTTPError:             # 需要import HTTPError，traceback error 會提醒錯誤種類
            print("好像到最終頁了")
            break

        html = BeautifulSoup(response)

        # Beautiful
        # find (找第一個符合條件) / find_all (找所有符合條件)
        # find 答案僅一個          find_all: list

        # 篩選方法一 : 
        # print(html.find_all("li",{"class":"list-rst"}))
        # 篩選方法二 : 
        for r in html.find_all("li", class_= "list-rst"):   # find_all 找出所有 li 的 list
            ja = r.find("small", class_="list-rst__name-ja")   # find 找出各個 small 的值
            en = r.find("a", class_="list-rst__name-main")
            score = r.find("b", class_="c-rating__val")
            # 有兩種價位，共用span, class_=rating__val 所以改用find_all list index 
            cost_night = r.find_all("span", class_="c-rating__val")[0].text
            cost_day = r.find_all("span", class_="c-rating__val")[1].text
            # text 為內容文本的固定值 / ["href"] 為超連結
            print(ja.text,en.text,en["href"],score.text)
            print(f"價位:夜間-{cost_night},日間-{cost_day}")

        # 最後，想要多爬幾頁內容，整個放入迴圈，並更改最初url
        page = page + 1

        # 執行到最後，發現Erro 400 : Bad Request
"""

#%%   以下是一個 notebook !!!
# 表格處理工具 pandas /CSV
import pandas as pd
#df = pd.read_csv(r"Tibame_Python/ted_main.csv", encoding = "UTF-8")
df = pd.read_csv("ted_main.csv", encoding = "UTF-8")
df

# dataframe
# 單行 (直) or 單列 (橫)   被稱為series

# 單行操作: ["行標籤名"]
df["comments"]

# 多行操作: [ ["標1", "標2", "標3"] ]
# 外面 [] 是 df / 裡面 [] 是 list
df[ ["comments", "description"] ]

# 純粹功能展示 : 翻轉 & 儲存檔案
df.T.to_csv("ted_翻轉.csv",encoding = "UTF-8")
df.T

# 方便的列操作
df.head(5)   # 前五列
df.tail(5)   # 尾五列

# 特定列操作 .iloc ["第一筆", "第二筆"]
df.iloc[100]   # 取得第 100 列資料
df.iloc[ [100,105], : ]   # 取得特定行 100 105 列，所有資料
df.iloc[100:105][["comments", "description"]]   # 取得 100-105 列，特定資料

# 更換表格中的時間: 秒數 -> 格林威治時間
# 表格中的時間 : 1140825600
from datetime import datetime
datetime.utcfromtimestamp(1140825600)
# 轉換成字串
str(datetime.utcfromtimestamp(1140825600))

# 資料轉換流程
# 遞給整行 -> 每個走過流程
# 1. 自定義轉化流程
def timestrans(s):
    return str(datetime.utcfromtimestamp(s))

# apply: apply(流程名字) 對每一個執行一次流程
# 此處apply 只需宣告流程名字，會自動帶入每一列的資料進入流程
df["film_date"].apply(timestrans)

# 將轉換好的時間，帶回到df中   / 在df最後，加入一行 名稱 "西元時間"
df["西元時間"] = df["film_date"].apply(timestrans)   
df

# 篩選操作: 原理 df[ [跟你的列，一樣多的boolean] ]，會留下True的列
df.head(3)   # 選三列

df.head(3)[ [True, False, True] ]   # 僅印出0,2
df.head(3)[ [True, True, True] ]   # 全部印出

# 練習1 : 篩選 comments > 3000 的資料
# 資料中有 2550 rows 所以需要創造 2550 個布林值
# 請篩選 comments > 3000 的資料
# 開始依照 comments 數字轉換 成布林值
def fflow(n):
    if n > 3000 and n < 5000:
        return True
    else:
        return False

# 完成自定義的轉換流程，先拿資料看看
df["comments"]

# 使用apply 判斷出布林值
judge = df["comments"].apply(fflow)

# judge 已經是一個 series 的資料形式，所以可以直接放入判斷中
df[judge]

# ================================================
# 練習2 : 篩選出 tags 中含有特定資訊的列

# 思考1 : 檢查 df["tags"] 的資料型態 -> 是有[]的字串
# 思考2 : 可以用 for in 判斷，但需要list，所以開始轉換資料
# 思考3 : 何種功能可以將帶有 [] 的字串轉換成 lsit -> json
# 思考4 : 使用 if 判斷條件

# import json

# def fflow(s):
#     taglist = json.loads(s)
#     if "children" in taglist:
#         return True
#     else:
#         return False

# 思考5 : 使用 apply
# df["tags"].apply(fflow)

# 發現錯誤!!  json 轉換資料時發生錯誤，使用其他方式轉換資料
# 思考6 : 新功能 eval()
# eval() -> 把傳入的字串 當成一個python程式 執行

def fflow(s):
    taglist = eval(s)
    if "children" in taglist:
        return True
    else:
        return False
judge_tags = df["tags"].apply(fflow)
df[judge_tags]
# 可以簡化 df[df["tags"].apply(fflow)]

# Matplotlib
import matplotlib.pyplot as plt
# hist 依指定欄位繪圖
# 第二參數 : X軸最小值 & 最大值
# 第三參數 : 拆分為多少區間 (多少柱體)
# 可以理解為 : 100 區分成10段 0-10, 10-20 ...
plt.hist(df["languages"], range = (0,100), bins = 10)
plt.show()

#%%
# 複合 : 爬蟲 & pandas 儲存資料的方式
# 爬蟲
# 思考1  找原始碼 -> 網址列
# 思考2  在原始碼內找到網址列 -> 直接使用    (ex.tabelog)
#        不在原始碼內 -> 去開發人員工具找   (ex. doodles)
# 思考3  回應後，需要打開回應的資料，伺服器有可能回應如下資料
#        1. 網頁 -> BeautifulSoup(response)
#        2. JSON -> json.load(response)
#        3. 多媒體 -> response.read()

#%%
# 爬蟲實作 - PTT 網頁爬蟲
# 1. 右鍵 -> 檢視網頁原始碼 -> 原始碼中就找到我們所需要的資訊 等等 ...
# 2. 所以可以直接複製網頁的網址列，並且使用網頁資料型態bs4

from urllib.request import urlopen, Request
from bs4 import BeautifulSoup
from jieba.analyse import extract_tags # 計算關鍵字

"""
    import requests   # 介紹新的套件，但有錯誤時，仍然需要用回urlopen
    url = "https://www.ptt.cc/bbs/movie/M.1677157753.A.0B9.html"
    response = requests.get(url)
    html = BeautifulSoup(response.text)
"""

url = "https://www.ptt.cc/bbs/movie/M.1677157753.A.0B9.html"

r = Request(url)
r.add_header("user-agent", "Mozilla/5.0") # 通常這樣就夠了，不行就複製全部

response = urlopen(r)
# get error
# urllib.error.HTTPError: HTTP Error 403: Forbiden   (權限問題)
# 403-情況1 : ip 被禁止   (此情況非常少見)
# 403-情況2 : 少了 Header   (較多為此，找到自己的user-agent)
# 為了完整 Header 多import 一個Request

html = BeautifulSoup(response, features="html.parser")

# 用開發人員工具，左上角的箭頭，發現無法只拿到文字內容
# PTT 網頁 結構設計的關係

content = html.find("div", id = "main-content")
#print(content.text)   # 發現擷取到所有內容

# 找到要去除掉的值
metas = content.find_all("span", class_="article-meta-value")

# extract 去除的function 一次針對一個
ms = content.find_all("div",class_="article-metaline")
for m in ms:
    m.extract()

ms = content.find_all("div",class_="article-metaline-right")
for m in ms:
    m.extract()

ms = content.find_all("a")
for m in ms:
    m.extract()

ms = content.find_all("div", class_="push")
for m in ms:
    m.extract()

ms = content.find_all("span", class_="f2")
for m in ms:
    m.extract()

ms = content.find_all("div")
for m in ms:
    m.extract()

# 可以額外做的作業：依照回復的推虛文，加分減分，計算文章總分
# 剩下主文後，使用 jieba 找出文章關鍵字
print(f"本文: {content.text}")
print(f"本文關鍵字: {extract_tags(content.text,5)}")

#%%
# 八卦版 - 設置你是否滿18歲的cookie

from urllib.request import urlopen
from bs4 import BeautifulSoup
import requests

url = "https://www.ptt.cc/bbs/Gossiping/M.1677325706.A.B1E.html"

# 拿取回應時，就可以設置cookies了
response = requests.get(url, cookies = {"over18":"1"})
html = BeautifulSoup(response.text,features="html.parser")

print(html.text)

#%%
# 卡提諾狂新聞 - 新聞頁面按下更多，就有更多頁面跑出來
# 但是網頁原始碼沒有改變的情形，如何爬取網站資料
# 所以需要看開發人員工具，去找網頁提出的新 request

# 開發人員工具 -> Network -> XHR -> 重新整理 -> 找到新的request
# 可以看到，每次按更多，不斷地被 request 出去
# 可以從 preview / Response 看到 json 格式

# 但每次的more request出去的網址都一樣
# 關鍵點 : Request Method : Post 不是Get

# Request Method : GET / POST / PUT / DELETE
# requests.get() / requests.post() / request.put ...
# 然後再調整 header, body 等等參數

import requests
import json

for p in range(50):
    url = "https://crazy.ck101.com/category/more" # 此網站已轉型，只稍作練習
    d = {"id":"1","page":str(p+1)}   # 此資訊顯示於開發人員工具
    print("處理頁面:", p+1)
    response = requests.post(url,data = d)
    # resquests 需要拿裡面的內容，要先加text

    # 當初用urllib = json.load(response)   # 但現在資料形式不一樣
    # 須改用json.loads
    news = json.loads(response.text)   # 多則新聞的List
    for n in news:                     # n 是各篇新聞，dict
        url = "https://crazy.ck101.com/post/" + str(n["id"])
        print(n["crazy-rating"], n["title"], url)
        

    # 此時要觀察，網站的網址，是將此新聞的ID放在網址得哪一個段落
    # 每一個網站放的位置不太一樣

    # 做完之後，想找個50頁，先判斷哪些東西需要重複做，然後放到 迴圈中
    # 因為這邊是固定次數，所以使用for in range

#%%
# pytube 套件
import pytube # 下載youtube影片等等
# from pytube import Youtube

yt = pytube.YouTube('https://www.youtube.com/watch?v=XXwIWPx5--8')
# 如果真的想要換行的格式，可以使用()將語法包起來 代表()內同一行
(yt.streams
   .filter(progressive=True, file_extension='mp4')
   .order_by('resolution')
   .desc()
   .first()
   .download())

#%%
# selenium 函示庫說明與實作
# pytohn -> 指令介面 (driver) -> Chorme
# selenium 改版
from selenium import webdriver
from selenium.webdriver.common.keys import Keys

driver = webdriver.Chrome(executable_path=r"Tibame_Python/chromedriver.exe")


# 打開網址
driver.get("https://www.youtube.com/view_all_playlists")

# 輸入
# 於selenium中   (selenium 改方法了)
# find = find_element / find_all = find_elements
search = driver.find_element("name","identifier")
search.send_keys("h0806449f@gmail.com")
