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
    movs r1, #6
    muls r0, r1
    bl inner
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
    push {r7,lr}
    movs r2, r7
    movs r3, r7
    muls r2, r2
    muls r2, r3
    pop  {r7,pc}

.global sumcube
sumcube:
   // push {r4-r7, lr}
    push {lr}
    movs r2,#0
    movs r4, r0 //x
    movs r5, r1 //y
    movs r6, #0 //sum
    movs r7, r0 //n
    
check:
    cmp r7, r5
    ble body
    b end2
body:
    bl cube
    adds r6, r2
    b end1
end1:
    adds r7, #1
    b check
end2:
    movs r0, r6
   // pop  {r4 - r7}
    pop {pc}

.global factorial
factorial:
    push {lr}
    movs r1, #1 // product
check2:
    cmp r0, #0
    bgt body2
    b end3
body2:
    muls r1, r0
    subs r0, #1
    b check2
end3:
    movs r0, r1
    pop {pc}

.global factorial2
factorial2:
    push {lr}
    //movs r2, r0
    movs r5, r0
    cmp r5, #1
    ble reach
    
recurse:
    push {r5}
    subs r5, #1
    movs r0, r5
    bl factorial2
    pop {r5}
    muls r0, r5
    
    
reach:
    pop {pc}
    
    
    

.global fun14
fun14:
    push {lr}
    //movs r2, r0
    movs r5, r0
    cmp r5, #4
    blt reachs
    
recurses:
    push {r5}
    subs r5, #3
    movs r0, r5
    bl fun14
    pop {r5}
    movs r6, #2
    muls r0, r6
    adds r0, #3
    
reachs:
    pop {pc}    

.global doublerec
doublerec:
push {lr}
pop {pc}

.global strcmp
strcmp:
    push {lr}
    movs r2, #0
cheg:
    ldrb r4, [r0]
    ldrb r6, [r1]
    cmp r4, r2
    bne buody
    cmp r6, r2
    bne buody
    b endive
buody:
    cmp r4, r6
    bne buody2
    b cheg2
buody2:
    subs r4, r6
    b endite
cheg2:    
    adds r0, #1
    adds r1, #1
    b cheg
endive:
    subs r4, r6
endite:
    movs r0, r4
    pop {pc}

.global vectoradd
vectoradd:
    push {lr}
    
    movs r4, #0 // n
chick:
    cmp r4, r0
    blt bidy
    b nd
bidy:
    movs r7, #4
    muls r7, r4
    ldr r5, [r2,r7]
    ldr r6, [r3,r7]
    adds r6, r5, r6
    str r6, [r1,r7]
    adds r4, r4, #1
    b chick
nd:    
    pop {pc}

.global updatesum
updatesum:
    push {lr}
    movs r2, #0 // n
    movs r3, #0 // sum
chek:
    cmp r2, r1
    blt bud
    b natsu
bud:
    movs r5, #4
    muls r5, r2
    ldr r4, [r0, r5] // x
    adds r3, r4
    adds r4, #1
    str r4, [r0, r5]
    adds r2, #1
    b chek
natsu:
    movs r0, r3
    pop {pc}

.global findfirst0
findfirst0:
    push {lr}
    movs r1, #0 // n
    movs r3, #0
    subs r3, #1
chika:    
    cmp r1, #32
    blt buda
    b duna
buda:
    movs r2, #1
    lsls r2, r1
    ands r2, r0
    cmp r2, #0
    beq equr
    adds r1, #1
    b chika
equr:
    movs r3, r1
    b duna

duna:
    movs r0, r3
    pop {pc}

.global globalsum
globalsum:
    push {lr}
    movs r1, #0 // n
    movs r2, #0 // sum
    ldr r3, =global_array // array
chicabang:
    cmp r1, r0
    blt badang
    b donne
badang:
    movs r4, #4
    muls r4, r1
    ldr r5, [r3, r4] 
    adds r2, r5
    adds r1, #1
    b chicabang
donne:
    movs r0, r2
    pop {pc}

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