## Code for the D1 project

`romformat.py` takes in a text file in some basic form of assembly and turns it into the machine code needed by the ROM. 


Example input:
```
// this creates a loop which increments by 1
// like for(i = 1; i < 10; i++) display(i);

// replaced as a literal, 
// eg: #var = 1 would would replace var with 1

// variables equal literals
// ie x = Anything will output:
// mdr = Anything, at the correct address
// added to end of rom

bottom = 1;
top = 10;
//inc = 1;

// These are pointers like in c
// they refer to the memory location
// use pointers to point to the ram
// ie the displays are at mem 30 in the RAM
*disp = 30;
*i = 16;

// I recommend increasing the word width to 10 or something to give you some more room
// or you can increase the size of the ROM and decrease the size of the RAM

STORE disp;
:start: LOAD bottom;
STORE i;
:loop: LOAD i;
STORE disp;
ADD bottom; // add bottom (instead of inc) to keep within the  ROM
STORE i;
LOAD top;
SUB i;
BNE :loop:;
LOAD bottom; // needed hack since there's no jump if zero
BNE :start:;
```

Output:
```
0: mdr = {`STORE, 5'd30}; // disp
1: mdr = {`LOAD, 5'd12}; // bottom - label: :start:
2: mdr = {`STORE, 5'd16}; // i
3: mdr = {`LOAD, 5'd16}; // i - label: :loop:
4: mdr = {`STORE, 5'd30}; // disp
5: mdr = {`ADD, 5'd12}; // bottom - add bottom (instead of inc) to keep within the  ROM
6: mdr = {`STORE, 5'd16}; // i
7: mdr = {`LOAD, 5'd13}; // top
8: mdr = {`SUB, 5'd16}; // i
9: mdr = {`BNE, 5'd15}; // :loop:
10: mdr = {`LOAD, 5'd12}; // bottom - needed hack since there's no jump if zero
11: mdr = {`BNE, 5'd14}; // :start:
12: mdr = 1; // bottom
13: mdr = 10; // top

// because of the way the cpu has been implemented you need
// a memory location which has the address of the label
14: mdr = 1; // :start: label
15: mdr = 3; // :loop: label
```