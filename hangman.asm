.data

#Strings
wordsFile:
	.asciiz "hangman_words/words.txt"
greeting:
	.asciiz "Welcome to Hangman. You must guess the word that was randomly selected from a dictionary"
winMessage:
	.asciiz "You won!"
loseMessage:
	.asciiz "You lost!"


#Addresses to hold info
loadedWords: 
	.space 1000
storedWords
	.space 1000 #totally unsure about the size for these...
chosenWord:
	.space 10

.text
# Main program starts here
main:
	jal loadWords
	jal prepForCount
	jal countWords
	
	jal promptUser
	
	li $v0, 10
	syscall
	
promptUser:
	li $v0, 4
	la $a0, greeting
	syscall
	jr $ra

prepForCount:
	la $a0, loadedWords	
	la $a1, storedWords
	sw $a0, ($a1)
	li $v0, 1
	add $a1, $a1, 4
	jr $ra

#sets $s0 as the number of words in file
countWords:
	lb $t0, ($a0)
	beq $t0, 0, finishCounting
	add $v0, $v0, 1 #increment counter
	add $a0, $a0, 1
	sw $a0, ($a1)
	add $a1, $a1, 4
	j countWords
	
finishCounting:
	li, $v0, 1
	move $a0, $s0
	syscall

	
loadWords:
	li $v0, 13 #open file syscall
	la $a0, wordsFile
	li $a1, 0
	li $a2, 0
	syscall	#syscall to load file
	
	move $s0, $v0 #file descriptor
	li $v0, 14
	move $a0, $s0
	la $a1, loadedWords #address for loaded words
	li, $a2, 1000 #buffer size
	syscall
	
	li $v0, 16 #close file
	move $a0, $s0
	syscall
	
	jr $ra #just return
