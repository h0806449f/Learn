# STRING
# ASK USER'S NAME
# name = input("what's your name? ").strip().title()

# \ 功能
# print("Hello, \"friends\"")
# Hello, "friends"

# REMOVE WHITESPACE
# name = name.strip()

# CAPOTALIZE 
# name = name.capitalize() # first
# name = name.title() # each first word

# OUTPUT
# print(f"Hello, {name}")

# ---

# FLOAT
# x = float(input("Enter X: "))
# y = float(input("Enter y: "))

# z = round(x + y)
# print(f"{z:,}") # format string # x = 999 & y = 1 >>> 1,000

# z = x/y
# print(f"{z:.2f}") # format string # x = 10 & y = 3 >>> 3.33
# z = round(x/y,2) # >>> 3.33

# ---

# DEF

def hello(variable_1 = "world"): # default = world
    print("Hello,",variable_1)

# username = input("Enter your name: ") 
# hello(username) # username will replace variable_1

# ---

# CONDITION
"""
x = int(input("What's x? "))
y = int(input("What's y? "))

if x < y:
    print("x less than y")
elif x > y:
    print("x more than y")
else:
    print("x = y")
"""

# ---

"""
def main():
    x = int(input("What's x? "))
    if is_even(x):
        print("Even")
    else:
        print("Odd")

def is_even(number):
    # return True if number % 2 == 0 else False
    return number % 2 == 0 # 如問題本身僅有兩種答案，可用此方法

main()
"""

# ---

# FOR
"""
for _ in range(3):
    print("meow")
"""

# print("meow\n" * 3,end="")

"""
while True:
    number = int(input("What's number? "))
    if number > 0:
        break
for _ in range(number):
    print("meow")
"""

# 以下這段必須複習

"""
def main():
    number = get_number()
    meow(number)

def get_number():
    while True:
        n = int(input("What's the number? "))
        if n > 0:
            return n

def meow(n):
    for _ in range(n):
        print("meow")

main()
"""

# LIST & DICT

students_0 = {
    "Henry": "Class_1",
    "Leslee": "Class_2",
    "Cindy": "Class_3",
    "Candy": "Class_4",
}

"""
for student in students_0:
    print(student, students_0[student], sep = ", ") # print(key, value)
"""

# list of dict

"""
students_1 = [
    {"name":"Henry", "class":"Class_1", "sexfriend":None},
    {"name":"Leslee", "class":"Class_2", "sexfriend":"Henry"},
    {"name":"Leslie", "class":"Class_3", "sexfriend":"Henry"},
    {"name":"Candy", "class":"Class_4", "sexfriend":"Henry"}
]

for student in students_1:
    print(student,student["name"]) # student 為dict, 用 key 將 value 喚出 
"""

def main():
    print_square(3)

def print_square(size):
    for x in range(size):
        print ("#" * size) # same result

"""
def print_square(size):
    for x in range(3):
        for y in range(3):
            print("@",end= "")   # @@@ 不換行
        print()                  # 每三個換一行
"""
main()


    1
    2
    3