#include<bits/stdc++.h>
#include <iostream>
#include <fstream>
using namespace std;
#define int long long
#define Y cout<<"YES"<<endl
#define N cout<<"NO"<<endl
#define D cout<<"DEBUG"<<endl

void generateInput(char sign, int bias){
    ofstream MyFile("filename.txt");
    // 00 01 10 11
    // 1-bias to 31 - bias
    int exponent = 1 - bias;
    while(exponent != 32-bias){
        int number1 = 1.00 * pow(2, exponent);
        int number2 = 1.01 * pow(2, exponent);
        int number3 = 1.10 * pow(2, exponent);
        int number4 = 1.11 * pow(2, exponent);
        MyFile<<sign<<" "<<exponent<<" "<<"00"<<endl;
        MyFile<<sign<<" "<<exponent<<" "<<"01"<<endl;
        MyFile<<sign<<" "<<exponent<<" "<<"10"<<endl;
        MyFile<<sign<<" "<<exponent<<" "<<"11"<<endl;
        exponent++;
    }
    MyFile<<endl;
    MyFile.close();
}

void solve(){
    ofstream MyFile("filename.txt");
    for(int i=0;i<64;i++){
        int bias = i;
        char sign = '+';
        int exponent = 1 - bias;
        while(exponent != 32-bias){
            int number1 = 1.00 * pow(2, exponent);
            int number2 = 1.01 * pow(2, exponent);
            int number3 = 1.10 * pow(2, exponent);
            int number4 = 1.11 * pow(2, exponent);
            MyFile<<sign<<" "<<exponent<<" "<<"00"<<endl;
            MyFile<<sign<<" "<<exponent<<" "<<"01"<<endl;
            MyFile<<sign<<" "<<exponent<<" "<<"10"<<endl;
            MyFile<<sign<<" "<<exponent<<" "<<"11"<<endl;
            exponent++;
        }
        MyFile<<endl;
        // generateInput('+', i);
        // generateInput('-', i);
        bias = i;
        sign = '-';
        exponent = 1 - bias;
        while(exponent != 32-bias){
            int number1 = 1.00 * pow(2, exponent);
            int number2 = 1.01 * pow(2, exponent);
            int number3 = 1.10 * pow(2, exponent);
            int number4 = 1.11 * pow(2, exponent);
            MyFile<<sign<<" "<<exponent<<" "<<"00"<<endl;
            MyFile<<sign<<" "<<exponent<<" "<<"01"<<endl;
            MyFile<<sign<<" "<<exponent<<" "<<"10"<<endl;
            MyFile<<sign<<" "<<exponent<<" "<<"11"<<endl;
            exponent++;
        }
        MyFile<<endl;
    }
    MyFile.close();
}

int32_t main(){
    solve();
}