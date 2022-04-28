.data
	message: .asciiz "Hi, everybody!\nMy name is Wiktor.\n"
	by: .asciiz "The end!\n"
.text
	main:
		addi $a1, $zero, 50
		addi $a2, $zero, 100
		
		jal addNumbers
		
		li $v0, 1
		move $a0, $v1
		syscall
		# Exit 
		li $v0, 10 
		syscall
	addNumbers: #get a1 a2 return v1
		add $v1, $a1, $a2
		
		jr $ra
