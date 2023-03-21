#%%
#使用自建模組

#_1 於同路徑下創立 並 import
#import testmodel_1 as _1

#_2 可以直接呼叫
#_1.hello()

#%%
# 使用已存在的模組 (亂數函示)

import random
#print(random.randint(1,6))

#%%
# 練習1_骰子遊戲 randint

# 新骰子的內容
contain = 'ABCDEF'
while True:
    inkey = input("任意鍵擲骰子，按Enter結束: ")
    if inkey == "":
        print("結束")
        break
    else:
        number = random.randint(1,6)
        # index表示骰子內容 / index -1 因起始為0
        print(f"擲出骰子點數為:{contain[number-1]}")

#%%
# 練習2_大樂透遊戲 

import random
# choice 從指定範圍中隨機取一個數
#print(random.choice('12345'))
#print(random.choice([1,3,5,7,9]))

# sample 從指定範圍中，隨機取出指定個數
#print(random.sample("13579",2))
#print(random.sample([2,4,6,8,10],3))

# sample變數1 : 指定範圍   range(1,50)
# sample變數2 : 指定抽樣數 7
list_1 = random.sample(range(1,50),7)
print(list_1)

#%%
# 時間模組 ctime, localtime
import time

# 內建功能 help
# help(time.ctime)

# 取得時間戳記的 struct_time
now = time.localtime() 
# 整理
print(f"現在時間\n{now.tm_year}年\n{now.tm_mon}月{now.tm_mday}日\n{now.tm_hour}:{now.tm_min}:{now.tm_sec}")

# 轉換中華民國時間，複習format
cyear = now.tm_year - 1911
month = now.tm_mon
day = now.tm_mday

print("中華民國 {}年 {}月 {}日".format(cyear,month,day))

#%%
# 檔案操作 OS模組 getcwd(), remove(), mkdir(), rmdir(), makedirs()
import os

# 取得目前工作目錄
print(os.getcwd())

#%%
# 檔案操作 os.path模組 abspath(), basename(), exist(), getsize(), split(), join()
# import os

# if os.path.exists('hello.py'):
#    os.remove('hello.py')
#    print('檔案已移除')
# else:
#    print('檔案不存在')

#print(os.path.abspath('tea_rice1_object_oriented_dev.py'))
#print(os.path.basename('tea_rice1_object_oriented_dev.py'))
#print(os.path.getsize('tea_rice1_object_oriented_dev.py'))

#%%
# glob 取得目錄中所有指定類型檔案
#import glob
#files = glob.glob('/CODING_PROGRAM/*')

# 以 for 迴圈單獨顯示各個檔案名稱
#for file in files:
#    print(file)

#%%
# 定義類別 & 建立物件
class A():   # 建立類別A
    def hello(self,name):   # 第二變數name，要求輸入第二變數name
        return(f"Hello {name}")
    def __init__(self,name):   # 設置建構式，如日後class A的內容多且重複時，可以於每次執行時先初始化
        self.name = name
        print("init")



customer1 = A("初始變數1")   # 上面使用self的目的，是將 class A 的功能帶入我們指定的變數中
                            # 此時，customer1 可以使用A內部設置的功能
                            # 由於建構式，class A中的變數name，被初始化為 "初始變數1"
print(customer1.name)
print(customer1.hello("Henry"))


# 於建構式中指定變數後
customer2 = A("初始變數2")
print(customer2.name)
print(customer2.hello("Candy"))

# 繼承 class B 繼承 class A
class B(A):
    pass

customer3 = B("初始變數3")
print(customer3.name)
print(customer3.hello("Leslee"))

#%%
# 定義類別 & 建立物件 - 練習1
# step_1 定義類別
class Person():
    name = 'David'   # 屬性：name
    age = 30   # 屬性：age
    def hello(self):   # 功能：hello
        print("說你好: ")
    def __init__(self,name,age):   # 設class的兩個變數，完成後，上面的兩個變數就可以刪除
        self.name = name
        self.age = age

# step_2 建立第一物件
person1 = Person("Henry",18)      # 分別給兩個屬性 值
print(person1.name,person1.age)   # 使用定義中的屬性
person1.hello()   # 使用定義中的 功能


# step_3 建立第二物件
person2 = Person("Leslee",16)
print(person2.name,person2.age)   # 使用定義中的屬性
person2.hello()

#%%
# 定義類別 & 建立物件 - 練習2 預設參數值!!!   比較重要!!!!!!!!!!
class Person():
    def __init__(self,name = 'default_name',age = 'default_age'):
        self.name = name
        self.age = age
    def hello(self):
        print(f"{self.age} 歲的 {self.name} 您好。")   # 使用上方已經設置的屬性

lover1 = Person()   # default 值
lover1.hello()

lover2 = Person("Leslee",16)
lover2.hello()

#%%
# 定義類別 & 建立物件 - 練習3 建立類別，求矩形的面積
class Square():
    def __init__(self,side1=0,side2=0):   #預設為0
        self.side1 = side1
        self.side2 = side2
    def answer(self):
        print(f"矩形面積: {self.side1} * {self.side2} = ", self.side1*self.side2)

squ1 = Square(33, 33)   # 利用類別：Square 建立物件：squ1
squ1.answer()

squ2 = Square()
squ2.answer()

#%%
# 類別封裝   (可以防止class外部竄改，但會無法被繼承)
class Bank():
    def __init__(self,money=0):
        self.__money = money
    
    def show(self):
        return self.__money

    def deposit(self,amount):
        self.__money = self.__money + amount
    
    def withdraw(self,amount):
        self.__money = self.__money - amount

Henry_bank = Bank(10000)
Henry_bank.show()   # 10000

Henry_bank.deposit(50000)
Henry_bank.show()   # 60000

Henry_bank.withdraw(30000)
Henry_bank.show()   # 30000

Henry_bank.money = 9999999999999   # 為了避免直接設置，竄改 Henry_bank.money 的值，需使用封裝
Henry_bank.show()                  # self.__money = money 設置私用 

#%%
# 類別封裝 - 練習1
class Lover():
    def __init__(self,name):
        self.__name = name
    
    def __speak(self):   # 封裝
        print(f"{self.__name} 說愛你")

    def speak_more(self):
        self.__speak()   # 使用封裝
        print("想吃吃")

person1 = Lover("Leslee")
person1.__speak()    # speak 功能已經被封裝，不能於外部使用

#%%
# 父類別 & 子類別 
class Person():
    def __init__(self,name):
        self.name = name
    def hello(self):
        print(f"{self.name} 說你好")

class Son(Person):                 # 繼承
    def __init__(self,name):
        self.name = 'Son' + name   # 覆寫
    def talk(self):                # 有別於父類別的新方法
        print(f"{self.name} 說你好早安!")

test1 = Son("Henry")
test1.talk()

#%%
# 父類別 & 子類別 - 延伸 super()
class Son(Person):
    def __init__(self,name):
        super().__init__(name)   # 繼承父-建構式的所有東西

    def talk(self):
        super().hello()          # 繼承父-hello功能中所有東西
        print(f"{self.name} 說你好早安!")   # 再增加自己的新功能

#%%
#父類別 & 子類別 - 練習1
# 建立矩形類別求矩形面積；建立三角形類別，繼承矩形，並計算三角形面積

class Rectangle():
    def __init__(self,length,width):
        self.length = length
        self.width = width
    
    def answer1(self):
        return self.length * self.width

class Triangle(Rectangle):
    def answer2(self):
        return super().answer1() / 2   #同時繼承建構式 & answer1

test1 = Triangle(10, 10)
print(test1.answer1())
print(test1.answer2())
