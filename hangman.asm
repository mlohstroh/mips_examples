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
	#add $t0, $s0, -1 #looking for indices here, so subtract 1
	move $a1, $s0 #max number must be less than number of words
	syscall
	
	move $t0, $a0 #t0 has random index in it
	
	la $t1, wordAddresses
	
	li $s5, 0 #s5 is the number of bytes to the word; initialize it to 0
	addi $a0, $t0, -1 #-1 to get index
	#sw $ra, ($t7) #save return address for later
	move $t7, $ra #save return address for later
	bgezal $t0, getAddressOffset #if index is >= 0 getAddressOffset
	move $ra, $t7 #return return address to its original state
	add $t0, $t1, $s5	#add the base address plus the index
	la $s0, ($t0) #load into $s0 the address of the chosen word 
	move $a0, $s0
	
	j getWordFromAddress
	#jr $ra #go back to the return address saved earlier (this statement is never reached)

getAddressOffset:#expects a0 to be current index to add (a0 = currIndex)
	move $t3, $a0 #t3 has index to add
	mul $t3, $t3, 4 #t3 now has byte offset
	la $t4, wordSizes
	add $t4, $t4, $t3 # add offset and memory of wordSizes[]
	lw $t8, ($t4) #currentWordSize = wordSizes[currIndex]
	add $s5, $s5, $t8 #offset += currentWordSize
	addi $a0, $a0, -1 #currIndex --
	bgez $a0, getAddressOffset #if index is still 0 or above, keep adding word sizes
	jr $ra		#get back to chooseRandomWord

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
	li $s0, 1 #number of words
	li $s2, 0 #current character count
	li $s3, 1 #current word size
	#add $a1, $a1, 1

#sets $s0 as the number of words in file
countWords:
	add $a0, $a0, 1 #increment byte position
	add $a1, $a1, 1 #increment byte position
	#lb $t0, ($a0) #ao is the start of my word list
	add $s2, $s2, 1
	add $s3, $s3, 1
	lb $t0, ($a0)
	sb $t0, ($a1)
	beq $t0, 10, incrementWordCount #increment word count when newline is encountered
	beq $s2, $s7, finishCounting
	#add $s0, $s0, 1 #increment word counter
	#sb $a0, ($a1)
	#lb $t0, ($a0)
	#sb $t0, ($a1)
	j countWords
	
incrementWordCount:
	addi $t5, $s0, -1 #decrement the current word count to get the current index in t5
	mul $t4, $s0, 4 #store in t4 the offset for the current word (4bytes / int)
	la $t6, wordSizes
	add $t4, $t4, $t6 #add offset to address of wordSizes[ ] and store wordSizes[currentWord - 1]' address in t4
	sw $s3, ($t4) #wordSizes[currentWord - 1] = currentWordSize;
	li $s3, 0 #currentWordSize = 0; 
	add $s0, $s0, 1 #currentWord++;
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
wordSizes:
	.align 2
	.space 4000
chosenWord:
	.space 100
