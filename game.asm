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
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
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

ship:		.word		0x4a4a4a 4160 1 1 10
ship_offset:	.half		-260 0 4 252 256

.text
.eqv BASE_ADDRESS 0x10008000

.globl main
main:
# INITIALIZATION
	# set canvas-color
	# $s0=base_addr; $s1=canvas_color; 
	# $s2=row_i; $s3=col_i; $s4=A[i][j] (where A is the framebuffer)
	
	li $s0, BASE_ADDRESS		# set the starting address
	li $s1, 0xfcfcfc		# set the color of the canvas
	addi $s2, $zero, 0		# set the starting index (for row_loop)
row_loop:
	addi $s3, $zero, 0		# set the starting index (for col_loop)
col_loop:
	add $s4, $s0, $s3		# address at some row and some column (that's divisible by 16)
	sw $s1, 0($s4)			# paint each unit
	sw $s1, 4($s4)
	sw $s1, 8($s4)
	sw $s1, 12($s4)
	sw $s1, 16($s4)
	sw $s1, 20($s4)
	sw $s1, 24($s4)
	sw $s1, 28($s4)
	sw $s1, 32($s4)
	sw $s1, 36($s4)
	sw $s1, 40($s4)
	sw $s1, 44($s4)
	sw $s1, 48($s4)
	sw $s1, 52($s4)
	sw $s1, 56($s4)
	sw $s1, 60($s4)
	
	addi $s3, $s3, 64		# update the address to the next set of columns
e_cl:	bne $s3, 256, col_loop		# if the address is not yet at the end of the framebuffer, jump to col_loop
	
	addi $s0, $s0, 256		# update the address to the next row
	addi $s2, $s2, 1		# increment the index
e_rl:	bne $s2, 32, row_loop		# if the index is not yet 32, jump to row_loop
	
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



















