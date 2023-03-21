# UNIT TEST - ASSERT

# FILE OF FUNCTION

"""
def main():
    x = int(input("What is x? "))
    print("x squared is", square(x))

def square(x):
    return x * x

if __name__ == "__main__":   # other users import function from this file, will not call this main() function, only if we call file name
    main()
"""

"""
def test_square():
    try:
        assert square(2) == 4
    except AssertionError:
        print("2 squared was not 4")
    try:
        assert square(3) == 9
    except AssertionError:
        print("3 squared was not 9")
"""

# but better way, we can use " pytest "

"""
def test_positive():
    assert square(2) == 4
    assert square(3) == 0

def test_negative():
    assert square(-2) == 4
    assert square(-3) == 9

def test_zero():
    assert square(0) == 0
"""

# And then, run pytest (小部分的code較好執行，且分別執行多個測試，會有更多線索找出編程錯誤)

"""
# test string

def main():
    name = input("What's your name? ")
    print(hello(name))

def hello(to = "World"):
    return f"hello, {to}"   # 如果使用print，則會無法使用pytest，因為沒有return value

if __name__ = "__main__":
    main()

# test string

from hello import hello

def test_hello():
    assert hello("David") == "hello, David"
    assert hello() == "hello, World" # code中，預設值為World
    for name in ["Henry", "Cindy", "Candy"]:
        assert hello(name) == f"hello, {name}"   # 運用for & list 測試，此段仍僅為 "一" 個測試
"""

# TESTING FILES IN ONE FOLDER
# 於終端執行
"""
mkdir test                      # 創建資料夾，test
code test/test_hello.py         # 創建file，test_hello.py
code test/__init__.py           # 創建file，__inin__.py ， 此file等同於告訴python將此資料夾視為"package"
run pytest test
"""

# FILE I/O (input & output)

"""
names = []

for _ in range(3):
    name = input("What's your name? ")
    names.append(name)                              # names.append(input("What's your name? "))

for name in sorted(names):
    print(f"hello, {name}")                         # 此資料目前僅暫存於 Memory
"""

"""
name = input("What's your name? ")

# file = open("name.txt","w")                       # write 模式，will reopen a new file 所以此時應該用append
# file = open("name.txt","a")
# file.write(f"{name}\n")                           # 換行，otherwise -> lesleehenry
# file.close()

#                                                   # 95 - 97行，優化版本

with open("name.txt","a") as file:
    file.write(f"{name}\n")                         # This will automatically close the file
"""

""" Read file which already exist"""
"""
with open("name.txt","r") as file:
    lines = file.readlines()

for line in lines:
    print(line.rstrip())                            # remove the extra \n
"""

#                                                   # 108 - 112行，優化版本
"""
with open("name.txt","r") as file:
    for line in file:
        print("hello,",line.rstrip())
"""

print('hello') 