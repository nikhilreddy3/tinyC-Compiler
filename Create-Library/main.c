#include "myl.h"

int main()
{
    char hello[12] = "Hello World\0";
    char newline[2] = "\n\0";
    printStr(hello);
    printStr(newline);

    int a;
    printStr("Give an Integer:\0");
    printStr(newline);
    int k=readInt(&a);
    
    char error[14] = "unsuccessfull\0";
    char length[8] = "Length=\0";
    if(k==-1)
    {
        printStr(error);
        printStr(newline);
    }
    else
    {
        k = printInt(a);
        printStr(newline);
        printStr(length);
        printInt(k);
        printStr(newline);
    }

    printStr("Give a float number:\0");
    printStr(newline);
    float f;
    k = readFlt(&f);
    if(k==-1)
    {
        printStr(error);
        printStr(newline);
    }
    else
    {
        k = printFlt(f);
        printStr(newline);
        printStr(length);
        printInt(k);
        printStr(newline);
    }
}