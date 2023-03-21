# 資料基本型態
# 數字
# 文字
# 布林值
"""
    # 功能 (function) 思考順序
    # 1. 需不需要 傳入資料 給該功能
    # 2. 此功能會不會 回傳資料

    # abs() 絕對值
    # print(abs(-100))   # 100

    # pow() 次方
    # print(pow(10, 2))   # 10的2次方 : 100

    # 練習1 - BMI 計算 (體重) / (身高公尺) ** 2
    BMI = 77 / pow(1.73, 2)

    # len() 資料長度 & index & index-slicing
    name = "Henry"
    name_length = len(name)
    name_slicing = name[0:8]

    # 布林值 & and & or
    Boolean1 = True or False   # True
"""
# 條件判斷 & input
# input 回傳內容，資料型態為 str
# 練習1 - 自己加了 while & try-except-else
"""
    while True:
        try:
            score = float(input("Enter your score: "))
        except:
            print("Please enter number")
        else:
            score_judge = score >= 60
            if score is True:
                print("PASS")
            else:
                print("FAIL")
        break
"""

# 練習2
"""
    score = int(input("Enter score: "))

    if score >= 90:
        print("Rank A")
    elif score >= 80:
        print("Rank B")
    elif score >= 70:
        print("Rank C")
    else:
        print("Rank D")
"""

# 練習3 - 剪刀石頭布
"""
    me = int(input("請出拳 [0]剪刀 [1]石頭 [2]布"))

    import random
    com = random.randint(0,2)
    # 充當翻譯 (list & index)
    list1 = ["剪刀", "石頭", "布"]

    print("你出的拳:", list1[me])
    print("電腦的拳:", list1[com])

    # 思考順序1 : 平手先剔除,由index來看,index n 會輸給 index n+1
    # 思考順序2 : % 取餘數，可以限制數字範圍，而我方需要的數字輪迴 : 0, 1, 2
    # 思考順序3 : com + 1 有可能超過 0,1,2的範圍,進到3
    # 思考順序4 : 所以對 com+1 取餘數
    if me == com:
        print("平手")
    elif me == (com+1)%3:
        print("我贏了")
    else:
        print("我輸了")
"""

# string function - replace(), upper(), lower()
"""
    diary = "Today is monday. Today is beautiful"

    diary_2 = diary.replace("Today","Tomorrow")
    # replace 不會改變原本diary的值 # 所有str function 都不會改變原本的值
    # 有某些功能，會改變原本的值
    print("初始的日記:\n",diary)
    print("修改的日記:\n",diary_2)

    diary = diary.replace("Today","Tomorrow",1)
    print("取代的日記:\n",diary)
"""

# 逃脫字元 : \n, \t, \b
"""
    # \n : 換行, \t : TAB, \b : backspace
    a = "Henry\nLeslee"
    # \n 僅占一個單位
"""

# 迴圈 while
# 思考順序1: 初始條件 
# 思考順序2: 判斷條件
# 思考順序3: 更新條件
"""
    # 1. 初始 = 0
    times = 0
    # 2. 判斷 < 次數
    while times < 10:   # 額外：此處用小於，後面的數字就代表執行迴圈的次數!
        print(f"罰寫{times+1}次")
        # 3. 更新 +1
        times = times + 1
    # 1. 2. 3. 這三個條件不要改!! ，如有其他要求，在while之下的條件區改!!
"""

# 迴圈 while - 練習1: 從 1 加到 10
"""
    result = 0
    times = 0

    while times < 10:
        result = result + (times+1)   # 此時times = 0，所以在此調整 +1
        times = times + 1             # 這邊是計算次數
    print("結果",result)
"""

# 迴圈 while - 練習2: 費氏數列
"""
    # 兩個記憶區
    # lasttwo 初始為0 / lastone 初始為1
    # lasttwo 由 lastone 取代 / lastone 是前兩個數字相加

    lasttwo = 0
    lastone = 0
    times = 0

    while times < 10:
        if times == 0:
            lasttwo = 0
            answer = 0
        elif times == 1:
            lastone = 1
            answer = 1
        else:   # 順序要再思考
            answer = lasttwo + lastone
            lasttwo = lastone
            lastone = answer
        print("第", times+1, "項:", answer)
        times = times + 1

    # 費氏數列
    # 0            
    # 0,1          
    # 0,1,1         
    # 0,1,1,2       
    # 0,1,1,2,3    
    # 0,1,1,2,3,5  
    # 0,1,1,2,3,5,8
"""

