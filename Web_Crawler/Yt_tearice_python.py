#%%
# 例外處理
"""
try:                          # 必須有
    可能引發例外的程式區塊
except 例外情形一 [as 參數]:   # 必須有
    處理例外的程式區塊一
except Exception [as 參數]: 
    處理所有其他可能發生的例外
else:
    指令正確時成行的程式區塊
finally:
    一定會執行的程式區塊
"""
#%%
# 例外處理 - 練習1
"""
try:
    number = input('Enter number: ')
    print(number + 1)
except TypeError:
    print("輸入非數字")
except:
    print("碰到不明錯誤")
print("End")
"""
#%%
# 例外處理 - 練習2
while True:   # 重複輸入直到輸出值
    try:
        number1 = int(input("Enter an number: "))
        number2 = int(input("Enter other number: "))
        left_number = number1 % number2
    except ValueError as error1:
        print("Do not enter string")
    except ZeroDivisionError as error2:
        print(f"Here may be an error {error2}")
    except:
        print("An unexcept error")
    else:
        print(left_number)
        break   # 跳出迴圈
    finally:    # 但是在try & except 中，finally 必定會執行
        print("=" * 10)

#%%
# 檔案讀取
"""
    with open (檔案名稱 [, 模式][, 編碼]) af f:
        f.檔案處理函式()
    模式:
    r : 讀取模式，此為預設值
    a : 附加模式，若檔案已存在，內容會被附加於檔案尾
    w : 寫入模式，若檔案已存在，內容會被覆蓋
    # a 和 w 模式，若檔案不存在，會自動新增該檔案
    b : 二進位模式

    檔案處理函式:
    read() : 讀取檔案內容為文字   (string)
    readline() : 讀取檔案內容的第一行文字   (string)
    readlines() : 讀取檔案內容，以行，為元素，儲存為串列   (list)
    write() : 寫入檔案
    close() : 關閉檔案
"""
f = open('test_file1.txt','w')
f.write('first testing line : 123')
f.close()   # 注意，因為上面模式為 write，所以這邊需要將檔案關起來


f = open('test_file1.txt','a')
f.write('\nsecond testing line : today is a beautoful day')   # 換行，在''裡面
f.close()

f = open('test_file1.txt','r')
print(f.read())
f.close()

# 另外一種寫法   (此方法，不需要用到 close() 關閉檔案)
with open('test_file2.txt','a') as f:
    f.write('123')
    f.write('\nabc')

#%%
# 網路爬蟲
"""
    資料爬取 : requests
    使用 get / post(較安全一點) 向網頁伺服器請求
    網頁伺服器 會回應 HTML
    網頁解析 : Beautiful Soup
"""

# 資料爬取 : request 模組
# COVID 各國家地區累積病例數與死亡數
# http://data.gov.tw/dataset/120449
# 資料下載地址 : https://od.cdc.gov.tw/eic/covid19/covid19_global_cases_and_deaths.csv

import requests
url = 'https://od.cdc.gov.tw/eic/covid19/covid19_global_cases_and_deaths.csv'

r = requests.get(url)
# print(r)   # 200 -> http 代碼
r.encoding = 'utf-8'   # 較常用的 Unicode 編碼模式
# print(r.text)   # 直接轉乘text 會發現有一些亂碼

# 將抓取下來的檔案存到本機
with open('python_covid_1.csv', 'w', encoding = 'utf-8') as f:
    f.write(r.text)

#%%
# 圖片下載
# https://www.youtube.com/watch?v=PEiDTL9IMUk            # youtube 影片
# https://img.youtube.com/vi/PEiDTL9IMUk/sddefault.jpg   # 影片縮圖網址 (僅需更換影片ID)
import requests
url = 'https://img.youtube.com/vi/PEiDTL9IMUk/sddefault.jpg'
r = requests.get(url)   # 因為是圖片，檔案為二進位制

# 請求資料為文字時，須用 變數.text
# 請求資料為文字時，須用 變數.content

with open('kokuri.jpg','wb') as f:   # w 寫入模式 & b 二進位模式
    f.write(r.content)

#%%
# 網頁解析
import requests
url = 'http://ehappy.tw/bsdemo1.htm'
r = requests.get(url)   # 將網址存入變數
r.encoding = 'utf-8'    # unicode 避免亂碼
# print(r.text)           # 以文字型態呈現

""" 拆解出來的 html 架構
    <!doctype html>
    <html lang="zh">
    <head>
        <meta charset="UTF-8">
        <title>我是網頁標題</title>
    </head>
    <body>
        <h1 class="large">我是標題</h1>
        <div>
        <p>我是段落</p>
        <img src="https://www.w3.org/html/logo/downloads/HTML5_Logo_256.png" alt="我是圖片">
        <a href="http://www.e-happy.com.tw">我是超連結</a>
        </div>
    </body>
    </html>
"""

