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
# structure of the SHIP
# [obj]			.word		[pos] [size of offset_array (in bytes)] [address of offset_array (initialized)] [damage timer] [health]
# ship has: (1, 1) bounds relative to the center of the ship
# ship has: pos because it's the one and only pos for this obj
ship:			.word		4160 10 0 0 3
ship_offset:		.half		-260 0 4 252 256


# structure of every ROCK-TYPE
# [obj]			.word		[size of offset_array (in bytes)] [address of offset_array (initialized)] [x-padding] [y-padding]
# [obj_offset]		.half		[array of offsets relative to obj.pos]
# NOTE that the color of the obj is made explicit in the .eqv

# s_rock has: (1, 1) bounds relative to the center of s_rock
s_rock:			.word 		10 0 1 1
s_rock_offset:		.half		-256 -4 0 4 256

# m_rock has: (1, 1) bounds relative to the center of m_rock
m_rock:			.word		18 0 1 1 
m_rock_offset:		.half		-260 -256 -252 -4 0 4 252 256 260

# b_rock has: (3, 3) bounds relative to the center of b_rock
b_rock:			.word		74 0 3 3
b_rock_offset:		.space		74
# b_rock_dec are extra pixels to make b_rock more (DEC)orative
b_rock_dec:		.half		-12, 12, -244, 244, -268, 268, -764, -768, -772, 764, 768, 772

# structure of every ROCK
# [obj]			.word		[pos] [h-speed] [v-speed] [dir multiplier] [address of some ROCK-TYPE]
r0:			.word		-1 0 0 0 0 
r1:			.word		-1 0 0 0 0
r2:			.word		-1 0 0 0 0
r3:			.word		-1 0 0 0 0
r4:			.word		-1 0 0 0 0
r5:			.word		-1 0 0 0 0
r6:			.word		-1 0 0 0 0
r7:			.word		-1 0 0 0 0

# ARRAY OF ROCK-TYPE
type_arr:		.word		0 0 0
# ARRAY OF ROCKS
obj_arr:		.word 		0 0 0 0 0 0 0 0

.text
.eqv BASE_ADDRESS 0x10008000
.eqv BG_COLOR 0xfcfcfc

.eqv KEYSTROKE 0xffff0000

.eqv WIDTH 64
.eqv HEIGHT 32

.eqv SHIP_BASE_COLOR 0x4a4a4a
.eqv SHIP_DMG_COLOR 0xb84242
.eqv S_ROCK_COLOR 0xe86691
.eqv M_ROCK_COLOR 0xe8d964
.eqv B_ROCK_COLOR 0x63bfdb

.eqv MAX_ROCKS 8

.globl main
main:
# INITIALIZATION
	# set canvas-color
	# $s0=base_addr; $s1=canvas_color; 
	# $s2=row_i; $s3=col_i; $s4=A[i][j] (where A is the framebuffer)
	li $s0, BASE_ADDRESS		# set starting address
	li $s1, BG_COLOR		# set color of the canvas
	addi $s2, $zero, 0		# set starting index (for row_loop)
crow_loop:
	addi $s3, $zero, 0		# set starting index (for col_loop)
ccol_loop:
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
e_ccl:	bne $s3, 256, ccol_loop		# if address not yet at end of framebuffer, jump to col_loop
	
	addi $s0, $s0, 256		# update the address to the next row
	addi $s2, $s2, 1		# increment the index
e_crl:	bne $s2, 32, crow_loop		# if index not yet 32, jump to row_loop


	# initialize the ROCKS and obj_array and type_array
	# $s0=rock; $s1=&type_arr; $s2=rock_offset;
	la $s1, type_arr
	la $s0, s_rock
	la $s2, s_rock_offset
	sw $s2, 4($s0)			# store address of s_rock_offset in s_rock
	sw $s0, 0($s1)			# store address of s_rock in type_arr
	la $s0, m_rock
	la $s2, m_rock_offset
	sw $s2, 4($s0)			# store address of m_rock_offset in m_rock
	sw $s0, 4($s1)			# store address of m_rock in type_arr
	la $s0, b_rock
	la $s2, b_rock_offset
	sw $s2, 4($s0)			# store address of b_rock_offset in b_rock
	sw $s0, 8($s1)			# store address of b_rock in type_arr
	
	# initialize b_rock's offset
	# $s0=&b_rock_offset; $s2=&b_rock_dec; $t0=index;
	la $s0, b_rock_offset		# get address of b_rock_offset
	li $t0, -520			# set starting index
