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
# - Milestone 1, 2, 3, 4 have been reached in this submission
# Which approved features have been implemented for milestone 4?
# (See the assignment handout for the list of additional features)
# 1. the ability to shoot (f)
# 2. difficult or surprising ROCKS (e)
# 3. scoring system (c)
# ... (add more if necessary)
#
# Link to video demonstration for final submission:
# - (insert YouTube / MyMedia / other URL here). Make sure we can view it!
#
# Are you OK with us sharing the video with people outside course staff?
# - yes / no / yes, and please share this project github link as well!
# yes, and please share this project github link as well:
# 
# Any additional information that the TA needs to know:
# - (write here, if any)
# 
#####################################################################

.data
# structure of the SHIP
# [ship]		.word		[ship_type] [ship_info]
# [ship_info]		.half		[x-coord] [y-coord] [health] 
# [ship_type]		.word		[color] [sizeof offset_arr] [address of offset_arr] 
# [ship_offset]		.half		[offsets]
ship:			.word		0 0 
ship_info:		.half		15 15 2 2 10
ship_type:		.word		0x4a4a4a 10 0 
ship_offset:		.half		-260 0 4 252 256
# structure of every ROCK and ROCK_INFO
# [r#] 			.word 		[address of some ROCK-TYPE] [address of ROCK-INFO]
# [r#_info]		.half		[x-coord] [y-coord] [h-speed] [v-speed] 
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
# structure of every ROCK_TYPE
# [x_rock]		.word		[color] [sizeof offset_arr] [address of offset_arr] [x-padding] [y-padding]
# [x_offset]		.half		[offsets]
s_rock:			.word 		0xe86691 10 0 -1 1
s_rock_offset:		.half		-256 -4 0 4 256
m_rock:			.word		0xe8d964 18 0 -1 1 
m_rock_offset:		.half		-260 -256 -252 -4 0 4 252 256 260
b_rock:			.word		0x63bfdb 74 0 -3 3 
b_rock_offset:		.space		74
b_rock_dec:		.half		-12, 12, -244, 244, -268, 268, -764, -768, -772, 764, 768, 772

# storage
# ARRAY OF ROCK-TYPE
type_arr:		.word		0 0 0
# ARRAY OF ROCKS
obj_arr:		.word 		0 0 0 0 0 0 0 0
# ARRAY OF BULLETS?

# UI
# structure of HEALTH BAR
# [obj]				.word		[current y-index] [size of offset array (in bytes)] [address of offset array]
# [obj_offset]			.space		[offset space amount]
health:				.word		1 120 0 
health_offset:			.space		120


.text
# canvas/framebuffer-related CONSTANTS
.eqv BASE_ADDRESS 0x10008000
.eqv BG_COLOR 0xfcfcfc
# keyboard-related CONSTANTS
.eqv KEYSTROKE 0xffff0000
# ship-related CONSTANTS
.eqv SHIP_BASE_COLOR 0x4a4a4a
# health-related CONSTANTS
.eqv HEALTH_DAM 0xff3d3d
.eqv HEALTH_FILL 0x5c5c5c
.eqv HEALTH_GAP 0xcfcfcf

.globl main
main:
awake: # .data-related variables are initialized HERE
	# initialize SHIP
	# $s0=&ship; $s1=&ship_info; $s2=&ship_type; $s3=&ship_offset;
	la $s0, ship
	la $s1, ship_info
	la $s2, ship_type
	la $s3, ship_offset		# get SHIP variables
	
	sw $s3, 8($s2)
	sw $s2, 0($s0)
	sw $s1, 4($s0)			# connect each other
	# initialize HEALTH_BAR
	# $s1=&health_offset; $s2=&health; $t0=index;
	la $s2, health
	la $s1, health_offset		# get HEALTH variables
	sw $s1, 8($s2)			# connect each other
	
	addi $t0, $zero, 0		# initialize index
