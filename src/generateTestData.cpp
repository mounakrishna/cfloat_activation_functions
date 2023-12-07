#include<bits/stdc++.h>
#include <iostream>
#include <fstream>
#include <utility>
using namespace std;
#define int long long
#define Y cout<<"YES"<<endl
#define N cout<<"NO"<<endl
#define D cout<<"DEBUG"<<endl


void solve(){
    ofstream MyFile("filename.txt");
    string sign = "-";
    string mantissa = "00";
    int exponent = 62;
    MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
    exponent--;
    while(exponent != 0){
        mantissa = "00";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        mantissa = "01";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        mantissa = "10";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        mantissa = "11";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        exponent--;
        MyFile<<endl;
    }

    exponent = -32;
    sign = "+";

    while(exponent != 32){
        mantissa = "00";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        mantissa = "01";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        mantissa = "10";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        mantissa = "11";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        exponent++;
        MyFile<<endl;
    }

    MyFile<<"\n\nDenormal numbers\n\n";
    sign = "-";
    exponent = -63;
    while(exponent!=1){
        mantissa = "01";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        mantissa = "10";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        mantissa = "11";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        exponent++;
        MyFile<<endl;
    }
    sign = "+";
    exponent = -63;
    while(exponent!=1){
        mantissa = "01";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        mantissa = "10";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        mantissa = "11";
        MyFile<<sign<<" "<<mantissa<<" "<<exponent<<endl;
        exponent++;
        MyFile<<endl;
    }

    MyFile.close();

}

int32_t main(){
    solve();
}