rock_loop:
	sh $t0, 0($s0)			# store each 5 pixel offsets into b_rock_offset
	addi $t0, $t0, 4
	sh $t0, 2($s0)
	addi $t0, $t0, 4
	sh $t0, 4($s0)
	addi $t0, $t0, 4
	sh $t0, 6($s0)
	addi $t0, $t0, 4
	sh $t0, 8($s0)
	addi $t0, $t0, 4
	
	addi $s0, $s0, 10		# update the pointer of b_rock_offset
	addi $t0, $t0, 236		# update the index to get the next row of pixels
e_rl:	bne $t0, 760, rock_loop		# if index is not yet on the 6th row, jump onto rock_loop

	# initialize b_rock's decorative offset
	# $s0=&b_rock_offset; $s2=&b_rock_dec; $s3=A[i] (where A is b_rock_dec); $t0=index;
	la $s2, b_rock_dec		# get address of b_rock_dec
	add $t0, $zero, $zero		# reset starting index
rock_dec_loop:
	lh $s3, 0($s2)			# copy each 4 offset-elements in b_rock_dec onto b_rock_offset
	sh $s3, 0($s0)
	lh $s3, 2($s2)
	sh $s3, 2($s0)
	lh $s3, 4($s2)
	sh $s3, 4($s0)
	lh $s3, 6($s2)
	sh $s3, 6($s0)
	
	addi $s0, $s0, 8		# update the pointer of b_rock_offset
	addi $s2, $s2, 8		# update the pointer of b_rock_dec
	addi $t0, $t0, 8		# update the index to get the next set of offsets
e_rdl:	bne $t0, 24, rock_dec_loop	# if index is not yet 24, jump onto rock_loop

	# store the ROCKS in obj_arr
	# $s0=&ROCK; $s1=&obj_arr;
	la $s1, obj_arr
	la $s0, r0
	sw $s0, 0($s1)
	la $s0, r1
	sw $s0, 4($s1)
	la $s0, r2
	sw $s0, 8($s1)
	la $s0, r3
	sw $s0, 12($s1)
	la $s0, r4
	sw $s0, 16($s1)
	la $s0, r5
	sw $s0, 20($s1)
	la $s0, r6
	sw $s0, 24($s1)
	la $s0, r7
	sw $s0, 28($s1)
	
	
	# initialize AND draw the ship
	# $s0=&ship; $s1=temp; $s2=temp;
	addi $sp, $sp, -12
	la $s0, ship			# get address of ship
	la $s2, ship_offset		
	sw $s2, 8($s0)			# assign address of ship_offset in ship
	lw $s2, 0($s0)			# get pos of ship
	li $s1, SHIP_BASE_COLOR		# get color of ship
	
	sw $s0, 0($sp)			# push &ship
	sw $s1, 4($sp)			# push color
	sw $s2, 8($sp)			# push pos
	jal draw			# call 'draw' function
	
# START-SCREEN

# GAME-LOOP
# $s0=&ship; $s1=&obj_arr; $s2=&type_arr;
game_loop:
	# update the ROCKS
	# $s1=&obj_arr; $s2=&type_arr; $s3=A[i] (where A is the obj_arr); $t0=index (for obj_arr);
	la $s1, obj_arr			# get address of obj_arr
	la $s2, type_arr		# get address of type_arr
	add $t0, $zero, $zero		# set the starting index
update_obj:
	# $s1=&obj_arr; $s2=&type_arr; $s3=A[i] (where A is the obj_arr); $s4=rock_pos; $t0=index (for obj_arr);
	add $s1, $s1, $t0		# update obj_arr pointer
	lw $s3, 0($s1)			# get address of rock 
	lw $s4, 0($s3)			# get pos of rock
	bne $s4, -1, rock_exists	# if pos is NOT -1, jump to rock_exists
	
	# randomly generate a bunch of values to assign to our newly made  R O C K
	# randomly assign the ROCK-TYPE
	li $v0, 42
	li $a0, 0
	li $a1, 3
	syscall				# generate a random INT from 0-2 (inclusive)
	sll $a0, $a0, 2			# and multiply it by 4
	add $a0, $s2, $a0		# add that offset to type_arr
	lw $a0, 0($a0)
	sw $a0, 16($s3)			# store it in rock.type
	
	# randomly assign the dir_multiplier
	li $v0, 42
	li $a0, 0
	li $a1, 2
	syscall				# generate a random INT from 0-1 (inclusive)
	# choose whether to store 1 or -1 
	beq $a0, 1, go_down		# if the random INT was 1, jump to go_down
	addi $a0, $zero, -1