health_loop:
	sh $t0, 0($s1)			# calc and set each group of 6 offset pixels
	addi $t0, $t0, 4		# onto health_offset
	sh $t0, 2($s1)
	addi $t0, $t0, 252
	sh $t0, 4($s1)
	addi $t0, $t0, 4
	sh $t0, 6($s1)
	addi $t0, $t0, 252
	sh $t0, 8($s1)
	addi $t0, $t0, 4
	sh $t0, 10($s1)
	addi $t0, $t0, 252
	
	addi $s1, $s1, 12		# shift health_offset to the next 12 bytes of space
e_hl:	bne $t0, 7680, health_loop	# jump to health_loop if health_offset not yet fully initialized 
	# initialize ROCK_TYPES and TYPE_ARR
	# $s1=&rock_type; $s2=&type_arr; $s3=&rock_offset;
	la $s2, type_arr		# get type_arr
	
	la $s3, s_rock_offset
	la $s1, s_rock
	sw $s3, 8($s1)			# store s_rock_offset in s_rock
	sw $s1, 0($s2)			# store s_rock in type_arr
	la $s3, m_rock_offset
	la $s1, m_rock
	sw $s3, 8($s1)			# store m_rock_offset in m_rock
	sw $s1, 4($s2)			# store m_rock in type_arr
	la $s3, b_rock_offset
	la $s1, b_rock
	sw $s3, 8($s1)			# store b_rock_offset in b_rock
	sw $s1, 8($s2)			# store b_rock in type_arr
	# initialize B_ROCK_OFFSET
	# $s3=&b_rock_offset; $t0=index;
	li $t0, -520			# set index
rock_loop:
	sh $t0, 0($s3)			# calc and set each group of 5 offset pixels 
	addi $t0, $t0, 4		# onto b_rock_offset
	sh $t0, 2($s3)
	addi $t0, $t0, 4
	sh $t0, 4($s3)
	addi $t0, $t0, 4
	sh $t0, 6($s3)
	addi $t0, $t0, 4
	sh $t0, 8($s3)
	addi $t0, $t0, 4
	
	addi $s3, $s3, 10		# shift b_rock_offset to the next 10 bytes of space
	addi $t0, $t0, 236		# update index
e_rl:	bne $t0, 760, rock_loop		# jump to rock_loop if b_rock_offset is not yet fully initialized
	# initialize B_ROCK_DEC onto B_ROCK_OFFSET
	# $s3=&b_rock_offset; $s4=&b_rock_dec; $s5=b_rock_dec[i]; $t0=index;
	la $s4, b_rock_dec		# get b_rock_dec
	add $t0, $zero, $zero		# set index
rock_dec_loop:
	lh $s5, 0($s4)			# transfer each group of 4 offset elements from b_rock_dec
	sh $s5, 0($s3)			# onto b_rock_offset
	lh $s5, 2($s4)
	sh $s5, 2($s3)
	lh $s5, 4($s4)
	sh $s5, 4($s3)
	lh $s5, 6($s4)
	sh $s5, 6($s3)
	
	addi $s3, $s3, 8		# shift b_rock_offset to the next 8 bytes of space
	addi $s4, $s4, 8		# shift b_rock_dec to the next 8 bytes of space
	addi $t0, $t0, 8		# update index
e_rdl:	bne $t0, 24, rock_dec_loop	# jump to rock_loop if b_rock_dec is not yet fully transfered to b_rock_offset
	# initialize ROCK & ROCK_INFO & OBJ_ARR
	# $s1=&obj_arr; $s3=&rock_info; $s4=&rock;
	la $s1, obj_arr
	
	la $s3, r0_info
	la $s4, r0
	sw $s3, 4($s4)			# store rock_info onto rock
	sw $s4, 0($s1)			# store rock onto obj_arr
	la $s3, r1_info
	la $s4, r1
	sw $s3, 4($s4)			# store rock_info onto rock
	sw $s4, 4($s1)			# store rock onto obj_arr
	la $s3, r2_info
	la $s4, r2
	sw $s3, 4($s4)			# store rock_info onto rock
	sw $s4, 8($s1)			# store rock onto obj_arr
	la $s3, r3_info
	la $s4, r3
	sw $s3, 4($s4)			# store rock_info onto rock
	sw $s4, 12($s1)			# store rock onto obj_arr
	la $s3, r4_info
	la $s4, r4
	sw $s3, 4($s4)			# store rock_info onto rock
	sw $s4, 16($s1)			# store rock onto obj_arr
	
	