# 進階語法
# 群集 
"""
    # 清單 list - index & slicing
    # 語法允許list中有不同類型的資料，但實務上最好放同類型的資料
    name_list = ["Henry", "Cindy", "Leslee"]
    print(name_list[0:2])

    name_list = name_list + ["Candy"]   # list & list 才可以相加
    print(name_list)
    print(len(name_list))

    # 依序 print list 中的資料
    # while 的用法
    times = 0
    while times < len(name_list):
        print(name_list[times])
        times = times + 1
    # for
    for i in name_list:
        print("-",i)
"""

# 額外練習 dictionary
"""
    dic1 = {1:"Henry",2:"Leslee",3:"Cindy"}
    # keys
    for i in dic1.keys():
        print(i)
    # values
    for i in dic1.values():
        print(i)
    # key & value pair
    for i in dic1.items():
        print(i)
"""

# list - 練習1 : 1 加到 10
"""
    result = 0
    for times in range(0,10):
        result = result + (times + 1)
    print(result)
"""

# list - list.append(object), list.insert(index,object), list.remove(object)
# list - list.reverse(), list.sort()
"""
    name_list = ["Henry", "Cindy", "Candy"]

    name_list_1 = name_list.insert(1,"Leslee")
    print(name_list_1)   # None 因為 insert 會直接改變原本的資料
    print(name_list)     # 原本的值 (list) 已經改變

    name_list.insert(-1,"Leslee")
    print(name_list)

    # remove()
    # name_list.remove("Leslee")   # 會直接刪除list 中找到的第一個重複值
    # print(name_list)

    # del 
    del name_list[-1]              # 刪除指定位置資料
    print(name_list)
"""

# list - 練習2 : 三門問題
"""
    import random

    win = 0
    lose = 0

    for times in range(0, 100):
        # 步驟1 : 準備三個門
        doors = ["羊", "羊"]
        c = random.randint(0,2)
        doors.insert(c,"車")   # insert 會改變原本值，所以不再指定回去
        print("隨機三個門: ",doors)   # 測試車子位子是否隨機

        # 步驟2 : 讓參賽者挑一個門
        c = random.randint(0,2)
        print("使用者選的:",doors[c])
        del doors[c]
        print("剩下門:", doors)

        # 步驟3 : 主持人開一隻羊出來
        doors.remove("羊")
        print("最後剩下的門:",doors)

        # 步驟4 : 確認參賽者的輸贏
        # 最後剩下的doors，資料型態仍然為list
        if doors[0] == "車":
            win = win + 1
            print("WIN")
        else:
            lose = lose +1
            print("LOSE")
    print("贏的次數:", win)
    print("輸的次數:", lose)
    print("贏的機率:", win / (win + lose) * 100, "%")
    print("輸的機率:", lose / (win + lose) * 100, "%")

    # 步驟5 : 加入while 迴圈
    # 思考順序1 : 哪些步驟需重複
    # 思考順序2 : 使用何種迴圈 (使用: 固定次數 or 不固定次數 or 群集)

    # 步驟6 : 計算 輸贏次數 於if條件式後，加上 +1
"""

# list - 練習2 : 三門問題   (自己練習)
"""
    # 步驟1 : 準備三個門
    # 步驟2 : 讓參賽者挑一個門
    # 步驟3 : 主持人開一隻羊出來
    # 步驟4 : 確認參賽者的輸贏
    # 步驟5 : 加入while 迴圈
    # 步驟6 : 計算 輸贏次數 於if條件式後，加上 +1
    import random

    times = 0
    win = 0
    lose = 0

    while times < 100:
        doors = ["羊", "羊"]
        r = random.randint(0,2)
        doors.insert(r,"車")
        print(doors)
        # 以上 隨機三道門

        r = random.randint(0,2)
        print("挑的門:", doors[r])
        del doors[r]
        print("剩的門:", doors)
        # 以上 挑一個門 & 顯示剩下的門

        doors.remove("羊")
        print("主持人干預後，受下的門", doors)

        if doors[0] == "車":
            print("WIN")
            win = win + 1
        else:
            print("LOSE")
            lose = lose + 1
        times = times + 1
    total = win + lose
    print("勝率:", (win/total) * 100, "%")
    print("敗率:", (lose/total) * 100, "%")
"""