go_down:
	sw $a0, 8($s3)			# store it in rock.dir_multiplier 
	
	# randomly assign a (valid) x-coord
	# $t1=x-coord;
	li $v0, 42
	li $a0, 0
	li $a1, 21
	syscall
	addi $t1, $a0, 40		# generate a random INT from 40-60 (inclusive)
	# randomly assign a (valid) y-coord
	# $t2=y-coord;
	li $v0, 42
	li $a0, 0
	li $a1, 25
	syscall
	addi $t2, $a0, 3		# generate a random INT from 3-28 (inclusive) 
	# convert x-y coords into index-pos
	sll $t2, $t2, 6
	add $t1, $t2, $t1
	sll $t1, $t1, 2			# calc (y-coord * 2^6 + x-coord) * 4
	sw $t1, 0($s3)			# store it in rock.pos
	
	# randomly assign a h-speed value
	li $v0, 42
	li $a0, 0
	li $a1, 3
	syscall
	addi $a0, $a0, 1		# generate a random INT from 1-3 (inclusive)
	sw $a0, 4($s3)			# store it in rock.h_speed
	# randomly assign a v-speed value
	li $v0, 42
	li $a0, 0
	li $a1, 4
	syscall				# generate a random INT from 0-3 (inclusive)
	sw $a0, 8($s3)			# store it in rock.v_speed
	
	j e_obj				# will be drawn on the next frame
rock_exists:



	addi $t0, $t0, 4
	bne $t0, 32, update_obj
	# go through each rock in obj_arr
		# if pos is -1
			# generate a new ROCK TYPE
			# generate a new y-coord (x-coord is fixed)
			# generate random direction to start off
		# get x-y coords
		# compute new coords using the direction and speed
		# check if still in bound (with padding considered)
			# if on edge, not only set it at edge, change direction sign
			# if at LHS, reset everything and make sure it's not drawn on the next frame
		# draw it NOW (because we know it's valid)
		# then check for collision so that next frame, it's gone
		# with valid new pos, check for collision with the ship (and the bullet later)
			# how exactly? 
			# we get the ship's x-y coords and we calculate the differences
			# check if it's within the padding for eg if the padding was 1 we check: -1 <= x/y <= 1
			# the importance is that both x and y are within the ineq, otherwise it could just be on the same row/col
			# then we can do damage and destroy the rock
			# doing damage is decrementing the health in the ship and setting the damage timer to 6
				# why 6? i calculated the ms to hrtz and hrtz to fps and we're going at 12fps, i want to change the color for at 
				# least half a second and if multiple collide, i want to reset the timer, not add more to it because that might look weird.
				# I WILL MODIFY ship-loop (at the end, where it is going to be drawn) to include a check if it's non-0
				# it will decrement that timer and reroute the draw function to draw with the specified color of damage
				# have to include that check near the front so that even if the ship hasn't moved, it can still be updated
		
e_obj: # we could have this as a branch 
	
update_ship:
	# get input
	# $s3=keystroke_val;
	li $s3, KEYSTROKE
	lw $s3, 0($s3)			# get keystroke-event value
	bne $s3, 1, e_ship		# ensure that user did input something, otherwise jump to e_i
	li $s3, KEYSTROKE
	lw $s3, 4($s3)			# get ASCII user input
	
	# store old-x-y-coords
	# $s0=&ship; $s5=old-ship.pos; $t0=old-x-coord; $t1=old-y-coord; $t2=new-x-coord; $t3=new-y-coord;
	lw $s5, 0($s0)			# get ship.pos
	srl $t1, $s5, 8			# calc y-coord=(old-ship.pos / 2^8)
	sll $s4, $t1, 6			# calc (y-coord * 2^6)
	srl $t0, $s5, 2			# calc (old-ship.pos / 2^2)
	sub $t0, $t0, $s4		# calc x-coord=(old-ship.pos / 2^2) - (y-coord * 2^6)
	
	add $t2, $zero, $t0		# copy old-coords onto the new-coords
	add $t3, $zero, $t1

	# check to ensure input was valid
	# $s3=keystroke_val; $t0=old-x-coord; $t1=old-y-coord; $t2=new-x-coord; $t3=new-y-coord;
	beq $s3, 119, W			# input was W
	beq $s3, 115, S			# input was S
	beq $s3, 97, A			# input was A
	beq $s3, 100, D			# input was D
	j e_ship			# input was INVALID

