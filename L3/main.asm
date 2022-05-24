.eqv STACK_SIZE 2048
.data
	# obszar na zapami?tanie adresu stosu systemowego
	sys_stack_addr: .word 0
	# deklaracja w?asnego obszaru stosu
	stack: .space STACK_SIZE
	
	global_array: .word 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
.text
	#Init stact
sw $sp, sys_stack_addr
la $sp, stack+STACK_SIZE

main:
	subi $sp, $sp, 4
	#0 - size
	#4 - *array

	
	li $t0, 10
	sw $t0, ($sp)
	
	la $t0, global_array
	addi $t0, $t0, 4
	sw $t0, 4($sp)
	jal sum
	
	li $v0, 1
	lw $a0, ($sp)
	syscall
	
	addi $sp, $sp, 4

lw $sp, sys_stack_addr
li $v0, 10
syscall
sum:
	subi $sp, $sp, 8
	move $t0, $ra
	sw $t0, ($sp)
	
	subi $sp, $sp, 8
	#0 - s
	#4 - i
	#8 - ra
	#12 - return
	#16 - size
	#20 - *array

	li $t0, 0
	sw $t0, ($sp)
	
	lw $t0, 16($sp)
	subi $t0, $t0, 1
	
	sw $t0, 4($sp)
	
	while:
		lw $t0, 4($sp) #get i
		bltz $t0, end_while
		
		lw $t0, 20($sp) #get *array
		
		lw $t1, ($t0) #get array[i]
		
		addi $t0, $t0, 4 #move array + 1
		sw $t0, 20($sp) #save *array
		
		lw $t0, ($sp) #get s
		add $t0, $t0, $t1 #s + array[i]
		
		sw $t0, ($sp) #save s 
		
		lw $t0, 4($sp)
		subi $t0, $t0, 1
		sw $t0, 4($sp)
		j while
	end_while:
	
	#return s
	lw $t0, ($sp)
	sw $t0, 12($sp)
	
	addi $sp, $sp, 8
	lw $ra, ($sp)
	addi $sp, $sp, 4
	jr $ra
