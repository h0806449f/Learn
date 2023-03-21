#%% 常用 str 功能
'''
.format     字符串模板，使用變數合成字串
[:]         利用index取值
.split      字串分割
.join       字串合併
.strip      頭尾去空白
.startwith  是否以 ... 開頭
.replace    以 ... 替換子字串
.find       找尋子字串的第一個 index 值
'''

#%% 常用 str 功能 - 練習 (format)
name_1 = "Henry"
name_2 = "Lesslee"
text = "Hi, couple {} {}".format(name_1,name_2)
print(text)

#%% 常用 str 功能 - 練習 (split / join ; 分隔 & 結合資料)
name_1 = "Henry Lee"
splited = name_1.split(" ")
# 字串中間有空白，split 選擇以空白為區隔，切割name_1

joined = ",,".join(splited)
# list 中，多個資料，以 ,, 合併   !!! 注意順序

print(splited)
print(joined)

#%% 常用 str 功能 - 練習 (strip，去除頭尾空白 / startwith / replace)
dirty_data = "     This is Henry !!   "
print(dirty_data)
print(dirty_data.strip())

print(dirty_data.startswith(" "))
print(dirty_data.startswith("T"))

print(dirty_data)
print(dirty_data.replace("Henry", "Leslee")
                .replace("This", "That")
     )

print(dirty_data.find("T"))

#%% IF ELSE 練習 1
number = 39
if number > 100:
     print("丁組")
elif number > 50:
     print("丙組")
elif number > 0:
     print("乙組")
else:
     print("甲組")

## 較好的做法
number = 39
team_belong = ""

if number > 100:
     team_belong = "丁組"
elif number > 50:
     team_belong = "丙組"
elif number > 0:
     team_belong = "乙組"
else:
     team_belong = "甲組"
print("判斷後組別為: ", team_belong)

#%% IF ELSE 練習 2
age = 1
gender = ""
expense = ""

if gender.upper() == "F":
     expense = 500
elif gender.upper() == "M" and age >=30:
     expense = 1000
elif gender.upper() == "M" and age < 30:
     expense = 700
else:
     expense = "尚未分組"

print("您的消費金額為: ", expense)

# 其他寫法 (巢狀 if else)
if gender == "F":
     print("消費金額為 500")
else:
     if age >= 30:
          print("消費金額為 1,000")
     else:
          print("消費金額為 700")

#%% IF ELSE 練習 3
time = "晚上"
season = "冬"
member = False

if time == "早上":
     if season == "春":
          if member:   # True 可以不指定 == True
               print("此時段免費")
          else:
               print("此時段收費200元")
     else:
          print("此時段未開放")
elif time == "下午":
     if season == "春" or season == "冬":
          print("此時段收費 1000")
     else:
          print("此時段未開放")
elif time == "晚上":
     if season == "春" or season == "冬":
          print("此時段收費 3500")
     else:
          print("此時段收費 2000")

# 其他寫法
if time == "早上":
     if season != "春":
          print("此時段未開放!!!")
     else:
          if member:
               print("此時段免費")
          else:
               print("此時段收費200")

elif time == "下午":
     is_summer_or_autumn = season =="夏" or season =="秋"
     message = "目前未開放!!!" if is_summer_or_autumn else "此時段收費 1000"   # 注意這邊的邏輯
     print(message)

elif time == "晚上":
     is_summer_or_autumn = season =="夏" or season =="秋"
     message_1 = "此時段收費2000!!!" if is_summer_or_autumn else "此時段收費 3500"   # 注意這邊的邏輯
     print(message_1)

#%% 串列 list
scores = [55,99,71,100,99,75,96,88,100]

scores_sum = sum(scores) # sum 總和
scores_len = len(scores) # len 計算 list 中元素個數

print("總分為: {}\n平均為: {}".format(scores_sum,(scores_sum/scores_len)))

# 串列 list 常用功能
data_1 = [1,2,3,4,5]

# 取值    透過 index

# 修改值  透過 index
data_1[0] = "全新的1"

