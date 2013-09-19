.data

file: .asciiz "words.txt"

buffer: .space 1024

.text
main: 

	li $v0, 13
	la $a0, file
	li $a1, 0
	li $a2, 0
	syscall
	move $s6, $v0
	
	li $v0, 14
	move $a0, $s6
	la $a1, buffer
	li $a2, 1024
	syscall
	
	move $t0, $v0
	
	li $v0, 16
	move $a0, $s6
	syscall
	
	li $v0, 1
	move $a0, $t0
	syscall
	
	li $v0, 10
	syscall
	
	
