	
.data
	lolo: .asciiz "Ala ma kota"

.text
	main:
		la $s0, lolo
		addi $s0, $s0, 2
		print_word ($s0)
		li $v0, 10
		syscall
		