# 新增值  加在list最末端
data_1.append("appended 1")

# 刪除值   透過 index
data_1.pop(-1)

#%% 練習
names = ["Jeff", "Leo", "Keven", "Lisa", "Matty"]
scores = [97, 93, 68, 85, 100]

print("嗨嗨，我是{}, 成績為 {}".format(names[2],scores[2]))
print("該梯次 平均為 {}".format(sum(scores)/len(scores)))

scores[-2] = 72
print("修改{}號同學,新成績為{}".format(4,scores[-2]))
print("該梯次 平均為 {}".format(sum(scores)/len(scores)))

#%% 字典 dictionary
scores_2 = {
     # KEY : VALUE key 值必須為字串 : value 可以為任何資料類別
     "Jeff":55,
     "Leo":99,
     "Keven":71,
     "Holy":100,
     "Jenny":99,
     "Elle":87
}

# dictionary 也可以使用 sum / len，須注意 sum 對象為值；len 對象為 dictionary
print("成績總和:{}".format(sum(scores_2.values())))
print("成績平均:{}".format(sum(scores_2.values()) / len(scores_2)))

# dict 常用功能 - 取值 (透過 KEY 取 VALUE 值)
print(scores_2["Jeff"])

# dict 常用功能 - 修改值 (透過 KEY 取 VALUE 值)
scores_2["Jeff"] = 100
print(scores_2["Jeff"])

# dict 常用功能 - 新增值 
scores_2["Henry"] = '100%'          # 直接新增一組 Henry : 100%
scores_2["Henry"] = [100,95,90]     # KEY 不可以重複，所以會取代

# dict 常用功能 - 刪除值 
del scores_2["Henry"]

# dict 常用功能 - 其他內建功能
# 長度 len           多少對 key&value pair
print(len(scores_2))

# 取 keys & 取 values
print(scores_2.keys())
print(scores_2.values())

#%% dictionary 練習
data = {
     "name":"Jeff",
     "height":170,
     "weight":65,
     "age":26,
     "class":"A-",
     "interest":["喝酒", "爬山", "寫程式"]
}

print(data)

print("嗨嗨,我是{},階級為{}".format(data["name"],data["class"]))

data["height"]=180
print("修改{}的身高為{}".format(data["name"],data["height"]))

# 較好的寫法
data["interest"].append("彈吉他")
print(data["interest"])

#%% dictionary in list
data3 = [
     {"name":"Jeff", "number":1, "math":100, "eng":87},
     {"name":"Leo", "number":2, "math":67, "eng":99},
     {"name":"Keven", "number":3, "math":72, "eng":92},
     {"name":"Jenny", "number":4, "math":89, "eng":33},
     {"name":"Holy", "number":5, "math":97, "eng":61}
]

# 擷取 Jeff 的數學成績
print(data3[0]["math"])

# 修改 Jenny 成績 math -> 95 / eng -> 100
data3[-2]["math"] = 95
data3[-2]["eng"] = 100
print(data3[-2])

# 帶入多個變數的 PRINT
no_0   = data3[0]["number"]
name_0 = data3[0]["name"]
math_0 = data3[0]["math"]
eng_0  = data3[0]["eng"]      # 有多個變數後，要將其帶入 print

print(f"學生號碼{no_0},學生姓名{name_0},數學成績{math_0},英語成績{eng_0}")

# 想print所有人成績，較快速的方法 -> for loop
#%% FOR LOOP
data3 = [
     {"name":"Jeff", "number":1, "math":100, "eng":87},
     {"name":"Leo", "number":2, "math":67, "eng":99},
     {"name":"Keven", "number":3, "math":72, "eng":92},
     {"name":"Jenny", "number":4, "math":89, "eng":33},
     {"name":"Holy", "number":5, "math":97, "eng":61}
]

print("開始執行迴圈")

