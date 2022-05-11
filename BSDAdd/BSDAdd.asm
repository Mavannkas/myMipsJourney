.data
	numberA: .byte 0x00, 0x99, 0xF0
	numberB: .byte 0x00, 0x99, 0xF0
	output: .space 2
.text
	main:
		la $a0, numberA
		la $a1, numberB
		la $a2, output
		jal add
		
		la $t1, output
		li $t0, 2
		print:
			beqz $t0, exitLoop
			
			lb $t3, ($t1)
			
			move $a1, $t3
			jal getOlderNumber
			move $a0, $v0
			li $v0, 1
			syscall
			
			move $a1, $t3
			jal getYoungerNumber
			move $a0, $v0
			li $v0, 1
			syscall
			subi $t0, $t0, 1
			addi $t1, $t1, 1			
			j print
		exitLoop:
		
		
		
		
	li $v0, 10
	syscall


	add: 
		#vars
		move $s7, $ra
		
		move $s0, $a0 #Number 1
		move $s1, $a1 #Number 2

		move $a0, $s0
		jal getSize
		move $s2, $v0 #Size of Number 1
		
		move $a0, $s1
		jal getSize
		move $s3, $v0 #Size of Number 2
		
		move $t8, $s2 #Copy of size n1
		move $t9, $s3 #Copy of size n1
		
		li $s4, 0 #Output Index
		li $s5, 0 #Overload Flag
		
		move $s6, $a2 #Output
		#Swap 
		bge $s2, $s2, noSwap
		move $t5, $s0
		move $s0, $s1
		move $s1, $t5
		
		move $t8, $s3
		move $t9, $s2
		noSwap:
		
		#add bigger to output
		move $t7, $t8 #save of bigger size
		
		while_add:
			beq $t8, $zero, end_while_add
			lb $t3, ($s0) #store for value
			
			li $t0, 2
			div $t8, $t0
			mfhi $t1
			
			bne $t1, $zero, no_zero
				move $a1, $t3
				jal getOlderNumber
				sll $v0, $v0, 4
				or $v0, $v0, $t3
				sb $v0, ($s6)
			no_zero:
			beq $t1, $zero, zero
				move $a1, $t3
				jal getYoungerNumber
				or $v0, $v0, $t3
				sb $v0, ($s6)
				
				addi $s0, $s0, 1
				addi $s6, $s6, 1
				addi $s4, $s4, 1
			zero:
			
			subi $t8, $t8, 1
			j while_add
		end_while_add:
		
		#Return with pointer
		while_back:
			beq $t8, $t9, end_while_back
			li $t0, 2
			div $t8, $t0
			mfhi $t1
			
			bne $t1, $zero, no_zero_back
				subi $s6, $s6, 1
				subi $s4, $s4, 1
			no_zero_back:
			
			addi $t8, $t8, 1
			j while_back
		end_while_back:
		
		#t5 - store
		li $t6, 0 #overload flag
		#Add A to B
		loop:
		
			lb $t3, ($s1) #store for value num b
			lb $t2, ($s6) #store for output
			li $t0, 2
			div $t8, $t0
			mfhi $t1
			
			bne $t1, $zero, no_zero_loop
				move $a1, $t2
				jal getOlderNumber
				move $t5, $v0
				
				move $a1, $t3
				jal getOlderNumber
				add $t5, $t5, $v0
				
				blt $t5, 10, less_than_10
					subi $t5, $t5, 10
					
					bne $s4, $zero, no_zero_less_than_10
						li $s5, 1
					no_zero_less_than_10:
					beq $s4, $zero, zero_less_than_10
						subi $s6, $s6, 1
						lb $t6, ($s6)
						addi $t6, $t6, 1
						sb $t6, ($s6) 
						addi $s6, $s6, 1
					zero_less_than_10:					
				less_than_10:
				sll $t5, $t5, 4
				
				move $a1, $t2
				jal getYoungerNumber
				or $t5, $t5, $v0
				
				sb $t5, ($s6)
			no_zero_loop:
			beq $t1, $zero, zero_loop
				move $a1, $t2
				jal getYoungerNumber
				move $t5, $v0
				
				move $a1, $t3
				jal getYoungerNumber
				add $t5, $t5, $v0
				
				blt $t5, 10, less_than_10_else
					subi $t5, $t5, 10
					li $t6, 1					
				less_than_10_else:
				
				move $a1, $t2
				jal getOlderNumber
				add $v0, $v0, $t6
				sll $v0, $v0, 4
				or $v0, $v0, $t5
				
				sb $v0, ($s6)
				
				addi $s1, $s1, 1
				addi $s6, $s6, 1
				addi $s4, $s4, 1
			zero_loop:
			li $t6, 0	
			subi $t8, $t8, 1
			bnez $t8, loop
		
		repeat_fix_loop:
		li $t4, 0	
		#Return with pointer
		while_back_2:
			beq $t8, $t7, end_while_back_2
			li $t0, 2
			div $t8, $t0
			mfhi $t1
			
			bne $t1, $zero, no_zero_back_2
				subi $s6, $s6, 1
				subi $s4, $s4, 1
			no_zero_back_2:
			
			addi $t8, $t8, 1
			j while_back_2
		end_while_back_2:
		fix_loop:
			lb $t2, ($s6) #store for output
			
			li $t0, 2
			div $t8, $t0
			mfhi $t1
			
			bne $t1, $zero, no_zero_fix_loop
				move $a1, $t2
				jal getOlderNumber
				move $t5, $v0
				
				blt $t5, 10, less_than_10_fix
					li $t4, 1
					subi $t5, $t5, 10
					
					bne $s4, $zero, no_zero_less_than_10_fix
						li $s5, 1
					no_zero_less_than_10_fix:
					beq $s4, $zero, zero_less_than_10_fix
						subi $s6, $s6, 1
						lb $t6, ($s6)
						addi $t6, $t6, 1
						sb $t6, ($s6) 
						addi $s6, $s6, 1
					zero_less_than_10_fix:					
				less_than_10_fix:
				sll $t5, $t5, 4
				
				move $a1, $t2
				jal getYoungerNumber
				or $t5, $t5, $v0
				
				sb $t5, ($s6)
			no_zero_fix_loop:
			beq $t1, $zero, zero_fix_loop
				move $a1, $t2
				jal getYoungerNumber
				move $t5, $v0
				
				blt $t5, 10, less_than_10_else_fix
					li $t4, 1
					subi $t5, $t5, 10
					li $t6, 1					
				less_than_10_else_fix:
				
				move $a1, $t2
				jal getOlderNumber
				add $v0, $v0, $t6
				sll $v0, $v0, 4
				or $v0, $v0, $t5
				
				sb $v0, ($s6)
				
				addi $s6, $s6, 1
				addi $s4, $s4, 1
			zero_fix_loop:
			
			li $t6, 0	
			subi $t8, $t8, 1
			bnez $t8, fix_loop
			
			bnez $t4, repeat_fix_loop
			
		while_back_3:
			beq $t8, $t7, end_while_back_3		
			beqz $s5, no_zero_back_3
				move $t0, $s6
				subi $t0, $t0, 1
				lb $t0, ($t0)
				sb $t0, ($s6)
			no_zero_back_3:
			
			subi $s6, $s6, 1
			subi $s4, $s4, 1
			addi $t8, $t8, 2
			j while_back_3
			
		end_while_back_3:	
		beqz $s5, no_zero_4
			li $t0, 1
			sb $t0, ($s6)
		no_zero_4:
			
		jr $s7
	getOlderNumber: #Get a1 out v0
		move $v0, $a1
		sra $v0, $v0, 4
		and $v0, 0x0F
		jr $ra 
	
	getYoungerNumber: #Get a1 out v0
		move $v0, $a1
		and $v0, 0x0F
		jr $ra 
	
	getSize: #Get a0 out v0
		move $t4, $ra
		li $t1, 0
		move $t0, $a0
		repeateSize:
			lb $t2, ($t0)
			
			move $a1, $t2
			jal getOlderNumber
			beq $v0, 0xf, finish
			
			addi $t1, $t1, 1
			
			move $a1, $t2
			jal getYoungerNumber
			beq $v0, 0xf, finish
			
			addi $t1, $t1, 1
			addi $t0, $t0, 1 
			j repeateSize
		finish:
		move $v0, $t1
		jr $t4
