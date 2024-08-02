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
# - Milestone 4 (choose the one the applies)
#
# Which approved features have been implemented?
# (See the assignment handout for the list of features)
# Easy Features:
# 1. 1
# 2. 11
# ... (add more if necessary)
# Hard Features:
# 1. 2
# 2. 4
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
	.word	112
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
checkPossibleRotation:
	.word	0
rotationAttempted:
	.word	0
gravityCounter:
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

drawRefreshBlock:
	lw, $s7, 0($sp)
	lw, $s6, 4($sp)
	addi $sp, $sp 8
	add $s3, $s6, $s7
	add $s4, $t0, $s3
	addi $s5, $s4, 512
	
refreshBlockLoop:	
	bgt $s4, $s5, doneRefreshBlockLoop
	sw $zero, 0($s4)
	sw $zero, 4($s4)
	sw $zero, 8($s4)
	sw $zero, 12($s4)
	addi $s4, $s4, 256
	j refreshBlockLoop
doneRefreshBlockLoop:	
	sw $zero, 0($s4)
	sw $zero, 4($s4)
	sw $zero, 8($s4)
	sw $zero, 12($s4)
	jr $ra

	
	
	
	
drawO:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0xf9fe02
	li $t2, 0xebea5c
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
    	lw $t5, rotationAttempted	
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision	# Returns 1 if clear 0 if cannot rotate
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
    	j drawO
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision	# Returns 1 if clear 0 if cannot rotate
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
    	j drawO
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
    
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
    	j drawO
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
    	j drawO
    	
    	
drawI:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0x00e3fe
	li $t2, 0x2fc5d7
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
    	lw $t5, rotationAttempted	
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawI
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawI
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawI
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawI
	
	
drawS:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0xf60100
	li $t2, 0xda0b0d
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
	lw $t5, rotationAttempted	
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawS
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawS
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawS
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawS



drawZ:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0x68b522
	li $t2, 0x5e9b3c
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
	lw $t5, rotationAttempted	
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	addi, $sp, $sp, 4
	j drawZ
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawZ
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawZ
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawZ



drawL:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0xfd8c01
	li $t2, 0xeb8f21
	lw $t5, rotationAttempted	
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawL
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawL
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawL
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawL


drawJ:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0xfd50ba
	li $t2, 0xd465a9
	lw $t5, rotationAttempted	
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawJ
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawJ
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawJ
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawJ



drawT:
	addi, $sp, $sp, -4
	sw $ra, 0($sp)
	li $t1, 0x9c0193
	li $t2, 0x83107d
    	sw $t1, blockPrimaryColor
    	sw $t2, blockSecondaryColor
    	li $t4, 0
    	lw $t5, rotationAttempted	
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawT
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawT
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawT
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
    	
    	beq $t5, 0, tetrominoLoop
    	jal checkRotationCollision
    	beq $v1, 1, tetrominoLoop
	jal revertRotation
	lw $zero, rotationAttempted
	lw $ra, 0($sp)
	addi, $sp, $sp, 4
	j drawT
	
	
	
revertRotation:
	lw $s1, tetrominoRotation
	beq $s1, 0, revertRotationReset
	addi $s1, $s1, -1
	sw $s1, tetrominoRotation
	jr $ra
revertRotationReset:
	li $s1, 3
	sw $s1, tetrominoRotation
	jr $ra
	
	
tetrominoLoop:
	sw $zero, rotationAttempted
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
	
refreshTetrominoLoop:
	bge $t4, 4, doneRefreshTetrominoLoop
	lw $t6, 0($t3)
	lw $t7, 4($t3)
	addi, $t3, $t3, 8
	addi $sp, $sp, -4
	sw $t6, 0($sp)
	addi $sp, $sp, -4
	sw $t7, 0($sp)
	addi $t4, $t4, 1
	jal drawRefreshBlock
	j refreshTetrominoLoop
doneRefreshTetrominoLoop:
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
	sw $t3, 8($t1)
	
	sw $t3, -8($t2)
	sw $t3, 0($t2)
	sw $t3, 4($t2)
	addi $t1, $t1, 256
	addi $t2, $t2, -256
	j backgroundSideLoop
doneBackgroundLoops:
	jr $ra 



drawTetromino:
    	beq $a1, 0, drawO
    	beq $a1, 1, drawI
    	beq $a1, 2, drawS
    	beq $a1, 3, drawZ
    	beq $a1, 4, drawL
    	beq $a1, 5, drawJ
    	beq $a1, 6, drawT
tetrominoOut:
    	jr $ra


