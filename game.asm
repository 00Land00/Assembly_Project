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
message:		.asciiz		"\n"

# structure of the SHIP
# [obj]			.word		[ship_type] [ship_info]
# [obj_info]		.half		[x-coord] [y-coord] [h-speed] [v-speed] [dmg timer] [health] 
# [obh_type]		.word		[color] [sizeof offset_arr] [address of offset_arr] [x-padding] [y-padding]
# ship has: (1, 1) bounds relative to the center of the ship
# ship has: pos because it's the one and only pos for this obj
ship:			.word		0 0 
ship_info:		.half		15 15 2 2 0 3
ship_type:		.word		0x4a4a4a 10 0 1 1
ship_offset:		.half		-260 0 4 252 256


# structure of every ROCK-TYPE
# [obj]			.word		[color] [size of offset_array (in bytes)] [address of offset_array (initialized)] [x-padding] [y-padding]
# [obj_offset]		.half		[array of offsets relative to obj.pos]
# NOTE that the color of the obj is made explicit in the .eqv

# s_rock has: (1, 1) bounds relative to the center of s_rock
s_rock:			.word 		0xe86691 10 0 -1 1
s_rock_offset:		.half		-256 -4 0 4 256

# m_rock has: (1, 1) bounds relative to the center of m_rock
m_rock:			.word		0xe8d964 18 0 -1 1 
m_rock_offset:		.half		-260 -256 -252 -4 0 4 252 256 260

# b_rock has: (3, 3) bounds relative to the center of b_rock
b_rock:			.word		0x63bfdb 74 0 -3 3 
b_rock_offset:		.space		74
# b_rock_dec are extra pixels to make b_rock more (DEC)orative
b_rock_dec:		.half		-12, 12, -244, 244, -268, 268, -764, -768, -772, 764, 768, 772

# structure of every ROCK and ROCK_INFO
# [obj] 		.word 		[address of some ROCK-TYPE] [address of ROCK-INFO]
# [obj_info]		.half		[x-coord] [y-coord] [h-speed] [v-speed] 
r0:			.word 		0 0
r0_info:		.half		-1 0 0 0
r1:			.word		0 0 
r1_info:		.half		-1 0 0 0
r2:			.word		0 0  
r2_info:		.half		-1 0 0 0
r3:			.word		0 0 
r3_info:		.half		-1 0 0 0 
r4:			.word		0 0 
r4_info:		.half		-1 0 0 0 
r5:			.word		0 0 
r5_info:		.half		-1 0 0 0 
r6:			.word		0 0 
r6_info:		.half		-1 0 0 0 
r7:			.word		0 0 
r7_info:		.half		-1 0 0 0 

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

.eqv MAX_ROCKS 8

.globl main
main:
# INITIALIZATION
	# set canvas-color
	# $s0=base_addr; $s1=canvas_color; $s2=row_i; $s3=col_i; $s4=A[i][j] (where A is the framebuffer)
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


	# initialize ROCK-TYPEs and TYPE_ARRAY
	# $s0=rock; $s1=&type_arr; $s2=rock_offset;
	# $s0=rock_offset; $s1=rock; $s2=&type_arr;
	la $s2, type_arr
	
	la $s0, s_rock_offset
	la $s1, s_rock
	sw $s0, 8($s1)			# store s_rock_offset in s_rock
	sw $s1, 0($s2)			# store s_rock in type_arr
	la $s0, m_rock_offset
	la $s1, m_rock
	sw $s0, 8($s1)			# store m_rock_offset in s_rock
	sw $s1, 4($s2)			# store m_rock in type_arr
	la $s0, b_rock_offset
	la $s1, b_rock
	sw $s0, 8($s1)			# store b_rock_offset in s_rock
	sw $s1, 8($s2)			# store b_rock in type_arr
	# initialize B_ROCK_OFFSET
	# $s0=&b_rock_offset; $t0=index;
	la $s0, b_rock_offset		
	li $t0, -520			# set starting index
rock_loop:
	sh $t0, 0($s0)			# set each 5 pixel offsets onto b_rock_offset
	addi $t0, $t0, 4
	sh $t0, 2($s0)
	addi $t0, $t0, 4
	sh $t0, 4($s0)
	addi $t0, $t0, 4
	sh $t0, 6($s0)
	addi $t0, $t0, 4
	sh $t0, 8($s0)
	addi $t0, $t0, 4
	
	addi $s0, $s0, 10		# update b_rock_offset pointer
	addi $t0, $t0, 236		# update starting index
