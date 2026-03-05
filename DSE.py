"UnaryOp":{
        "Tile": {"N": 8},
        "Loop": ["N"],
        "InTensors0Prec": 8,
        "SubUnits": {
            "Trig": {"Throughput": 2, "Delay": 8},
            "Alu": {"Throughput": 1, "Delay": 1}, #Simple negate etc.
            "Activations": {"Throughput": 4, "Delay": 8}, #Silu

        }
    "Sparsity": {},
    "Systolic": {},
    "": {},
},


#Investigate 

"BinaryOp":{
    #ALUs
    "PE": 64,#单变 1D array X, 两变 2D array, X = sqrt(64), Y = sqrt(64)
    "Tile": {"B": TB, "I": TN},
    "Loop": ["BB", "I", "B"],
    #["BB", "I", "B"], ["I", "B"], ["B", "I"],["II", "BB", "I", "B"],
    #["BB", "II", "B", "I"],["II", "B", "I"],
    
    "SparsityTile": {"B": TB , "I": TI },
    "ValueSparsity": {"X": False, "Y": False, "O": False},
    "MemorySparsity": {  },
    
    "Systolic": {"X": False, "Y": False, "O": False},
    
    "InTensors0Prec": 8,
    "SubUnits": {
        "Multiplier": {"Throughput": 1, "Delay": 4},
        "Add": {"Throughput": 1, "Delay": 1},}},
