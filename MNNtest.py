import MNN
from MNN import expr
import json
from functools import reduce
import numpy as np
#net = MNN.nn.load_module_from_file("./llm.mnn",["position_ids","patches"],["logits"])
def get_size(l):
    return int(reduce(lambda x, y: (x) * (y), l))
    
def replaced(numbers , v , r=-1):
    return list(map(lambda x: v if x == r else x, numbers))

def tiles(v, tiling):
    return (v + tiling-1) // tiling


def get_conv_params(k):
    padX = k['main']['common']['padX']
    padY = k['main']['common']['padY']
    kernelX =k['main']['common']['kernelX']
    kernelY =k['main']['common']['kernelY']
    strideX =k['main']['common']['strideX']
    strideY =k['main']['common']['strideY']
    outC = k['main']['common']['outputCount']
    inC = k['main']['common']['inputCount']
    return padX,padY,kernelX,kernelY,strideX,strideY\
                    ,outC,inC 
    
class MyCompiler:

    def load_json(self, file_path):
        #file_path = "llm.mnn.json"
        #file_path = "visual.json"
        with open(file_path, 'r') as file:
            self.data = json.load(file)

    def set_hw(self, hw):
        self.hw = hw

    def set_rt(self, rt):
        self.rt = rt

    def analyze_tensors(self, inputs, use_inputs = True, debug = False, input_data = {}):
        for k in self.data['oplists']:
            continue
        tensors = {}
        #for k in self.data['tensorName']:
        #    #tensors[k] = []
        #    #print(k)
        #    #input()
        vals = {}

        
        
        exec_order = []#future make into tree
        
        for k in self.data['oplists']:
            if(debug):
                print(k['type'],k)
            ty = k['type']
            ou = k['outputIndexes'][0]
            ins =k.get('inputIndexes',[])
            
            if(ty == "Input"):
                tensors[ou] = list (k['main']['dims'])
                if(use_inputs):
                    tensors[ou] = list(inputs[k['name']])
                    if(k['name'] in input_data):
                        vals[ou] = input_data[k['name']]
                    
                    
                #如果有-1怎么办？
            elif(ty == "Const"):
                if('dims' in k['main']):
                    tensors[ou] = list( k['main']['dims'] )
                else:
                    #print(k)
                    tensors[ou] = list([len(k['main'].get('int32s', k['main'].get('float32s',0)))])
                if('int32s' in k['main']):
                    
                    vals[ou] = list(k['main']['int32s'])
                    if(vals[ou][0] > 99999):
                        vals[ou] = [1024]#(todos adhoc) cap at 1024 say
            elif(ty == "Reshape"):
                orig = tensors[ins[0]] #origshape

                if("dims" in k['main']):
                    shp = k['main']['dims']
                else:
                    shp = vals[ins[1]] #shape
                #print(orig)
                #print(shp)
                #tensors[ou] = shp
                size = abs(get_size(shp))
                size2 = abs(get_size(orig))
                tensors[ou] = list( replaced(shp, int(size2/size)) )
                #tensors[ou] = 
            elif(ty == "Shape"):
                orig = tensors[ins[0]] #origshape
                tensors[ou] = [ len(orig) ]
                vals[ou] = list ( orig )

            elif(ty == "SliceTf"):
                orig = list(tensors[ins[0]])
                start = list(vals[ins[1]])
                end = list(vals[ins[2]])
                #print(ins[0])
                #print(ins[1])
                #print(ins[2])
                #print(orig)
                #print(start)
                #print(end)
                #input()
                orig[0] = end[0]
                tensors[ou] = list( orig )
                vals[ou] = list( vals[ins[0]][ start[0] : start[0] + end[0] ]   )

            elif(ty == "Slice"):
                    #print(k)
                    orig = tensors[ins[0]]
                    slices = vals[ins[1]]
                    start = [slices[0]]
                    end = [slices[1]]
                    stride = [slices[2]]

                    for outs in k['outputIndexes']:
                        tensors[outs] = list(orig)
                    #input()
               
            elif(ty == "StridedSlice"):
                #print(k)
                orig = list(tensors[ins[0]])
                start = list(vals[ins[1]])
                end = list(vals[ins[2]])
                stride = list(vals[ins[3]])
                #print(k)
                #print(start)
                #print(end)
                #print(stride)
                #print(ins)
                #print(vals)
                #print(tensors)
                tensors[ins[0]]
                orig[0] = end[0]
                if(stride[0] == 0):
                    stride = [1]
                tensors[ou] = list( orig )
                if(ins[0] in vals):
                    vals[ou] = list( vals[ins[0]][ start[0] : start[0] + end[0] : stride[0] ]   )

                
                #input()
                

                        
            elif(ty == "Concat"):
                axis = k['main']['axis']
                #for i in ins:
                #    print(tensors[i])
                    
                res = list( tensors[ins[0]] )
                #print(res)
                for idx in range(len( res )):
                    for i in ins[1:]:
                        if(idx == axis):
                            res[idx] += tensors[i][idx]
                tensors[ou] = res

                if(ins[0] in vals):
                    res_val = list( vals[ins[0]] )

                    
                    
                    vals[ou] = res_val
                    for i in ins[1:]:
                        vals[ou] = list(np.concatenate((vals[ou], vals[i] ), axis=axis))
                    #input()
                    for v in range(len(vals[ou])):
                        vals[ou][v] = int(vals[ou][v])

            #similar to transpose
            elif(ty == "Permute"):
                m = {}
                v1 = tensors[ins[0]]
                v2 = k['main']['dims']
                for x,y in zip(v1 , v2):
                    m[y] = x
                trans = []
                for i in range(len(v2)):
                    trans.append(m[i])
                tensors[ou] = list(trans)                
           
            elif(ty == "Transpose"):
                m = {}
                v1 = tensors[ins[0]]
                v2 = vals[ins[1]]
                for x,y in zip(v1 , v2):
                    m[y] = x
                #print(m)
                ##print(v1)
                #print(v2)
                
                trans = []
                for i in range(len(v2)):
                    trans.append(m[i])
                #print(trans)
                tensors[ou] = list(trans)

            elif(ty == "Unpack"):
                v1 = tensors[ins[0]]
                vo = []
                for idx,i in enumerate(v1):
                    if(idx == k['main']['axis']):
                        continue
                    else:
                        vo.append(i)
                for ou in k['outputIndexes']:
                    tensors[ou] = list(vo)

            elif(ty == "ConvertTensor"):
                #memory nchw -> nc4hw4
                v1 = tensors[ins[0]]
                tensors[ou] = list(v1)

            elif(ty == "GatherV2"):

                v1 = tensors[ins[0]]
                if(ins[1] not in vals):
                    tensors[ou] = list(v1)
                else:
                
                    axis = vals[ins[2]][0]
                    v1 = tensors[ins[0]]
                    indices = vals[ins[1]]
                    #print(v1, vals.get(ins[0],""))
                    #print(indices, vals.get(ins[1],""))
                    #print(axis)
                    #print(k)
                    #input()

                    #print(indices)
                    #print(axis)
                    #print(v1)

                    
                    res = list(v1)
                    res[ axis ] = len(indices)
                    tensors[ou] = res

                    if(get_size(v1) < 10):
                        if(ins[0] in vals and ins[1] in vals):
                            res = []
                            for i in vals[ins[1]]:
                                res.append(vals[ins[0]][i])
                            vals[ou] = list(res)
                '''
                res = []
                for idx in range(len(indices)):
                    if(idx == axis):
                        res.append(indices[idx])
                    else:
                        res.append( v1[idx] )
                tensors[ou] = list(res)

                if(ins[0] in vals and ins[1] in vals):
                    res = []
                    for i in vals[ins[1]]:
                        res.append(vals[ins[0]][i])
                    vals[ou] = list(res)

                #input()v 
                # [1, 145, 384]  [0, 0]  [1] -> r
                #r [-1, 384, 1, 1] =   
                ''' 
            elif(ty == "Unsqueeze"):
                v1 = list(tensors[ins[0]])
                if(len(ins) == 1):
                    #   if(k['main']['squeezeDims']):
                    tensors[ou] = [1] + v1
                else:
                    axis = vals[ins[1]][0]
                    v1.insert(axis, 1)
                    tensors[ou] = v1 

                if(ins[0] in vals):
                    vals[ou] = list(vals[ins[0]])

            elif(ty == "Squeeze"):
                if(len(tensors[ins[0]]) == 1):
                    tensors[ou] = list(tensors[ins[0]])
                    vals[ou] = list(vals[ins[0]])
                else:
                    res =[]
                    for i in tensors[ins[0]]:
                        if(i == 1):
                            continue
                        else:
                            res.append(i)
                    if(len(res) == 0):
                        res = [1]
                    tensors[ou] = list(res)
                

            elif(ty == "Rank"):
                #assume full rank
                tensors[ou] = [1]
                vals[ou] = [len(tensors[ins[0]])]#list(tensors[ins[0]])[-1]]
                #print(k)
                
                #input()

            elif(ty == "Cast"):
                tensors[ou] = list(tensors[ins[0]])
                #vals[ou] = list(vals[ins[0]])

     



            elif(ty == "UnaryOp"):

                v1 = list(tensors[ins[0]])
                op = k['main']['opType']

                #if(op == "COS"):
                #    pass

                #elif(op == "SIN"):
                #    pass
                tensors[ou] = v1
                 
            elif(ty == 'BinaryOp'):
                v1 = list(tensors[ins[0]])
                v2 = list(tensors[ins[1]])
                op = k['main']['opType']
                #print(v1, vals.get(ins[0], ))
                #print(v2, vals.get(ins[1], ))
                #val1 = vals[ins[0]]
                #val2 = vals[ins[1]]
                size = abs(get_size(v1))
                size1 = abs(get_size(v2))
                
                if(len(v1) > len(v2)):
                    v2 =  [1]*(len(v1)-len(v2)) + v2
                elif(len(v1) < len(v2)):
                    v1 = [1]*(len(v2)-len(v1)) + v1 
                res = []
                for i in range(len(v1)):
                    if(v1[i] > v2[i]):
                        res.append(v1[i])
                    else:
                        res.append(v2[i])
                tensors[ou] = list(res)

                
                if(get_size(tensors[ou]) > size or get_size(tensors[ou]) > size1):
                    if(size > size1):
                        tensors[ou] = list(v1)
                    else:
                        tensors[ou] = list(v2)
                    #input()

                

                if(ins[0] in vals and ins[1] in vals):
                    if(op == "MUL"):
                        vals[ou] = [vals[ins[0]][i]  * vals[ins[1]][i]   for i in range(len(vals[ins[0]]))]
                    elif(op == "REALDIV"):
                        vals[ou] = [vals[ins[0]][i]  / vals[ins[1]][i]   for i in range(len(vals[ins[0]]))]
                    
                        
                    elif(op == "ADD"):
                        
                        vals[ou] = [vals[ins[0]][i]   +vals[ins[1]][i]   for i in range(len(vals[ins[0]]))]
                    elif(op == "MINIMUM"):
                        vals[ou] = [min(vals[ins[0]][i] ,vals[ins[1]][i] )  for i in range(len(vals[ins[0]]))]
                    elif(op == "SUB"):
                        vals[ou] = [vals[ins[0]][i]   - vals[ins[1]][i]   for i in range(len(vals[ins[0]]))]
                    elif(op == "MOD"):
                        vals[ou] = [vals[ins[0]][i]   % vals[ins[1]][i]   for i in range(len(vals[ins[0]]))]

                               
                
            elif(ty == "Reduction"):
                v1 = list(tensors[ins[0]])
                axis = vals[ins[1]][0]
                res = []
                for i in range(len(v1)):
                    if(i == axis):
                        continue
                    else:
                        res.append(v1[i])

                tensors[ou] = res

            elif(ty == "LayerNorm"):
                #ignore axis, assume is the same
                tensors[ou] = list(tensors[ins[0]])
            
            #the output channel is equal to inchanel * kernelY * kernelX
            elif(ty == "Im2Col"):
                
                v1 = tensors[ins[0]]


                padX,padY,kernelX,kernelY,strideX,strideY\
                    ,outC,inC = get_conv_params(k)

                tensors[ou] = list(v1)
                tensors[ou][-2] = (v1[-2] + 2*padY - kernelY)//strideY + 1
                tensors[ou][-1] = (v1[-1] + 2*padX - kernelX)//strideX + 1 
                tensors[ou][-3] = v1[-3]*kernelX*kernelY
            elif(ty == "Convolution"):
                padX,padY,kernelX,kernelY,strideX,strideY\
                    ,outC,inC = get_conv_params(k)
                                
                aQuant = k['main']['quanParameter']['aMaxOrBits']
                v1 = tensors[ins[0]]
                tensors[ou] = list(v1)
                tensors[ou][-2] = (v1[-2] + 2*padY - kernelY)//strideY + 1
                tensors[ou][-1] = (v1[-1] + 2*padX - kernelX)//strideX + 1 
                tensors[ou][-3] = outC

            elif(ty == "MatMul"):
                #print(k)
                orig = list( tensors[ins[0]] )
                weight = list(tensors[ins[1]])

                tensors[ou] = orig[0:-2] + [orig[-2],weight[-1]]
                #tensors[ou] = orig[0:-2] + [weight[-2],orig[-1]]
            elif(ty == "Softmax"):
                orig = list( tensors[ins[0]] )
                tensors[ou] = orig
                
            elif(ty == "Eltwise"):
                v1 = tensors[ins[0]]
                v2 = tensors[ins[1]]
                op = k['main']['type']
                res = []
                for x,y in zip(v1,v2):
                    if(x > y):
                        res.append( x )
                    else:
                        res.append(y)
                tensors[ou] = res

            elif(ty == "Attention"):
                #print(k['type'],k)
                v1 = tensors[ins[0]]
                #for i in ins:
                #    print(tensors[i], vals.get(i,""))

                x = tensors[ins[0]]
                if(len(v1) == 5):
                    batch,seq,h, head, head_dim = v1 #group query attention
                elif(len(v1) == 6):
                    batch, s, seq, h,  head, head_dim = v1
                
                mask = tensors[ins[3]]

                tensors[ou] = [batch, seq, head* head_dim]#list(tensors[ins[2]])
                #input()

                #Attention: values, keys, query, mask

            #should execute on machine or not
            
            exec_order.append({"config":k})

            #print(k['type'], k)
            #print(k['type'])
            #print(k['type'])
            #print(k)
            #print(tensors.get(3,""), vals.get(3,""))
            #input()
            if debug:
                for ou in k['outputIndexes']:
                   print(k['name'], k['type'], ou, tensors[ou], vals.get(ou, ''))
            #    #print(65, tensors.get(65,''))
            #input()
        self.exec_order = exec_order
        self.vals = vals
        self.tensors = tensors

    def print_exec(self):
        exec_order = self.exec_order 
        vals = self.vals
        tensors = self.tensors

        
        for ex in exec_order:
            k = ex['config']
            ou = k['outputIndexes']

            is_exec = True
            for o in ou:
                if(o in vals):
                    is_exec = False
                    break
            if(is_exec):
                for ou in k['outputIndexes']:
                    print( k['type'],  k['name'], ou, tensors[ou], vals.get(ou, ''))

    def compile_exec(self, folder):
        import os
        import json
        
        directory_path = folder
        # 使用 os.makedirs 创建目录
        try:
            os.makedirs(directory_path)
            print(f"成功创建目录: {directory_path}")
        except FileExistsError:
            print(f"目录 {directory_path} 已经存在")
        except Exception as e:
            print(f"创建目录时出错: {e}")


        skip = ['Input', 'Const',]  + [ 'Slice', 'SliceTf', 'StridedSlice','Unsqueeze', 'Squeeze' , 'Reshape' ] #+ [ 'ConvertTensor', ]

    
        exec_order = self.exec_order 
        vals = self.vals
        tensors = self.tensors
        iii = 0
        for edx,ex in enumerate(exec_order):
            k = ex['config']
            ou = k['outputIndexes']
            is_exec = True
            for odx, o in enumerate( ou):
                if(o in vals):
                    is_exec = False
                    break
                
            if(is_exec):
                #for ou in k['outputIndexes']:
                #    print( k['type'],  k['name'], ou, tensors[ou], vals.get(ou, ''))
                if(k['type'] not in skip):

                    #should execute
                    name = k['name'].replace('/', "_")
                    file = folder + "/" + str(iii) + "."+ name + ".cfg"
                    t = []
                    v = []
                    for idx, i in enumerate(k['inputIndexes']):
                        #t.append(tensors[i])
                        #v.append(vals.get(i,i))
                        
                        k['inTensors'+str(idx)] = tensors[i]
                        k['inVals'+str(idx)] = vals.get(i,[]) 

                            
                    # 使用 json.dump 将字典写入 JSON 文件
                    with open(file, 'w') as f:
                        json.dump(k, f, indent=4)

                    print("save exec layer " + file)
                    iii += 1
                    #return                


    #Timing model 1
    def arch_time(self):
        time = 0
        i = 0
        for k in self.data['oplists']:
            i = i + 1
            print( k['type'],k['name'], k['main_type'], k.get('inputIndexes',''), k['outputIndexes'])    
            #print(k['name'])
        

    def arch_perf(self):
        skip = ['Input', 'Const',]  + [ 'Slice', 'SliceTf', 'StridedSlice','Unsqueeze', 'Squeeze' , 'Reshape' ] + ['Cast', 'GatherV2'] + ['Unpack']#+ [ 'ConvertTensor', ]
        exec_order = self.exec_order 
        vals = self.vals
        tensors = self.tensors
        iii = 0

        total_cycles = 0
        total_time = 0
        total_throughput = 0

        perf_summary = {}
        throughput_summary = {}
        total_comp_cyc  = 0
        for edx,ex in enumerate(exec_order):
            k = ex['config']
            ou = k['outputIndexes']
            is_exec = True
            for odx, o in enumerate( ou):
                if(o in vals):
                    is_exec = False
                    break
            if(is_exec):
                if(k['type'] not in skip):
                    name = k['name'].replace('/', "_")
                    t = []
                    v = []
                    for idx, i in enumerate(k['inputIndexes']):      
                        k['inTensors'+str(idx)] = tensors[i]
                        k['inVals'+str(idx)] = vals.get(i,[]) 

                    ty = k['type']

                    perf = 0
                    dram_time = 0
                    comp_time = 0 
                    dram_cyc = 0
                    comp_cyc = 0                        
                    ########PERF SIMULATOR##########
                    Clock = 1e-9
                    DmaWidth = self.hw["Module"]["Dma"]["Width"]
                    DmaDelay = self.hw["Module"]["Dma"]["Delay"]
                    DmaBw = DmaWidth/DmaDelay
                    config = self.hw["Ops"].get(ty, {})
                    

                    tensor0 = self.tensors[k['inputIndexes'][0]]
                    
                    #print(ty)
                    Outs = 0
                    Ins = 0
                    for i in k['inputIndexes']:
                        Ins += get_size(self.tensors[i])
                    for o in k['outputIndexes']:
                        Outs += get_size(self.tensors[o])
                    dram_cyc =(Outs + Ins)/   DmaBw


                    throughput = DmaBw



                    
                    if(ty == "Attention"):

                        mmconfig = self.hw["Ops"]["MatrixMultiply"]
                        smconfig = self.hw['Ops']['Softmax']
                        #print(mmconfig, smconfig)
                        #print(k)

                        v1 = tensors[k['inputIndexes'][0]]
                        if(len(v1) == 5):
                            batch,seq,h, head, head_dim = v1 #group query attention
                        elif(len(v1) == 6):
                            batch, s, seq, h,  head, head_dim = v1
                        
                        preca = mmconfig['InTensors0Prec']
                        precw =  mmconfig['InTensors1Prec']
                        #KQ BGMM
                        b = batch*seq*head
                        n = seq
                        i = head_dim
                        unit = mmconfig
                        comp_cyc = tiles(b,  unit['Tile']['B']) * tiles(n, unit['Tile']['N']) * tiles(i, unit['Tile']['I']) * unit["SubUnits"]["Multiplier"]['Throughput']
                        dram_cyc += b*n*preca / DmaBw
                        #Softmax
                        b = batch*seq
                        i = seq
                        unit = smconfig
                        comp_cyc += tiles(b,  unit['Tile']['B']) * tiles(i, unit['Tile']['I']) * unit["SubUnits"]["Exp"]['Throughput']
                        dram_cyc += b*i*preca*2 / DmaBw
                        #V Output BGMM
                        b = batch*seq*head
                        n = head_dim
                        i = seq
                        unit = mmconfig
                        comp_cyc += tiles(b,  unit['Tile']['B']) * tiles(n, unit['Tile']['N']) * tiles(i, unit['Tile']['I']) * unit["SubUnits"]["Multiplier"]['Throughput']
                        throughput = unit['Tile']['B']*unit['Tile']['N']*unit['Tile']['I']*(preca + precw) / unit["SubUnits"]["Multiplier"]['Throughput']
                        dram_cyc += b*i*preca / DmaBw


                        ty = 'AttentionCore'

                        #print(comp_cyc)
                        #print(dram_cyc)
                        #input()
                    elif(ty == "ConvertTensor" or ty == "Permute" or ty == "Transpose"):
                        if(ty == "Transpose"):
                            config = self.hw['Ops']['ConvertTensor']
                        #print(k)
                        '''
                        name = k['name']
                        if('attn' in name):
                            ty = "Attention"
                        elif('Linear' in name):
                            ty = "MatrixMultiply"
                        else:
                            print(k)
                            input()
                        '''
                        #print(k)
                        #input()
                        #print(config)
                        SingleOpFetch = 2*(  config["InTensor0Prec"] *  get_size(k['inTensors0'])  ) /   DmaBw    
                        InputSize = get_size(k['inTensors0'])
                        dram_cyc = SingleOpFetch   
                        comp_cyc = InputSize/config.get("Tile",1) #(n*i*kx*ky * unit['bprec']) / bww + (b*i*x*y* unit['aprec']) / bwa
                        throughput = DmaBw
                        
                    elif(ty == "Convolution"):
                        #print(k)
                        rt = k['main']['common']
                        wei = rt['kernelX'] * rt['kernelY'] * rt['outputCount'] * rt['inputCount']
                        act = get_size(self.tensors[k['inputIndexes'][0]])
                        out = get_size(self.tensors[k['outputIndexes'][0]])
                        preca = config['InTensors0Prec']
                        precw =  config['InTensors1Prec']
                        dram_cyc = wei*precw/DmaBw + act*preca/DmaBw + out*preca/DmaBw
                        x = self.tensors[k['inputIndexes'][0]][2]
                        y = self.tensors[k['inputIndexes'][0]][3]
                        i =  rt['inputCount']
                        n =  rt['outputCount']
                        kx = rt['kernelX']
                        ky = rt['kernelY']
                        unit = config
                        b = self.tensors[k['inputIndexes'][0]][0]
                        comp_cyc = tiles(x//rt['strideX'],  unit['Tile']['X']) * tiles(y//rt['strideX'], unit['Tile']['Y']) * tiles(i, unit['Tile']['I']) * tiles(kx, unit['Tile']['KX']) * \
                            tiles(ky, unit['Tile']['KY']) * tiles(n, unit['Tile']['N']) * tiles(b, unit['Tile']['B']) * config["SubUnits"]["Multiplier"]['Throughput']
                        throughput = unit['Tile']['B']*unit['Tile']['N']*unit['Tile']['Y']*unit['Tile']['X']*unit['Tile']['KY']*unit['Tile']['KX']*unit['Tile']['I']*(preca + precw) / config["SubUnits"]["Multiplier"]['Throughput']

                        #depthwise conv, i.e. matrix multiply
                        if(kx == ky == 1):
                            ty = "MatrixMultiply"

                    elif(ty == "Convolution" or ty == "Im2Col"):
                        #print(k)
                        if(len(config) == 0):
                            config = self.hw['Ops']['Convolution']
                        rt = k['main']['common']
                        wei = rt['kernelX'] * rt['kernelY'] * rt['outputCount'] * rt['inputCount']
                        act = get_size(self.tensors[k['inputIndexes'][0]])
                        out = get_size(self.tensors[k['outputIndexes'][0]])
                        
                        preca = config['InTensors0Prec']
                        precw =  config['InTensors1Prec']
                        dram_cyc = wei*precw/DmaBw + act*preca/DmaBw + out*preca/DmaBw
                        x = self.tensors[k['inputIndexes'][0]][2]
                        y = self.tensors[k['inputIndexes'][0]][3]
                        i =  rt['inputCount']
                        n =  rt['outputCount']
                        if (i == 0):
                            i = x*y
                            n = x*y
                        kx = rt['kernelX']
                        ky = rt['kernelY']
                        unit = config
                        b = self.tensors[k['inputIndexes'][0]][0]
                        comp_cyc = tiles(x//rt['strideX'],  unit['Tile']['X']) * tiles(y//rt['strideX'], unit['Tile']['Y']) * tiles(i, unit['Tile']['I']) * tiles(kx, unit['Tile']['KX']) * \
                            tiles(ky, unit['Tile']['KY']) * tiles(n, unit['Tile']['N']) * tiles(b, unit['Tile']['B']) * config["SubUnits"]["Multiplier"]['Throughput']
                        throughput = unit['Tile']['B']*unit['Tile']['N']*unit['Tile']['Y']*unit['Tile']['X']*unit['Tile']['KY']*unit['Tile']['KX']*unit['Tile']['I']*(preca + precw) / config["SubUnits"]["Multiplier"]['Throughput']

                        #depthwise conv, i.e. matrix multiply
                        if(kx == ky == 1):
                            ty = "MatrixMultiply"
                            
                        
                    elif(ty == "Concat"):
                        #print(k)
                        dram_cyc =(Outs + Ins)/   DmaBw 
                        comp_cyc = 1
                        

                        
                    elif(ty == "BinaryOp" or ty == "Eltwise" or ty == "Reduction"):
                        #print(k)

                        if(ty == 'Eltwise'):
                            config = self.hw['Ops']['BinaryOp']
                            #print(k)
                            op = k['main']['type']
                        elif(ty == 'Reduction'):
                            config = self.hw['Ops']['BinaryOp']
                            op = "SUM"
                            
                        else:
                            op = k['main']['opType']
                        #print(tensor0)
                        if(len(tensor0) == 1):
                            b = 1
                        else:
                            b = get_size(tensor0[ 0:-1 ])
                        i = tensor0[ -1 ]
                        #print(op)
                        if(op == "ADD" or op == "SUM"):
                            comp_cyc= tiles(b,  unit['Tile']['B']) * tiles(i, unit['Tile']['I']) * config["SubUnits"]["Add"]['Throughput']
                        elif(op == "MUL" or op == "MOD"):
                            comp_cyc= tiles(b,  unit['Tile']['B']) * tiles(i, unit['Tile']['I']) * config["SubUnits"]["Multiplier"]['Throughput']

                    elif(ty == "UnaryOp"):
                        #print(k)
                        #print(k)
                        op = k['main']['opType']
                        b = get_size(tensor0)
                        #print(self.tensors[k['inputIndexes'][0]])
                        if(b == 0):
                            b = 32
                        #print(op)
                        if(op == "COS" or op == "SIN"):
                            comp_cyc= tiles(b,  unit['Tile']['B'])* config["SubUnits"]["Trig"]['Throughput']
                        elif(op == "NEG" or op == "SQUARE"):
                            comp_cyc= tiles(b,  unit['Tile']['B'])* config["SubUnits"]["Alu"]['Throughput']

                        elif(op == "SILU" or op == "TANH" or op == "GELU"):
                            comp_cyc = tiles(b,  unit['Tile']['B'])* config["SubUnits"]["Activations"]['Throughput'] 
                        print(k)
                        input()
                    elif(ty == "LayerNorm"):

                        b = get_size(tensor0[ 0:-1 ])
                        i = tensor0[ -1 ]
                        unit = config
                        #Mean
                        comp_cyc += tiles(b,  unit['Tile']['B']) * tiles(i, unit['Tile']['I']) * config["SubUnits"]["AddReduce"]['Throughput']
                        #STDEV
                        comp_cyc += tiles(b,  unit['Tile']['B']) * tiles(i, unit['Tile']['I']) * config["SubUnits"]["Multiplier"]['Throughput']
                        #MADD
                        comp_cyc += tiles(b,  unit['Tile']['B']) * tiles(i, unit['Tile']['I']) * config["SubUnits"]["Multiplier"]['Throughput']
                        throughput = min(throughput,  tiles(b,  unit['Tile']['B']) * tiles(i, unit['Tile']['I'])*  config['InTensors0Prec'] / config["SubUnits"]["Multiplier"]['Throughput'] )
                        pass



                    else:
                        print("not implement " + k['type'])
                        return
                    #print(k)
                    dram_time = dram_cyc * Clock
                    comp_time = comp_cyc * Clock

                    perf_cyc = max(dram_cyc, comp_cyc)
                    perf_time = max(dram_time,comp_time)

                    total_cycles += perf_cyc
                    total_time += perf_time
                    total_throughput += throughput

                    total_comp_cyc += comp_cyc
                    
                    if(comp_cyc == 0):
                        print("not implement " + k['type'])
                        return
                    #print(ty, perf_time, "(",dram_cyc, comp_cyc,")", throughput)
                    #print(ty, k['name'], perf_time, "(",dram_cyc, comp_cyc,")")
                    #input()
                    iii += 1
                    #return      

                    if(ty in perf_summary):
                        perf_summary[ty] += perf_time
                        throughput_summary[ty] += throughput#*perf_time
                    else:
                        perf_summary[ty] = perf_time
                        throughput_summary[ty] = throughput#*perf_time

        
        
        print(total_cycles)
        print(total_comp_cyc)
        print("time",total_time)
        print("Throughput", total_throughput/iii*1e-3) #TOPS
        print("Util", total_comp_cyc/total_cycles)
        print("Util", total_comp_cyc/total_cycles)
        print('Token/s', 1024/total_time)
        perf_frac = {}
        perf_tot = sum([perf_summary[k] for k in perf_summary])
        for k in perf_summary:
            perf_frac[k] = perf_summary[k]/perf_tot

        
        

        import matplotlib.pyplot as plt
        # 2. 绘制饼图
        fig, ax = plt.subplots(1, 2, figsize=(10, 4))

        
        
        ax[0].pie([perf_summary[k] for k in perf_summary], autopct='%1.1f%%', startangle=90, labeldistance=1.1 , pctdistance=1.18, wedgeprops={'linewidth':.8, 'edgecolor':'k', 'width':0.38})
        # autopct: 显示百分比；startangle: 起始角度
        ax[0].axis('equal')  # 保证饼图是正圆
        ax[0].set_title("Latency", y=1.1,)

        ax[1].pie([throughput_summary[k] for k in throughput_summary], autopct='%1.1f%%', startangle=90, pctdistance=1.18, wedgeprops={'linewidth':.8, 'edgecolor':'k', 'width':0.38})
        # autopct: 显示百分比；startangle: 起始角度
        ax[1].axis('equal')  # 保证饼图是正圆
        ax[1].set_title("Throughput", y=1.1,)
        fig.legend([k for k in throughput_summary], loc='upper right')
        #plt.title('编程语言使用比例')
        plt.subplots_adjust(hspace=0.30, wspace=0.076, top=0.8, right=0.9, bottom=0.102, left=0.04)
        
        #plt.show()
        

#Independent Modules (no module fusion, sparsity, etc.)
TN = 256
TB = 256
Width =64

print("Ideal throughput", TN*TB)
hw = {
    "Module":{
        "Dma":{
            "SramDepth": 4096,
            "Width": Width,
            "DramPrec": 32,
            "Delay": 4},
        "Counter": {
            "IdxPrec": 16,},
        "Address": {
            "AddrPrec": 16,
            "SubUnits": {
                "Multiplier": {"Throughput": 4, "Delay": 4}  }},},
    "Ops":{
        "ConvertTensor": {
            "Tile": TN,
            "InTensor0Prec": 8,},
        "Convolution": {
            "Tile": {"B": 1, "N": TN, "I": TB, "X": 1, "Y": 1, "KX": 1, "KY": 1},
            "InTensors0Prec": 8,
            "InTensors1Prec": 4,
            "SubUnits": {
                "Multiplier": {"Throughput": 1, "Delay": 4},
                "AddReduce": {"Throughput": 1, "Delay": 1},
            }},
        "MatrixMultiply": {
            "Tile": {"B": 1, "N": TN, "I": TB},
            "InTensors0Prec": 8,
            "InTensors1Prec": 4,
            "SubUnits": {
                "Multiplier": {"Throughput": 1, "Delay": 4},
                "AddReduce": {"Throughput": 1, "Delay": 1},}},
        "Permute": {
            #0,2,1
            "InTensor0Prec": 8,},
        "Concat":{
            "InTensor0Prec": 8,
            "Tile": {"B": 8, "I": 8}, },
        "UnaryOp":{
            "Tile": TN,
            "InTensors0Prec": 8,
            "SubUnits": {
                "Trig": {"Throughput": 2, "Delay": 8},
                "Alu": {"Throughput": 1, "Delay": 1}, #Simple negate etc.
                "Activations": {"Throughput": 4, "Delay": 8}, #Silu
            }},
        "BinaryOp":{
            #ALUs
            "Tile": {"B": TB, "I": TN},
            "InTensors0Prec": 8,
            "SubUnits": {
                "Multiplier": {"Throughput": 1, "Delay": 4},
                "Add": {"Throughput": 1, "Delay": 1},}},
        "LayerNorm":{
            "InTensors0Prec": 8,
            "Tile": {"B": TB, "I": TN},
            "SubUnits": {
                "Sqrt": {"Throughput":4, "Delay":4},
                "AddReduce": {"Throughput":1, "Delay":1},
                "Multiplier": {"Throughput":1, "Delay":4},},},
        "Softmax":{
            "Tile": {"B": TB, "I": TN},
            "SubUnits":{
                "Exp": {"Throughput": 4, "Delay": 4},      
            }},
    }, 
}
rt = {}

patch = 8
pos_id = 2
idx_tensor =  1024
batch = 8

inputs = {
    "patches": [patch,1536],
    "position_ids": [2,pos_id],
    "attention_mask": [1, 1024, 1024],
    "idx_tensor": [4,idx_tensor],
    "weight_tensor": [4,idx_tensor],
    "123": 123,
    
}






inputs = {
    "patches": [patch,1536],
    "position_ids": [2,pos_id],
    "attention_mask": [1, 1024, 1024],
    "idx_tensor": [4,idx_tensor],
    "weight_tensor": [4,idx_tensor],
    "123": 123,
    
}
mc = MyCompiler()
mc.load_json("./Qwen3-VL-2B-Instruct/visual.json")
#mc.load_json("./VIT/vit_small.json")
mc.set_hw(hw)
mc.set_rt(rt)
#mc.arch_time()
mc.analyze_tensors(inputs, True)
#mc.print_exec()
mc.arch_perf()
#$mc.compile_exec("./generated/Qwen3-VL-2B-Instruct/vlm/visual")

#input("visual")

input()

inputs = {
    "input_ids": [1, 1, 2048],
    "attention_mask": [1, 1, 1024, 1024],
    "position_ids": [3, 2048],
    "past_key_values": [ 28, 2, 1, -1, 8, 128 ],
    "logits_index": [1],
    "deepstack_embeds": [ 3, 1, 2048 ],
    
    
    
}
input_data = {
    "logits_index": [0]
}
mc = MyCompiler()
mc.load_json("./Qwen3-VL-2B-Instruct/llm.mnn.json")
#mc.load_json("./VIT/vit_small.json")
mc.set_hw(hw)
mc.set_rt(rt)
#mc.arch_time()
mc.analyze_tensors(inputs, True, debug =False, input_data = input_data)
#mc.print_exec()
#mc.compile_exec("./generated/Qwen3-VL-2B-Instruct/vlm/llm")
mc.arch_perf()





'''

inputs = {
    "x": [batch,3,384,384]
}
mc = MyCompiler()
#mc.load_json("./Qwen3-VL-2B-Instruct/visual.json")
mc.load_json("./VIT/vit_small.json")
mc.set_hw(hw)
mc.set_rt(rt)
#mc.arch_time()
mc.analyze_tensors(inputs, True)
#mc.print_exec()
#mc.compile_exec("./generated/VIT/vit_small")
mc.arch_perf()
'''

























#def 

#i = 0
#for k,v in data.items():
#    print(k)
#    i = i + 1


#print(data['bizCode'])
#print(data['extraInfo'])
#print(data['outputName'])
#print(data['sourceType'])

"""
i = 0
for k in data['tensorName']:
    print(k)
    i = i + 1
    if(i > 10):
        break



print('--------------')

i = 0
for k in data['oplists']:
    #print(k)
    i = i + 1
    #print(k['main_type'])
    print(k['name'], k['type'], k['main_type'], k.get('inputIndexes',''), k['outputIndexes'])
    #if(i > 10):
    #    break
    #if("Attn" in k['type']):
    #input()

"""
#if(i > 10):
#    break

#v = expr.load_as_list('llm.mnn')
#print(len(v))
#MNN.nn.load_module_from_file("./llm.mnn",["input_ids"],["logits"])

#interpreter = MNN.Interpreter("./visual.mnn")
#session = interpreter.createSession()

'''
interpreter = MNN.Interpreter("./visual.mnn")
#print(interpreter)
session = interpreter.createSession()
# set input
# ...
def begin_callback(tensors, opinfo):
    print('layer name = ', opinfo.getName())
    print('layer op = ', opinfo.getType())
    # print('layer flops = ', opinfo.getFlops())
    for tensor in tensors:  
        print(tensor.getShape())
    return True
def end_callback(tensors, opinfo):
    print('layer name = ', opinfo.getName())
    print('layer op = ', opinfo.getType())
    # print('layer flops = ', opinfo.getFlops())
    for tensor in tensors:  
        print(tensor.getShape())
    return True
interpreter.runSessionWithCallBackInfo(session, begin_callback, end_callback)
print("done")
'''






