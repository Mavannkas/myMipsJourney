.macro shift_left(%bits) 
	lw $t8, out_f
	sll $t8,$t8, %bits
	sw $t8, out_f
.end_macro
.data
	output_msg: .asciiz "Twoj wynik to: "
	in_i: .word 1
	out_f: .word 0
.text
	main:
		lw $s0, in_i
		beqz $s0, finish # je?li zero to wyj?tek
		bgt $s0, $zero, gt #jak mniejsze od 0 to dodaj 1 do wyniku i zaneguj liczb?
		
		#Dodawanie do wyniku
		addi $t1, $zero, 1
		sw $t1, out_f

		neg $s0, $s0
		
		gt:
		addi $s1, $zero, 127	# Cecha
		addi $s2, $zero, 0	# Mantysa
		
		loop:
			ble $s0, 1, end_loop 
			
			#Dodawanie do cechy
			addi $s1, $s1, 1
			
			#sprawdzanie parzysto?ci
			andi $t1, $s0, 1
			
			srl $s0, $s0, 1
			srl $s2, $s2, 1
			
			#warunkowe zwi?kszanie mantysy
			beqz $t1, not_zero_2
			ori $s2, $s2, 4194304 # 1 + 22 zera binarnie	
			not_zero_2:
			j loop
		end_loop:	
			
		#Dodanie na zwolnione miejsce cechy
		shift_left (8)
		lw $t0, out_f
		or $t0, $t0, $s1
		sw $t0, out_f
		
		#Dodanie na zwolnione miejsce mantysy
		shift_left (23)
		lw $t0, out_f
		or $t0, $t0, $s2
		sw $t0, out_f
		
		#wypisywanie wyniku + rzutowanie
		finish:
		li $v0, 4
		la $a0, output_msg
		syscall

		li $v0, 2
		lw $t0, out_f
		mtc1 $t0, $f12
		syscall 
	
		
	#EXIT	
	li $v0, 10
	syscall

