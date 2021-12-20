
#David Hernandez
#Date: 12/20/2021
#"Get your Name - With a Twist!"

.data

youEntered: .asciiz "Enter your name: "
post_prompt: .asciiz "\nYou entered the following:\n"
replaced_prompt: .asciiz "\nName starting from last initial, replaced by a lower case:\n"
name: .space 50 #will store the full name obtained from the user
newname: .space 50 #will store the last name only
nline: .byte '\n' #null character
aSpace: .byte ' '


.text 
.main:

	##Print "Enter Your Name"
	add $v0, $zero, 4 # add 4 to register to print a string
	la $a0, youEntered #load the address of the asciiz name_prompt for printing
	syscall
	
	#Code to read user input and to save the input to a register
	add $v0, $zero, 8 # load 8 to register to READ a string
	la $a0, name #load the address of name to register for printing
	la $t0, name #load the address of the name unto register $t0 to access bytes
	li $a1, 50 #load desired number of char to read in
	syscall
	
	#Print "You entered the following:"
	add $v0, $zero, 4 # load 4 to print a string
	la $a0, post_prompt #load the address of post_prompt to print
	syscall
	
	#Print the 'name' that was inputed
	add $v0, $zero, 4 # load 4 to print a string
	la $a0, name # load the address of name to print
	syscall
	
	#prints a new line after displaying the 'name' that was inputed
	add $v0, $zero, 4 # print new space
	la $a0, nline #loads the address of the byte nline
	syscall
	
	#Prints "Name starting from last initial, replaced by a lower case:"
	add $v0, $zero, 4 # load 4 to the register to print a string
	la $a0, replaced_prompt # load the address of replaced_prompt ro register to print 
	syscall
	
	##END FOR PROMPTS
	
	##LOAD CHARACTERS TO COMPARE
	
	#Loads the 'space' character to the register for comparing
	la $t2, aSpace #load the address of the byte aSpace to $t2
	lb $t2, 0($t2) #loads the first byte of address at $t2, and store in $t2 ($t2 = ' ')
	##DO NOT REASSIGN THIS REGISTER
	
	#loads the '\n' character for comparing
	la $t3, nline #load the address of the byte nline
	lb $t3, 0($t3)#loads the first byte store at $t3 on to $t3 ($t3 = '\n')
	##DO NOT REASSIGN THIS REGISTER
	
	##END LOADINGS CHARACTERS TO COMPARE
	
	
	#loads the first byte to the register $t1
	lb $t1, 0($t0) # load the first byte in the address of 'name' to register $t1, to begin loop
	#this is the first letter in the inputed name

	
#Finds if the current byte is equal to a space
find_space:

	
	#IF the current byte is a new character line, branch to END to end program
	beq $t1, $t3, END
	
	#else, incremenet the address by one 
	la $t0, 1($t0)
	#reload the first word of the current, now incremented address
	lb $t1, 0($t0)
	
	#If the currrent byte is a space, see if the next byte is capital letter
	beq $t1, $t2, check_capital
	
	
	
	#loop back to beginning of this loop
	j find_space

#If the current byte is a space, then check to see if the letter one byte over is a capital letter	
check_capital:
	
	#load the byte of the current address + 1
	lb $s3, 1($t0)
	
	##if the byte after the space, is a space, loop back to find_space
	beq $s3, $t2, find_space
	
	#check if the byte in $s3, is less than 91 (a capital letter in ascii)
	slti $s1, $s3, 91 
	
	#if the byte IS a capital, branch to save the address
	beq $s1, 1, save_address
	
	#ELSE, if none of the above conditions are met
	#incremenet the address by one 
	la $t0, 1($t0)
	#reload the first word of the current, now incremented address
	lb $t1, 0($t0)
	
	#loop back to the beginning of this loop
	j find_space

#The address that is one byte over from the address of were the space is locatesd is saved to $t4
#and the first letter is added 32 to its lower case equivalent in ascii 
save_address:
	
	#loadd address + 1 of the current address to the register $t4
	la $t4, 1($t0)

	#load the first byte of the now stripped last name
	lb $t1, 0($t4)
	#change from upper case to lower case
	add $t1, $t1, 32
	
	#load the address of newname to register
	la $s0, newname
	#store byte (now lowercase first letter) into the register containing the address of newname
	sb $t1, 0($s0)

##loop for storing all the characters of the now stripped lastname to the address of newname	
storeNewName:
	
	#load the address of the stripped last name plus one byte over
	la $t4, 1($t4)
	#load the first byte of the incremented address to $t1
	lb $t1, 0($t4)
	
	#if the byte at $t1 is equal to a newline character, program branches to end
	beq $t1, $t3, END
	
	#ELSE, continue incrementing the address of newname to store each letter
	#of the now stripped last name into the register containing the address of newname
	
	#loads the address stored at $s0 (newname) plus 1 byte
	la $s0, 1($s0)
	#stores the byte in $t1 to the space in the now incremented address of newname
	sb $t1, 0($s0)
	
	##loop back around until all the bytes in the address containing the stripped address
	##are stored into the register containing the address of storeNewName
	j storeNewName
	
	
END:

	#add 4 to the register for printing of a string
	add $v0, $zero, 4
	la $a0, newname #load the address of newname to register for printing
	syscall
	
	#end program gracefully
	add $v0, $zero, 10
	syscall
	