# 字典 dictionary
"""
    person0 = {"name":"Henry", "hight":173, "handsome":True}

    person0.keys()
    person0.values()
    person0.items()

    print(person0["name"])   # Henry，使用 dictionary 的鍵值

    # 於 dictionary 中新增資料 & 更改資料
    person0["weight"] = 75   # 新增體重

    # 於 dictionary 中更改資料
    person0["weight"] = person0["weight"] + 3   # 修改體重

    # 刪除 dictionary 中的資料
    del person0["weight"]   # 刪除體重

    for key in person0:   # 在 dictionary 的情況中，可以直接使用 key
        print("鍵值", key, person0[key])
"""

# 字典 dicyionary - 練習 : 計算字數
"""
    # 讀取檔案
    # 1. 所有資源都要放在專案底下
    # 2. 檔案路徑 : 相對路徑
    #  Windows 需要特別指定相對路徑...絕對路徑，前面再加上一個r，就會變成相對路徑 
    f = open(r"D:\Coding_Program\Tibame_Python\a.txt", "r", encoding = "utf-8")   # "r" 唯讀模式, 編碼模式 encoding = "utf-8"

    article = f.read()   # 讀取檔案

    f.close()   # 關閉檔案，會自動儲存

    # print(article)

    # 創立空字典
    result = {}

    for c in article:
        # 對，第二次以上遇到此字
        if c in result:
            result[c] = result[c] + 1
        # 錯，第一次遇到此字
        else:
            result[c] = 1
    #print(result)


    # 語言處理 jieba (AI 讀懂文意)
    # 邏輯1: 該詞出現次數越多，越重要 (分數越高)
    # 邏輯2: 慣用修正，蒐集很多不同文章，在不同文章出現次數都很多的詞，越不重要  (分數越低)
    # tf-idf 方法

    # jieba : 分詞 > 數次數 > 慣用係數 > 算出分數   全部都處理完畢
    import jieba.analyse
    # keywords = jieba.analyse.extract_tags(article, 5)   # 分詞 > 數次數 > 慣用係數 > 算出分數

    # 5，代表取前五名，default = 20
    #print("前五關鍵詞:",keywords)
"""

# import package & 部分匯入
"""
    # jieba 相關知識 (import) (github : https://github.com/fxsjy/jieba)
    # 分詞的問題 1 : 有時會出現歧義字 (球拍/賣完了 vs 球/拍賣完了)
    # 分詞的問題 2 : 新詞            (傻眼貓咪 vs 傻眼/貓咪)
    import jieba
    import jieba.analyse   
    (from jieba import analyse，如用此寫法，下方可以直接寫: analyse.extract_tags(article,5))

    f = open(r"D:\Coding_Program\Tibame_Python\a.txt", "r", encoding = "utf-8")
    article = f.read()
    f.close()

    # 可以直接在dict文件中，新增加自己定義的詞
    jieba.load_userdict(r"D:\Coding_Program\Tibame_Python\mydict.txt")   # 需要貼上相對路徑，r的部分為Windows調整



    # 此時的資料型態是 jieba 自己定義的，無法 print
    # 使用 " ".join 可以看到jieba怎麼切割文字的 
    sep = " ".join(jieba.cut(article))
    print(sep)

    print("關鍵詞:",jieba.analyse.extract_tags(article,5))

    jieba.load_userdict(r"D:\Coding_Program\Tibame_Python\mydict.txt")
"""

