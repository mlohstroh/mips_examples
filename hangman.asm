.text
# Main program starts here
main:
	jal loadWords
	jal prepForCount
	
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
	
	la $t1, wordAddresses
	mul $t5, $t0, 4
	add $t0, $t1, $t5	#add the base address plus the index
	lw $s0, ($t0)
	move $a0, $s0


	j getWordFromAddress

	jr $ra

getWordFromAddress: 	#expects base address to be in $a0
	li $s1, 0 #current position in word
	la $s2, chosenWord
	
readWord:
	add $t1, $a0, $s1 #offset in buffer
	add $t4, $s2, $s1
	lb $t3, ($t1) 
	beq $t3, 0, endReadWord #end if we reach a null terminator
	sb $t3, ($t4)
	j readWord
	
endReadWord:
	li $v1, 4
	la $a0, chosenWord
	syscall

	li $v1, 10
	syscall
			

promptUser:
	li $v0, 4
	la $a0, greeting
	syscall
	jr $ra

prepForCount:
	la $a0, buffer
	la $a1, wordAddresses
	sw $a0, ($a1)
	li $s0, 1
	li $s2, 0 #current character count
	add $a1, $a1, 4

#sets $s0 as the number of words in file
countWords:
	lb $t0, ($a0) #ao is the start of my word list
	add $s2, $s2, 1
	beq $s2, $s7, finishCounting
	bne $t0, 10, incrementWordCount
	add $s0, $s0, 1 #increment word counter
	add $a0, $a0, 1 #increment word position
	sw $a0, ($a1)
	add $a1, $a1, 4 #increment byte position
	j countWords
	
incrementWordCount:
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
	
	move $s7, $v0 #number of bytes read
	
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
	.align 2
	.space 100000
wordAddresses:
	.align 2
	.space 1000000 #totally unsure about the size for these...
chosenWord:
	.space 100
