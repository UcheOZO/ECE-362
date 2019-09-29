.syntax unified
.cpu cortex-m0
.fpu softvfp
.thumb

//=============================================================================
// ECE 362 Lab Experiment 5
// Timers
//
//=============================================================================

.equ  RCC,      0x40021000
.equ  APB1ENR,  0x1C
.equ  AHBENR,   0x14
.equ  TIM6EN,	0x10
.equ  GPIOCEN,  0x00080000
.equ  GPIOBEN,  0x00040000
.equ  GPIOAEN,  0x00020000
.equ  GPIOC,    0x48000800
.equ  GPIOB,    0x48000400
.equ  GPIOA,    0x48000000
.equ  MODER,    0x00
.equ  PUPDR,    0x0c
.equ  IDR,      0x10
.equ  ODR,      0x14
.equ  PC0,      0x01
.equ  PC1,      0x04
.equ  PC2,      0x10
.equ  PC3,      0x40
.equ  PIN8,     0x00000100

// NVIC control registers...
.equ NVIC,		0xe000e000
.equ ISER, 		0x100
.equ ICER, 		0x180
.equ ISPR, 		0x200
.equ ICPR, 		0x280

// TIM6 control registers
.equ  TIM6, 	0x40001000
.equ  CR1,		0x00
.equ  DIER,		0x0C
.equ  PSC,		0x28
.equ  ARR,		0x2C
.equ  TIM6_DAC_IRQn, 17
.equ  SR,		0x10

.equ  PC0_8,	0x10055
.equ  PA0_3,	0x55
.equ  PP4_7,	0xAA00

