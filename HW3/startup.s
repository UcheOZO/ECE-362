.cpu cortex-m0
.thumb
.syntax unified
.fpu softvfp

.org 0x08000000 
startup:
    b main

.global main
main:
testfive: // Test problem 1
	bl five
	cmp r0,#5
	bne testfirst
	movs r0,#1
	bl mark

testfirst: // Test problem 2
	movs r0,#15
	bl first
	cmp r0,#15
	bne testmul4
	movs r0,#2
	bl mark

testmul4: // Test problem 3
	movs r0,#2
	movs r1,#3
	movs r2,#5
	movs r3,#7
	bl mul4
	cmp r0,#210
	bne testor_into
	movs r0,#3
	bl mark

testor_into: // Test problem 4
	bl tmparr
	movs r1,#0xaa
	str r1,[r0]
	movs r1,#0x0f
	bl or_into
	bl tmparr
	ldr r1,[r0]
	cmp r1,#0xaf
	bne testgetbit
	movs r0,#4
	bl mark

testgetbit: // Test problem 5
	bl tmparr
	movs r1,#0xaa
	str r1,[r0]
	movs r1,#5
	bl getbit
	cmp r0,#1
	bne testsetbit
	bl tmparr
	movs r1,#6
	bl getbit
	cmp r0,#0
	bne testsetbit
	movs r0,#5
	bl mark

testsetbit: // Test question 6
	bl tmparr
	movs r1,#0xaa
	str r1,[r0]
	movs r1,#4
	bl setbit
	bl tmparr
	ldr r1,[r0]
	cmp r1,#0xba
	bne testclrbit
	movs r0,#6
	bl mark

testclrbit: // Test question 7
	bl tmparr
	movs r1,#0xaa
	str r1,[r0]
	movs r1,#5
	bl clrbit
	bl tmparr
	ldr r1,[r0]
	cmp r1,#0x8a
	bne testouter
	movs r0,#7
	bl mark


testouter: // Test question 8
	movs r0,#3
	bl outer
	cmp r0,#25
	bne testset5
	movs r0,#8
	bl mark

testset5: // Test question 9
	bl tmparr
	movs r1,#0x55
	str r1,[r0]
	movs r1,#0xff // bogus value
	bl set5
	bl tmparr
	ldr r1,[r0]
	cmp r1,#0x75
	bne testget12
	movs r0,#9
	bl mark

testget12: // Test question 10
	bl tmparr
	movs r1,#0x55
	lsls r1,r1,#8
	str r1,[r0]
	movs r1,#0xff // bogus value
	bl get12
	cmp r0,#1
	bne testsumcube
	movs r0,#10
	bl mark

testsumcube: // Test question 11
	movs r0,#2
	movs r1,#6
	bl sumcube
	movs r1,#220
	lsls r1,r1,#1 // compare to 440
	cmp r0,r1
	bne testfactorial
	movs r0,#11
	bl mark

testfactorial: // Test question 12
	movs r0,#5
	bl factorial
	cmp r0,#120
	bne testfactorial2
	movs r0,#12
	bl mark

testfactorial2: // Test question 13
	movs r0,#4
	bl factorial2
	cmp r0,#24
	bne testfun14
	movs r0,#13
	bl mark

testfun14: // Test question 14
	movs r0,#10
	bl fun14
	cmp r0,#29
	bne testdoublerec
	movs r0,#14
	bl mark

testdoublerec: // Test question 15
	movs r0,#8
	bl doublerec
	cmp r0,#5
	bne teststrcmp
	movs r0,#15
	bl mark

teststrcmp: // Test question 16
	bl tmparr
	movs r1,#0x45 // E
	strb r1,[r0,#0]
	movs r1,#0x43 // C
	strb r1,[r0,#1]
	movs r1,#0x45 // E
	strb r1,[r0,#2]
	movs r1,#0x33 // 3
	strb r1,[r0,#3]
	movs r1,#0x36 // 6
	strb r1,[r0,#4]
	movs r1,#0x32 // 2
	strb r1,[r0,#5]
	movs r1,#0 // NUL
	strb r1,[r0,#6]
	movs r1,#0x45 // E
	strb r1,[r0,#7]
	movs r1,#0x43 // C
	strb r1,[r0,#8]
	movs r1,#0x45 // E
	strb r1,[r0,#9]
	movs r1,#0x32 // 2
	strb r1,[r0,#10]
	movs r1,#0x37 // 7
	strb r1,[r0,#11]
	movs r1,#0x30 // 0
	strb r1,[r0,#12]
	movs r1,#0 // NUL
	strb r1,[r0,#13]
	adds r1,r0,#7
	bl strcmp
	cmp r0,#1
	bne testvectoradd
	bl tmparr
	movs r1,#0
	strb r1,[r0,#3] // store a NUL after ECE
	strb r1,[r0,#10] // store a NUL after ECE
	adds r1,r0,#7
	bl strcmp
	cmp r0,#0
	bne testvectoradd
	movs r0,#16
	bl mark

testvectoradd: // Test question 17
        bl tmparr
        movs r1,#3
        str r1,[r0,#0] // 3
        adds r1,#1
        str r1,[r0,#4] // 4
        adds r1,#2
        str r1,[r0,#8]  // 6
        adds r1,#1
        str r1,[r0,#12] // 7
        movs r1,r0
        movs r0,#2
        movs r2,r1
        movs r3,r1
        adds r3,#8
        bl vectoradd
        bl tmparr
        ldr r1,[r0]
        cmp r1,#9
        bne testupdatesum
        ldr r1,[r0,#4]
        cmp r1,#11
        bne testupdatesum
        movs r0,#17
        bl mark

testupdatesum: // Test question 18
        bl tmparr
        movs r1,#5
        str r1,[r0,#0] // 5
        adds r1,#2
        str r1,[r0,#4] // 7
        subs r1,#4
        str r1,[r0,#8] // 3
        subs r1,#2
        str r1,[r0,#12] // 1
        movs r1,#4
        bl updatesum
        cmp r0,#16
        bne testfindfirst0
        bl tmparr
        ldr r1,[r0,#0]
        cmp r1,#6
        bne testfindfirst0
        ldr r1,[r0,#4]
        cmp r1,#8
        bne testfindfirst0
        ldr r1,[r0,#8]
        cmp r1,#4
        bne testfindfirst0
        ldr r1,[r0,#12]
        cmp r1,#2
        bne testfindfirst0
        movs r0,#18
        bl mark

testfindfirst0: // Test question 19
        movs r0,#0xff
        bl findfirst0
        cmp r0,#8
        bne testglobalsum
        movs r0,#0
        bl findfirst0
        cmp r0,#0
        bne testglobalsum
        subs r0,#1
        bl findfirst0
        adds r0,#1
        cmp r0,#0
        bne testglobalsum
        movs r0,#19
        bl mark

testglobalsum: // Test question 20
        movs r0,#4
        bl globalsum
        cmp r0,#17
        bne thisistheend
        movs r0,#5
        bl globalsum
        cmp r0,#28
        bne thisistheend
        movs r0,#20
        bl mark

thisistheend:
        wfi
        b thisistheend



// Mark question N as correct
mark:
	movs r1,#0x20
	lsls r1,r1,#24
	subs r1,#1
	strb r0,[r1,r0]
	bx lr

// Load the address of the temporary array in R0
tmparr:
	movs r0,#0x20
	lsls r0,r0,#24
	adds r0,#20
	bx lr

.data
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.byte 0xff
	.word 0x0
	.word 0x0
	.word 0x0
	.word 0x0

.text
