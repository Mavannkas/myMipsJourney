#include <iostream>

void addBSD(unsigned char* a1, unsigned char* a2, unsigned char* output);
int getSize(unsigned char* a);
unsigned char getOlderNumber(unsigned char a);
unsigned char getYoungerNumber(unsigned char a);

int main()
{
    unsigned char* a1 = new unsigned char[] {
       0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0x99, 0xF0
    };    
    
    unsigned char* a2 = new unsigned char[] {
        0x01
    };

    unsigned char* output = new unsigned char[] {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
    };

    addBSD(a1, a2, output);
}

void addBSD(unsigned char* a1, unsigned char* a2, unsigned char* output) {
    std::cout << "Start\n";
    int s0 = getSize(a1);
    int s1 = getSize(a2);
    unsigned char* t0 = a1;
    unsigned char* t1 = a2;
    int t2 = s0;
    int t3 = s1;
    
    int outputIndex = 0;
    unsigned char overloaded = 0x00;
    //Swap
    if (s0 < s1) {
        t0 = a2;
        t1 = a1;

        t2 = s1;
        t3 = s0;
    }

    int t4 = t2;
    while (t2 > 0) {
        if (t2 % 2 == 0) {
            (*output) = (*output) | (getOlderNumber(*t0) << 4);
        }
        else {
            (*output) = (*output) | (getYoungerNumber(*t0));

            t0++;
            output++;
            outputIndex++;
        }
        t2--;
    }

    while (t3 != t2) {
        if (t2 % 2 == 0) {
            output--;
            outputIndex--;
        }
        t2++;
    }
    char t10;
    char overload = 0;

loop:

    if (t2 % 2 == 0) {
        t10 = getOlderNumber(*output) + getOlderNumber(*t1);
        if (t10 >= 10) {
            t10 = t10 - 10;
            if (outputIndex == 0) {
                overloaded = 1;
            }
            else {
                output--;
                (*output) = (*output) + 1;
                output++;
            }
        }

        (*output) = (t10 << 4) | getYoungerNumber(*output);
    }
    else {
        t10 = getYoungerNumber(*output) + getYoungerNumber(*t1);
        if (t10 >= 10) {
            t10 = t10 - 10;
            overload = 1;
        }
        (*output) = ((getOlderNumber(*output) + overload) << 4) | t10;

        t0++;
        output++;
        outputIndex++;
    }
    overload = 0;
    t2--;
    if (t2 != 0) {
        goto loop;
    }


    int repeat = 0;
repeatLoop:
    while (t2 != t4) {
        if (t2 % 2 == 0) {
            output--;
            outputIndex--;
        }
        t2++;
    }

loop2:

    if (t2 % 2 == 0) {
        t10 = getOlderNumber(*output);
        if (t10 >= 10) {
            repeat = 1;
            t10 = t10 - 10;
            if (outputIndex == 0) {
                overloaded = 1;
            }
            else {
                output--;
                (*output) = (*output) + 1;
                output++;
            }
        }

        (*output) = (t10 << 4) | getYoungerNumber(*output);
    }
    else {
        t10 = getYoungerNumber(*output);
        if (t10 >= 10) {
            repeat = 1;
            t10 = t10 - 10;
            overload = 1;
        }
        (*output) = ((getOlderNumber(*output) + overload) << 4) | t10;

        output++;
        outputIndex++;
    }
    overload = 0;
    t2--;
    if (t2 != 0) {
        goto loop2;
    }
    if (repeat == 1) {
        repeat = 0;
        goto repeatLoop;
    }

    //t2 -= 2;
    while (t2 != t4) {
        if (overloaded == 1) {
            *output = *(output - 1);
        }
        output--;
        outputIndex--;
        t2 += 2;
    }
    if (overloaded == 1) {
        *output = 1;
        t4 += 1;
    }
    int test;
    //std::cout << (int)overloaded;
    while (t4 > 0) {
        if (t4 % 2 == 0) {
            test = (int)getOlderNumber(*output);
            std::cout << test;
        }
        else {
            test = (int)getYoungerNumber(*output);

            std::cout << test;
            output++;
        }
        t4--;
    }

    std::cout << "\nStop";

}

int getSize(unsigned char* a) {
    int size = 0;
    
    repeat: 
        if (getOlderNumber(*a) == 0xf) {
            goto finish;
        }
        size++;
        if (getYoungerNumber(*a) == 0xf) {
            goto finish;
        }
        size++;
        a++;
    goto repeat;

    finish:
        return size;
}

unsigned char getOlderNumber(unsigned char a) {
    return a >> 4 & 0x0F;
}

unsigned char getYoungerNumber(unsigned char a) {
    return a & 0x0F;
}