e_rl:	bne $t0, 760, rock_loop		# jump onto rock_loop if starting index not yet 760
	# initialize B_ROCK_DEC onto B_ROCK_OFFSET
	# $s0=&b_rock_offset; $s1=&b_rock_dec; $s3=A[i] (where A is b_rock_dec); $t0=index;
	la $s1, b_rock_dec		
	add $t0, $zero, $zero		# set starting index
rock_dec_loop:
	lh $s3, 0($s1)			# transfer each 4 offset-elements onto b_rock_offset
	sh $s3, 0($s0)
	lh $s3, 2($s1)
	sh $s3, 2($s0)
	lh $s3, 4($s1)
	sh $s3, 4($s0)
	lh $s3, 6($s1)
	sh $s3, 6($s0)
	
	addi $s0, $s0, 8		# update b_rock_offset pointer
	addi $s1, $s1, 8		# update b_rock_dec pointer
	addi $t0, $t0, 8		# update starting index
e_rdl:	bne $t0, 24, rock_dec_loop	# jump onto rock_loop if starting index not yet 24

	# initialize ROCK_INFO onto ROCK onto OBJ_ARR
	# $s0=&rock;_info $s1=&rocko; $s3=&obj_arr;
	la $s3, obj_arr
	
	la $s0, r0_info
	la $s1, r0
	sw $s0, 4($s1)			# store rock_info onto rock
	sw $s1, 0($s3)			# store rock onto obj_arr
	la $s0, r1_info
	la $s1, r1
	sw $s0, 4($s1)			# store rock_info onto rock
	sw $s1, 4($s3)			# store rock onto obj_arr
	la $s0, r2_info
	la $s1, r2
	sw $s0, 4($s1)			# store rock_info onto rock
	sw $s1, 8($s3)			# store rock onto obj_arr
	la $s0, r3_info
	la $s1, r3
	sw $s0, 4($s1)			# store rock_info onto rock
	sw $s1, 12($s3)			# store rock onto obj_arr
	la $s0, r4_info
	la $s1, r4
	sw $s0, 4($s1)			# store rock_info onto rock
	sw $s1, 16($s3)			# store rock onto obj_arr
	la $s0, r5_info
	la $s1, r5
	sw $s0, 4($s1)			# store rock_info onto rock
	sw $s1, 20($s3)			# store rock onto obj_arr
	la $s0, r6_info
	la $s1, r6
	sw $s0, 4($s1)			# store rock_info onto rock
	sw $s1, 24($s3)			# store rock onto obj_arr
	la $s0, r7_info
	la $s1, r7
	sw $s0, 4($s1)			# store rock_info onto rock
	sw $s1, 28($s3)			# store rock onto obj_arr
	add $s1, $s3, $zero
	
	# initialize SHIP_INFO and SHIP_TYPE onto SHIP
	# $s0=&ship; $s3=&ship_info; $s4=&ship_type; $s5=&ship_offset;
	la $s0, ship
	la $s3, ship_info
	la $s4, ship_type
	la $s5, ship_offset
	
	sw $s5, 8($s4)
	sw $s4, 0($s0)
	sw $s3, 4($s0)
	
	
# START-SCREEN
	# draw SHIP
	# $s0=&ship; $t0=temp; $t1=temp;
	la $s0, ship
	addi $a0, $s0, 0		# push &ship
	lw $t0, 0($s0)
	lw $t0, 0($t0)
	addi $a1, $t0, 0		# push ship_type.color
	lw $t0, 4($s0)
	lh $t1, 0($t0)
	addi $a2, $t1, 0		# push ship_info.x_coord
	lh $t1, 2($t0)
	addi $a3, $t1, 0		# push ship_info.y_coord
	
	jal draw
	

# GAME-LOOP
# $s0=&ship; $s1=&obj_arr; $s2=&type_arr; 
game_loop:

	# update ROCKS
	# $s1=&obj_arr; $s2=&type_arr; $t0=index;
	la $s1, obj_arr			# get address of obj_arr
	la $s2, type_arr		# get address of type_arr
	add $t0, $zero, $zero		# set the starting index
