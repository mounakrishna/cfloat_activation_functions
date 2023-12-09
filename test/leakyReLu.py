import sys
import os

bias = int(sys.argv[1])
possible_inp = {}
denormal_inp = {}
for exp in range(1, 32):
    possible_inp[exp] = list()

def leakyRelu(inp):
    if (inp > 0):
        return inp
    else:
        return 0.01 * inp

def round_to_nearest(a, b, inp):
    mid = (a+b)/2
    if (inp >= a and inp < mid):
        return a
    else:
        return b

def decimal_to_cfloat(inp):
    #print(inp)
    if (inp >= 0 and inp < denormal_inp[1]):
        print(round_to_nearest(0, denormal_inp[1], inp))
    elif (inp >= denormal_inp[1] and inp < denormal_inp[2]):
        print(round_to_nearest(denormal_inp[1], denormal_inp[2], inp))
    elif (inp >= denormal_inp[2] and inp < denormal_inp[3]):
        print(round_to_nearest(denormal_inp[2], denormal_inp[3], inp))
    elif (inp >= denormal_inp[3] and inp < possible_inp[1][0]):
        print(round_to_nearest(denormal_inp[2], possible_inp[1][0], inp))
    else:
        for exp in range(1, 32):
            if (inp >= possible_inp[exp][0] and inp < possible_inp[exp][1]):
                print(round_to_nearest(possible_inp[exp][0], possible_inp[exp][1], inp))
            elif (inp >= possible_inp[exp][1] and inp < possible_inp[exp][2]):
                print(round_to_nearest(possible_inp[exp][1], possible_inp[exp][2], inp))
            elif (inp >= possible_inp[exp][2] and inp < possible_inp[exp][3]):
                print(round_to_nearest(possible_inp[exp][2], possible_inp[exp][3], inp))
            

def gen_inp_cfloat_numbers():
    for exp in range(1, 32):
        value = 2**(exp - bias)
        for m in range(4):
            if (m == 0):
                possible_inp[exp].append(value * 1)
            elif (m == 1):
                possible_inp[exp].append(value * 1.25)
            elif (m == 2):
                possible_inp[exp].append(value * 1.5)
            else:
                possible_inp[exp].append(value * 1.75)
    value = 2**(-bias)
    denormal_inp[1] = value * 0.25
    denormal_inp[2] = value * 0.5
    denormal_inp[3] = value * 0.75

    #print(denormal_inp)
    #print(possible_inp)



if __name__=="__main__":
    gen_inp_cfloat_numbers()
    number = 2.1
    decimal_to_cfloat(leakyRelu(number))
