.text
.globl main

main:
	li	$v0, 6
	syscall
	mov.s 	$f12, $f0
	
	li	$v0 4
	la	$a0 msg
	syscall
	
	li	$v0, 2
	syscall
	
	li	$v0, 10
	syscall
	.data 	

msg: .asciiz "Ale super napisales liczbe! "