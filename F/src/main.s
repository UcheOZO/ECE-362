.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

.text

.global main
main:
    // Put any instructions you want here.
    b five
    b first
    b mul4
    b or_into
    b outer

    wfi


.global five
five:
    push {lr}
	movs r0,#5
	pop  {pc}

.global first
first:
    push {lr}
    movs r0, r0
	pop  {pc}

.global mul4
mul4:
    push {lr}
	muls r0, r1
	muls r0, r2
	muls r0, r3
	pop  {pc}

.global or_into
or_into:
    push {lr}
	ldr r2, [r0]
	orrs r2, r1
	str r2, [r0]
	pop  {pc}

.global getbit
getbit:
    push {lr}
	ldr r2, [r0]
	lsrs r2, r1
	movs r3, #1
	ands r2, r3
	movs r0, r2
	pop  {pc}

.global setbit
setbit:
    push {lr}
    movs r2, #1
	lsls r2, r1
	ldr r3, [r0]
	orrs r3, r3, r2
	str r3, [r0]
	pop  {pc}

.global clrbit
clrbit:
    push {lr}
	movs r2, #1
	lsls r2, r1
	ldr r3, [r0]
	bics r3, r2
	str r3, [r0]
	pop  {pc}

.global inner
inner:
    push {lr}
    subs r0, #2
    pop  {pc}

.global outer
outer:
    push {lr}
    b inner
    adds r0, #9
    pop  {pc}

.global set5
set5:
    push {lr}
    //movs r0, r0
    movs r1, #5
    b setbit
    pop  {pc}

.global get12
get12:
    push {lr}
    //movs r0, r0
    movs r1, #12
    b getbit
    pop  {pc}

.global cube
cube:
    push {lr}
    movs r2, r0
    movs r3, r0
    muls r2, r2
    muls r2, r3
    pop  {pc}

.global sumcube
sumcube:
    push {r4 - r7, lr}

    movs r4, r0 //x
    movs r5, r1 //y
    movs r6, #0 //sum
    movs r7, r0 //n

check:
    cmp r7, r5
    ble body
    b end2
body:
    b cube
    adds r6, r3
    b end1
end1:
    adds r7, #1
    b check
end2:
    movs r0, r6
    pop  {r4 - r7, pc}

.global factorial
factorial:

.global factorial2
factorial2:

.global fun14
fun14:

.global doublerec
doublerec:

.global strcmp
strcmp:

.global vectoradd
vectoradd:

.global updatesum
updatesum:

.global findfirst0
findfirst0:

.global globalsum
globalsum:

// Because this array is "const", we can
// put it in the text segment (which is
// in the Flash ROM.  It cannot be modified.
bx lr // put a return here just in case you missed one above.
.global global_array
.align 4
global_array:
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