start: # the scene will be set HERE
	# draw CANVAS
	# $s0=base_addr; $s1=canvas_color; $s2=row_i; $s3=col_i; $s4=A[i][j] (where A is the framebuffer)
	# $s3=base_addr; $s4=canvas_color; $s5=frame_buffer[i][j]; $t0=row_i; $t1=col_i; 
	li $s3, BASE_ADDRESS		# get frame_buffer address
	li $s4, BG_COLOR		# get color of the canvas
	addi $t0, $zero, 0		# set index (for row_loop)
canvas_row_loop:
	addi $t1, $zero, 0		# set index (for col_loop)
canvas_col_loop:
	add $s5, $s3, $t1		# get address of frame_buffer that's a multiple of 16
	sw $s4, 0($s5)			# paint each group of 16 pixels
	sw $s4, 4($s5)
	sw $s4, 8($s5)
	sw $s4, 12($s5)
	sw $s4, 16($s5)
	sw $s4, 20($s5)
	sw $s4, 24($s5)
	sw $s4, 28($s5)
	sw $s4, 32($s5)
	sw $s4, 36($s5)
	sw $s4, 40($s5)
	sw $s4, 44($s5)
	sw $s4, 48($s5)
	sw $s4, 52($s5)
	sw $s4, 56($s5)
	sw $s4, 60($s5)
	
	addi $t1, $t1, 64		# update address to next group of 16 pixels
e_ccl:	bne $t1, 256, canvas_col_loop	# jump to col_loop if address of frame_buffer has not reached edge of the canvas yet
	
	addi $s3, $s3, 256		# update the address to the next row
	addi $t0, $t0, 1		# increment the index
e_crl:	bne $t0, 32, canvas_row_loop	# jump to row_loop if canvas has not been completely painted
	# draw HEALTH_BAR
	# $s3=health; $t0=temp;
	la $s3, health			# get health
	addi $a0, $s3, 0
	li $a1, HEALTH_FILL
	li $a2, 61
	li $a3, 1			
	jal draw			# pass function-param (via registers) and call draw
	li $t0, 12
	sw $t0, 4($s3)			# set new y-index in health
	# draw SHIP
	# $s0=&ship; $t0=temp; $t1=temp;
	lw $a0, 0($s0)			# get &ship_type
	li $a1, SHIP_BASE_COLOR		
	lw $t0, 4($s0)
	lh $t1, 0($t0)
	addi $a2, $t1, 0		
	lh $t1, 2($t0)
	addi $a3, $t1, 0		
	jal draw			# pass function-param (via registers) and call draw
	
	
update: # the game begins from HERE
	# $s0=&ship; $s1=&obj_arr; $s2=&type_arr; 
game_loop:
	# update ROCKS (instantiation | position | collision | destruction | display)
	# $s1=&obj_arr; $t0=index;
	la $s1, obj_arr			# get &obj_arr
	add $t0, $zero, $zero		# set index
update_obj:
	# setup update_obj
	# $s1=&obj_arr; $s3=&obj_info; $s4=&obj_type;
	lw $s3, 0($s1)
	lw $s4, 0($s3)
	lw $s3, 4($s3)
	# does this rock exist?
	# $s3=&obj_info; $t1=x-coord; $t2=y-coord; $t3=h-speed; $t4=v-speed;
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
	li $a1, 7
	syscall
	addi $t1, $a0, 50		# generate a random INT from 50-56 (inclusive)
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
	addi $t4, $a0, -2		# generate a random INT from (-2)-(2) (inclusive)
	sh $t4, 6($s3)			# store it in obj_arr[i].obj_info.v_speed
	
