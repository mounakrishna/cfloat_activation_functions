#include<bits/stdc++.h>
#include <cstdio>
#include <iostream>
#include <fstream>
#include <string>
#include <utility>
using namespace std;
#define int long long
#define Y cout<<"YES"<<endl
#define N cout<<"NO"<<endl
#define D cout<<"DEBUG"<<endl


double convertToDecimal(string sign, int exponent, string check, string mantissa){
    map<string, double> m;
    m["00"] = 0;
    m["01"] = 0.25;
    m["10"] = 0.50;
    m["11"] = 0.75;
    double num;
    if(check == "denormal" || exponent == 0){
        num = (m[mantissa])*pow(2, exponent);
        if(sign == "-")num = -1*num;
    }
    else{
        num = (1 + m[mantissa])*pow(2, exponent);
        if(sign == "-")num = -1*num;
    }
    return num;
}

vector<string> decimalToBinary(double input){
    vector<string> ans(3, "");
    ans[0] = "sign";
    ans[1] = "mantissa";
    ans[2] = "exponent";
    if(input >= 0)ans[0] = "+";
    else ans[0] = "-";
    input = abs(input);
    // 1.00 to 1.75 * 2^exponent
    int exponent = -62;
    exponent = -1000;
    if(input == 0){
        ans[0] = "zero";
        ans[1] = "zero";
        ans[2] = "zero";
        return ans;
    }
    while(exponent<32){
        if(input/(pow(2, exponent)) >= 1.00 && (input/(pow(2, exponent))) < 2.00){
            double input1 = input/(pow(2, exponent));
            if(input1 < 1.125){
                ans[1] = "00";
            }
            else if(input1 < 1.375){
                ans[1] = "01";
            }
            else if(input1 < 1.625){
                ans[1] = "10";
            }
            else if(input1 < 1.875){
                ans[1] = "11";
            }
            else{
                exponent++;
                ans[1] = "00";
            }
            break;
        }
        else exponent++;
    }
    if(exponent < -62){
        ans[0] = "zero";
        ans[1] = "zero";
        ans[2] = "zero";
        return ans;
    }
    if(exponent == 0){
        if(input < 0.125){
            ans[1] = "00";
        }
        else if(input<0.375){
            ans[1] = "01";
        }
        else if(input<0.625){
            ans[1] = "10";
        }
        else{
            ans[1] = "11";
        }
    }
    ans[2] = to_string(exponent);
    if(exponent == 32){
        ans[1] = "11";
        ans[2] = "32";
    }
    return ans;
}

double calTanHyper(double input){
    return (2/(exp(-2*input) + 1)) - 1;
}

double calSigmoid(double input){
    return (1/(1 + exp(-1*input)));
}

double calRelu(double input){
    // cout<<input/abs(input)<<endl;
    if(input < 0) return 0.01*input;
    else return input;
}

double calSelu(double input){
    if(input > 0){
        return 1.05070098*input;
    }
    else{
        return 1.05070098*1.67326324*(exp(input)-1);
    }
}

void outputGenerator(double input){
    /*
    function = 1 : tanh
    function = 2 : sigmoid
    function = 3 : relu
    function = 4 : selu
    */
    ofstream tanhyper("tanh.txt", std::ios_base::app);
    ofstream sigmoid("sigmoid.txt", std::ios_base::app);
    ofstream relu("relu.txt", std::ios_base::app);
    ofstream selu("selu.txt", std::ios_base::app);

    vector<string> result1;
    vector<string> result2;
    vector<string> result3;
    vector<string> result4;
    result1 = decimalToBinary(calTanHyper(input));
    tanhyper<<result1[0]<<" "<<result1[1]<<" "<<result1[2]<<endl;

    result2 = decimalToBinary(calSigmoid(input));
    sigmoid<<result2[0]<<" "<<result2[1]<<" "<<result2[2]<<endl;

    result3 = decimalToBinary(calRelu(input));
    relu<<result3[0]<<" "<<result3[1]<<" "<<result3[2]<<endl;

    result4 = decimalToBinary(calSelu(input));
    selu<<result4[0]<<" "<<result4[1]<<" "<<result4[2]<<endl;

    tanhyper.close();
    sigmoid.close();
    relu.close();
    selu.close();

    return;
}

void solve(){
    ofstream MyFile("filename.txt"); // input file
    string sign = "-";
    string mantissa = "00";
    int exponent = -62;
    // MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
    // exponent--;
    ofstream tanhyper("tanh.txt", std::ios_base::app);
    ofstream sigmoid("sigmoid.txt", std::ios_base::app);
    ofstream relu("relu.txt", std::ios_base::app);
    ofstream selu("selu.txt", std::ios_base::app);
    while(exponent != 32){
        mantissa = "00";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "", mantissa));
        mantissa = "01";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "", mantissa));
        mantissa = "10";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "", mantissa));
        mantissa = "11";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "", mantissa));
        exponent++;
        MyFile<<endl;
        tanhyper<<endl;
        sigmoid<<endl;
        relu<<endl;
        selu<<endl;
    }

    sign = "+";
    mantissa = "00";
    exponent = -62;
    while(exponent != 32){
        mantissa = "00";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "", mantissa));
        mantissa = "01";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "", mantissa));
        mantissa = "10";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "", mantissa));
        mantissa = "11";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "", mantissa));
        exponent++;
        MyFile<<endl;
        tanhyper<<endl;
        sigmoid<<endl;
        relu<<endl;
        selu<<endl;
    }

    MyFile<<"\n\nDenormal numbers\n\n";
    tanhyper<<"\n\nDenormal numbers\n\n";
    sigmoid<<"\n\nDenormal numbers\n\n";
    relu<<"\n\nDenormal numbers\n\n";
    selu<<"\n\nDenormal numbers\n\n";
    sign = "-";
    exponent = -63;
    while(exponent!=1){
        mantissa = "01";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "denormal", mantissa));
        mantissa = "10";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "denormal", mantissa));
        mantissa = "11";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "denormal", mantissa));
        exponent++;
        MyFile<<endl;
        tanhyper<<endl;
        sigmoid<<endl;
        relu<<endl;
        selu<<endl;
    }
    sign = "+";
    exponent = -63;
    while(exponent!=1){
        mantissa = "01";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "denormal", mantissa));
        mantissa = "10";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "denormal", mantissa));
        mantissa = "11";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        outputGenerator(convertToDecimal(sign, exponent, "denormal", mantissa));
        exponent++;
        MyFile<<endl;
        tanhyper<<endl;
        sigmoid<<endl;
        relu<<endl;
        selu<<endl;
    }
    tanhyper.close();
    sigmoid.close();
    relu.close();
    selu.close();
    MyFile.close();
}

int32_t main(){
    solve();
}