.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

//============================================================================
// Q1: hello
//============================================================================
.global hello
hello:
	push {lr}
	ldr r0, =greet
	bl printf
	pop {pc}
greet:
	.string "Hello, World!\n"
	.align 2 // Align anything after this

//============================================================================
// Q2: add2
//============================================================================
.global add2
add2:
	push {lr}
	adds r3, r0, r1
	movs r2, r1
	movs r1, r0
	ldr r0,=format
	bl printf
	pop {pc}
format:
	.string "%d + %d = %d\n"
	.align 2

//============================================================================
// Q3: add3
//============================================================================
.global add3
add3:
	push {lr}
	adds r4, r0, r1
	adds r4, r2
	movs r3, r2
	movs r2, r1
	movs r1, r0
	ldr r0,=format2
	sub sp, #4
	str r4, [sp,#0]
	bl printf
	add sp, #4
	pop {pc}
format2:
	.string "%d + %d +%d = %d\n"
	.align 2
//============================================================================
// Q4: rotate6
//============================================================================
.global rotate6
rotate6:
	push {r4-r7,lr}
	ldr r5, [sp, #24]
	ldr r4, [sp, #20]

	cmp r0, #0
	bne body
	b return
body:


	movs r6, r5
	movs r5, r4
	movs r4, r3
	movs r3, r2
	movs r2, r1
	movs r1, r0
	movs r0, r6
	sub sp, #4
	str r5,[sp,#0]
	sub sp, #4
	str r4,[sp,#0]
	bl rotate6

	add sp, #4
	add sp, #4
	pop {r4-r7,pc}
	wfi

return:

	//subs r5, r0
	subs r5, r1
	subs r5, r2
	subs r5, r3
	subs r5, r4
	movs r0, r5
	pop {r4-r7,pc}
	wfi

//============================================================================
// Q5: low_pattern
//============================================================================
.type compare, %function  // You knew you needed this line.  Of course you did!
compare:
        ldr  r0,[r0]
        ldr  r1,[r1]
        subs r0,r1
        bx lr

.global low_pattern
low_pattern:
	push {r4-r7,lr}
	sub sp, #400
	sub sp, #400
	mov r7, sp // top of array
	movs r5, #0 // x
check:

	cmp r5, #200
	blt body2
	b nude
body2:

	lsls r6,r5,#2     // R6 is 4*x
	movs r4, r5
	adds r4, #1
	movs r3, #255
	movs r2, #0xff
	muls r4, r3
	ands r4, r2
	str  r4,[r7,r6]   // array[x] = r4
	adds r5, #1 //x+1
	b check
nude:
	movs r5, r0
	lsls r5,r5,#2
	movs r0, r7
	movs r1, #200
	movs r2, #4
	ldr r3, =compare
	bl qsort
	ldr r0, [r7,r5]
	add sp, #400
	add sp, #400
	pop {r4-r7,pc}

//============================================================================
// Q6: get_name
//============================================================================
.global get_name
get_name:
		push {lr}
		sub sp, #80
		ldr r0, =format3
		bl printf
		mov r0, sp
		bl gets
		movs r1, r0
		ldr r0, =format4
		bl printf
		add sp, #80
		pop {pc}
format3:
	.string "Enter your name: "
	.align 2
format4:
	.string "Hello, %s\n"
	.align 2
//============================================================================
// Q7: random_sum
//============================================================================
.global random_sum
random_sum:
	push {r4-r7,lr}
	sub sp, #80
	mov r7, sp // array
	movs r0, #0 // so no initialization error

	movs r5, #0 // x = 0
	lsls r6,r5,#2 // r6 is x*4

	bl random
	str  r0,[r7,r6] // arr[0] = random
	movs r4, r0 // previous element
	movs r5, #1
checkers:
	cmp r5, #20
	blt body4
	b ready
body4:

	lsls r6,r5,#2
	bl random
	subs r4, r0
	str r4, [r7,r6]
	adds r5, #1
	b checkers
ready:
	movs r5, #0
	movs r2, #0 // sum
checkerpt2:
	cmp r5, #20
	blt body5
	b dumebe
body5:
	lsls r6, r5, #2
	ldr r4, [r7,r6]
	adds r2, r4
	adds r5, #1
	b checkerpt2
dumebe:
	movs r0, r2
	add sp, #80
	pop {r4-r7,pc}

//============================================================================
// Q8: fibn
//============================================================================
.global fibn
fibn:
	push {r4-r7,lr}
	sub sp, #480
	mov r7, sp
	movs r1, #0 // x
	str r1, [r7, #0]
	movs r2, r1 // x-2
	movs r1, #1
	str r1, [r7, #4]
	movs r3, r1// x-1
	movs r1, #2

checkukle:
	cmp r1, #120
	blt budy
	b dye
budy:
	lsls r6, r1, #2
	adds r4, r3, r2  // arr[x-1] + arr[x-2]
	str r4, [r7, r6]
	adds r1, #1
	movs r2, r3  //new boys
	movs r3, r4
	b checkukle
dye:
	lsls r1, r0, #2
	ldr r0, [r7, r1]

	add sp, #480
	pop {r4-r7,pc}
//============================================================================
// Q9: fun
//============================================================================
.global fun
fun:
	push {r4-r7,lr}
	sub sp, #400
	mov r7, sp
	movs r2, #0 // sum and multpile of x
	str r2, [r7, #0]
	movs r3, #1 // x
	movs r4, r2 // previous
checkt:
	cmp r3, 100
	blt beyonce
	b dominatrix
beyonce:
	lsls r2, r3, #2
	movs r5, #37 // caluclate pod
	adds r6, r3, #7
	muls r5, r6
	adds r5, r4
	str r5, [r7,r2]
	adds r3, #1
	movs r4, r5
	b checkt
dominatrix:
	movs r3, r0
	movs r2, #0
chuka:
	cmp r3, r1
	ble gat
	b tag
gat:
	lsls r6, r3, #2
	ldr r4, [r7, r6]
	adds r2, r4
	adds r3, #1
	b chuka
tag:
	movs r0, r2
	add sp, #400
	pop {r4-r7,pc}

//============================================================================
// Q10: sick
//============================================================================
.global sick
sick:
/*
	push {r4-r7,lr}
	push {r0-r1}

	movs r5, #1 //x
	movs r6, #0 // sum
	sub sp, #400
	mov r7, sp
	str r6, [r7,r6]
	movs r0, #0 //previous
chark:
	cmp r5, #100
	blt hana
	b naha
hana:
	lsls r4, r5, #2 // 4*x
	adds r1, r5, r2 // x+add
	muls r1, r3 // (a+add)*mul
	adds r1, r0
	movs r0, r1 // new previous
	str r1, [r7, r4]
	adds r5, #1
naha:
	pop {r0-r1}
	ldr r4, [sp,#20]
	movs r5, r0 // start
tina:
	cmp r5, r1
	ble boo
	b oob
boo:
	lsls r2, r5, #2
	ldr r3, [r7, r2]
	adds r6, r3
	adds r5, r4
	b tina
oob:
	movs r0, r6

	pop {r4-r7,pc}

*/
