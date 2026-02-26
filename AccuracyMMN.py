#import MNN.Net as Net
#from MNN.OpType import OpType
#from MNN.Convolution2D import Convolution2D

#buf = open("C:\\Users\\liu23\\Desktop\\projects\\VLM\\VIT\\vit_small.mnn.weight", 'rb').read()
#buf = bytearray(buf)
#net = Net.GetRootAsNet(buf, 0)

import MNN.nn as nn
import MNN.cv as cv
import MNN.numpy as np
import MNN.expr as expr

# 配置执行后端，线程数，精度等信息；key-value请查看API介绍
config = {}
config['precision'] = 'low' # 当硬件支持（armv8.2）时使用fp16推理
config['backend'] = 0       # CPU
config['numThread'] = 4     # 线程数

rt = nn.create_runtime_manager((config,))

# 加载模型创建_Module
net = nn.load_module_from_file('mobilenet_v1.mnn', ['data'], ['prob'], runtime_manager=rt)
