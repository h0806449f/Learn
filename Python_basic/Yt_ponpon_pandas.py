"""
    pandas資料分析 : 
    基礎教學, 單維度資料, 雙維度資料, 篩選資料, google play store 實作
"""
import pandas as pd

people = pd.Series(["Henry", "Cindy", "Candy", "Leslee"])
numbers = pd.Series([1, 2, 3, 4])

people = people+["cat"]   # Henrycat, Cindycat, Candycat, Lesleecat

numbers = numbers == 4   # False, False, False, True

df = pd.DataFrame({                          # keys 會自動成為 行標題
    "name": ["Henry", "Leslee", "Candy"],   
    "salary": [30000, 50000, 60000],
    "age": [18, 20, 22]
})

# 取得特定 欄
name = df["name"]
name_age = df[ ["name", "age"] ]   # 第一[ ]代表df   第二[]代表 list  

# 取得特定 列
test1 = df.iloc[0]
test2 = df.iloc[ [0,2] ]   # Henry, Candy
test3 = df.iloc[0:2]       # Henry, Leslee

# Series & 自訂索引值
numbers = pd.Series([1, 2, 3, 4],index=[1, 2, 3, 4])   # 內建會是 : 0, 1, 2, 3


# Series 字串相關操作 .str.function
people = pd.Series(["Henry", "Cindy", "Candy", "Leslee"])
"""
    print(people.str.lower())
    print(people.str.upper())
    print(people.str.len())
    print(people.str.cat(sep = "_@_"))   # 將自串串在一起，並以指定符號區隔
    print(people.str.contains("H"))      # 判斷是否包含某字串
    print(people.str.replace("Leslee", "Leslie"))   # replace
"""

# DataFrame 操作
df = pd.DataFrame({                          
    "name": ["Henry", "Leslee", "Candy", "Cindy", "Judy", "loli"],   
    "salary": [30000, 50000, 60000, 70000, 25000, 300000],
    "age": [18, 20, 22, 25, 18,12]
})

print(df.size)           # 有幾筆資料
print(df.shape)          # n * n
print(df.index)          # index
print("="*20) 
print(df.iloc[0])        # 特定列
print(df.iloc[0:5])      # 特定範圍的列
print(df[["name", "age"]])   # 特定欄

df["sex"] = [True, True, False, False, False, True]
print(df)