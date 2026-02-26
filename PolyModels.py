def cos_fast(x):
    # 系数是预先通过拟合计算好的 (示例系数，实际应用中需精确计算)
    # 注意：这通常需要配合“角度归约”使用
    w0, w1, w2, w3, w4, w5 = 1.260e-5, 0.9996, 0.002307, -0.1723, 0.006044, 0.005752
    
    # 直接计算多项式: P(x) = w0 + w1*x + w2*x^2 + ... + w5*x^5
    # (实际应用中，为了减少乘法次数，会使用秦九韶算法/霍纳法则重写)
    x2 = x * x
    x4 = x2 * x2
    x3 = x2 * x
    x5 = x4 * x
    return w0 + x*(w1 + x*w2)
    return w0 + w1*x #+ w2*x2 + w3*x3 + w4*x4 + w5*x5
    #return w0 + x*(w1 + x*(w2 + x*w3))
from math import cos, sin


#def cos(x):
#    return cos(x)


def exp_fast(x, n=2):
    x2 = x * x
    x4 = x2 * x2
    x3 = x2 * x
    x5 = x4 * x
    w0 = 1
    w1 = 1/1
    w2 = 1/2
    w3 = 1/6
    w4 = 1/24
    w5 = 1/120

    t = [ w0, w1*x, w2*x2, w3*x3, w4*x4, w5*x5 ]
    res = 0
    idx = 0
    for i in range(n+1):#t[0:n]:
        res += t[i]
    return res#w0 + w1*x + w2*x2 + w3*x3 + w4*x4 + w5*x5

def exp_qin(x, n=3):
    x2 = x * x
    x4 = x2 * x2
    x3 = x2 * x
    x5 = x4 * x
    w0 = 1
    w1 = 1/1
    w2 = 1/2
    w3 = 1/6
    w4 = 1/24
    w5 = 1/120

    #w0 + w1(x + w2(x + w3 (x) ))
    

from math import exp, e, log2
def exp_sca(x):

    #1 mult
    j = log2(e) * x
    k = int(j)
    p = j - k
    print(k,p)
    #2. shift + exp
    q = 2**k
    #i = 2**p
    i = 1 + 0.693147*p + 0.240227*p**2
    #3. mult
    return q * i

    #

    #exp^(x)
    #2^(ln(2)



'''
print(cos_fast(0.1))
print(sin(0.1))
print(cos_fast(0.2))
print(sin(0.2))
print(cos_fast(0.7))
print(sin(0.7))
exit(0)

print(cos_fast(0.0))
print(cos(0.0))
print(cos_fast(3.14/2))
print(cos(3.14/2))
print(cos_fast(0.1))
print(cos(0.1))
'''

print("EXP")
from math import exp
n = 3
print(exp_fast(0.2,n=n))
print(exp(0.2))

print(exp_fast(0.7,n=n))
print(exp(0.7))


'''
from math import exp
print(exp_fast(1.0))
print(exp(1.0))
print(exp_fast(0.7))
print(exp(0.7))
print(exp_fast(2))
print(exp(2.0))
'''
