.data
	input1Message: .asciiz "Liczba a="
	input2Message: .asciiz "\nLiczba b="
	selectOptionMessage: .asciiz "\nWybierz co chcesz zrobic:\n1-dodawanie\n2-odejmowanie\n3-mnozenie\n4-dzielenie\n"
	isExitMessage: .asciiz "\nZakonczyc? 0/1\n"
	outputMessage: .asciiz "Wynik to: "
	
.text
	main:
		jal selectOption
		jal getInputData
		jal calculateOutput
		jal printResult
		
		jal getCloseData
		
		beqz $t0, main
		bnez $t0, exit

	selectOption: #Result $t0
		move $s7, $ra
		la $a0, selectOptionMessage
		jal printMessage
		jal getInput
		move $t0, $t3
		
		jr $s7
	
	getInputData: #Result $t1, $t2
		move $s7, $ra
		
		la $a0, input1Message
		jal printMessage
		jal getInput
		move $t1, $t3
		
		la $a0, input2Message
		jal printMessage
		jal getInput
		move $t2, $t3
		
		jr $s7
		
	calculateOutput: #Result $t4
		move $s7, $ra
		
		beq $t0, 1, addNumbers
		beq $t0, 2, substractNumbers
		beq $t0, 3, multiplicateNumbers
		beq $t0, 4, divideNumbers

		jr $s7
	
	printResult:#Get t4
		move $s7, $ra
		
		la $a0, outputMessage
		jal printMessage
		
		li $v0, 1
		move $a0, $t4
		syscall

		jr $s7
	
	getCloseData: #Result t0
		move $s7, $ra
		
		la $a0, isExitMessage
		jal printMessage
		jal getInput
		move $t0, $t3
		
		jr $s7
		
	#Calculations
	addNumbers: 
		add $t4, $t1, $t2
		jr $ra
		
	substractNumbers: 
		sub $t4, $t1, $t2
		jr $ra
	
	multiplicateNumbers:
		mul $t4, $t1, $t2
		jr $ra
	
	divideNumbers:
		div $t4, $t1, $t2
		jr $ra
	
	getInput: #result $t3
		li $v0, 5
		syscall
		move $t3, $v0
		jr $ra
		
	printMessage: # Get $a0
		li $v0, 4
		syscall
		jr $ra
	
	exit: 
		li $v0, 10
		syscall