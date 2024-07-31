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
GAME_WIDTH:
	.word 320
GAME_HEIGHT:
	.word 640

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
currentTetromino:
	.word	1	# 0 - O, 1 - I, 2 - S, 3 - Z, 4 - L, 5 - J, 6 - T
tetrominoRotation:
	.word	0
tetrominoInPlay:
	.word	0

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
	lw $t8, tetrominoRotation
    	la $t3, blockPositions
    	
    	beq $t8, 0, Deg0O
    	beq $t8, 1, Deg90O
    	beq $t8, 2, Deg180O
    	beq $t8, 3, Deg270O
    	
Deg0O:
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
Deg90O:
    	# Top left block
    	addi $t6, $t6, 16
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
Deg180O:
    	# Top left block
    	addi $t6, $t6, 16
    	addi $t7, $t7, 1024
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
Deg270O:
    	# Top left block
    	addi $t7, $t7, 1024
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
	lw $t8, tetrominoRotation
    	la $t3, blockPositions
    	
    	beq $t8, 0, Deg0I
    	beq $t8, 1, Deg90I
    	beq $t8, 2, Deg180I
    	beq $t8, 3, Deg270I
    	
Deg0I:
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
Deg90I:
    	# Top block
    	addi $t6, $t6, -16
    	addi $t7, $t7, 2048
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Top second block
    	addi $t6, $t6, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top third block
    	addi $t6, $t6, 16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Bottom block
    	addi $t6, $t6, 16
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
    	j tetrominoLoop
Deg180I:
    	# Top block
    	addi $t7, $t7, 1024
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
Deg270I:
    	# Top block
    	addi $t6, $t6, -32
    	addi $t7, $t7, 2048
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Top second block
    	addi $t6, $t6, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top third block
    	addi $t6, $t6, 16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Bottom block
    	addi $t6, $t6, 16
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
	lw $t8, tetrominoRotation
    	la $t3, blockPositions
    	
    	beq $t8, 0, Deg0S
    	beq $t8, 1, Deg90S
    	beq $t8, 2, Deg180S
    	beq $t8, 3, Deg270S
    	
Deg0S:
    	# Bottom left block
    	addi $t6, $t6, 16
    	addi $t7, $t7, 1024
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t6, $t6, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t6, $t6, -32
    	addi $t7, $t7, 1024
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t6, $t6, 16
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg90S:
    	# Bottom left block
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t7, $t7, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t7, $t7, 16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t7, $t7, 1024
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg180S:
    	# Bottom left block
    	addi $t7, $t7, 16
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t7, $t7, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t7, $t7, -32
    	addi $t7, $t7, 1024
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t7, $t7, 16
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg270S:
    	# Bottom left block
    	addi $t7, $t7, 16
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t7, $t7, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t7, $t7, 16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t7, $t7, 1024
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
	lw $t8, tetrominoRotation
    	la $t3, blockPositions

    	beq $t8, 0, Deg0Z
    	beq $t8, 1, Deg90Z
    	beq $t8, 2, Deg180Z
    	beq $t8, 3, Deg270Z
    	
Deg0Z:	
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
Deg90Z:	
    	# Bottom left block
    	addi $t6, $t6, 32
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t7, $t7, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t7, $t7, -16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t7, $t7, 1024
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg180Z:	
    	# Bottom left block
    	addi $t7, $t7, 1024
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
Deg270Z:	
    	# Bottom left block
    	addi $t6, $t6, 16
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t6, $t6, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t7, $t7, -16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t7, $t7, 1024
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
	lw $t8, tetrominoRotation
    	la $t3, blockPositions
    	
    	beq $t8, 0, Deg0L
    	beq $t8, 1, Deg90L
    	beq $t8, 2, Deg180L
    	beq $t8, 3, Deg270L
    
Deg0L:	
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
    	addi $t6, $t6, 16
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg90L:	
    	# Bottom left block
    	addi $t7, $t7, 1024
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t6, $t6, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t6, $t6, 16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t6, $t6, -32
    	addi $t7, $t7, 1024
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg180L:	
    	# Bottom left block
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t7, $t7, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t7, $t7, 1024
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t7, $t7, 1024
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg270L:	
    	# Bottom left block
    	addi $t7, $t7, 32
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t7, $t7, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t7, $t7, -16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t7, $t7, -16
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
	lw $t8, tetrominoRotation
    	la $t3, blockPositions
    	
    	beq $t8, 0, Deg0J
    	beq $t8, 1, Deg90J
    	beq $t8, 2, Deg180J
    	beq $t8, 3, Deg270J
    	
Deg0J:
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
Deg90J:
    	# Bottom left block
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t7, $t7, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t7, $t7, 16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t6, $t6, 16
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg180J:
    	# Bottom left block
    	addi $t6, $t6, 16
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t7, $t7, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t7, $t7, 1024
    	addi $t7, $t7, -16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t6, $t6, 1024
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg270J:
    	# Bottom left block
    	addi $t7, $t7, 1024
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Bottom center block
    	addi $t6, $t6, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Top center block
    	addi $t6, $t6, 16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t7, $t7, 1024
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
	lw $t8, tetrominoRotation
    	la $t3, blockPositions
    	
    	beq $t8, 0, Deg0T
    	beq $t8, 1, Deg90T
    	beq $t8, 2, Deg180T
    	beq $t8, 3, Deg270T
    	