rock_exists:
	# get NEW and VALID coords
	# get paddings
	# $s4=&obj_type; $t5=x-padding; $t6=y-padding;
	lw $t5, 12($s4)			# get x-padding
	lw $t6, 16($s4)			# get y-padding
	# calc new coords 
	# $s3=&obj_info; $s4=&obj_type; $t1=x-coord; $t2=y-coord; $t3=h-speed; $t4=v-speed;
	add $t1, $t1, $t3		# add h-speed
	add $t2, $t2, $t4		# add v-speed
	# calc new x-coord + x-padding (x-combined)	
	# calc v-speed + y-padding (y-combined)
	# $t1=new x-coord; $t4=v-speed; $t5=x-padding; $t6=y-padding; $t7=x-combined; $t8=y-combined; $t9=temp;
	add $t7, $t1, $t5		# x-combined
	add $t8, $t4, $zero		
	bgtz $t4, pos1
	sll $t8, $t4, 1
	sub $t8, $t4, $t8
pos1:
	add $t8, $t8, $t6
	bgtz, $t4, pos2
	sll $t9, $t8, 1
	sub $t8, $t8, $t9
pos2:					# y-combined
	# verify y-coord is valid
	# $s3=&obj_info; $t8=y-combined; $t9=new y-coord (with padding);
	lh $t9, 2($s3)
	add $t9, $t9, $t8		# calc new y-coord with padding
	bltz $t9, top1			# jump to top1 if new y-coord is invalid
	bge $t9, 32, bottom1		# jump to bottom1 if new y-coord is invalid
	j left				# jump to left because new y-coord is valid
top1:
	# update so it stays on screen
	# $t2=new y-coord; $t6=y-padding;
	add $t2, $t6, $zero		# calc new (valid) y-coord
	j swap				# jump to swap to switch v-speed signs
bottom1:
	# update so it stays on screen
	# $t2=new y-coord; $t6=y-padding;
	addi $t2, $zero, 31
	sub $t2, $t2, $t6		# calc new (valid) y-coord
swap:
	# change v-speed direction
	# $s3=&obj_info; $t4=new v-speed; $t9=temp;
	sll $t9, $t4, 1
	sub $t4, $t4, $t9
	sh $t4, 6($s3)			# calc and set inverse v-speed in &obj_info
left:	
	# verify x-coord is valid
	# $t7=x-combined;
	bgez $t7, s_np			# jump to s_np if x-combined is non-negative
	
	# indicate that this ROCK is set for removal
	# $t1=new x-coord;
	addi $t1, $zero, -1
	j d_obj				# jump to d_obj with invalid x-coord (preventing it from being redrawn)
s_np:	
	