update_obj:
	# setup for the rest of the update_obj loop
	# $s1=&obj_arr; $s3=&obj_info; $s4=&obj_type;
	lw $s3, 0($s1)
	lw $s4, 0($s3)
	lw $s3, 4($s3)

	# does this rock exist?
	# $s3=&obj_info; $t1=x-coord; $t2=y-coord;
	lh $t1, 0($s3)			# get x-coord
	lh $t2, 2($s3)			# get y-coord
	lh $t3, 4($s3)			# get h-speed
	lh $t4, 6($s3)			# get v-speed
	bne $t1, -1, rock_exists	# jump to rock_exists if x-coord is NOT -1
	
	
	# create a new  R O C K
	
	# randomly assign the ROCK-TYPE
	# $s1=&obj_arr; $s2=&type_arr; $s4=&obj_type; $s5=temp;
	li $v0, 42
	li $a0, 0
	li $a1, 3
	syscall				
	sll $a0, $a0, 2			# generate a random value in {0, 4, 8}
	add $a0, $s2, $a0		
	lw $a0, 0($a0)
	lw $s5, 0($s1)
	sw $a0, 0($s5)			# store it in obj_arr[i].obj_type
	add $s4, $a0, $zero		# update $s4
	# randomly assign a (valid) x-coord
	# $s3=&obj_info; $t1=x-coord;
	li $v0, 42
	li $a0, 0
	li $a1, 11
	syscall
	addi $t1, $a0, 50		# generate a random INT from 50-60 (inclusive)
	sh $t1, 0($s3)			# store it in obj_arr[i].obj_info.x_coord
	# randomly assign a (valid) y-coord
	# $s3=&obj_info; $t2=y-coord;
	li $v0, 42
	li $a0, 0
	li $a1, 25
	syscall
	addi $t2, $a0, 3		# generate a random INT from 3-28 (inclusive) 
	sh $t2, 2($s3)			# store it in obj_arr[i].obj_info.y_coord
	# randomly assign a h-velocity value (i call it h-speed, but here, i incorporated direction) 
	# $s3=&obj_info; $t3=h-speed
	li $v0, 42
	li $a0, 0
	li $a1, 2
	syscall
	addi $t3, $a0, -2		# generate a random INT from (-2)-(-1) (inclusive)
	sh $t3, 4($s3)			# store it in obj_arr[i].obj_info.h_speed
	# randomly assign a v-speed value
	# $s3=&obj_info; $t2=y-coord; $t4=v-speed; 
	li $v0, 42
	li $a0, 0
	li $a1, 5
	syscall		
	#bne $a0, 2, svs
	#blt $t2, 16, lh
	#addi $t4, $a0, -1
	#j svs	
#lh:	addi $t4, $a0, 1
#svs:
	addi $t4, $a0, -2		# generate a random INT from (-2)-(2) (inclusive)
	sh $t4, 6($s3)			# store it in obj_arr[i].obj_info.v_speed
	
	
rock_exists:
	# get paddings
	# $s4=&obj_type; $t5=x-padding; $t6=y-padding;
	lw $t5, 12($s4)			# get x-padding
	lw $t6, 16($s4)			# get y-padding

	# calc new coords 
	# $s3=&obj_info; $s4=&obj_type; $t1=new x-coord; $t2=new y-coord; $t3=h-speed; $t4=v-speed;
	# add h-speed
	add $t1, $t1, $t3		# h-speed
	# add v-speed
	add $t2, $t2, $t4		# v-speed
	
	# calc new x-coord + x-padding (x-combined)	
	# calc v-speed + y-padding (y-combined)
	# $s4=&obj_type; $t1=new x-coord; $t3=h-speed; $t4=v-speed; $t5=x-padding; $t6=y-padding; $t7=x-combined; $t8=y-combined; $t9=temp;
	add $t7, $t1, $t5		# x-combined
	
	add $t8, $t4, $zero		# y-combined
	bgtz $t4, pos1
	sll $t8, $t4, 1
	sub $t8, $t4, $t8
pos1:
	add $t8, $t8, $t6
	bgtz, $t4, pos2
	sll $t9, $t8, 1
	sub $t8, $t8, $t9
