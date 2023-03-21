#%%
# array
import numpy as np
array_1 = np.array([1,2,3])
print(array_1)
print(array_1.size)

#%%
# array 基本介紹：一維陣列
np.empty(3)   # 未指定的一維陣列
np.zeros(3)   # 都是0的一維陣列
np.ones(3)
np.arange(10)   # 連續資料的一維陣列

#%%
# array 基本介紹：二維陣列
np.array([
    [1,2],
    [3,4],
    [5,6]
])   # 3 * 2的陣列，第一個層次有3個資料，第二個層次有兩個資料
np.empty([3,2])
np.zeros([3,2])
np.ones([3,2])

#%%
# array 基本介紹：三維陣列
np.array([
    [
        [1,2,3],[4,5,6]
    ],
    [
        [7,8,9],[10,11,12]
    ]
    ])
np.empty([2,2,3])
np.zeros([2,2,3])

#%%# array 基本介紹：高維陣列
np.array([[[[1,2],[3,4]]]])

#%%
# 運算功能：逐元運算 針對陣列中的每個資料，逐一進行基本運算

data1 = np.array([1,2,3])
data2 = np.array([10,11,12])

test1 = data1 + data2
print(test1)

#%%
# 運算功能 : 矩陣運算 針對兩個陣列進行矩陣運算
data1 = np.array([2,1])   # 1 * 2
data2 = np.array([[3,2,0],[3,1,-1]])   # 2 * 3

test1 = data1.dot(data2)   # 內積 1 * 3
test2 = data1 @ data2   # 內積 1 * 3
test3 = np.outer(data1,data2)   # 外積 2 * 6

print(test1)
print(test2)
print(test3)

#%%
# 統計運算
data = np.array([
    [2,1,7],
    [3,-5,8]
])

data.sum()
column = data.sum(axis = 0)   # 加總column
row = data.sum(axis = 1)   # 加總row
data.min()
data.cumsum()   # 逐職累加
data.mean()
data.std()   # 標準差

#%%
# 內積運算 & 外積運算
# 內積 第一矩陣後面的維度，需與第二矩陣前面的維度對上 1*4 4*2
data1 = np.array([1,3])
data2 = np.array([
    [2,-1,3],
    [-2,4,1]
])
# [(1*2 + 3*-2) , (1*-1 + 3*4) , (1*3 + #*1)]

result1 = data1 @ data2
print(result1)

result2 = np.outer(data1,data2)
print(result2)

#%%
# 統計運算
data=np.array([
    [2,1,7],
    [-5,3,8]
])
result = data.sum(axis = 0)   # 針對欄，總和
print(result)
result = data.sum(axis = 1)   # 針對列，總和
print(result)
result = data.max(axis = 0)   # 針對欄，找最大值
print(result)
result = data.mean(axis = 1)   # 針對列，找中位數
print(result)
result = data.cumsum(axis = 0)   # 針對欄，逐值累加
print(result)

#%%
# 多維陣列的形狀 shape
data=np.array([
    [2,1,7],
    [-5,3,8]
])
result1 = data.shape
# (2, 3)
result2 = data.T.shape   # 資料轉至
# (3, 2)
result3 = data.ravel()   # 扁平化資料
# [ 2  1  7 -5  3  8]

# 重塑資料形狀   array 中，資料個數需相同
data = np.array([
    [[1,2],[3,4]],
    [[5,6],[7,8]]
])   # 2 * 2 * 2 = 8
result4 = data.reshape(4,2)   # 4 * 2 = 8
#[[1 2]
# [3 4]
# [5 6]
# [7 8]]

#%%
# 練習：多維陣列的形狀 shape 
data = np.ones(9)
print(data)

result1 = data.reshape(1,3,3)
print(result1)   # 重塑資料型態

result2 = result1.T.shape
print(result1.T)   # 轉至資料，仍為 array
print(result2)   # 返還 (4, 2)，不是 array 

result3 = result1.ravel()
print(result3)

data2 = np.zeros(5).reshape(1,5,1)
print(data2)

#%%
# 索引 indexing / 切片 slicing
import numpy as np

data = np.array([
    [1,5,2],
    [3,-1,10]
])

# 多維陣列[索引, 索引]
data[0,0] # 1

# slicing 多維陣列[開始索引 : 結束索引] 不會包含結束索引
data = np.array([3,4,1,5])

data[0:2]   # [3,4]
data[:]   # [3,5,1,4]

# 多維陣列[開始索引 : 結束索引 , 開始索引 : 結束索引]
# 用逗號區隔維度
data = np.array([
    [1,2,3],[4,5,6],
    [7,8,9],[10,11,12]
])

L1 = data[2:4]   # 第一維度，選取 2:4

L2 = data[2:4 , 1:3]   # 第二維度，選取1:3
data = np.array([
    [
        [3,1,2],[1,0,5]
    ],
    [
        [5,4,3],[1,3,-3]
    ]
])

data[1,...]   # ... 代表全部選取
# 第一維 index : 1
# 第二維之後 ... 全部選取

#%%
# 練習
import numpy as np

data = np.array([
    [
        [1,2,3],[4,5,6],[7,8,9]
    ],
    [
        [10,11,12],[13,14,15],[16,17,18]
    ],
    [
        [19,20,21],[22,23,24],[25,26,27]
    ]
])

#%%
# 合併操作 stacking
# 將數個多維陣列，合併成一個

# 合併陣列的第一個維度
# np.vstack((陣列一, 陣列二)) -> np.vstack(tuple)

# 合併陣列的第二個維度
# np.hstack((陣列一, 陣列二))

array1 = np.array([
    [1,2]
])   # 1 * 2

array2 = np.array([
    [3,4]
])   # 1 * 2

result1 = np.vstack((array1,array2))
print(result1)   # 新陣列，shape (2 * 2)
# 合併第一維度時，第二維度數量需一致

result2 = np.hstack((array1,array2))
print(result2)   # 新陣列，shape (1 * 4)
# 合併第二維度時，第一維度數量需一致

#%%
# 練習
array1 = np.array([
    [1,2,3],
    [4,5,6]
])   # 2 * 3

array2 = np.array([
    [7,8,9],
    [10,11,12]
])   # 2 * 3

# 合併第一維度
result1 = np.vstack((array1,array2))
print(f"合併後結果\n{result1}")
print(result1.shape)

result2 = np.hstack((array1,array2))
print(f"合併後結果\n{result2}")
print(result2.shape)

# 測試合併多個陣列
print("==========")
array3 = np.array([
    [-1,-2,-3],
    [-4,-5,-6]
])   # 2 * 3

result3 = np.vstack((array1,array2,array3))
print(result3)

result4 = np.hstack((array1,array2,array3))
print(result4)

#%%
# 切割操作 Splitting
# 根據第一維度切割
# np.vsplit(陣列,切割數量)

# 根據第二維度切割
# np.hsplit(陣列,切割數量)

array1 = np.array([
    [1,2,3,4],
    [5,6,7,8]
])   # 2 * 4

result1 = np.vsplit(array1,2)
print(result1)

result2 = np.hsplit(array1,2)
print(result2)

#%%
# 練習
import numpy as np

arr = np.array([
    [2,4,6,8,10,12],
    [1,3,5,7,9,11]
])   # 2 * 6

result1 = np.vsplit(arr,2)
print(result1)

result2 = np.hsplit(arr,3)
print(result2)