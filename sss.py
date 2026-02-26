import numpy as np
import random
np.random.seed(42)

#for 3d array
def manual_transpose(arr, axes):

    block = [1,1,8]
    block = [1,8,8]
    
    sh = arr.shape

    if axes is None:
        axes = list(range(arr.ndim))[::-1] # [2, 1, 0] for 3D
    
    # 2. 获取新数组的形状
    # 新形状 = 原形状按照 axes 顺序重新排列
    new_shape = tuple(arr.shape[i] for i in axes)
    
    # 3. 创建新数组 (这里为了演示用 zeros，实际 NumPy 返回视图)
    result = np.zeros(new_shape, dtype=arr.dtype)

    for i in range(0,sh[0],block[0]):
        for j in range(0,sh[1],block[1]):
            for k in range(0,sh[2],block[2]):
                #print(i, i+block[0])
                #print(arr.shape)
                slock = arr[i : i+ block[0], j : j+ block[1], k :k+ block[2]]
                new_shape = tuple(slock.shape[i] for i in axes)
                tres = np.zeros(new_shape,dtype=arr.dtype)
                if(axes == (0,2,1)):
                    print(slock)
                    for ii in range(slock.shape[0]):
                        for jj in range(slock.shape[1]):
                            for kk in range(slock.shape[2]):
                                tres[ii,kk,jj] = slock[ii,jj,kk]
                    print(tres)   

                
                return
    

arr_3d = np.random.rand(4, 6, 8)
print(arr_3d.shape)
print(arr_3d)




v1 = np.transpose(arr_3d, axes=(0,2,1))
print(v1.shape)
print(v1)

print("Manual")

mv1 = manual_transpose(arr_3d, axes=(0,2,1))