pos2:
	
	# verify y-coord is valid
	# $s3=&obj_info; $t8=y-combined; $t9=old y-coord;
	lh $t9, 2($s3)
	add $t9, $t9, $t8
	
	bltz $t9, top
	bge $t9, HEIGHT, bottom
	j left
top:
	# update so it stays on screen
	# $t2=new y-coord; $t6=y-padding;
	add $t2, $t6, $zero
	j swap
bottom:
	# update so it stays on screen
	# $t2=new y-coord; $t6=y-padding;
	addi $t2, $zero, 31
	sub $t2, $t2, $t6
swap:
	# change v-speed direction
	# $t4=new v-speed; $t9=temp;
	sll $t9, $t4, 1
	sub $t4, $t4, $t9
	sh $t4, 6($s3)
left:	
	# verify x-coord
	# $t7=x-combined;
	bgez $t7, s_np
	
	# indicate that this ROCK is set for removal
	# $t1=new x-coord;
	addi $t1, $zero, -1
	j d_obj
s_np:	

# optimize and find ways to set it in the register and not have to get it again (in the obj_loop)
# clean up the ship's code
# relabel everything better?

# implement health system
# implement indicator of damage
# implement UI
# implement stopping condition (so it can end without me stopping it manually)
# shooting stuff
# score system and restarting


ship_col:
	# collision check (with the ship)
	# get x-y diff
	# $s0=&ship; $s3=&obj_info; $s5=x-diff; $s6=y-diff; $t7=ship x-coord; $t8=ship y-coord; $t9=temp;
	lw $t9, 4($s0)
	lh $t7, 0($t9)
	lh $t8, 2($t9)
	
	lh $t9, 0($s3)
	sub $s5, $t7, $t9
	lh $t9, 2($s3)
	sub $s6, $t8, $t9
	# get x-paddings
	# $t9=x-paddings; 
	addi $t9, $t5, -1			# ship padding is hardcoded
	# check for horizontal collision
	# $t3=x-diff; $t4=combined-padding; $t5=temp; $s7=temp;
	blt $s5, $t9, e_ship_col
	sll $s7, $t9, 1
	sub $t9, $t9, $s7
	bgt $s5, $t9, e_ship_col
	# get y-paddings
	# $t9=y-paddings; 
	addi $t9, $t6, 1			# ship padding is hardcoded
	# check for vertical collision
	# $t3=y-diff; $t4=combined-padding; $t5=temp;
	bgt $s6, $t9, e_ship_col
	sll $s7, $t9, 1
	sub $t9, $t9, $s7
	blt $s6, $t9, e_ship_col

	# it did collide
	# activate damage timer | decrement health
	# do a slight pause
	li $v0, 32
	li $a0, 300
	syscall
	addi $t1, $zero, -1
	j d_obj
e_ship_col:

	# collision check (with other ROCKS)
	# setup
	# $s5=&obj_arr; $t9=index;
	la $s5, obj_arr
	li $t9, 0
