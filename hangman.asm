.text
# Main program starts here
main:
	jal loadWords
	jal prepForCount
	jal countWords
	
gameSetup:
	jal chooseRandomWord
	jal printChosenWord
	jal gameLoop
	
gameLoop:
	li $v0, 10
	syscall	
	
	
printChosenWord:
	li $v0, 4
	la $a0, chosenWord
	syscall

	jr $ra
	
chooseRandomWord:
	#choose a random index
	li $v0, 42
	move $a1, $s0 #max number
	syscall
	move $t0, $a0
	
	la $t1, storedWords
	la $t2, chosenWord
	
	# http://www.cs.sbu.edu/dlevine/PreviousCourses/Fall%202003/CS231Fall2003/Labs/Lab2/Lab2Hint.htm
	add $t0, $t0, $t0
	add $t0, $t0, $t0
	add $t0, $t0, $t1
	la $t3, ($t0)
	lw $t4, ($t3) #a pointer to a pointer?
	sw $t4, ($t2)

	jr $ra

promptUser:
	li $v0, 4
	la $a0, greeting
	syscall
	jr $ra

prepForCount:
	la $a0, buffer
	la $a1, storedWords
	sw $a0, ($a1)
	li $s0, 1
	add $a1, $a1, 4
	jr $ra

#sets $s0 as the number of words in file
countWords:
	lb $t0, ($a0)
	beq $t0, 0, finishCounting
	bne $t0, 10, skipped
	add $s0, $s0, 1 #increment counter
	add $a0, $a0, 1
	sw $a0, ($a1)
	add $a1, $a1, 4
	j countWords
	
# https://github.com/mlohstroh/Word-Hazard/blob/master/Word%20Hazard%20FINAL/importing.asm#L58
skipped:	#TODO: Figure out how why this even works
	add $a0, $a0, 1	
	j countWords

finishCounting:
	jal gameSetup
	
loadWords:
	li $v0, 13 #open file syscall
	la $a0, wordsFile
	li $a1, 0
	li $a2, 0
	syscall	#syscall to load file
	move $s6, $v0 #file descriptor
	
	li 	$v0, 14
	move 	$a0, $s6
	la 	$a1, buffer #address for loaded words
	li, 	$a2, 100000 #buffer size
	syscall
	
	li $v0, 16 #close file
	move $a0, $s6
	syscall
	
	jr $ra #just return

.data
greeting:
  .asciiz "Welcome to Hangman. You must guess the word that was randomly selected from a dictionary"
#Strings
wordsFile:
	.asciiz "words"


#Addresses to hold info
buffer: 
	.space 100000
storedWords:
	.align 2
	.space 1000000 #totally unsure about the size for these...
chosenWord:
	.space 100
