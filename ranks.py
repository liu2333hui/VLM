import torch

# 创建一个一维张量
tensor = torch.tensor([10, 2, 35, 4, 5])

# 使用torch.sort对张量进行排序，返回排序后的值和对应的索引
sorted_values, sorted_indices = torch.sort(tensor)

# 计算原始张量中每个元素的排名
ranks = torch.zeros_like(sorted_indices)
for i in range(len(sorted_indices)):
    ranks[sorted_indices[i]] = i

print("原始张量:", tensor)
print("排序后的值:", sorted_values)
print("排序后的索引:", sorted_indices)
print("原始张量中每个元素的排名:", ranks)


