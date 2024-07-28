#####################################################################
# CSCB58 Summer 2024 Assembly Final Project - UTSC
# Student1: Mohamed Ibrahim, 1010216491, ibrah798, mohamedhassen.ibrahim@mail.utoronto.ca

#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed) 
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 1024 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4/5 (choose the one the applies)
#
# Which approved features have been implemented?
# (See the assignment handout for the list of features)
# Easy Features:
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# ... (add more if necessary)
# Hard Features:
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# ... (add more if necessary)
# How to play:
# (Include any instructions)
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

##############################################################################

    .data
##############################################################################
# Immutable Data
##############################################################################
# The address of the bitmap display. Don't forget to connect it!
ADDR_DSPL:
    .word 0x10008000
# The address of the keyboard. Don't forget to connect it!
ADDR_KBRD:
    .word 0xffff0000

##############################################################################
# Mutable Data
##############################################################################
blockLocationOffset:
	.space	4
blockPrimaryColor:
	.space	4
blockSecondaryColor:
	.space	4

##############################################################################
# Code
##############################################################################
.eqv	RED	0xff0000
.eqv	GREEN	0x00ff00
.eqv	BLUE	0x0000ff

	.text
	.globl main

	# Run the Tetris game.
drawblock:
	lw $s1, blockPrimaryColor
	lw $s2, blockSecondaryColor
	lw $s3, blockLocationOffset
	add $s4, $t0, $s3
	addi $s5, $s4, 512
	
loop:	
	bgt $s4, $s5, DONE
	sw $s1, 0($s4)
	sw $s1, 4($s4)
	sw $s1, 8($s4)
	sw $s2, 12($s4)
	addi $s4, $s4, 256
	j loop
	
DONE:	sw $s2, 0($s4)
	sw $s2, 4($s4)
	sw $s2, 8($s4)
	sw $s2, 12($s4)
	jr $ra
	
	
	
drawO:
	li $t1, 0xf9fe02
	li $t2, 0xebea5c
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
	li $t8, 0
	
OLoop:	bge $t8, 32,doneFunctionLoop
	jal drawblock
	addi $t8, $t8, 16
	sw $t8, blockLocationOffset 
	j OLoop

	

drawI:
	li $t1, 0x00e3fe
	li $t2, 0x2fc5d7
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
	li $t8, 0
lLoop:	bge $t8, 4096, doneFunctionLoop
	jal drawblock
	addi $t8, $t8, 1024
	sw $t8, blockLocationOffset 
	j lLoop
	
doneFunctionLoop:
	jr $ra
	
	
drawS:
drawZ:
drawL:
drawJ:
drawT:
	
main:
    	# Initialize the game

   	# 0x1000FFFC is the bottom right pixel
   
    	lw $t0, ADDR_DSPL       # $t0 = base address for display
    	
    	
    	jal drawO


game_loop:
	# 1a. Check if key has been pressed
    	# 1b. Check which key has been pressed
    	# 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    	#5. Go back to 1
	b game_loop