# ----- Key Press Detection + Execution -----
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
	li $t1, 1
	sw $t1, rotationAttempted
	jal rotateTetromino
    	jal refreshGameDisplay
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra
	
skipRevertRotation:
    	jal refreshGameDisplay
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra
aPress:
	jal detectLeftCollision
	beq $v1, 0, postMove
	lw $t3, blockXOffset
	addi $t3, $t3, -16
	sw $t3, blockXOffset
    	jal refreshGameDisplay
	j postMove
sPress:
	jal detectBottomColliison
	beq $v1, 2, postMove
	lw $t3, blockYOffset
	addi $t3, $t3, 1024
	sw $t3, blockYOffset
    	jal refreshGameDisplay
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra
dPress:
	jal detectRightCollision
	beq $v1, 1, postMove
	lw $t3, blockXOffset
	addi $t3, $t3, 16
	sw $t3, blockXOffset
    	jal refreshGameDisplay
    	j postMove
postMove:
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra
	
# ----- Rotation Logic -----
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

checkRotationCollision:
	# Check the next tetromino block array and ensure that the intended positions of every block is an unoccupied space
	la $s3, blockPositions
	li $s4, 0
checkRotationCollisionLoop:
	beq $s4, 4, clearRotation
	lw $s5, 0($s3)
	lw $s6, 4($s3)
	add $s6, $s6, $s5
	add $s6, $s6, $t0
	lw $s7, 0($s6)
	bne $s7, 0, failedRotation
	addi $s3, $s3, 8
	addi $s4, $s4, 1
	j checkRotationCollisionLoop
clearRotation:
	li $v1, 1
	jr $ra
failedRotation:
	li $v1, 0
	jr $ra
	
# ----- Screen Refresh -----
refreshGameDisplay:
	li $t4, 0
    	la $t3, blockPositions
	j refreshTetrominoLoop
  
# ----- Side Collision Detection -----

detectLeftCollision:
	li $s0, 0
	la $s1, blockPositions
	addi $s3, $s3, -16
touchingLeftLoop:
	beq $s0, 4, sidesClear
	lw $s5, blockPrimaryColor
	lw $s2, 0($s1)
	lw $s3, 4($s1)
	add $s3, $s2, $s3
	add $s3, $t0, $s3	# Store pixel location of top left of block in $s3
	addi $s3, $s3, -16	# Store pixel location of block left of top left of block in $s3
	lw $s4, 0($s3)
	lw $s5, blockPrimaryColor
	addi $s1, $s1, 8
	addi $s0, $s0, 1
	beq $s4, $s5, leftBlockCheck
	bne $s4, 0, touchingLeftWall
	j touchingLeftLoop
leftBlockCheck:	
	neg $s2, $t0
	add $s3, $s3, $s2	# Gets sum of x and y coordinates and stores in $s3
	la $s5, blockPositions
	li $s7, 0
leftBlockCheckLoop:
	beq $s7, 4, touchingLeftWall
	lw $s2, 0($s5)
	lw $s6, 4($s5)
	add $s6, $s6, $s2
	beq $s3, $s6, touchingLeftLoop
	addi $s5, $s5, 8
	addi $s7, $s7, 1
	j leftBlockCheckLoop
	
detectRightCollision:
	li $s0, 0
	la $s1, blockPositions
	addi $s3, $s3, -16
touchingRightLoop:
	beq $s0, 4, sidesClear
	lw $s5, blockPrimaryColor
	lw $s2, 0($s1)
	lw $s3, 4($s1)
	add $s3, $s2, $s3
	add $s3, $t0, $s3	# Store pixel location of top left of block in $s3
	addi $s3, $s3, 16	# Store pixel location of block right of top left of block in $s3
	lw $s4, 0($s3)
	lw $s5, blockPrimaryColor
	addi $s1, $s1, 8
	addi $s0, $s0, 1
	beq $s4, $s5, rightBlockCheck
	bne $s4, 0, touchingRightWall
	j touchingRightLoop
rightBlockCheck:	
	neg $s2, $t0
	add $s3, $s3, $s2	# Gets sum of x and y coordinates and stores in $s3
	la $s5, blockPositions
	li $s7, 0
rightBlockCheckLoop:
	beq $s7, 4, touchingRightWall
	lw $s2, 0($s5)
	lw $s6, 4($s5)
	add $s6, $s6, $s2
	beq $s3, $s6, touchingRightLoop
	addi $s5, $s5, 8
	addi $s7, $s7, 1
	j rightBlockCheckLoop
sidesClear:
	li $v1, -1
	jr $ra
touchingLeftWall:
	li $v1, 0
	jr $ra
