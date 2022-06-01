.macro change_last_char (%store)
	move $t0, %store
	li $t2, 0x0A
	while:
		lb $t1, ($t0)
		beq $t1, $t2, end_while
		beqz $t1, end_while
		addi $t0, $t0, 1
		j while
	end_while:
	
	li $t1, 0
	sb $t1, ($t0)
.end_macro

.macro read_string (%store)
	print(in)
	move $a0, %store
	la $a1, 32
	li $v0, 8
	syscall
	
	change_last_char (%store)
.end_macro 

.macro terminate ()
	li $v0, 10
	syscall
.end_macro

.macro print_string (%store)
	print(out)
	move $t0, %store
	while:
		lb $t1, ($t0)
		beqz $t1, end_while
		print_char($t1)
		addi $t0, $t0, 1
		j while
	end_while:
.end_macro

.macro print_char (%char)
	li $v0, 11
	move $a0, %char
	syscall
.end_macro

.macro println()
      	la $a0, newLine                  
      	li $v0, 4
      	syscall
.end_macro

.macro print (%string)
      	la $a0, %string
      	li $v0, 4
      	syscall
.end_macro

.macro getStr () #output v0
	repeat:
	print(txt1)
	println()
	li $v0, 5
	syscall
	move $a1, $v0
	choose_str ($a1)
	beqz $v0, repeat
.end_macro

.macro choose_str (%id)
	
	li $t0, 1
	bne $t0, %id, no_1
		la $v0, str1
	no_1:
	addi $t0, $t0, 1
	
	bne $t0, %id, no_2
		la $v0, str2
	no_2:
	addi $t0, $t0, 1
	
	bne $t0, %id, no_3
		la $v0, str3
	no_3:
	addi $t0, $t0, 1
	
	bne $t0, %id, no_4
		la $v0, str4
	no_4:
	
	ble %id, $t0, no_5
		li $v0, 0
	no_5:

.end_macro

.macro init ()
	repeat:
	println()
	println()
	print(txt2)
	li $v0, 5
	syscall
	move $a1, $v0
	choose_op ($a1)
	j repeat
.end_macro


.macro choose_op (%id)

	li $t0, 1
	bne $t0, %id, no_1
		#op1
		getStr()
		move $a2, $v0
		read_string($a2)
		
	no_1:
	addi $t0, $t0, 1
	
	bne $t0, %id, no_2
		#op2
		getStr()
		move $a2, $v0
		print_string($a2)
		println()
	no_2:
	addi $t0, $t0, 1
	
	bne $t0, %id, no_3
		#op3
		getStr()
		move $a0, $v0
		jal strlen
		move $t0, $v0
		print(out)
		
		move $a0, $t0
		li $v0, 1
      		syscall
      		println()
	no_3:
	addi $t0, $t0, 1
	
	bne $t0, %id, no_4
		getStr()
		move $s0, $v0
		getStr()
		move $s1, $v0
		
		move $a0, $s0
		move $a1, $s1
		jal strcmp
		move $t0, $v0
		
		print(out)
		
		move $a0, $t0
		li $v0, 1
      		syscall
      		println()
	no_4:
	
	addi $t0, $t0, 1
	
	bne $t0, %id, no_5
		getStr()
		move $s0, $v0
		getStr()
		move $s1, $v0
		getStr()
		move $s2, $v0
		
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2		
		jal strcat
	no_5:
	
	addi $t0, $t0, 1
	
	bne $t0, %id, no_6
		getStr()
		move $s0, $v0
		getStr()
		move $s1, $v0
		
		move $a0, $s0
		move $a1, $s1
		jal strfind
		move $t0, $v0
		
		print(out)
		
		move $a0, $t0
		li $v0, 1
      		syscall
      		println()
	no_6:
	
	bnez %id, no_7
		terminate()
	no_7:
.end_macro

.data
	str1: .space 32
	str2: .space 32
	str3: .space 32
	str4: .space 32
	in: .asciiz "input: "
	out: .asciiz "output: "
	newLine: .asciiz "\n"
	txt1: .asciiz "Wybierz magazyn 1-4: "
	txt2: .asciiz "Wybierz operacje 0-6:\n0-Koniec\n1-Wczytaj napis\n2-Wyswietl napis\n3-Wykonaj strlen\n4-Wykonaj strcmp\n5-Wykonaj strcat\n6-Wykonaj strfind\n"

.text
	main:
		init()
	
	strlen:
		move $t0, $a0
		li $v0, 0
		while:
			lb $t1, ($t0)
			beqz $t1, end_while
			addi $v0, $v0, 1
			addi $t0, $t0, 1
			j while
		end_while:
		jr $ra
	
	strcmp:
		move $s0, $a0 #save arg1
		move $s1, $a1 #save arg2
		move $s7, $ra #save CB
		
		move $a0, $s0 
		jal strlen
		move $s2, $v0 
		
		move $a0, $s1 
		jal strlen
		move $s3, $v0 
		
		sub $s2, $s2, $s3
		li $v0, 0
		bnez $s2, no_zero
			while_no_zero:
				lb $t1, ($s0)
				lb $t2, ($s1)
				beqz $t1, end_while_no_zero

				sub $t1, $t1, $t2
				
				beqz $t1, no_inner_zero
					bltz $t1, no_inner_less
						li $v0, 1
						jr $s7
					no_inner_less:
					bgez $t1, no_inner_greater
						li $v0, -1
						jr $s7
					no_inner_greater:
				no_inner_zero:
				addi $s0, $s0, 1
				addi $s1, $s1, 1
				j while_no_zero
			end_while_no_zero:
		no_zero:
		beqz $s2, final_no_zero
		bltz $s2, no_less
			li $v0, 1
		no_less:
		
		bgez $s2, no_greater
			li $v0, -1
		no_greater:
		final_no_zero:
		jr $s7

	strcat:
		move $s0, $a0 #save dest
		move $s1, $a1 #save arg1
		move $s2, $a2 #save arg1

		while_a1:
			lb $t0, ($s1)
			beqz $t0, end_while_a1
			sb $t0, ($s0)
			addi $s0, $s0, 1
			addi $s1, $s1, 1
			j while_a1
		end_while_a1:
		
		
		while_a2:
			lb $t0, ($s2)
			beqz $t0, end_while_a2
			sb $t0, ($s0)
			addi $s0, $s0, 1
			addi $s2, $s2, 1
			j while_a2
		end_while_a2:
		jr $ra
	
	strfind:
		move $s0, $a0 #save arg1
		move $s1, $a1 #save arg2
		li $v0, -1
		li $t7, 0
		while_find:
			lb $t0, ($s0)
			beqz $t0, end_while_find
			
			move $s2, $s1
			move $s3, $s0
			while_inner_find:
				lb $t0, ($s2)
				beqz $t0, end_while_inner_find
				lb $t1, ($s3)
				beqz $t1, not_equal
				bne $t0, $t1, not_equal
				addi $s2, $s2, 1
				addi $s3, $s3, 1
				j while_inner_find
			end_while_inner_find:
				move $v0, $t7
				jr $ra
			not_equal:
			addi $s0, $s0, 1
			addi $t7, $t7, 1
			j while_find
		end_while_find:
		jr $ra