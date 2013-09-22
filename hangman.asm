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
	la $s0, ($t0) #load into $s0 the address of the chosen word 
	move $a0, $s0


	j getWordFromAddress

	jr $ra

getWordFromAddress: 	#expects base address to be in $a0
	li $s1, 0 #current position in word
	la $s2, chosenWord
	
readWord: #1 byte at a time
	add $t1, $a0, $s1 #$t1 isoffset in buffer for word list
	add $t4, $s2, $s1 #$t4 is offset in buffer for chosen word
	lb $t3, ($t1) #copy byte located at $t1 to $t3
	sb $t3, ($t4) #store byte at t3 in address stored in t4
	#lb $t3, ($t1) 
	#sb $t3, ($t4)
	beq $t3, 10, endReadWord #end if we reach a newline character
	addi $s1, $s1, 1 #go to next byte
	
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
	lb $t0, ($a0)
	sb $t0, ($a1)
	li $s0, 1
	li $s2, 0 #current character count
	#add $a1, $a1, 1

#sets $s0 as the number of words in file
countWords:
	add $a0, $a0, 1 #increment byte position
	add $a1, $a1, 1 #increment byte position
	lb $t0, ($a0) #ao is the start of my word list
	add $s2, $s2, 1
	lb $t0, ($a0)
	sb $t0, ($a1)
	beq $t0, 10, incrementWordCount
	beq $s2, $s7, finishCounting
	#add $s0, $s0, 1 #increment word counter
	#sb $a0, ($a1)
	#lb $t0, ($a0)
	#sb $t0, ($a1)
	j countWords
	
incrementWordCount:
	add $s0, $s0, 1
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
	li, 	$a2, 1000 #buffer size
	syscall
	
	move $s7, $v0 #number of bytes read
	
	li $v0, 16 #close file
	move $a0, $s6
	syscall
	
	jr $ra #just return

.data
greeting:
  .asciiz "Welcome to Hangman. You must guess the word that was randomly selected from a dictionary\n"
#Strings
wordsFile:
	.asciiz "words"


#Addresses to hold info
buffer: 
	.align 2
	.space 1000
wordAddresses:
	.align 2
	.space 1000 #1000 bytes 
chosenWord:
	.space 100