ship_col:
	# verify if NEW and VALID coords don't collide with the SHIP
	# get x-y diff
	# $s0=&ship; $s3=&obj_info; $s5=x-diff; $s6=y-diff; $t7=ship x-coord; $t8=ship y-coord; $t9=temp;
	lw $t9, 4($s0)			
	lh $t7, 0($t9)			# get ship x-coord
	lh $t8, 2($t9)			# get ship y-coord
	
	lh $t9, 0($s3)			# get old x-coord
	sub $s5, $t7, $t9		# calc x-diff
	lh $t9, 2($s3)			# get old y-coord
	sub $s6, $t8, $t9		# calc y-diff
	# get x-paddings
	# $t5=x-padding; $t9=x-paddings; 
	addi $t9, $t5, -1		# combine x-paddings (ship padding is hardcoded)
	# check for horizontal collision
	# $s5=x-diff; $s7=temp; $t9=combined-padding; 
	blt $s5, $t9, e_ship_col	# jump to e_sc if no horizontal collision
	sll $s7, $t9, 1
	sub $t9, $t9, $s7		# get inverse of combined-padding
	bgt $s5, $t9, e_ship_col	# jump to e_sc if no horizontal collision
	# get y-paddings
	# $t6=y-padding; $t9=y-paddings; 
	addi $t9, $t6, 1		# combine y-paddings (ship padding is hardcoded)
	# check for vertical collision
	# $s6=y-diff; $s7=temp; $t9=combined-padding;
	bgt $s6, $t9, e_ship_col	# jump to e_sc if no vertical collision
	sll $s7, $t9, 1
	sub $t9, $t9, $s7		# get inverse of combined-padding
	blt $s6, $t9, e_ship_col	# jump to e_sc if no vertical collision

	# if you've made it this far, it did collide
	# decrement ship-health
	# $s0=&ship; $s5=ship-health; $t3=temp;
	lw $t3, 4($s0)
	lh $s5, 8($t3)			# get ship-health
	addi $s5, $s5, -1		# decrement ship-health
	sh $s5, 8($t3)			# set ship-health
	# preserve $t0 - $t2
	# $t0=index; $t1=new x-coord; $t2=new y-coord;
	addi $sp, $sp, -8
	addi $t1, $zero, -1		# set new x-coord = -1
	sh $t1, 0($sp)
	sh $t2, 2($sp)
	sw $t0, 4($sp)			# store registers $t0 - $t2 in the STACK
	# update the bar
	# $s7=&health;
	la $s7, health
	addi $a0, $s7, 0
	li $a1, HEALTH_DAM
	li $a2, 61
	lw $a3, 0($s7)
	jal draw			# pass function-param (via registers) and call draw
	# do a slight pause
	li $v0, 32
	li $a0, 350
	syscall
	# change it back 
	addi $a0, $s7, 0
	li $a1, HEALTH_GAP
	li $a2, 61
	lw $a3, 0($s7)
	addi $t3, $a3, 3
	sw $t3, 0($s7)			# calc and set new y-coord in HEALTH
	jal draw			# pass function-param (via registers) and call draw
	# check if it's gg
	# $s5=ship-health;
	beqz $s5, end
	# jump if it aint
	j d_ship_col			# jump to d_ship_col if it's not gameover yet
e_ship_col:
	beqz $t4, d_obj			# jump to d_obj if v-speed is 0
	
	# verify if NEW and VALID coords don't collide with other ROCKS
	# $s5=&obj_arr; $t9=index;
	la $s5, obj_arr
	li $t9, 0