# 群集 : 1. list /2. dictionary /3. set
# set "不重複" 的 "同類型" 的資料群集
"""
    name_set = {"周", "林", "黃", "李", "周"}

    print(name_set)   # 1.重複的值，會自動刪掉 / 2.沒有順序性

    name_set.add("許")   # 新增資料到 set 中 / 會取代原本資料內容
    print(name_set)

    name_set.discard("周")   # 移除 set 中的資料
    print(name_set)

    name_set.union({"何","李"})   # 使用union，不會取代原本資料型態，所以需要指定新變數
    name_set2 = name_set.union({"何","李"})
    print(name_set2)

    for i in name_set2:   # for in 也可以適用 set
        print(i)
"""

# set - 練習1 : 樂透彩
    # 思考順序1: 產生隨機不重複的7個數字，放入set
    # 思考順序2: 產生隨機不重複的7個數字，放入set
    # 思考順序3: 兩個set 互相比值
"""
    import random

    prize = set()   
    while len(prize) <7:
        n = random.randint(1, 48)
        prize.add(n)
    print(f"頭獎的號碼:,{prize}")

    # 無窮迴圈 + 手動停止
    # 使用時機: while 條件寫不出來的時候。
    lottery_count = 0
    while True:
        lottery = set()   # 產生空的set

        while len(lottery) <7:
            n = random.randint(1, 48)
            lottery.add(n)   # set add 不會增加重複的值，如果用if則需要增加判斷式

        print(f"我買的彩券:,{lottery}")

        lottery_count = lottery_count + 1   # 買的彩券數量 +1

        prize = set()   
        while len(prize) <7:
            n = random.randint(1, 48)
            prize.add(n)
        print(f"頭獎的號碼:,{prize}")

        total = 0
        for i in lottery:
            if i in prize:
                print(i,"COUNT!")
                total = total + 1
        print("中了", total, "個數字")

        # 設置停止條件
        if total >= 6:
            break

        # 最後，我們需要記憶買了幾張彩券
    print(f"總共買了{lottery_count}張才中")
"""

# Tuple
"""
    person1 = ("Henry", 175, 80)

    new = person1 + ("Taipei", )   # 於 tuple 中，增加"一"個資料

    new[-1]   # 取特定資料
    new[:3]   # 取特定範圍資料
"""

# 自定義函式 - 再做一次彩券問題
"""
    import random

    def generate_ticket():
        ticket = set()
        while len(ticket) <7:
            number = random.randint()
            ticket.add(number)
        return ticket

    prize = generate_ticket()
    print("中獎彩券")

    times = 0

    while True:
        lottery = generate_ticket()
        print("買的彩券")
        times = times + 1

        ...
"""

# 自定義函式
"""
    def 功能名稱(暫時名字1,暫時名字2):
        ...
        return 
"""
"""
    # 兩資料相加
    # 1. =1, 預設參數，一旦預設參數，右邊所有參數都要預設值
    # 2. 使用函式時，如果想直接使用n4，可以直接指定 (指定代入)
    def add(n1,n2,n3=1,n4=1):
        return (n1 + n2) / n3 * n4

    print

    def add_multiple(*list1):   # 參數為list
        result = 0   # 此處設置0，代表list1只能輸入整數
        for n in list1:
            result = result + n
        return result

    # print(add_multiple([3,4,5,6])) # def add_multiple(list1)

    # * 此星號，代表會在所有參數外圍，加上 []
    # print(add_multiple(3,4,5,6))   # def add_multiple(*list1)
"""

# 物件導向 # 通常首字大寫
"""
    # 1. def 計算BMI
    def BMI(height, weight):
        return wieght / (height / 100) ** 2

    # 2. class
    class Person:
        # name = None   # 每次都要自己輸入此三個變數，所以在設置一個流程 
        # height = None 
        # weight = None 
        def __init__(self,name,height,weight):
            self.name = name
            self.height = height
            self.weight = weight

        def return_bmi(self):   #(此時不用再定義參數，上面已經定義)
            return self.weight / (self.height / 100) ** 2
        
        def isoverBMI(self):
            if self.weight / (self.height / 100) ** 2 > 20:
                return "Overweight"
            elif self.weight / (self.height / 100) ** 2 > 15:
                return "Good"
            else:
                return "Underweight "

    p2 = Person("Leslee",150,45)
    # p2.name = "Leslee"
    # p2.height = 155
    # p2.weight = 45
    print(p2.name,p2.return_bmi())
    print(f"BMI值:{p2.isoverBMI()}")
"""