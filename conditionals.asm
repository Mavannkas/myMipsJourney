.data
	message: .asciiz "The name are equal."
	message2: .asciiz "Nothing happend"
.text
	main:
		addi $t0, $zero, 20
		addi $t1, $zero, 20
		
		blt $t0, $t1, numbersEquals		
		
		#exit
		li $v0, 10
		syscall
	
	numbersEquals:
		li $v0, 4
		la $a0, message
		syscall
		
	