col_loop:
	# setup col_loop
	# $s5=&obj_arr; $s6=&obj_info; $s7=&obj_type;
	lw $s7, 0($s5)
	lw $s6, 4($s7)			# get &obj_info
	lw $s7, 0($s7)			# get &obj_type
	# make sure it's not the same rock
	# $s1=&obj_arr; $s5=&obj_arr; $t7=temp;
	sub $t7, $s1, $s5		# calc diff of &obj_arr's
	beqz $t7, i_col_loop		# jump to i_col_loop if diff is 0 (the same rock)
	
	# get x-coords then x-diff then x-padding
	# $s6=&obj_info; $t7=x-coord; 
	lh $t7, 0($s6)			# get x-coord
	beq $t7, -1, i_col_loop		# jump to i_col_loop if x-coord is -1
	# $t1=new x-coord; $t7=x=coord; 
	sub $t7, $t1, $t7		# calc x-diff
	# $s7=&obj_type; $t5=x-padding; $t8=x-paddings;
	lw $t8, 12($s7)			# get x-padding
	add $t8, $t8, $t5		# calc sum of x-paddings
	# check for horizontal collision
	# $t3=temp; $t7=x-diff; $t8=x-paddings;
	blt $t7, $t8, i_col_loop	# jump to i_col_loop if x-diff < x-paddings
	sll $t3, $t8, 1			
	sub $t8, $t8, $t3		# calc inverse of x-paddings
	bgt $t7, $t8, i_col_loop	# jump to i_col_loop if x-diff > x-paddings
	# get y-coords then y-diff then y-padding
	# $s6=&obj_info; $s7=&obj_type; $t7=y-coord; $t8=y-paddings
	lh $t7, 2($s6)			# get y-coord
	sub $t7, $t2, $t7		# calc y-diff
	lw $t8, 16($s7)			# get y-padding
	add $t8, $t8, $t6		# calc sum of y-paddings
	# check for vertical collision
	# $t3=temp; $t7=y-diff; $t8=y-paddings;
	bgt $t7, $t8, i_col_loop	# jump to i_col_loop if y-diff > y-paddings
	sll $t3, $t8, 1
	sub $t8, $t8, $t3		# calc inverse of y-paddings
	blt $t7, $t8, i_col_loop	# jump to i_col_loop if y-diff < y-paddings
	
	
	# get product of v-speeds
	# $s6=&obj_info; $t3=product; $t4=v-speed;
	lh $t3, 6($s6)
	mult $t3, $t4
	mflo $t3			# calc product of v-speeds 
	
	# swap v-speed (of other rock)
	# $s6=&obj_info; $t7=v-speed; $t8=temp;
	lh $t7, 6($s6)				
	sll $t8, $t7, 1
	sub $t7, $t7, $t8
	sh $t7, 6($s6)			# calc inverse of v-speed (and set it)
	# check if same direction
	# $t3=product;
	bgtz $t3, invalid_pos
	# swap v-speed (of current rock)
	# $t3=temp; $t4=v-speed;
	sll $t3, $t4, 1
	sub $t4, $t4, $t3
	sh $t4, 6($s3)			# calc inverse of v-speed (and set it)
	
	# update current rock's y-coord
	# $t2=new y-coord; $t3=copy of $t2; $t4=v-speed; $t6=y-padding;
	lh $t2, 2($s3)
	add $t2, $t2, $t4			
	add $t3, $t2, $zero		# get new y-coord and make it double (have an extra copy)
	
	bgtz $t4, pos3			# add/sub y-padding to the copy (depending on sign)
	sub $t3, $t3, $t6
	j e_pos3
pos3:
	add $t3, $t3, $t6
e_pos3:
	# check if it collides past the borders
	# $t3=$t2 (but with padding);
	bltz $t3, invalid_pos		# jump to invalid_pos if too high
	bge $t3, 32, invalid_pos	# jump to invalid_pos if too low
	# get new y-diff then new y-paddings 
	# $s6=&obj_info; $s7=&obj_type; $t6=y-padding; $t7=y-diff; $t8=y-paddings;
	lh $t7, 2($s6)
	sub $t7, $t2, $t7		# calc new y-diff
	lw $t8, 16($s7)				
	add $t8, $t8, $t6		# calc sum of y-paddings
	# check if there's still vertical collision
	# $t1=new x-coord; $t3=temp; $t7=y-diff; $t8=y-paddings;
	bgt $t7, $t8, i_col_loop	# jump to i_col_loop if vertical collision is gone
	sll $t3, $t8, 1
	sub $t8, $t8, $t3
	blt $t7, $t8, i_col_loop	# jump to i_col_loop if vertical collision is gone
invalid_pos:
	addi $t1, $zero, -1		# indicate that this ROCK is set for removal
	j d_obj				# jump to d_obj because there's no point in checking other collisions if it's still stuck like this
	
	
i_col_loop:
	# increment index and &obj_arr
	# $s5=&obj_arr; $t9=index;
	addi $s5, $s5, 4		# shift obj_arr to the next element
	addi $t9, $t9, 4		# increment index
e_col_loop: bne $t9, 20, col_loop	# jump to col_loop if not yet gone through whole obj_arr
	