Deg0T:
    	# Top left block
    	addi $t7, $t7, 1024
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Top center block
    	addi $t6, $t6, 16
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Bottom center block
    	addi $t6, $t6, 16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t6, $t6, -16
    	addi $t7, $t7, 1024
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg90T:
    	# Top left block
    	addi $t7, $t7, 16
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Top center block
    	addi $t7, $t7, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Bottom center block
    	addi $t7, $t7, -16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t7, $t7, 16
    	addi $t7, $t7, 1024
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg180T:
    	# Top left block
    	addi $t6, $t6, 16
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Top center block
    	addi $t7, $t7, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Bottom center block
    	addi $t6, $t6, 16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t6, $t6, -32
    	sw $t6, 24($t3)
    	sw $t7, 28($t3)
	j tetrominoLoop
Deg270T:
    	# Top left block
    	addi $t6, $t6, 16
    	sw $t6, 0($t3)
    	sw $t7, 4($t3)
    	# Top center block
    	addi $t6, $t6, 1024
    	sw $t6, 8($t3)
    	sw $t7, 12($t3)
    	# Bottom center block
    	addi $t6, $t6, 16
    	sw $t6, 16($t3)
    	sw $t7, 20($t3)
    	# Top right block
    	addi $t6, $t6, -16
    	addi $t7, $t7, 1024
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
	j tetrominoOut



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



drawTetromino:
    	beq $a0, 0, drawO
    	beq $a0, 1, drawI
    	beq $a0, 2, drawS
    	beq $a0, 3, drawZ
    	beq $a0, 4, drawL
    	beq $a0, 5, drawJ
    	beq $a0, 6, drawT
tetrominoOut:
    	jr $ra



checkKeyPress:
	lw $t9, ADDR_KBRD
	lw $t8, 0($t9)
	beq $t8, 1, keypressOccurred
	jr $ra
	
keypressOccurred:
	lw $t2, 4($t9)
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	beq $t2, 0x77, wPress 
	beq $t2, 0x61, aPress
	beq $t2, 0x73, sPress
	beq $t2, 0x64, dPress
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra

wPress:
	jal rotateTetromino
    	jal refreshGameDisplay
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra
aPress:
	jal detectSideCollision
	beq $v0, 0, postMove
	lw $t3, blockXOffset
	addi $t3, $t3, -16
	sw $t3, blockXOffset
    	jal refreshGameDisplay
	j postMove
sPress:
	jal detectBottomColliison
	beq $v0, 2, postMove
	lw $t3, blockYOffset
	addi $t3, $t3, 1024
	sw $t3, blockYOffset
    	jal refreshGameDisplay
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra
dPress:
	jal detectSideCollision
	beq $v0, 1, postMove
	lw $t3, blockXOffset
	addi $t3, $t3, 16
	sw $t3, blockXOffset
    	jal refreshGameDisplay
    	j postMove
postMove:
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra



refreshGameDisplay:
	li $s1, 0
	li $s2, 0
	li $t4, 0
    	sw $s1, blockPrimaryColor
    	sw $s2, blockSecondaryColor
    	la $t3, blockPositions
	j tetrominoLoop
	
  
  
detectSideCollision:
	li $s1, 0x1000A430
	li $s2, 0x1000A4CC
whileSideCheck:
	# POSSIBLE BUG: CHECKS LEFT BEFORE RIGHT CAN COLLIDE ON THE BOTTOM RIGHT (TEST THIS)
	beq $s1, 0x1000F030, wallsClear
	# beq $t2, 0x1000F0CC, rightClear
	lw $s3, 0($s1)
	lw $s4, 0($s2)
	bne $s3, 0, touchingLeftWall
	bne $s4, 0, touchingRightWall
	addi $s1, $s1, 1024
	addi $s2, $s2, 1024
	j whileSideCheck
wallsClear:
	li $v0, -1
	jr $ra
touchingLeftWall:
	li $v0, 0
	jr $ra
touchingRightWall:
	li $v0, 1
	jr $ra



detectBottomColliison:
	la $s1, blockPositions
	lw $s2, 24($s1)
	lw $s3, 28($s1)
	
	add $s3, $s2, $s3
	add $s3, $t0, $s3
	addi $s3, $s3, 1024
	
	lw $s4, 0($s3)
	bne $s4, 0, touchingBottom
	lw $s4, 4($s3)
	bne $s4, 0, touchingBottom
	lw $s4, 8($s3)
	bne $s4, 0, touchingBottom
	lw $s4, 12($s3)
	bne $s4, 0, touchingBottom
	
bottomClear:
	li $v0, -1
	jr $ra
touchingBottom:
	li $a1, 7
    	li $v0, 42
    	syscall
    	li $t3, 48
    	li $t4, 9216
	sw $t3, blockXOffset
	sw $t4, blockYOffset
	li $s3, 0
	sw $s3, tetrominoInPlay
	li $v0, 2
	jr $ra
	
	
	
rotateTetromino:
	lw $s1, currentTetromino
	lw $s2, tetrominoRotation
	beq $s2, 3, resetRotation
	addi $s2, $s2, 1
	sw $s2, tetrominoRotation
	jr $ra
resetRotation:
	li $s2, 0
	sw $s2, tetrominoRotation
	jr $ra


	
main:
    	# Initialize the game

   	# 0x1000FFFC is the bottom right pixel
   
    	lw $t0, ADDR_DSPL       # $t0 = base address for display
    	jal drawBackground


game_loop:
	# 1a. Check if key has been pressed
    	# 1b. Check which key has been pressed
    	# 2a. Check for collisions
	# 2b. Update locations (paddle, ball)
	# 3. Draw the screen
	# 4. Sleep

    	#5. Go back to 1
    	
    	jal checkKeyPress
    	jal drawTetromino
    	
	b game_loop
