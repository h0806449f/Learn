# TRY &　EXCEPT & ELSE

"""
while True:
    try:
        x = int(input("What's x? "))
    except ValueError:
        print("Please enter integer")
    else:
        break
print(f"x is {x}")
"""

# better version

"""
def main():
    x = get_int()
    print(f"x is {x}")

def get_int():
    while True:
        try:
            x = int(input("What's x? "))
        except ValueError:
            # pass                          # 如果只打pass，將不會提示使用者任何訊息，而繼續往下執行
            print("Please enter integer")
        else:
            return x                        # return 有類似於 break 的功能，可以跳脫loop
"""

# MODULES

"""
import random

coin = random.choice(["Heads", "Tails"])
dice = random.randint(1,6)

cards = ["Ten","Jack","Queen","King"]
random.shuffle(cards)

for card in cards:
    print(card)
"""

import sys
# 從終端擷取變數
"""
# checking error
if len(sys.argv) < 2:
    sys.exit("Too few arguments")
elif len(sys.argv) > 2:
    sys.exit("Too many arguments")

# print name
print("hello, my name is", sys.argv[1])
"""

# SLICE

# PIP

# APIS & REQUESTS & JSON

# LIBRARY

