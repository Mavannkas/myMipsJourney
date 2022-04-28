.data
	message: .asciiz "Close?\n"
	message2: .asciiz "bay!"
.text
	main:
		jal printQuestion
		jal getUserInput
		beqz $v0, main
		beq $v0, 1,  exit
	printQuestion:
		li $v0, 4
		la $a0, message
		syscall
		jr $ra
		
	getUserInput:
		li $v0, 5n
		syscall
		jr $ra
	
	exit:
		li $v0, 4
		la $a0, message2
		syscall
		
		li $v0, 10
		syscall