W:	addi $t3, $t1, -3		# calc new-y-coord with padding 
	blt $t3, 0, v_lb		# if invalid, go to vertical-lower-bound
	addi $t3, $t3, 1		# remove padding
	j s_i				
S:	addi $t3, $t1, 3		# calc new-y-coord with padding 
	bge $t3, HEIGHT, v_ub		# if invalid, go to vertical-upper-bound
	addi $t3, $t3, -1		# remove padding
	j s_i
	
v_lb:	addi $t3, $zero, 1		# set new-y-coord (without padding) at 1
	j s_i
v_ub:	addi $t3, $zero, HEIGHT		# set new-y-coord (without padding) at HEIGHT-2
	addi $t3, $t3, -2
	j s_i 

A:	addi $t2, $t0, -3		# calc new-x-coord with padding
	blt $t2, 0, h_lb		# if invalid, go to horizontal-lower-bound
	addi $t2, $t2, 1		# remove padding
	j s_i
D:	addi $t2, $t0, 3		# calc new-x-coord with padding
	bge $t2, WIDTH, h_ub		# if invalid, got horizontal-upper-bound
	addi $t2, $t2, -1		# remove padding
	j s_i
	
h_lb:	addi $t2, $zero, 1		# set new-x-coord (without padding) at 1
	j s_i
h_ub:	addi $t2, $zero, WIDTH		# set new-x-coord (without padding) at WIDTH-2
	addi $t2, $t2, -2
	
s_i:
	# convert new-x-y coords 
	# $s3=new-pos; $t2=new-x-coord; $t3=new-y-coord;
	sll $t3, $t3, 6			# calc (new-y-coord * 2^6)
	add $s3, $t3, $t2		# calc (new-y-coord * 2^6) + new-x-coord
	sll $s3, $s3, 2			# calc ((new-y-coord * 2^6) + new-x-coord) * 2^2
	
	# with differences, set it AND redraw it (otherwise, don't redraw)
	# $s0=&ship; $s1=temp; $s2=temp; $s5=old-pos;
	addi $sp, $sp, -12
	la $s0, ship			# get address of ship
	li $s1, BG_COLOR		# get color of canvas
	
	sw $s0, 0($sp)			# push &ship
	sw $s1, 4($sp)			# push color
	sw $s5, 8($sp)			# push pos
	jal draw			# call 'draw' function
	
	# $s0=&ship; $s1=temp; $s2=temp; $s3=new-pos;
	addi $sp, $sp, -12
	la $s0, ship			# get address of ship
	li $s1, SHIP_BASE_COLOR		# get color of ship
	
	sw $s0, 0($sp)			# push &ship
	sw $s1, 4($sp)			# push color
	sw $s3, 8($sp)			# push pos
	jal draw			# call 'draw' function
	
	sw $s3, 0($s0)
e_ship:
	
	# sleep
	li $v0, 32
	li $a0, 40
	syscall
	j game_loop

# END-SCREEN
	li $v0, 10			# gracefully terminate the program (with grace)
	syscall


# FUNC PARAM	: $t0=&obj; $t1=color; $t2=pos;
# LOCAL REG 	: $t3=&A (where A is the obj_offset array); $t4=temp;
#		  $t5=index; $t6=pixel_addr; $t7=A[i] (where A is the obj_offset array);
draw:
	lw $t0, 0($sp)			# pop &obj
	lw $t1, 4($sp)			# pop color
	lw $t2, 8($sp)			# pop pos
	addi $sp, $sp, 12
	
	lw $t3, 8($t0)			# load address of obj_offset array from &obj
	lw $t4, 4($t0)			# load size of obj_offset array from &obj 
	
	add $t5, $zero, $zero		# set index
draw_loop:
	add $t7, $t3, $t5
	lh $t7, 0($t7)			# store current offset in $t7
	
	add $t6, $t2, $t7
	addi $t6, $t6, BASE_ADDRESS	# calc (BASE_ADDRESS + obj.pos + obj_offset[i])
	sw $t1, 0($t6)			# paint at that address the given color
	
	addi $t5, $t5, 2		# increment the index
	bne $t5, $t4, draw_loop		# if the index is not the same as obj.num_pixels, jump back to the draw_loop
	
	jr $ra				# return back


## function for converting index to x, y

## function for converting x, y to index

















