#####################################################################
#
# CSCB58 Winter 2021 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Lander Joshua Vitug, 1006560366, vituglan
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 256 (update this as needed)
# - Display height in pixels: 128 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 1/2/3/4 (choose the one the applies)
#
# Which approved features have been implemented for milestone 4?
# (See the assignment handout for the list of additional features)
# 1. (fill in the feature, if any)
# 2. (fill in the feature, if any)
# 3. (fill in the feature, if any)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
#
# Any additional information that the TA needs to know:
# - (write here, if any)
#
#####################################################################

.data
# structure of every obj
# [obj]		.word		[color] [pos] [x-bound] [y-bound] [num_pixels (size of array)]
# [obj_offset]	.half		[array of offsets relative to obj.pos]

ship:		.word		0x4a4a4a 924 1 1 10
ship_offset:	.half		-132 0 4 124 128

.text
.eqv BASE_ADDRESS 0x10008000

.globl main
main:
# INITIALIZATION
	# set canvas
	li $t0, BASE_ADDRESS		# initialize the canvas_loop by 
	addi $t1, $zero, 0		# setting the index starting-value, the color of the canvas, 
	li $t2, 0xfcfcfc		# and the address of the first row of the framebuffer
canvas_loop:
	sw $t2, 0($t0)			# paint each unit
	sw $t2, 4($t0)
	sw $t2, 8($t0)
	sw $t2, 12($t0)
	sw $t2, 16($t0)
	sw $t2, 20($t0)
	sw $t2, 24($t0)
	sw $t2, 28($t0)
	sw $t2, 32($t0)
	sw $t2, 36($t0)
	sw $t2, 40($t0)
	sw $t2, 44($t0)
	sw $t2, 48($t0)
	sw $t2, 52($t0)
	sw $t2, 56($t0)
	sw $t2, 60($t0)
	sw $t2, 64($t0)
	sw $t2, 68($t0)
	sw $t2, 72($t0)
	sw $t2, 76($t0)
	sw $t2, 80($t0)
	sw $t2, 84($t0)
	sw $t2, 88($t0)
	sw $t2, 92($t0)
	sw $t2, 96($t0)
	sw $t2, 100($t0)
	sw $t2, 104($t0)
	sw $t2, 108($t0)
	sw $t2, 112($t0)
	sw $t2, 116($t0)
	sw $t2, 120($t0)
	sw $t2, 124($t0)
	
	addi $t0, $t0, 128		# update the address to the next row
	addi $t1, $t1, 1		# increment the index
	bne $t1, 32, canvas_loop	# if the index is not yet 32, jump to canvas_loop
	
	# draw the ship
	addi $sp, $sp, -12
	la $s0, ship			# get &obj
	la $s1, ship_offset		# get &obj_offset
	lw $s2, 0($s0)			# get obj.color
	sw $s0, 0($sp)			# push &obj
	sw $s1, 4($sp)			# push &obj_offset
	sw $s2, 8($sp)			# push obj.color
	
	jal draw			# call the draw function


	li $v0, 10			# gracefully terminate the program (with grace)
	syscall

# FUNC PARAM	: $t0=&obj; $t1=&obj_offset; $t2=color;
# LOCAL REG 	: $t3=pos; $t4=num_pixels; $t5=temp; $t6=temp; $t7=temp;
draw:
	lw $t0, 0($sp)			# pop &obj
	lw $t1, 4($sp)			# pop &obj_offset
	lw $t2, 8($sp)			# pop color
	addi $sp, $sp, 12
	
	lw $t3, 4($t0)			# get obj.pos
	lw $t4, 16($t0)			# get obj.num_pixels
	add $t5, $zero, $zero		# set index
draw_loop:
	add $t7, $t1, $t5
	lh $t7, 0($t7)			# store current offset in $t7
	
	add $t6, $t3, $t7
	addi $t6, $t6, BASE_ADDRESS	# calc (BASE_ADDRESS + obj.pos + obj_offset[i])
	sw $t2, 0($t6)			# paint at that address the given color
	
	addi $t5, $t5, 2		# increment the index
	bne $t5, $t4, draw_loop		# if the index is not the same as obj.num_pixels, jump back to the draw_loop
	
	jr $ra				# return back



















