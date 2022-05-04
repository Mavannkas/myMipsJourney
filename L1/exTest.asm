# Mno?enie liczb nieca?kowitych
# 0101 - 5
# 0110
# -----
# we 16bit liczby :1 L2
# Suma < 0
# mask < 0000000000000001
# L2 and na masce
# mask SLL 1
# L1 L1 SLL 1

# la li 
# odejmowaiie 1
# sll

.data

.text
	main:
		li $s1, 16
		li $t0, 0
		
		li $v0, 5
		syscall
		move $t1, $v0
				
		li $v0, 5
		syscall
		move $t2, $v0
		
		jal multiply
	
	multiply:
		beq $s1, $zero, exit
		
		andi $a0, $t2, 1
		bne $a0, $zero, addToMask
		sll $t1, $t1, 1
		srl $t2, $t2, 1
		
		
		subi $s1, $s1, 1
		j multiply
	
	addToMask:
		add $t0, $t0, $t1
		sll $t1, $t1, 1
		srl $t2, $t2, 1
		
		
		subi $s1, $s1, 1
		j multiply
	
	exit:
		li $v0, 1
		move $a0, $t0
		syscall
		
		li $v0, 10
		syscall