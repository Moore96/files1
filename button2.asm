;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file
            
;-------------------------------------------------------------------------------
            .def    RESET                   ; Export program entry-point to
                                            ; make it known to linker.
;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory.
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section.
            .retainrefs                     ; And retain any sections that have
                                            ; references to current section.
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
; Main loop here~!AZS
;-------------------------------------------------------------------------------
init:
	CLR.b P1OUT 			;Clear Port 1 output
	CLR.b P6OUT 			;Clear Port 6 output
	bis.b #01h, &P1DIR 		;P1.0 output (LED1)
	bis.b #40h, &P6DIR 		;P6.6 output (LED2)
	bic.w #0001h, &PM5CTL0 	;GPIO power on
	bic.b #02h, P4DIR		;button 4.1 Direction OUT
	bis.b #02h, &P4REN		;button 4.1 Enable Pullup Res
	bis.b #02h, &P4OUT 		;select pull up (on)
	bic.b #08h, P2DIR		;button 2.3 Direction OUT
	bis.b #08h, &P2REN		;button 2.3 Enable Pullup Res
	bis.b #08h, &P2OUT 		;select pull up (on)
main:

press:
	bit.b #02h, &P4IN		;flag button press 4.1
	jz letgo4				;exit if flag true
	bit.b #08h, &P2IN		;flag button press 2.3
	jz letgo2				;exit if flag true
	jnz press				;else loop press

letgo4:
	bit.b #02h, &P4IN
	jnz toggle
	jz letgo4
letgo2:
	bit.b #08h, &P2IN
	jnz toggle
	jz letgo2

toggle:
	xor.b #00000001b, P1OUT ;toggle LED P1OUT
	xor.b #01000000b, P6OUT ;toggle LED P6OUT
	jmp main 				;repeat to main

	nop

;-------------------------------------------------------------------------------
; Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect   .stack
            
;-------------------------------------------------------------------------------
; Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
            