from bs4 import BeautifulSoup
sp = BeautifulSoup(r.text,'html.parser')   # 以 html.parser 格式分析r.text，並放入變數中
print(sp.title)        # 可以指定 sp 的任何節點
print(sp.title.text)   # 僅呈現文字型態

print(sp.body.h1.text)    # 練習1
print(sp.body.div.p.text) # 練習2

#%%
# 網頁解析
import requests
from bs4 import BeautifulSoup

url = 'http://ehappy.tw/bsdemo2.htm'
r = requests.get(url)
r.encoding = 'utf-8'

"""
    <html>
    <head>
    <meta charset="utf-8"/>
    <title>我是網頁標題</title>
    </head>
    <body>
    <h1 class="large">我是標題</h1>
    <div>
    <p class="large" id="p1">我是段落一</p>
    <p id="p2" style="font-size:16pt">我是段落二</p>
    <img alt="HTML5 logo" src="https://www.w3.org/html/logo/downloads/HTML5_Logo_256.png"/>
    <ul>
    <li class="odd"><a href="http://www.ehappy.tw">我是超連結1</a></li>
    <li class="even"><a href="http://www.e-happy.com.tw">我是超連結2</a></li>
    </ul>
    </div>
    </body>
    </html>
"""

sp = BeautifulSoup(r.text,'html.parser')
# print(sp.body.p.text)   # 取 body p  但此方法無法取得p2

# 找標籤 tag 方法一
# sp.find('p').text
print(sp.find_all('p')[1].text)  
    # find_all 找出該標籤所有內容
    # 此時型態為List，用index尋找需要內容
    # text 僅取得文字內容

# 找標籤 tag 方法二
print(sp.find('p',id = 'p2').text)

# 找標籤 tag 練習
print(sp.find_all('a')[1].text)
print(sp.find('a', href = 'http://www.e-happy.com.tw').text)
print(sp.find('li',class_='even').text)   #因為class 為 python 保留字，所以使用 class_

# 取得屬性
print(sp.find('li',class_='even').a['href'])   # 取的該超連結
print(sp.find('li',class_='even').a.get('href'))

# # 取得屬性 練習
print(sp.find('img').get('src'))

#%%
# PTT美食版爬蟲 - 練習1：某頁標題
# http://www.ptt.cc/bbs/Food/index.html

import requests
from bs4 import BeautifulSoup

url = 'https://www.ptt.cc/bbs/Food/index7004.html'
r = requests.get(url)
r.encoding = 'utf-8'

sp = BeautifulSoup(r.text,'html.parser')
#print(sp.title.text)   # 確認所有資料已經爬回來

datas = sp.find_all('div',class_='r-ent')   # 此時傳回串列 list
#print(datas[0])                             # 印出串列中的第一個資料，來確認內容
#print("=" * 10)
#print(datas[0].find('a').text)
# or print(datas[0].a.text)

# 確認後，用 for 迴圈，將所有標題印出   !!!
for data in datas:
    print(data.find('div',class_='date').text, end = ' ')   # 不換行
    print('https://www.ptt.cc' + data.find('div',class_='title').a.get('href'),end = ' ')
    # 加上該字串，使超連結更完整
    print(data.a.text)

#%%
# PTT美食版爬蟲 - 練習2：五頁標題
# 思考一 : 讀取五頁標題，僅需變更爬蟲網址
# 思考二 : 整理剛剛 coding，將讀取內容與爬取網頁分開


import requests
from bs4 import BeautifulSoup
url = 'https://www.ptt.cc/bbs/Food/index.html'


# 思考三 : 於 action-bar 找到上下頁的網址，計算有幾個 btn wide 類型
#len(sp.find_all('a',class_ = 'btn wide'))

# 思考四 : 需要上一頁的連結，並取得屬性
#sp.find_all('a',class_='btn wide')[1].get('href')

# 思考五 : 取得屬性後，需取得網址
#last_page = 'https://www.ptt.cc' + sp.find_all('a',class_='btn wide')[1].get('href')

# 思考六 : 取得標題後，url 變數改變，並執行五次
"""
for i in range(5):
    print(f'第{i+1}頁')
    r = requests.get(url)
    sp = BeautifulSoup(r.text,'html.parser')
    datas = sp.find_all('div',class_='r-ent')
    for data in datas:
        print(data.find('div',class_='date').text, end = ' ') 
        print('https://www.ptt.cc' + data.find('div',class_='title').a.get('href'),end = ' ')
        print(data.a.text)

    url = 'https://www.ptt.cc' + sp.find_all('a',class_='btn wide')[1].get('href')
"""

