import sys
import os
import math

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

def round_to_nearest(a, b, manA, manB, inp):
    mid = (a+b)/2
    if (inp >= a and inp < mid):
        return a, manA
    else:
        return b, manB

def decimal_to_cfloat(inp):
    #print(inp)
    inp = abs(inp)
    if (inp >= 0 and inp < denormal_inp[1]):
        return (round_to_nearest(0, denormal_inp[1], 0, 1, inp), 0)
    elif (inp >= denormal_inp[1] and inp < denormal_inp[2]):
        return (round_to_nearest(denormal_inp[1], denormal_inp[2], 1, 2, inp), 0)
    elif (inp >= denormal_inp[2] and inp < denormal_inp[3]):
        return (round_to_nearest(denormal_inp[2], denormal_inp[3], 2, 3, inp), 0)
    elif (inp >= denormal_inp[3] and inp < possible_inp[1][0]):
        tmp1, tmp2 = round_to_nearest(denormal_inp[3], possible_inp[1][0], 3, 0, inp)
        if tmp2 == 3:
            return (tmp1, 3), 0
        else:
            return (tmp1, 0), 1
    else:
        for exp in range(1, 32):
            if (inp >= possible_inp[exp][0] and inp < possible_inp[exp][1]):
                return (round_to_nearest(possible_inp[exp][0], possible_inp[exp][1], 0, 1, inp), exp)
            elif (inp >= possible_inp[exp][1] and inp < possible_inp[exp][2]):
                return (round_to_nearest(possible_inp[exp][1], possible_inp[exp][2], 1, 2, inp), exp)
            elif (inp >= possible_inp[exp][2] and inp < possible_inp[exp][3]):
                return (round_to_nearest(possible_inp[exp][2], possible_inp[exp][3], 2, 3, inp), exp)
            elif (inp >= possible_inp[exp][3] and inp < possible_inp[exp+1][0]):
                tmp1, tmp2 = round_to_nearest(possible_inp[exp][3], possible_inp[exp+1][0], 3, 0, inp)
                if tmp2 == 3:
                    return (tmp1, 3), exp
                else:
                    return (tmp1, 0), exp+1
            

def gen_inp_cfloat_numbers():
    for exp in range(1, 32):
        value = 2**(exp - bias)
        for m in range(4):
            if (m == 0):
                possible_inp[exp].append(value * 1.0)
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
    #for exp in range(1, 32):
    #    print(possible_inp[exp])
    #print(possible_inp[2][0])
    #print(decimal_to_cfloat(possible_inp[2][0]))
    #print(decimal_to_cfloat(leakyRelu(-1*possible_inp[2][0])))
    #number = -37.5
    ref_file = open("leakyReLu_ref.txt", "w")

    for exp in range(1, 32):
        for m in range(4):
            #print(exp, m)
            #print(decimal_to_cfloat(possible_inp[exp][m]))
            (inp_dec, inp_man), inp_exp = decimal_to_cfloat(possible_inp[exp][m])
            (out_dec, out_man), out_exp = decimal_to_cfloat(leakyRelu(possible_inp[exp][m] * -1))
            #print("exp: ", exp, "m: ", m, "inp: ", possible_inp[exp][m])
            #print("inp_dec: ", inp_dec ," inp_man: ", inp_man," inp_exp: ", inp_exp)
            #print("out_dec: ", out_dec ," out_man: ", out_man," out_exp: ", out_exp)
            #ref_file.write(str(inp_dec) + ' ' + str(inp_man) + ' ' + str(inp_exp) + ' ' + str(out_dec) + ' ' + str(out_man) + ' ' + str(out_exp) + '\n')
            inp_bit = '1'+"{0:05b}".format(inp_exp)+"{0:02b}".format(inp_man)
            out_bit = '1'+"{0:05b}".format(out_exp)+"{0:02b}".format(out_man)
            ref_file.write("{0:02x}".format(int(inp_bit, 2)) + "{0:02x}".format(int(out_bit, 2)) + '\n')
            #ref_file.write('1'+"{0:05b}".format(inp_exp)+"{0:02b}".format(inp_man)+'1'+"{0:05b}".format(out_exp)+"{0:02b}".format(out_man)+'\n')

    ref_file.close()

    #(inp_dec, inp_man), inp_exp = decimal_to_cfloat(abs(number))
    #(out_dec, out_man), out_exp = decimal_to_cfloat(leakyRelu(number))

    #print("inp_dec: ", inp_dec ," inp_man: ", inp_man," inp_exp: ", inp_exp)
    #print("out_dec: ", out_dec ," out_man: ", out_man," out_exp: ", out_exp)
    #print("OUT: ", decimal_to_cfloat(leakyRelu(number)))
