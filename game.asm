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
.eqv KEYSTROKE 0xffff0000
.eqv WIDTH 64
.eqv HEIGHT 32

.eqv MV_SP 1				# this is for later when we want to increase the move speed of our ship (this is the number of bits to inc speed!)

# FIX THE COMMENTS
# FIX THE BUGS
# OPTIMIZE 
# IMPLEMENT THE OBSTACLES


.globl main
main:
# INITIALIZATION
	# set canvas-color
	# $s0=base_addr; $s1=canvas_color; 
	# $s2=row_i; $s3=col_i; $s4=A[i][j] (where A is the framebuffer)
	li $s0, BASE_ADDRESS		# set starting address
	li $s1, 0xfcfcfc		# set color of the canvas
	addi $s2, $zero, 0		# set starting index (for row_loop)
row_loop:
	addi $s3, $zero, 0		# set starting index (for col_loop)
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
	
	addi $s3, $s3, 64		# update address to next set of columns
e_cl:	bne $s3, 256, col_loop		# if address not yet at end of framebuffer, jump to col_loop
	
	addi $s0, $s0, 256		# update the address to the next row
	addi $s2, $s2, 1		# increment the index
e_rl:	bne $s2, 32, row_loop		# if index not yet 32, jump to row_loop
	
	# draw the ship
	# $s0=&ship; $s1=&ship_offset; $s2=obj.color
	# $t0=color; $t1=pos; $t2=num_pixels; $t3=&obj_offset; 
	addi $sp, $sp, -16
	la $s0, ship			# get &obj
	la $s1, ship_offset		# get &obj_offset
	lw $s2, 0($s0)			# get obj.color
	lw $s3, 4($s0)			# get obj.pos
	lw $s4, 16($s0)			# get obj.num_pixels
	
	sw $s2, 0($sp)			# push &obj
	sw $s3, 4($sp)			# push &obj_offset
	sw $s4, 8($sp)			# push obj.color
	sw $s1, 12($sp)
	
	jal draw			# call 'draw' function
	
# START-SCREEN

# GAME-LOOP
# $s0=&ship; $s1=&ship_offset; $s2=&obj_arr
game_loop:
	
get_input:
	# get input AND verify ship.pos
	# $s3=keystroke_val; $s4=temp; $s5=old-ship.pos; $s6=new-ship.pos; $s7=relevant_bound;
	# $t0=old-x-coord; $t1=old-y-coord; $t2=new-x-coord; $t3=new-y-coord;
	li $s3, KEYSTROKE
	lw $s3, 0($s3)			# get keystroke-event value
	bne $s3, 1, e_i			# ensure that user did input something, otherwise jump to e_i
	li $s3, KEYSTROKE
	lw $s3, 4($s3)			# get ASCII user input
	
	lw $s5, 4($s0)			# get ship.pos
	srl $t1, $s5, 8			# calc y-coord=(old-ship.pos / 2^8)
	sll $s4, $t1, 6			# calc (y-coord * 2^6)
	srl $t0, $s5, 2			# calc (old-ship.pos / 2^2)
	sub $t0, $t0, $t1		# calc x-coord=(old-ship.pos / 2^2) - (y-coord * 2^6)
	
	li $s4, WIDTH
	sll $s4, $s4, 2			# calc WIDTH * 4
	# get new ship.pos
	sub $s6, $s5, $s4		# new pos is (addr - W)
	# lw $s7, 12($s0)			# set relevant_bound to y-bound
	subi $t3, $t1, 2		# update y-coord to the new pos
	addi $t2, $t0, 0		# update x-coord to the new pos
	beq $s3, 119, c_i		# input was UP, check it's still valid
	
	add $s6, $s5, $s4		# new pos is (addr + W)
	# lw $s7, 12($s0)			# set relevant_bound to y-bound
	addi $t3, $t1, 2		# update y-coord to the new pos
	addi $t2, $t0, 0		# update x-coord to the new pos
	beq $s3, 115, c_i		# input was DOWN, check it's still valid 
	
	addi $s6, $s5, 1		# new pos is (addr + 1)
	# lw $s7, 8($s0)			# set relevant_bound to x-bound
	addi $t2, $t0, 2		# update x-coord to the new pos
	addi $t3, $t1, 0		# update y-coord to the new pos
	beq $s3, 97, c_i		# input was LEFT, check it's still valid
	
	subi $s6, $s5, 1		# new pos is (addr - 1)
	# lw $s7, 8($s0)			# set relevant_bound to x-bound
	subi $t2, $t0, 2		# update x-coord to the new pos
	addi $t3, $t1, 0		# update y-coord to the new pos
	beq $s3, 100, c_i		# input was RIGHT, check it's still valid
	
	# we know what our ship is, we can hard-code and save some registers
	
	j e_i				# input was NONE OF THE ABOVE
