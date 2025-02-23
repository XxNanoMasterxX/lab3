;
; lab3 bebeeee.asm
;
; Created: 2/22/2025 6:33:35 PM
; Author : laloj
;


; Replace with your application code
.include "M328Pdef.inc"
.cseg
.org 0x0000
rjmp comodicee
.org PCI1addr //pcINT1
jmp elpepe
.org OVF0addr //Timer0, Overfloq
jmp dispe


comodicee:
	cli
	ldi r16, HIGH(RAMEND)
	out SPH, R16
	ldi R16, LOW(RAMEND)
	out spl, r16

	mitabla: .DB 0x3f, 0x06, 0x5b, 0x4f, 0x66, 0x6D, 0x7D, 0x07, 0x7f, 0x67, 0x77, 0x7c, 0x39, 0x5e, 0x79, 0x71

	; Setup del clock
	ldi r16, (1 << CLKPCE)
	sts CLKPR, r16 //Hora de prescaler hermano
	ldi r16, 0b00000100
	sts CLKPR, r16 // Asi es viejo, prescaler F_cpu = 1MHz

	call in_tim

	ldi r16, 0x01
	sts TIMSK0, r16

	LDI ZL, LOW(mitabla<<1)
	LDI ZH, HIGH(mitabla<<1)
	LPM R17, Z // Se carga el valor inicial de z hacia el port, este siendo 0.
	ldi R22, 0xff
	eor r17, R22
	out portd, r17

	; Setup PCINT1
	ldi r16, 0x2
	sts PCICR, r16 // 0101, los dos interrupts en ambos flancos

	ldi r16, 0x03
	sts PCMSK1, r16 //Los interrupts se activan cuando se vuelvan uno



	ldi r16, 0x00
	out DDRC, r16 // PinC como entrada
	ldi r16, 0xff
	out DDRB, r16 // PinB como salida
	out DDRD, r16 // PinD como salida
	out PORTC, r16


	ldi r18, 0x00
	ldi r20, 0x00
	ldi r21, 0x00

	sei

loop:
	jmp loop


elpepe:
	SBIS PINC, 0
	call incre
	SBIS PINC, 1
	call decre
	reti

incre:
	inc r18
	call DELAY
	andi r18, 0x0f
	out PORTB, r18
	ret

decre:
	dec r18
	call DELAY
	andi r18, 0x0f
	out PORTB, r18
	ret


in_tim:
	LDI R16, (1<<CS01) | (1<<CS00)
	OUT TCCR0B, R16 // Setear prescaler del TIMER 0 a 64
	LDI R16, 100
	OUT TCNT0, R16 // Cargar valor inicial en TCNT0
	RET

dispe:
	ldi r16, 100
	OUT TCNT0, R16
	inc r20
	cpi r20, 100
	brne fini
	clr r20
	adiw Z, 1
	inc r21
	cpi r21, 0x0A
	brne fini
	clr r21
	LDI ZL, LOW(mitabla<<1)
	LDI ZH, HIGH(mitabla<<1)
fini:
	lpm r17, Z
	eor r17, R22
	out portd, r17
	reti



DELAY:
    LDI     R19, 0
SUBDELAY1:
    INC     R19
    CPI     R19, 0
    BRNE    SUBDELAY1
    LDI     R19, 0
SUBDELAY2:
    INC     R19
    CPI     R19, 0
    BRNE    SUBDELAY2
    LDI     R19, 0
SUBDELAY3:
    INC     R19
    CPI     R19, 0
    BRNE    SUBDELAY3
	LDI		R19, 0
SUBDELAY4:
	INC     R19
    CPI     R19, 0
    BRNE    SUBDELAY4
    RET