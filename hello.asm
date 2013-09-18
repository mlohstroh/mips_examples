	.data 
prompt: .asciiz "Please Enter An Integer:"
display: .asciiz "Your number is: "

	.text
	
main: 
	li $v0, 4
	la $a0, prompt
	syscall 
	
	li $v0, 5
	syscall
	add $t0, $v0, $zero #input integer is stored in t1
	 
	la $a0, display
	li $v0, 4
	syscall
	
	add $a0, $t0, $zero
	li $v0, 1
	syscall
	
	