for element in data3:
     # 思考順序_1：依序取出 dtat3 中的資料，放入變數 element 中。此例：第一次執行：element = data3[0] 是list當中的第一個dictionary
     # 思考順序_2：element 值，確定後，會往下依序執行 第一迴圈.  此例依序執行 : data3[0]["number"] -> data3[0]["name"] -> data3[0]["math"] -> data3[0]["eng"]
     number = element["number"]
     name = element["name"]
     math = element["math"]
     eng = element["eng"]

     print(f"Number:{number},Name:{name},Math:{math},English:{eng}")
     # 思考順序_3：element 值，執行完第一迴圈內的程式碼後，會重新回到for 取出 data3 的第二筆資料，放入 element 中。
     # 思考順序_4 : element 又有了新資料後，會再次回到 思考順序_2

print("迴圈執行完畢")

#%% range 與 FOR LOOP 結合
for test in range(1,7):   # range(1,7) -> 產生 1 - 6 不包含 7 的 list (其實資料型態是class，此為理解方便)
     print(test)
     print("我是區隔行")
     print(f"第{test}次迴圈")
     # 依序print range(1,7) 中的資料

# 練習 - for loop 中 有 if else 條件式
for temp_number in range(1,20):
     if temp_number % 2 == 0:
          print(f"我是{temp_number}，我是偶數!")
     else:
          print(f"我是{temp_number}，我是奇數")
print("迴圈結束")

#%% 整理 : 可以放在 for 迴圈中，跌代的資料類型
# range
for i in range(3,8):
     print(i)

# list
for i in list[1,2,3,4,5]:    
     print(i)

# dictionary !!
dict={"name":"Jeff","age":18,"message":"嗨嗨，今天星期六"}
for key in dict:
     print(key,dict[key])

# string
for w in "Henry is trying his best to learn SQL & Python":
     print(w)

# disctionary in list

#%% 練習
#1. 計算 1+2+3+ ... +100 總和
answer = 0
for i in range(1,101):
     answer = answer + i
print(answer)

#2. 列印出星號圖形
for i in [6,5,4,3,2,1]:
     print(i*"*")
#2. 較好的寫法           !!!
for i in range(6,0,-1):
     print("*" * i)

#3. 有一變數 name = "Jack!"，列印出下列訊息
name = "Jack!"
test = 5

for i in name:
     print(i*test)
     test = test - 1

#%% random
# 大樂透 01 - 49 可以重複 抽取六個號碼
import random

#print( random.random() )         # 隨機取數
#print( random.randint(10,20))    # 於10-20，隨機取數

lotter = []

# 號碼可以重複
#for i in range(1,7):
#     number = random.randint(1,49)
#     lotter.append(number)
#print(sorted(lotter))     # sorted : 排序

# 號碼不重複
for i in range(1,50):                  # 多抽幾次
     number = random.randint(1,49)     # 隨機取數
     
     if number not in lotter:          # 判斷：不重複
          lotter.append(number)
     
     if len(lotter) == 6:              # list 有6個數字後
          break                        # 結束迴圈

print(sorted(lotter))                  # 正向排序
print(sorted(lotter, reverse = True))  # 反向排序

# %% 額外補充，dictionary in list 的排序方法
b = [
     {"name":"Jeff", "number":1, "math":100, "eng":87},
     {"name":"Leo", "number":2, "math":67, "eng":99},
     {"name":"Keven", "number":3, "math":72, "eng":92},
     {"name":"Jenny", "number":4, "math":89, "eng":33},
     {"name":"Holy", "number":5, "math":97, "eng":61}
]

result = sorted(b, key = lambda ele: ele["math"],reverse=True)
for test in result:
     print(test)

#%% 
# WHILE LOOP - 直接進練習
# 1. 計算 1+2+3+ ... +100 總和
total = 0
i = 0

while True:
     if i == 101:
          break
     total = total + i
     i = i + 1
print(total)

# 2. 列印出星號圖形
i = 6
while i > 0:
     print("*" * i)
     i = i - 1


# 3. 有一變數 name = "Jack!"，列印出下列訊息
name = "Tim"
i = len(name)

while i > 0:
     for names in name:
          print(names * i)
          i = i -1