d_obj:
	# preserve $t0 - $t2 registers
	# $t0=index; $t1=new x-coord; $t2=new y-coord; $t3=temp;
	addi $sp, $sp, -8		
	sh $t1, 0($sp)
	sh $t2, 2($sp)
	sw $t0, 4($sp)			# store registers $t0 - $t2 in the STACK

d_ship_col:
	# cover the old
	# $s3=&obj_info; $s4=&obj_type;
	addi $a0, $s4, 0
	addi $a1, $zero, BG_COLOR
	lh $a2, 0($s3)
	lh $a3, 2($s3)
	jal draw			# pass function-param (via registers) and call draw
	
	# retrieve and set the preserved registers
	# $s3=&obj_info; $t1=new x-coord; $t2=new y-coord; 
	lh $t1, 0($sp)
	lh $t2, 2($sp)			# get registers $t1, $t2
	addi $sp, $sp, 4		
	sh $t1, 0($s3)			
	sh $t2, 2($s3)			# set registers into &obj_info
	beq $t1, -1, i_obj		# check if x-coord is VALID (otherwise, jump to i_obj)
	
	# and paint with the new
	# $s4=&obj_type; $t1=new x-coord; $t2=new y-coord; 
	addi $a0, $s4, 0		
	lw $a1, 0($s4)
	addi $a2, $t1, 0
	addi $a3, $t2, 0
	jal draw			# pass function-param (via registers) and call draw
i_obj:
	lw $t0, 0($sp)
	addi $sp, $sp, 4		# get register $t0
	addi $s1, $s1, 4		# shift obj_arr to the next element
	addi $t0, $t0, 4		# update index
e_obj: bne $t0, 20, update_obj		# jump to update_obj if not yet gone through whole obj_arr
	
	
update_ship:
	# store x-y coords (and more!)
	# $s0=&ship; $s3=&ship_info; $s4=&ship_type; $t0=x-coord; $t1=y-coord;
	lw $s3, 4($s0)			# get &ship_info
	lw $s4, 0($s0)			# get &ship_type
	lh $t0, 0($s3)			# get ship x-coord
	lh $t1, 2($s3)			# get ship y-coord
	# $t0=x-coord; $t1=y-coord; $t2=new x-coord; $t3=new y-coord;
	addi $t2, $t0, 0		# initialize new ship x-coord
	addi $t3, $t1, 0		# initialize new ship y-coord

	# check and get input
	# $s5=keystroke_val; $s6=temp;
	li $s5, KEYSTROKE
	lw $s6, 0($s5)			# get keystroke-event value
	bne $s6, 1, draw_ship		# ensure that user did input something, otherwise jump to draw_ship
	lw $s5, 4($s5)			# get ASCII user input

	# determine what the input was
	# $s3=keystroke_val; $t0=old-x-coord; $t1=old-y-coord; $t2=new-x-coord; $t3=new-y-coord;
	beq $s5, 119, W			# input was W
	beq $s5, 115, S			# input was S
	beq $s5, 97, A			# input was A
	beq $s5, 100, D			# input was D
	beq $s5, 112, P			# input was P
	# input was i
	j draw_ship			# input was INVALID

	# $t0=x-coord; $t1=y-coord; $t2=new x-coord; $t3=new y-coord;
W:	addi $t3, $t1, -2		# calc new-y-coord with padding 
	bge $t3, 1, s_i 		# if invalid, go to vertical-lower-bound
	addi $t3, $zero, 1
	j s_i				
S:	addi $t3, $t1, 2		# calc new-y-coord with padding 
	ble $t3, 30, s_i		# if invalid, go to vertical-upper-bound
	addi $t3, $zero, 30
	j s_i
A:	addi $t2, $t0, -2		# calc new-x-coord with padding
	bge $t2, 1, s_i 		# if invalid, go to horizontal-lower-bound
	addi $t2, $zero, 1		# remove padding
	j s_i
