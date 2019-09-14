/////////// C
int x = 7;
int y = 6;
int z = 1;

...

x = z;
do {
	x = x + y;
	y = y - z;
} while (y != 0);

/////////// S
.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

.data
x: .word 7
y: .word 6
z: .word 1

.text
.global main
main:
// let r0 be the address of the start of the variables
ldr r0, =x         // load the address of the x variable

// x = z;
ldr  r1, [r0, #8]  // load from z
str  r1, [r0]      // store to x

label0: // do

// x = x + y
ldr  r1, [r0]      // load x
ldr  r2, [r0, #4]  // load y
adds r1, r1, r2    // x = x + y
str  r1, [r0]      // store x

// y = y - z
ldr r1, [r0, #4]   // load y
ldr r2, [r0, #8]   // load z
subs r1, r1, r2    // y = y - z
str r1, [r0, #4]   // store y

// while (y != 0);
ldr r1, [r0, #4]   // load y
// need a cmp because ldr does not set flags.
cmp r1, #0
bne label0

// when we're done with the loop, we fall through...

bkpt #0


////////////////// C
int a = 8;
int b = 7;
int c = 6;
int d = 5;

...

d = a - b;
d = d + c;
d = d * a;
d = d - c;
////////////////////// S
.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

.data
a: .word 8
b: .word 7
c: .word 6
d: .word 5

.text
.global main
main:

ldr r1, =a // a
ldr r1, [r1]
ldr r2, =b // b
ldr r2, [r2]
ldr r3, =c // c
ldr r3, [r3]
ldr r4, =d // d
ldr r4, [r4]
ldr r0, =d // address of d

subs r4, r1, r2
adds r4, r4, r3
muls r4, r1
subs r4, r4, r3
str r4, [r0]
wfi


///////////////////////// C
int sum = 0;
int x = 0;
int begin = 6;
int end = 19;

...

x = begin;
while (x <= end) {
	sum += x;
	x = x + 2;
}

///////////////////////// S

.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

.data
sum: .word 0
x: .word 0
begin: .word 6
end: .word 19

.text
.global main
main:

ldr r1, =x // x
ldr r1, [r1]
ldr r2, =sum // sum
ldr r2, [r2]

ldr r3, =begin // begin and end
ldr r3, [r3]

ldr r0, =sum // address of sum and x

movs r1, r3 // x = begin
ldr r3, =end
ldr r3, [r3]
check:
cmp r1, r3
bgt nani
body:    
adds r2, r2, r1
adds r1, r1, #2
b check
nani:    
str r2, [r0]
ldr r0, =x
str r1, [r0]
wfi

//////////////////////// C
int count = 0;
int x = 0;
int first = 15;
int last = 430;

...

for (x=first; x <= last; x = x + 1) {
	// If x is odd, then (x&1) == 1
	if ((x & 1) != 0) {
		count = count + 1;
	}
}

////////////////////////// S
.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

.data
count: .word 0
x: .word 0
first: .word 15
last: .word 430

.text
.global main
main:


ldr r2, =first // first
ldr r2, [r2]
movs r1, r2 // x
ldr r3, =last  // last
ldr r3, [r3]
movs r4, #0 // count 
movs r5, #1  // Store x & 1

check:
cmp r1, r3
bgt nani
body:    
movs r5, #1
ands r5, r1
cmp r5, #0
bne done
adds r4, r4, #1
done:
adds r1, r1, #1
b check
nani:  
ldr r0, =count
str r4, [r0]
ldr r0, =x
str r1, [r0]
wfi