# 4. 大樂透 01 - 49 可以重複 抽取六個號碼
import random
lotter = []

while True:
     number = random.randint(1,49)

     if number not in lotter:
          lotter.append(number)

     if len(lotter) == 6:
          break
print(sorted(lotter,reverse=True))

# 4. 較好的寫法
while len(lotter)<6:     # 於此就進行條件判斷，可以省一段if
     number = random.randint(1,49)

     if number not in lotter:
          lotter.append(number)
print(sorted(lotter,reverse=True))

#%% 
# 雙重迴圈 (巢狀迴圈)

for i in range(1,4):
     for w in ["Leslee","Henry","Leslie"]:
          print(i,w)

# 九九乘法表
for num_1 in range(1,10):
     for num_2 in range(1,10):
          #print(f"{num_1} * {num_2} =",num_1*num_2)
     #print("-"*5)

#%% 
# 練習 1 - 印出特定圖形

for num_1 in range (6,0,-1):
     print("*" * num_1)
for num_1 in range (2,7):
     print("*" * num_1)

#%%
# 練習 2 - 統計個字母出現次數，並以dict表示
data = ["a","b","c","c","c","a","d","b","b","a","c"]
dict = {}

for num_1 in data:
     if num_1 not in dict:
          dict[num_1] = data.count(num_1)
print(dict)

# 較符合邏輯的寫法
for num_1 in data:
     if num_1 in dict:
          dict[num_1] += 1
     # 如需檢查 dict 中是否有特定key值，使用 in
     # 條件，若存在 value 值 +1
     else:
          dict[num_1] = 1
     # 條件，若不存在，設置 value 值為 1
print(dict)

#%% 練習 3 - 寫出九九乘法表，並排列成方陣
for num_1 in range(1,10):
     for num_2 in range(1,10):
          # 設置一個個變數，決定後面的空格
          # 方法一
          #space = ""
          #if num_1 * num_2 >= 10:
          #     space = " "
          #else:
          #     space = "  "

          # 方法二
          space = " " if num_1 * num_2 >= 10 else "  "
          
          # 判斷換行與否，如果沒有設置 變數空格 會導致不工整
          if num_2 == 9:
               print(f"{num_1}*{num_2} = {num_1 * num_2}{space}")
          else:
               print(f"{num_1}*{num_2} = {num_1 * num_2}{space}",end="")

#%% 額外補充，list comprehension 
# 將 list 中，所有的元素都進行一次運算。
a = [1,2,3,4,5]
a_2 = [i**3 for i in a]
print(a)
print(a_2)

#%% 函式 function

def list_func(name,grade):
     result_1 = sum(grade)
     result_2 = sum(grade) / len(grade)
     result_3 = max(grade)
     result_4 = min(grade)   # 想要新的計算資料，可以繼續於def 中增加
     print(f"{name}計算如右->總和為: {result_1},\n 平均為: {result_2},\n 最大值為: {result_3},\n 最小值為: {result_4}")   # \n 換行
     
Math_grade = [60,70,80,90,100,111]
list_func("Math",Math_grade)
print("-"*25)

# 補充 1 有無 return 的差別
# 沒有return的function，執行時，不需要額外的變數去接function，也不需要額外打print

def test(name):
     print("function 起點")
     print(f"Hello, {name}")

print(test("henry"))   # 會返還 : function 起點 / Hello, henry / 且型態為：None
print("-"*25)

def test_1(name):
     print("function 起點")
     print(f"Hello, {name}")
     return "function 終點"

print(test_1("henry"))

# 補充 2 function 內的變數，為：區域變數
# function 內的變數，僅於function 內有效，不可於function外部使用該變數


# 補充 3 function 內可以呼叫其他 function

# 補充 4 break vs continue

for i in range(1,10):
     if i == 4:
          continue
     print(i,end=',')      # 不換行，以逗號取代間隔，繼續列印
     # continue 條件符合，跳過本迴圈，繼續往其他迴圈執行

#%% function 練習 1