D:	addi $t2, $t0, 2		# calc new-x-coord with padding
	blt $t2, 58, s_i		# if invalid, got horizontal-upper-bound
	addi $t2, $zero, 58		# remove padding
	j s_i
P:	
	# reset SHIP_HEALTH
	# $t0=MAX health; $s3=&ship_info;
	addi $t0, $zero, 10
	sh $t0, 8($s3)			# init and set MAX-health in SHIP
	# reset SHIP_POS
	# $s3=&ship_info; $t0=x-coord; $t1=y-coord;
	addi $t0, $zero, 15
	addi $t1, $zero, 15		# init values for SHIP_INFO
	sh $t0, 0($s3)
	sh $t1, 2($s3)			# set values for SHIP_INFO
	# reset HEALTH_BAR
	# $s7=&health; $t0=temp; $t1=temp;
	la $s7, health
	addi $t0, $zero, 1
	addi $t1, $zero, 120		# init values for HEALTH_BAR
	sw $t0, 0($s7)
	sw $t1, 4($s7)			# set values for HEALTH_BAR
	# reset ROCK_X-COORD
	# $s1=&obj_arr; $s3=&obj_info; $t0=index; $t1=temp;
	la $s1, obj_arr			# get &obj_arr
	addi $t0, $zero, 0		# set index
	addi $t1, $zero, -1		# set new VAL
rock_reset_loop:
	lw $s3, 0($s1)
	lw $s3, 4($s3)
	sh $t1, 0($s3)			# set new VAL to obj's x-coord
	
	addi $t0, $t0, 4		# increment index
	addi $s1, $s1, 4		# shift obj_arr to the next element
e_rrl:	bne $t0, 20, rock_reset_loop	# jump to rock_reset_loop if not yet gone through the whole obj_arr 
	j start				# jump to start (after everything has been initialized, but before the canvas was made)
I:
s_i:
	
erase_ship:
	# preserve registers $t2, $t3
	# $s0=&ship; $s1=temp; $s2=temp; $s5=old-pos;
	addi $sp, $sp, -4
	sh $t2, 0($sp)			
	sh $t3, 2($sp)			# store registers $t2, $t3 in the STACK
	
	# cover the old
	# $s0=&ship; $t0=old ship x-coord; $t1=old ship y-coord;
	lw $a0, 0($s0)
	addi $a1, $zero, BG_COLOR
	addi $a2, $t0, 0
	addi $a3, $t1, 0
	jal draw			# pass function-param (via registers) and call draw
	
	lh $t2, 0($sp)			
	lh $t3, 2($sp)			# get preserved registers
	sh $t2, 0($s3)			
	sh $t3, 2($s3)
	addi $sp, $sp, 4		# set preserved registers in SHIP_INFO
	
draw_ship:
	# and paint with the new
	# $s0=&ship; $s1=temp; $s2=temp; $s3=new-pos; $t7=temp;
	lw $a0, 0($s0)
	lw $a1, 0($s4)
	addi $a2, $t2, 0
	addi $a3, $t3, 0
	jal draw			# pass function-param (via registers) and call draw
e_ship:
	
	# sleep 
	li $v0, 32
	li $a0, 40
	syscall
	j game_loop			# jump back to game_loop because we're not done yet

end: # the curtains fall as we finish... ENCORE?
# END-SCREEN
	li $v0, 10			# gracefully terminate the program (with grace)
	syscall



# FUNC PARAM	: $a0=&obj_type; $a1=color; $a2=x-coord; $a3=y-coord;
# LOCAL REG 	: $t0=&obj_offset; $t1=index; $t2=upper_bound; $t3=obj.pos; $t4=temp; $t5=temp;
draw:
	# calc obj.pos
	sll $t3, $a3, 6
	add $t3, $t3, $a2
	sll $t3, $t3, 2
	# get obj_offset
	lw $t0, 8($a0)
	# get upper bound
	lw $t2, 4($a0)
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

