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
blockXOffset:
	.word	48
blockYOffset:
	.word	9216
blockPrimaryColor:
	.word	0xff0000
blockSecondaryColor:
	.word	0xff0000
blockPositions:
	.space	32

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
	
	lw, $s7, 0($sp)
	lw, $s6, 4($sp)
	addi $sp, $sp 8
	
	add $s3, $s6, $s7
	add $s4, $t0, $s3
	addi $s5, $s4, 512
	
blockLoop:	
	bgt $s4, $s5, doneBlockLoop
	sw $s1, 0($s4)
	sw $s1, 4($s4)
	sw $s1, 8($s4)
	sw $s2, 12($s4)
	addi $s4, $s4, 256
	j blockLoop
	
doneBlockLoop:	
	sw $s2, 0($s4)
	sw $s2, 4($s4)
	sw $s2, 8($s4)
	sw $s2, 12($s4)
	jr $ra

	
	
drawO:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0xf9fe02
	li $t2, 0xebea5c
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
	lw $t6, blockXOffset
	lw $t7, blockYOffset
    	la $t3, blockPositions
    	
    	# Top left block
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	
    	# Top right block
    	addi $t6, $t6, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	
    	# Bottom right block
    	addi $t7, $t7, 1024
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	
    	# Bottom left block
    	addi $t6, $t6, -16
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
    	
    	j tetrominoLoop
    	
drawI:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0x00e3fe
	li $t2, 0x2fc5d7
	
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
	lw $t6, blockXOffset
	lw $t7, blockYOffset
    	la $t3, blockPositions
    	
    	# Top block
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	
    	# Top second block
    	addi $t7, $t7, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	
    	# Top third block
    	addi $t7, $t7, 1024
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	
    	# Bottom block
    	addi $t7, $t7, 1024
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	
	j tetrominoLoop
	
drawS:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0xf60100
	li $t2, 0xda0b0d
	
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
	lw $t6, blockXOffset
	lw $t7, blockYOffset
    	la $t3, blockPositions
    	
    	# Bottom left block
    	addi $t7, $t7, 1024
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	
    	# Bottom center block
    	addi $t6, $t6, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	
    	# Top center block
    	addi $t7, $t7, -1024
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	
    	# Top right block
    	addi $t6, $t6, 16
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	
	j tetrominoLoop

drawZ:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0x68b522
	li $t2, 0x5e9b3c
	
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
	lw $t6, blockXOffset
	lw $t7, blockYOffset
    	la $t3, blockPositions
    	
    	# Bottom left block
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	
    	# Bottom center block
    	addi $t6, $t6, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	
    	# Top center block
    	addi $t7, $t7, 1024
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	
    	# Top right block
    	addi $t6, $t6, 16
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	
	j tetrominoLoop


drawL:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0xfd8c01
	li $t2, 0xeb8f21
	
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
	lw $t6, blockXOffset
	lw $t7, blockYOffset
    	la $t3, blockPositions
    	
    	# Bottom left block
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	
    	# Bottom center block
    	addi $t7, $t7, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	
    	# Top center block
    	addi $t7, $t7, 1024
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	
    	# Top right block
    	addi $t6, $t6, 16
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	
	j tetrominoLoop

drawJ:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0xfd50ba
	li $t2, 0xd465a9
	
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
	lw $t6, blockXOffset
	lw $t7, blockYOffset
    	la $t3, blockPositions
    	
    	# Bottom left block
    	addi $t6, $t6, 16
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	
    	# Bottom center block
    	addi $t7, $t7, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	
    	# Top center block
    	addi $t7, $t7, 1024
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	
    	# Top right block
    	addi $t6, $t6, -16
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	
	j tetrominoLoop

drawT:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0x9c0193
	li $t2, 0x83107d
	
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
	lw $t6, blockXOffset
	lw $t7, blockYOffset
    	la $t3, blockPositions
    	
    	# Top left block
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	
    	# Top center block
    	addi $t6, $t6, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	
    	# Bottom center block
    	addi $t7, $t7, 1024
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	
    	# Top right block
    	addi $t6, $t6, 16
    	addi $t7, $t7, -1024
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	
	j tetrominoLoop


tetrominoLoop:	
	bge $t4, 4, doneTetrominoLoop
	lw $t6, 0($t3)
	lw $t7, 4($t3)
	addi, $t3, $t3, 8
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	addi $sp, $sp, -4
	sw $t7, 0($sp)
	addi $t4, $t4, 1
	jal drawblock
	j tetrominoLoop
	
doneTetrominoLoop:
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	jr $ra



drawBackground:
	li $t1, 0x1000A228
	li $t2, 0x1000F5D4
	li $t3, 0x303339
	
backgroundTopLoop:
	bge $t1, 0x1000A2D4, backgroundSideLoop
	sw $t3, 0($t1)
	sw $t3, 256($t1)
	sw $t3, 0($t2)
	sw $t3, -256($t2)
	addi $t1, $t1, 4
	addi $t2, $t2, -4
	j backgroundTopLoop 

backgroundSideLoop:
	bge $t1, 0x1000F5D8, doneBackgroundLoops
	sw $t3, 0($t1)
	sw $t3, -4($t1)
	sw $t3, 0($t2)
	sw $t3, 4($t2)
	addi $t1, $t1, 256
	addi $t2, $t2, -256
	j backgroundSideLoop

doneBackgroundLoops:
	jr $ra 




main:
    	# Initialize the game

   	# 0x1000FFFC is the bottom right pixel
   
    	lw $t0, ADDR_DSPL       # $t0 = base address for display

    	jal drawBackground
    	jal drawT


game_loop:
	# 1a. Check if key has been pressed
    	# 1b. Check which key has been pressed
    	# 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    	#5. Go back to 1
	b game_loop