//=======================================================
// 6.1: Configure timer 6
//=======================================================
.global init_TIM6
init_TIM6:
	push {lr}
	// Enable Clock to Timer 6
	ldr r0, =RCC
	ldr r1, [r0, #APB1ENR]
	ldr r2, =TIM6EN
	orrs r1, r2
	str r1, [r0, #APB1ENR]

	// Set PSC and ARR values so that the timer update event occurs exactly once every 1ms.
	// but first the counter of tim6
	ldr r0, =TIM6
	ldr r1, [r0, #CR1]
	movs r2, #1
	orrs r1, r2
	str r1, [r0, #CR1]

	ldr r1, =47
	str r1, [r0, #PSC]
	ldr r1, =999
	str r1, [r0, #ARR]

	//Enable UIE in the TIMER6's DIER register
	ldr r1, [r0, #DIER]
	movs r2, #0x1
	orrs r2, r1
	str r2, [r0, #DIER]

	//Enable TIM6 interrupt in NVIC's ISER register
	ldr r0, =NVIC
	ldr r1, =ISER
	ldr r2, =(1<<TIM6_DAC_IRQn)
	str r2, [r0, r1]
	pop {pc}


//=======================================================
// 6.2: Confiure GPIO
//=======================================================
.global init_GPIO
init_GPIO:
	push {lr}
	//Enable clock to Port C and Port A.
	ldr r0, =RCC
	ldr r1, [r0, #AHBENR]
	ldr r2, =GPIOCEN
	orrs r1, r2
	ldr r2, =GPIOAEN
	orrs r1, r2
	str r1, [r0, #AHBENR]

	//Set PC0, PC1, PC2, PC3 and PC8 as outputs.
	ldr r0, =GPIOC
	ldr r1, [r0, #MODER]
	ldr r2, =PC0_8
	orrs r1, r2
	str r1, [r0, #MODER]

	//Set PA0, PA1, PA2 and PA3 as outputs
	ldr r0, =GPIOA
	ldr r1, [r0, #MODER]
	ldr r2, =PA0_3
	orrs r1, r2
	str r1, [r0, #MODER]

	//Set up a pull down resistance on pins PA4, PA5, PA6 and PA7
	ldr r1, [r0, #PUPDR]
	ldr r2, =PP4_7
	orrs r1, r2
	str r1, [r0, #PUPDR]
	pop {pc}

//=======================================================
// 6.3 Blink blue LED using Timer 6 interrupt
// Write your interrupt service routine below.
//=======================================================
.type TIM6_DAC_IRQHandler, %function
.global TIM6_DAC_IRQHandler
TIM6_DAC_IRQHandler:
	push {r4-r7,lr}
	//Acknowledge the interrupt
	ldr r0, =TIM6
	ldr r1, [r0, #SR]
	movs r2, #0x1
	bics r1, r2
	str r1, [r0, #SR]


	// NEW STUFF
	//Update the selectded column
	ldr r0, =col
	ldr r1, [r0]
	adds r1, #1
	movs r2, #3
	ands r1, r2
	str r1, [r0]

	ldr r0, =GPIOA
	movs r2, #1
	lsls r2, r2, r1
	str r2, [r0, #ODR]

	//Index
	lsls r1, r1, #2
	movs r4, r1

	// Left shift all of the history variables
	ldr r1, =history
	movs r2, r4
	//lsls r2, r2, #2 //index*4
	ldrb r3, [r1, r2]
	lsls r3, r3, #1
	strb r3, [r1, r2]

	movs r2, r4
	adds r2, #1
	//lsls r2, r2, #2
	ldrb r3, [r1, r2]
	lsls r3, r3, #1
	strb r3, [r1, r2]

	movs r2, r4
	adds r2, #2
	//lsls r2, r2, #2
	ldrb r3, [r1, r2]
	lsls r3, r3, #1
	strb r3, [r1, r2]

	movs r2, r4
	adds r2, #3
	//lsls r2, r2, #2
	ldrb r3, [r1, r2]
	lsls r3, r3, #1
	strb r3, [r1, r2]

	// get row
	ldr r5, [r0, #IDR]
	lsrs r5, r5, #4
	movs r2, #0xf
	ands r5, r2

	// or the new key sample into each history variable
	movs r2, r4
	//lsls r2, r2, #2
	ldrb r3, [r1, r2]
	lsrs r6, r5, #0
	movs r7, #0x1
	ands r6, r7
	orrs r3, r6
	strb r3, [r1, r2]

	movs r2, r4
	adds r2, #1
	//lsls r2, r2, #2
	ldrb r3, [r1, r2]
	lsrs r6, r5, #1
	movs r7, #0x1
	ands r6, r7
	orrs r3, r6
	strb r3, [r1, r2]

	movs r2, r4
	adds r2, #2
	//lsls r2, r2, #2
	ldrb r3, [r1, r2]
	lsrs r6, r5, #2
	movs r7, #0x1
	ands r6, r7
	orrs r3, r6
	strb r3, [r1, r2]

	movs r2, r4
	adds r2, #3
	//lsls r2, r2, #2
	ldrb r3, [r1, r2]
	lsrs r6, r5, #3
	movs r7, #0x1
	ands r6, r7
	orrs r3, r6
	strb r3, [r1, r2]


	//Increment a global variable 'tick'
	ldr r0, =tick
	ldr r1, [r0]
	adds r1, #1
	str r1, [r0]

	ldr r2, =1000
	cmp r1, r2
	bne fuck

	ldr r1, =0x100
	ldr r2, =GPIOC
	ldr r3, [r2, #ODR]
	eors r3, r1
	str r3, [r2, #ODR]

	movs r1, #0
	str r1, [r0]
fuck:

	pop {r4-r7,pc}

//=======================================================
// 6.5 Debounce keypad
//=======================================================
.global getKeyPressed
getKeyPressed:
	push {lr}
start://while(1)
	ldr r0, =history
	movs r1, #0 // i
check:
	//lsls r2, r1, #2 // i*4
	cmp r1, #16
	bge done2
check2:
	ldrb r3, [r0,r1]
	cmp r3, #1
	bne done
	movs r0, r1
	ldr r1, =tick
	movs r2, #0
	strb r2, [r1]
	pop {pc}
done:
	adds r1, #1
	b check
done2:
	b start


.global getKeyReleased
getKeyReleased:
	push {r4,lr}
star://while(1)
	ldr r0, =history
	movs r1, #0 // i
chec:
	//lsls r2, r1, #2 // i*4
	cmp r1, #16
	bge node2
chec2:
	ldrsb r3, [r0,r1]
	movs r4, #0
	subs r4, #2
	cmp r3, r4
	bne node
	movs r0, r1  //r0 no longer needed
	ldr r1, =tick
	movs r2, #0
	strb r2, [r1]
	pop {r4,pc}
node:
	adds r1, #1
	b chec
node2:
	b star

