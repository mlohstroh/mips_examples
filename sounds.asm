#This file just demos how to make sounds with mips

#reference down at bottom: http://courses.missouristate.edu/kenvollmar/mars/help/syscallhelp.html

main:
	li $v0, 33 #synchronous playback
	li $a0, 86 #half of max pitch
	li $a1, 2000 #2 seconds
	li $a2, 24 #guitar
	li $a3, 86 #half volume
	syscall
	
	li $v0, 10
	syscall
	

