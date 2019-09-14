Write a subroutine that does the following:

	Enable the GPIO Port C peripheral as you did with enable_ports_bc, above.
Configure the GPIO Port C MODER so that pin 8 is set for output. (i.e., set bits 16 and 17 of the MODER appropriately)
	Read from the ODR, set bit 8 of that value to '1', and write it back to the ODR.


	/// S
	.equ RCC_AHBENR, 0x40021014 
	.equ IOPCEN, 0x80000
	.equ GPIOC_MODER, 0x48000800
	.equ OUT8, 0x10000
	.equ ODR, 0x14
	.equ B8 0x100

	enable_ports_bc:
	//Does the first part
	push {r0-r5,lr} 
	ldr r0, =RCC_AHBENR
	ldr r1, [r0] 
	ldr r2, =IOPCEN 
	orrs r1, r2
	str r1, [r0] 

	//Does the second part
	ldr r3, =GPIOC_MODER
	ldr r3, [r3]
	ldr r4, =OUT8
	orrs r3, r4
	str r3, [r3] 

	//Does the third part
	ldr r5, [r3, #ODR]
	ldr r0, =B8
	ldr r0, [r0]
	orrs r5, r0
	str r5, [r3, #ODR]

	pop {r0-r5,pc}
