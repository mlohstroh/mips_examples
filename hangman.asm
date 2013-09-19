.data

#Strings
wordsFile:
	.asciiz "hangman_words/words.txt"

#Addresses to hold info
loadedWords: 
	.space 1000

main:
	j loadWords
	
promptUser:
	
	
loadWords:
	li $v0, 13 #open file syscall
	la $a0, wordsFile
	li $a1, 0
	li $a2, 0
	syscall	#syscall to load file
	
	move $s0, $v0 #file descriptor
	li $v0, 14
	
	
	j promptUser