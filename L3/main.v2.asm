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
	la $t0, global_array
	sw $t0, ($sp)
	
	subi $sp, $sp, 4
	li $t0, 10
	sw $t0, ($sp)

	#0 - size
	#4 - *array

	jal sum
	
	li $v0, 1
	lw $a0, ($sp)
	syscall
	
	addi $sp, $sp, 12

lw $sp, sys_stack_addr
li $v0, 10
syscall
sum:
	subi $sp, $sp, 8
	move $t0, $ra
	sw $t0, ($sp)
	
	subi $sp, $sp, 4
	#0 - s
	#4 - i
	#8 - ra
	#12 - return
	#16 - size
	#20 - *array

	li $t0, 0
	sw $t0, ($sp)
	
	subi $sp, $sp, 4
	lw $t0, 16($sp)
	subi $t0, $t0, 1
	
	
	sw $t0, 4($sp)
	
	li $t3, -1
	li $t4, 1
	
	andi $t1, $t0, 1
	beqz $t1, not_equal
	mulo $t4, $t4, $t3
	not_equal:
	
	while:
		lw $t0, 4($sp) #get i
		bltz $t0, end_while
		
		li $t2, 4
		mulo $t1, $t0, $t2 #calc index
		
		lw $t0, 20($sp) #get *array
		
		add $t0, $t0, $t1
		
		lw $t1, ($t0) #get array[i]
		
		mulo $t1, $t1, $t4 # mul 1/-1
		mulo $t4, $t3, $t4 
		
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
