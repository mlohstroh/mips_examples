main: 
	li $v0, 5
	syscall
	move $t0, $v0
	
	li $v0, 5
	syscall
	move $t1, $v0
	
	bgt $t0, $t1, t0_bigger
	move $a0, $t1
	b endif
t0_bigger: 
	move $a0, $t0
endif:
	li $v0, 1
	syscall 
	
	li $v0, 10
	syscall
	
	