c_i:
	# check that new-pos is within bounds of our framebuffer
	
	sw $s6, 4($s0)			# set ship.pos to new pos
	
	bge $t2, HEIGHT, r1		# check if new-x-coord is within range of framebuffer
	blt $t2, 0, r2
	bge $t3, WIDTH, r3		# check if new-y-coord is within range of framebuffer
	blt $t3, 0, r4
	j e_i				# input is VALID

r1:
	addi $t2, $zero, 31		# updated to be on edge
	j e_r
r2:
	add $t2, $zero, $zero		# updated to be on edge
	j e_r
r3:
	addi $t3, $zero, 63		# updated to be on edge
	j e_r
r4:
	add $t3, $zero, $zero		# updated to be on edge
e_r:
	sll $s6, $t3, 6
	add $s6, $s6, $t2		
	sll $s6, $s6, 2			# convert x-y coords into addressable index
	sw $s6, 4($s0)			# set ship.pos to valid new pos
e_i:
	
	# redraw
	# FOR NOW: we will just draw previous position with bg color and draw new position with obj color
	# however we have two issues:
	# what about when there are collisions and the obstacles are not the bg?
	# what about when the pos hasn't changed?
	# $s0=&ship; $s1=&ship_offset; $s2=obj.color
	# $t0=color; $t1=pos; $t2=num_pixels; $t3=&obj_offset; 
	addi $sp, $sp, -16
	la $s3, 0xfcfcfc		# get canvas color
	lw $s4, 16($s0)			# get ship.num_pixels
	la $s6, ship_offset		# get &obj_offset
	sw $s3, 0($sp)			# push canvas color
	sw $s5, 4($sp)			# push old pos
	sw $s4, 8($sp)			# push ship.num_pixels
	sw $s6, 12($sp)			# push &obj_offset
	
	jal draw			# call 'draw' function
	
	# $s0=&ship; $s1=&ship_offset; $s2=obj.color
	addi $sp, $sp, -16
	lw $s3, 0($s0)			# get obj.color
	lw $s4, 4($s0)			# get obj.pos
	lw $s7 16($s0)			# get obj.num_pixels
	la $s6, ship_offset		# get &ship_offset
	sw $s3, 0($sp)			# push obj.color
	sw $s4, 4($sp)			# push new pos
	sw $s7, 8($sp)			# push ship.num_pixels
	sw $s6, 12($sp)			# push &obj_offset
	
	jal draw			# call 'draw' function
	
	# sleep
	li $v0, 32
	li $a0, 40
	syscall
	j game_loop

# END-SCREEN
	li $v0, 10			# gracefully terminate the program (with grace)
	syscall

# FUNC PARAM	: $t0=color; $t1=pos; $t2=num_pixels; $t3=&obj_offset; 
# LOCAL REG 	: $t5=temp; $t6=temp; $t7=temp;
draw:
	lw $t0, 0($sp)			# pop color
	lw $t1, 4($sp)			# pop pos
	lw $t2, 8($sp)			# pop num_pixels
	lw $t3, 12($sp)			# pop &obj_offset
	addi $sp, $sp, 16
	
	add $t5, $zero, $zero		# set index
draw_loop:
	add $t7, $t3, $t5
	lh $t7, 0($t7)			# store current offset in $t7
	
	add $t6, $t1, $t7
	addi $t6, $t6, BASE_ADDRESS	# calc (BASE_ADDRESS + obj.pos + obj_offset[i])
	sw $t0, 0($t6)			# paint at that address the given color
	
	addi $t5, $t5, 2		# increment the index
	bne $t5, $t2, draw_loop		# if the index is not the same as obj.num_pixels, jump back to the draw_loop
	
	jr $ra				# return back



