# 思考七 : 執行後，發現有些文章遭刪除，沒有超連結
# 需增加一個條件式
"""
for i in range(5):
    print(f'第{i+1}頁')
    r = requests.get(url)
    sp = BeautifulSoup(r.text,'html.parser')
    datas = sp.find_all('div',class_='r-ent')
    for data in datas:
        if data.find('div',class_='title').a.get('href'):   # 思考八 : 判斷有無超連結屬性，仍會發生錯誤，往上一層找!!!
            print(data.find('div',class_='date').text, end = ' ') 
            print('https://www.ptt.cc' + data.find('div',class_='title').a.get('href'),end = ' ')
            print(data.a.text)

    url = 'https://www.ptt.cc' + sp.find_all('a',class_='btn wide')[1].get('href')
"""

for i in range(5):
    print(f'第{i+1}頁')
    r = requests.get(url)
    sp = BeautifulSoup(r.text,'html.parser')
    datas = sp.find_all('div',class_='r-ent')
    for data in datas:
        if data.find('div',class_='title').a:
            print(data.find('div',class_='date').text, end = ' ') 
            print('https://www.ptt.cc' + data.find('div',class_='title').a.get('href'),end = ' ')
            print(data.a.text)

    url = 'https://www.ptt.cc' + sp.find_all('a',class_='btn wide')[1].get('href')

# 成功擷取五頁標題

#%%
# PTT爬蟲練習3 - 八卦版
# 直接複製剛剛內容會失敗，因為網頁會首先要求勾選：我已經年滿18歲
# cookie : 更多工具 > 開發人員工具 > 應用程式 > cookie
# 發現有一個 over 18 ; 值 : 1 (True)

import requests
from bs4 import BeautifulSoup
url = 'http://www.ptt.cc/bbs/Gossiping/index.html'

cookies = {'over18':'1'}   # 事先設置一個cookie
r = requests.get(url, cookies=cookies)   # 將我們設置的cookie值，帶入url中的cookie值
sp = BeautifulSoup(r.text, 'html.parser')
datas = sp.find_all('div', class_='r-ent')

for data in datas:
    if data.a:
        print(data.find('div',class_='date').text, end = ' ')
        print('http://www.ptt.cc' + data.a.get('href'),end=' ')
        print(data.a.text)

#%%
# 網頁爬蟲練習4 - 台灣彩券 (威力彩)
import requests
from bs4 import BeautifulSoup

url = 'https://www.taiwanlottery.com.tw/index_new.aspx'
r = requests.get(url)
html = BeautifulSoup(r.text,'html.parser')

# 思考一 : 發現 class = contents_mine_tx02，有四個
#len(html.find_all('div',class_='contents_box02'))
# find_all 的資料型態為：串列 list

# 思考二 : 我們要取得的資訊是第一個
html1 = html.find('div',class_='contents_box02')   # find 僅顯示第一個
html2 = html1.find('span',class_='font_black15').text
print(html2)

# 成功後，再練習將開出順序，大小順序找出來
# 因為有多個數字，需要使用find_all，find_all因為是list，不支援text

# 開出順序，不換行
print('開出順序: ',end = '')
for i in range(0,6):
    print(html.find_all('div',class_='ball_tx ball_green')[i].text,end = ' ')

# 換行
print('')

# 大小順序，不換行
print('大小順序: ',end = '')
for i in range(6,12):
    print(html.find_all('div',class_='ball_tx ball_green')[i].text,end = ' ')

#%%
# 網頁爬蟲練習4 - 台灣彩券 (大樂透)
import requests
from bs4 import BeautifulSoup

url = 'https://www.taiwanlottery.com.tw/index_new.aspx'
r = requests.get(url)
html = BeautifulSoup(r.text,'html.parser')

level = html.find_all('div',class_='contents_box02')[2]
level1 = level.find('span',class_='font_black15').text
print(level1)

# 開出順序，不換行
print('開出順序: ',end = '')
for i in range(0,6):
    print(level.find_all('div',class_='ball_tx ball_yellow')[i].text, end = ' ')

# 換行
print()

# 大小順序，不換行
print('大小順序: ',end = '')
for i in range(6,12):
    print(level.find_all('div',class_='ball_tx ball_yellow')[i].text, end = ' ')

# 換行
print()

# 特別號
print('特別號: ', end = '')
print(level.find_all('div', class_='ball_red')[0].text)
# 因為特別號只有一個，也可以用find
# print(level.find('div', class_='ball_red').text)

#%%
# 網頁爬蟲練習4 - 日日新影城 (熱映電影)
# 蒐集電影名稱，說明網址，上映時間
# 下載電影海報照片，儲存在 photos 資料夾

import requests
from bs4 import BeautifulSoup

url = 'https://srm.com.tw/%E9%9B%BB%E5%BD%B1%E7%B0%A1%E4%BB%8B/%E7%86%B1%E6%98%A0%E4%B8%AD/'
r = requests.get(url)
movie = BeautifulSoup(r.text,'html.parser')



for i in range(0,13):
    level = movie.find_all('article',class_ = 'main_color inner-entry')[i]
    print(level.a.get('title'))   # title
    print(level.a.get('href'))    # 超連結
    print(level.find('div',class_='grid-entry-excerpt').text)   # 上映日期