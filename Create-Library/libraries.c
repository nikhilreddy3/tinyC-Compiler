#include "myl.h"
#define MAXINT 20
#define MAXFLOAT 152

int printStr(char *a)  // Function to print a String
{
    int bytes, i=0;

    while (a[i] != '\0')   //Loops over the string until '\0' is encountered
    {
        i++;
    }  
    bytes = i;    
 
    __asm__ __volatile__("movl $1, %%eax\n\t"   // To write the string
                         "movq $1, %%rdi\n\t"
                         "syscall\n\t"
                         :
                         : "S"(a), "d"(bytes));

    return bytes;    //Returns the number of characters printed
}

int readInt(int *n)  // Function to Read a Integer
{
    char buff[MAXINT], zero = '0';
    int i, len = 0;
    __asm__ __volatile__("movl $0, %%eax\n\t"   //To read a Integer
                         "movq $0, %%rdi\n\t"
                         "syscall\n\t"
                         :
                         : "S"(buff), "d"(MAXINT));

    if (i < 0)
        return ERR;

    i = 0;
    while (buff[i] != '\n')  //Find the length of the Intger including the '\n'
    {
        len++;
        i++;
    }

    if (!(buff[0] - zero == '-' || (buff[0] - zero >= 0 && buff[0] - zero <= 9)))  //Check if the first elemtent is a digit or '-'
        return ERR;

    for (i = 1; i < len; i++)  //Check if rest all are digits and not any other character
    {
        if (!((buff[i] - zero) >= 0 && (buff[i] - zero) <= 9))
        {
            return ERR;
        }
    }

    i = 0;
    *n = 0;
    if (buff[0] == '-')  // If first char is '-' move to next elemnt
        i = 1;

    while (buff[i] != '\n')   //Multiply and add each succesive elements by 10 
    {                         //Store it in *n
        *n *= 10;
        *n += buff[i] - zero;
        i++;
    }

    if (buff[0] == '-')    // If negative multiply *n by -1
        *n = -*n;

    return OK;
}

int printInt(int n){     //Function to print an Integer

    char buff[MAXINT], zero='0';
    int i=0, j, k, bytes;

    if(n == 0)
    {
      buff[i++]=zero;  //If number is zero add zero to the character array 
    } 
    else
       {
       if(n < 0) {
          buff[i++]='-';   //If number is negative make first element as '-'
          n = -n;
       }
       while(n)
       {
          int dig = n%10;    //Extract each digit from the end and add it to character array
          buff[i++] = (char)(zero+dig);
          n /= 10;
       }
       if(buff[0] == '-') j = 1;
       else j = 0;
       k=i-1;  
       while(j<k)        //Reverse the complete string except '-' to get correct number
       { 
          char temp=buff[j];
          buff[j++] = buff[k];
          buff[k--] = temp;
       }
    } 
    buff[i]='\0';  //Add '/0' at the end
    bytes = i+1;

    __asm__ __volatile__ (       // to write the String
          "movl $1, %%eax \n\t"
          "movq $1, %%rdi \n\t"
          "syscall \n\t"
          :
          :"S"(buff), "d"(bytes)
    ) ;  // $1: write, $1: on stdin

    if (i < 0)
        return ERR;
    return i;   
}

int readFlt(float *n)   //Function to read a Float 
{
    char buff[MAXFLOAT], zero = '0';
    int i, len = 0;
    float j = 0.1;
    __asm__ __volatile__("movl $0, %%eax\n\t"   // To read a string
                         "movq $0, %%rdi\n\t"
                         "syscall\n\t"
                         :
                         : "S"(buff), "d"(MAXFLOAT + 1));

    if (i < 0)
        return ERR;

    i = 0;
    while (buff[i] != '\n')  //Find the length of the float string
    {
        len++;
        i++;
    }

    if (!(buff[0] == '-' || (buff[0] - zero >= 0 && buff[0] - zero <= 9)))  // Check if all the characters are digits
        return ERR;                                                         // Chwck if its a valid Float number

    i = 1;
    while (buff[i] != '.')    //If number 
    {
        if (!(buff[i] - zero >= 0 && buff[i] - zero <= 9))
            return ERR;
        i++;
    }
    i++;

    for (; i < len; i++)
        if (!(buff[i] - zero >= 0 && buff[i] - zero <= 9))
            return ERR;

    i = 0;
    *n = 0;
    if (buff[0] == '-')    // If first elemnt is '-' move to the next element
        i = 1;
    
    while (buff[i] != '.')  // Multiply each succesive character till '.' by 10 and add to *n
      {
          *n *= 10;
          *n += buff[i] - zero;
          i++;
      }

      i++;
    while (buff[i] != '\n')  //Multiply each succesive elemnt after '.' by 0.1 and add to *n
      {
          *n += (buff[i] - zero) * j;
          i++;
          j /= 10;
      }

    if (buff[0] == '-') //If first element is '-' Multiply the number by -1
        *n = -*n;

    return OK;
}

int printFlt(float n) //Function to print a Float number
{
    char buff[MAXFLOAT + 1], zero = '0';
    int i = 0, m = (int)n, total = 0;
    float tmp;

    tmp = n - m;
    if (tmp < 0)
        tmp = -tmp;

    if ((int)(tmp * 10000000) % 10 >= 5)
    {
        tmp += 0.000001;
        tmp = (int)(tmp * 1000000) / 1000000.0;
        n = m + tmp;
        m = (int)n;

        n = n - m;
        if (n < 0)
            n = -n;
    }
    else
    {
        n = tmp;
    }

    i = printInt(m);
    if (i < 0)
        return ERR;
    total += i;

    buff[0] = '.';
    buff[1] = '\0';
    i = printStr(buff);
    if (i < 0)
        return ERR;
    total += 1;

    i = 0;
    while (i != 6)
    {
        n *= 10;
        buff[i] = (char)(zero + (int)n);
        n -= (int)n;
        i++;
    }
    buff[i] = '\0';
    i = printStr(buff);
    if (i < 0)
        return ERR;
    total += i;

    return total;
}