touchingRightWall:
	li $v1, 1
	jr $ra


# ----- Bottom Collision Detection -----
detectBottomColliison:
	li $s0, 0
	la $s1, blockPositions
touchingBottomLoop:
	beq $s0, 4, bottomClear
	lw $s2, 0($s1)
	lw $s3, 4($s1)
	add $s3, $s2, $s3
	add $s3, $t0, $s3
	addi $s3, $s3, 1024
	lw $s4, 0($s3)
	lw $s5, blockPrimaryColor
	addi $s1, $s1, 8
	addi $s0, $s0, 1
	beq $s4, $s5, bottomBlockCheck
	bne $s4, 0, touchingBottom
	j touchingBottomLoop
bottomBlockCheck:
	add $s2, $s2, $t0
	neg $s2, $t0
	add $s3, $s3, $s2	# Gets sum of x and y coordinates and stores in $s3
	la $s5, blockPositions
	li $s7, 0
bottomBlockCheckLoop:
	# Loops through the coordinates of the tetromino and tries to find if the sum of any coordinates is equal to the block in question
	beq $s7, 4, touchingBottom
	lw $s2, 0($s5)
	lw $s6, 4($s5)
	add $s6, $s6, $s2
	beq $s3, $s6, touchingBottomLoop
	addi $s5, $s5, 8
	addi $s7, $s7, 1
	j bottomBlockCheckLoop
bottomClear:
	li $v1, -1
	jr $ra
touchingBottom:
	li $a1, 7
    	li $v0, 42
    	syscall
    	move $a1, $a0
    	li $t3, 112
    	li $t4, 9216
	sw $t3, blockXOffset
	sw $t4, blockYOffset
	li $s3, 0
	sw $s3, tetrominoInPlay
	li $v1, 2
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	jal lineDetection
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
# ----- ----- ----- ----- ----- -----

gravity:
	li $v0, 32
	li $a0, 16
	syscall
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	jal detectBottomColliison
	beq $v1, 2, postMove
	lw $t2, gravityCounter
	
	beq $t2, 1024, gravityEffect
	addi $t2, $t2, 32
	sw $t2, gravityCounter
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
gravityEffect:
	sw $zero, gravityCounter
	lw $t3, blockYOffset 
	addi $t3, $t3, 1024
	sw $t3, blockYOffset
    	jal refreshGameDisplay
    	lw $ra, 0($sp)
    	addi $sp, $sp, 4
	jr $ra
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
	
	
lineDetection: 
	li $t1, 0x1000F030
	li $t4, 0
	add $t3, $t1, 160
checkingLine:
	beq $t1, $t3, lineFull
	lw $t2, 0($t1)
	beq $t2, 0, nextLine
	addi $t4, $t4, -16
	addi $t1, $t1, 16
	j checkingLine
lineFull:
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	j clearLine
	j nextLine		
nextLine:
	add $t1, $t1, $t4
	addi $t1, $t1, -1024
	beq $t1, 0x1000A430, reachedTop
	li $t4, 0
	add $t3, $t1, 160
	j checkingLine
reachedTop:
	jr $ra
clearLine:
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	addi $s1, $s0, -160
clearLineLoop:
	beq $s0, $s1, nextLine
	li $s2, 0xffffff
	sw $s2, 0($s1)
	sw $s2, 4($s1)
	sw $s2, 8($s1)
	sw $s2, 12($s1)
	
	sw $s2, 256($s1)
	sw $s2, 260($s1)
	sw $s2, 264($s1)
	sw $s2, 268($s1)
	
	sw $s2, 512($s1)
	sw $s2, 516($s1)
	sw $s2, 520($s1)
	sw $s2, 524($s1)
	
	sw $s2, 768($s1)
	sw $s2, 772($s1)
	sw $s2, 776($s1)
	sw $s2, 780($s1)
	
	li $v0, 32
	li $a0, 20
	syscall
	
	sw $zero, 0($s1)
	sw $zero, 4($s1)
	sw $zero, 8($s1)
	sw $zero, 12($s1)
	
	sw $zero, 256($s1)
	sw $zero, 260($s1)
	sw $zero, 264($s1)
	sw $zero, 268($s1)
	
	sw $zero, 512($s1)
	sw $zero, 516($s1)
	sw $zero, 520($s1)
	sw $zero, 524($s1)
	
	sw $zero, 768($s1)
	sw $zero, 772($s1)
	sw $zero, 776($s1)
	sw $zero, 780($s1)
	
	addi $s1, $s1, 16
	j clearLineLoop

	

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
    	jal detectBottomColliison
    	jal gravity
    	b game_loop
