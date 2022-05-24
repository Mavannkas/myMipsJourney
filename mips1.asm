.macro to_float(%x)
#Move int to float register
mtc1 %x, $f12
#Convert binary int to IEEE 754
cvt.s.w $f12, $f12
.end_macro

.data 
	numberA: .word 12
	numberB: .word 12
.text
	main:
		#Loat to registers
		lw $t0, numberA
		lw $t1, numberB
		
		#Cast int to float
		to_float($t0)
		#Save macro output
		mov.s $f1, $f12
		
		to_float($t1)
		mov.s $f2, $f12
		
		#Div float by float
		div.s $f3, $f1, $f2
		
		#Print output
		li $v0, 2
		mov.s $f12, $f3
		syscall 
