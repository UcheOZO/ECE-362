/////////// C

int n = 5;
int array[] = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, };
int sum;
int x;
sum = 0;
x = 0;
while(x < n) {
	// NOTE: a previous version of the statement below mistakenly used n as the index.
	sum = sum + array[x];
	x = x + 1;
}

////////////// S

.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

.text
.global main
main:
// Put any instructions you want here.
ldr R0, =n
ldr R0, [R0]
ldr R1, =array
MOVS R2, #0  // Sum
MOVS R3, #0  // X
MOVS R4, #4 // Array index
MOVS R5, #0
MOVS R6, #0

while:
cmp R0, R3
ble end
do:  
MOVS R5, R4
MULS R5, R3
LDR R6, [R1,R5]
ADDS R2, R6 
ADDS R3, R3, #1
b while
end:

LDR R0, =sum
STR R2, [R0]

wfi

.data
.align 4
sum:	.space 4
n:	.word 5
array:
.word 2
.word 3
.word 5
.word 7
.word 11
.word 13
.word 17
.word 19
.word 23
.word 29
