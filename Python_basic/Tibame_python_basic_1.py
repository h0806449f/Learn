# TA 2-2 讀取一串由空白隔開的數字，每個數字加1後輸出：
"""
    numbers = input().split()   # 讀取一串由空白隔開的數字
    for i in range(len(numbers)):
        numbers[i] = int(numbers[i]) + 1   # 將每個數字轉換為 int 類型，加1後存回原本的列表
    print(*numbers)   # 輸出每個數字（使用 * 運算符展開列表）
"""
"""
    一行解 (串列生成式 練習)
    print([int(number) + 1 for number in input().split()])
"""

# TA 2-3 輸入唯一個數字i，請試試看印出指定數字的(以人類的索引直)第i個數字是多少
"""
    list1 = [0, 1, 1]

    index1 = 1
    index2 = 2

    number = int(input())

    i = 0
    while i < number:
    if number == 1:
        print(list1[0])
        break
    elif number == 2:
        print(list1[1])
        break
    elif number == 3:
        print(list1[2])
        break
    elif number > 3:
        list1.append(list1[index1] + list1[index2])
        index1 = index1 + 1
        index2 = index2 + 1
        i = i + 1
    if number > 3:
    print(list1[number-1])
"""
# 老師的答案
"""
    q = int("100")

    fibo = [0,1]
    while not len(fibo) >= q:
        fibo.append(fibo[-1] + fibo[-2])

    print(fibo[q-1])
"""

# for enumerate
# stds = ["A", "B", "C"]

# for index,value in enumerate(stds):
#     print(index,value)
# 0 A
# 1 B
# 2 C

# 字典
"""
    lover1 = {
    "name": "Leslee",
    "height": 149,
    "weight": 44,
    }

    fuck = {
    "嘴": True,
    "胸": True,
    "穴": True,
    "肛門": True
    }
    # 結合兩個字典
    lover2 = {**lover1,**fuck}
    print(lover2)

    # list 則用 一個*
"""

# 自訂函式
"""
    # 1. 定義型態 (會提示使用者，回傳資料型態)
    # 2. 自己寫說明欄位
    # 3. 預設值

    def drink(item:str = "春芽冷露") -> str:
        "這是說明欄位 - 我是買飲料人"
        print(f"我去買{item}了")
        return (f"我買好了，這就是{item}")

    drink()
"""

# 內建函式介紹
"""
    # map(func,iterable_item)
    a = [1,2,3,4,5]
    map(str,a) # 需要查看map內容，需要再轉list

    print(list(map(str,a)))

    # 自定義函式練習
    def my_map(function,items):
    answer  = []
    for item in items:
        answer.append(function(item))
    return answer

    a = [1,2,3,4]
    b = my_map(str,a)
    print(b)

    c = ["1", "2", "3", "4"]
    d = my_map(int,c)
    print(d)
"""

"""
    # filter(func,iterable_item)
    # 此種又稱具名函式
    def is_even(number:int) -> bool:
    "判斷偶數"
    if number % 2 == 0:
        return True
    else:
        return False

    a = [1,2,3,4,5,6,7,8,9]
    b = list(filter(is_even,a))
    print(b)

    # 不具名函式 (lambda)
    # 使用時機 : 此function 僅一行
    # 使用時機 : 此function 只會用到一次
"""

# enumerate & 多行輸入
"""
    import sys

    texts = sys.stdin.read()

    for index, text in enumerate(texts.splitlines(), start=1):
        print(f"{text}{index}")
"""

# class 物件導向
"""
    class Chair():
    name = "椅子"
    def __init__(self,c:str,) -> None:
        self.color = c

    def seat(self) -> None:
        return(f"這{self.color}{self.name}坐起來很舒服")

    chair_a = Chair("Red")
    print(chair_a.color)
    print(chair_a.seat())

    # 練習之前題目，機器人走路
    class Robot():
    def __init__(self, action: str) -> None:
        self.location = [0, 0]
        for a in action:
        if a == "U":
            self.up()
        elif a == "D":
            self.down()
        elif a == "L":
            self.left()
        elif a == "R":
            self.right()

    def up(self) -> None:
        self.location[1] += 1

    def down(self) -> None:
        self.location[1] -= 1

    def left(self) -> None:
        self.location[0] -= 1

    def right(self) -> None:
        self.location[0] += 1

    r = Robot("RLUU")
    print(r.location)

    # class function 繼承
    class Sofa(Chair):   # 繼承Chair 所有東西
    name = "沙發"

    def lay(self) -> None:   # 多於chair的功能
        return(f"這個{self.color}{self.name}可以躺")
    
    def seat_1(self) -> None:
        super().seat()   # 謹繼承seat 此功能

    sofa_a = Sofa("Black")
    print(sofa_a.color)
    print(sofa_a.seat())
    print(sofa_a.lay())
"""

# 檔案處理
# open(file, mode)
# mode: r w a
"""
    f = open("file.txt","r", encoding = "utf-8")   # 只是開啟檔案
    print(f.read())            # 讀取內容
    f.close()                  # 關閉檔案

    f = open("file.txt", "a", encoding = "utf-8")
    f.write("現在哼哼的叫")
    f.close()

    # python 自動關閉檔案
    with open("file.txt","r",encoding = "UTF-8") as f:
        print(f.read())
"""

# 測試
# 檔案 : main.py
def calc(a,b):
  return a + b

# 檔案 : test_main.py
import unittest
from main import cala

class TestCalaMethods(unittest.TestCase):
  def test_calc(self):
    predict = calc(10, 20)

    self.assertEqual(predict, 30)

if __name__=="__main__":
  unittest.main()
  # 加上此段，此檔案被import 時，以下程式碼不會被執行，僅運行本身此檔案時，會被執行