col_loop:
	# more setup for the rest of this loop
	# $s5=&obj_arr; $s6=&obj_info; $s7=&obj_type;
	lw $s7, 0($s5)
	lw $s6, 4($s7)				# get &obj_info
	lw $s7, 0($s7)				# get &obj_type
	# ensure it's not the same rock
	# $s1=&obj_arr; $s5=&obj_arr; $t7=temp;
	sub $t7, $s1, $s5			# calc diff of &obj_arr(s)
	beqz $t7, i_col_loop			# jump to i_col_loop if diff is 0
	
	# get x-coords then x-diff then x-padding
	# $s6=&obj_info; $t7=x-coord; 
	lh $t7, 0($s6)				# get x-coord
	beq $t7, -1, i_col_loop			# jump to i_col_loop if x-coord is -1
	# $t1=new x-coord; $t7=x=coord; 
	sub $t7, $t1, $t7			# calc x-diff
	# $s7=&obj_type; $t5=x-padding; $t8=x-paddings;
	lw $t8, 12($s7)				# get x-padding
	add $t8, $t8, $t5			# calc sum of x-paddings
	# check for horizontal collision
	# $t3=temp; $t7=x-diff; $t8=x-paddings;
	blt $t7, $t8, i_col_loop		# jump to i_col_loop if x-diff < x-paddings
	sll $t3, $t8, 1			
	sub $t8, $t8, $t3			# calc inverse of x-paddings
	bgt $t7, $t8, i_col_loop		# jump to i_col_loop if x-diff > x-paddings
	
	# get y-coords then y-diff then y-padding
	# $s6=&obj_info; $s7=&obj_type; $t7=y-coord; $t8=y-paddings
	lh $t7, 2($s6)				# get y-coord
	sub $t7, $t2, $t7			# calc y-diff
	lw $t8, 16($s7)				# get y-padding
	add $t8, $t8, $t6			# calc sum of y-paddings
	# check for vertical collision
	# $t3=temp; $t7=y-diff; $t8=y-paddings;
	bgt $t7, $t8, i_col_loop		# jump to i_col_loop if y-diff > y-paddings
	sll $t3, $t8, 1
	sub $t8, $t8, $t3			# calc inverse of y-paddings
	blt $t7, $t8, i_col_loop		# jump to i_col_loop if y-diff < y-paddings
	
	
	# get product of v-speeds
	# $s6=&obj_info; $t3=product; $t4=v-speed;
	lh $t3, 6($s6)
	mult $t3, $t4
	mflo $t3				# calc product of v-speeds 
	
	# swap v-speed (of other rock)
	# $s6=&obj_info; $t7=v-speed; $t8=temp;
	lh $t7, 6($s6)				
	sll $t8, $t7, 1
	sub $t7, $t7, $t8
	sh $t7, 6($s6)				# calc inverse of v-speed (and set it)
	# check if same direction
	# $t3=product;
	bgtz $t3, invalid_pos
	# swap v-speed (of current rock)
	# $t3=temp; $t4=v-speed;
	sll $t3, $t4, 1
	sub $t4, $t4, $t3
	sh $t4, 6($s3)				# calc inverse of v-speed (and set it)
	
	# update current rock's y-coord
	# $t2=new y-coord; $t3=copy of $t2; $t4=v-speed; $t6=y-padding;
	lh $t2, 2($s3)
	add $t2, $t2, $t4
	add $t3, $t2, $zero
	
	bgtz $t4, pos3
	sub $t3, $t3, $t6
	j e_pos3
pos3:
	add $t3, $t3, $t6
e_pos3:
	# check if it collides past the borders
	# $t3=$t2 (but with padding);
	bltz $t3, invalid_pos
	bge $t3, HEIGHT, invalid_pos
	# get new y-diff then new y-paddings 
	# $s6=&obj_info; $s7=&obj_type; $t6=y-padding; $t7=y-diff; $t8=y-paddings;
	lh $t7, 2($s6)
	sub $t7, $t2, $t7			# calc new y-diff
	lw $t8, 16($s7)				
	add $t8, $t8, $t6			# calc sum of y-paddings
	# check if there's still vertical collision
	# $t1=new x-coord; $t3=temp; $t7=y-diff; $t8=y-paddings;
	bgt $t7, $t8, i_col_loop
	sll $t3, $t8, 1
	sub $t8, $t8, $t3
	blt $t7, $t8, i_col_loop
invalid_pos:
	addi $t1, $zero, -1
	j d_obj
	
	
i_col_loop:
	# increment index and &obj_arr
	# $s5=&obj_arr; $t9=index;
	addi $s5, $s5, 4
	addi $t9, $t9, 4
e_col_loop: bne $t9, 24, col_loop
	
d_obj:
	# cover the old
	# $s1=&obj_arr; $s3=temp (&obj_type AND &obj_info);
	# $t0=index; $t1=new x-coord; $t2=new y-coord; $t3=temp;
	addi $sp, $sp, -8		
	sh $t1, 0($sp)
	sh $t2, 2($sp)
	sw $t0, 4($sp)
	
	lw $a0, 0($s1)
	addi $a1, $zero, BG_COLOR
	lh $a2, 0($s3)
	lh $a3, 2($s3)
	jal draw
	
	lh $t1, 0($sp)
	lh $t2, 2($sp)
	addi $sp, $sp, 4
	sh $t1, 0($s3)
	sh $t2, 2($s3)
	beq $t1, -1, i_obj
	
	# and paint with the new
	lw $a0, 0($s1)
	lw $a1, 0($s4)
	addi $a2, $t1, 0
	addi $a3, $t2, 0
	jal draw
i_obj:
	lw $t0, 0($sp)
	addi $sp, $sp, 4
	addi $s1, $s1, 4		# update obj_arr pointer
	addi $t0, $t0, 4
e_obj: bne $t0, 24, update_obj
	
	
update_ship:
	# store x-y coords
	# $s0=&ship; $t0=x-coord; $t1=y-coord; $t2=temp;
	lw $t2, 4($s0)
	lh $t0, 0($t2)
	lh $t1, 2($t2)
	# $t0=x-coord; $t1=y-coord; $t2=new x-coord; $t3=new y-coord;
	addi $t2, $t0, 0
	addi $t3, $t1, 0

	# get input
	# $s3=keystroke_val;
	li $s3, KEYSTROKE
	lw $s3, 0($s3)			# get keystroke-event value
	bne $s3, 1, draw_ship		# ensure that user did input something, otherwise jump to e_i
	li $s3, KEYSTROKE
	lw $s3, 4($s3)			# get ASCII user input
	

	# check to ensure input was valid
	# $s3=keystroke_val; $t0=old-x-coord; $t1=old-y-coord; $t2=new-x-coord; $t3=new-y-coord;
	beq $s3, 119, W			# input was W
	beq $s3, 115, S			# input was S
	beq $s3, 97, A			# input was A
	beq $s3, 100, D			# input was D
	j draw_ship			# input was INVALID

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
	
	# with differences, set it AND redraw it (otherwise, don't redraw)
	# $s0=&ship; $s1=temp; $s2=temp; $s5=old-pos;
	addi $sp, $sp, -8
	sw $t2, 0($sp)
	sw $t3, 4($sp)
	
	addi $a0, $s0, 0
	li $a1, BG_COLOR
	addi $a2, $t0, 0
	addi $a3, $t1, 0
	jal draw
	
	lw $t2, 0($sp)
	lw $t3, 4($sp)
	addi $sp, $sp, 8
	
draw_ship:
	
	addi $sp, $sp, -8
	sw $t2, 0($sp)
	sw $t3, 4($sp)
	# $s0=&ship; $s1=temp; $s2=temp; $s3=new-pos; $t7=temp;
	addi $a0, $s0, 0
	lw $t7, 0($a0)
	lw $a1, 0($t7)
	addi $a2, $t2, 0
	addi $a3, $t3, 0
	jal draw
	
	lw $t2, 0($sp)
	lw $t3, 4($sp)
	addi $sp, $sp, 8
	
	lw $t7, 4($s0)
	sh $t2, 0($t7)
	sh $t3, 2($t7)
e_ship:
	
	# sleep
	li $v0, 32
	li $a0, 40
	syscall
	j game_loop

# END-SCREEN
	li $v0, 10			# gracefully terminate the program (with grace)
	syscall



# FUNC PARAM	: $a0=&obj; $a1=color; $a2=x-coord; $a3=y-coord;
# LOCAL REG 	: $t0=&obj_offset; $t1=index; $t2=upper_bound; $t3=obj.pos; $t4=temp; $t5=temp;
draw:
	# calc obj.pos
	sll $t3, $a3, 6
	add $t3, $t3, $a2
	sll $t3, $t3, 2
	# get obj_offset
	lw $t4, 0($a0)
	lw $t0, 8($t4)
	# get upper bound
	lw $t4, 0($a0)
	lw $t2, 4($t4)
	# set index
	addi $t1, $zero, 0
	
draw_loop:
	# get address
	lh $t4, 0($t0)
	addi $t5, $zero, BASE_ADDRESS
	add $t5, $t5, $t3
	add $t5, $t5, $t4		# calc (BASE_ADDRESS + obj.pos + obj_offset[i])
	# paint
	sw $a1, 0($t5)
	# update
	addi $t0, $t0, 2
	addi $t1, $t1, 2
	bne $t1, $t2, draw_loop		# jump to draw_loop until index is the upper bound
	
	jr $ra






	

	# THIS IS WHERE YOU CHECK FOR SHIP COLLISION AND THAT WILL BE ANOTHER THING
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










