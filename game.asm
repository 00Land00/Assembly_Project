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
# - The pixel-font digits I used in this game are not my own creation,
#   they are made by a user that goes by 'vyznev'.
#
#   https://www.fontstruct.com/fontstructions/show/1404171/cg-pixel-4x5 
#
#   The link above takes you directly to the spritesheet where I found it. 
#   The pixel-font is licensed under the CC0 / public-domain.
#
# - I'am Frakenstein and this is my monster. Please handle with care <3
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
# structure of every BULLET 
# [b#]			.half		[x-coord] [y-coord] [h-speed]
b1:			.half		-1 0 2
b2:			.half		-1 0 2
b3:			.half 		-1 0 2

# storage
# ARRAY OF ROCK-TYPE
type_arr:		.word		0 0 0
# ARRAY OF ROCKS
obj_arr:		.word 		0 0 0 0 0 0 0 0
# ARRAY OF BULLETS
bullet_arr:		.word		0 0 0

# UI
# structure of HEALTH BAR
# [health]		.word		[current y-index] [sizeof offset_arr] [address of offset_arr]
# [health_offset]	.space		[offset space amount]
health:			.word		1 120 0 
health_offset:		.space		120
# SCORE (holds the score)
score:			.half		0
# ARRAY OF digits
score_arr:		.word		0 0 0 0 0 0 0 0 0 0
# structure of SCORE TYPE
# [s#_type]		.word		[color] [sizeof offset_arr] [address of offset_arr]
s0:			.word		0x7b56c7 24 0
s1:			.word		0x7b56c7 12 0		
s2:			.word		0x7b56c7 20 0
s3:			.word		0x7b56c7 20 0
s4:			.word		0x7b56c7 20 0
s5:			.word		0x7b56c7 24 0
s6:			.word		0x7b56c7 20 0
s7:			.word		0x7b56c7 16 0
s8:			.word		0x7b56c7 20 0
s9:			.word		0x7b56c7 20 0
# structure of these digits ARE BASED ON THE PIXEL-FONT I LINKED IN THE ADDITIONAL NOTES OF THE PREAMBLE (the pivot is at the top-left corner)
s0_offset:		.half		4 8 256 264 268 512 516 524 768 780 1028 1032 1036
s1_offset:		.half		8 260 264 520 776 1032
s2_offset:		.half		4 8 256 268 520 772 1024 1028 1032 1036
s3_offset:		.half		0 4 8 268 516 520 780 1024 1028 1032
s4_offset:		.half		0 12 256 268 512 516 520 524 780 1036
s5_offset:		.half		0 4 8 12 256 512 516 520 780 1024 1028 1032
s6_offset:		.half		4 8 256 512 516 520 768 780 1028 1032
s7_offset:		.half		0 4 8 12 268 520 776 1032
s8_offset:		.half		4 8 256 268 516 520 768 780 1028 1032
s9_offset:		.half		4 8 256 268 516 520 524 780 1028 1032

# the word FIN (for finish)
fin: 			.word		0 0 0
# structure of each letter
# [lx]			.word		[color] [sizeof offset_arr] [address of offset_arr]
# the letter F
lf:			.word		0x3a2999 12 0
lf_offset:		.half		0 4 8 256 260 512
# the letter I (I have to add an extra l because otherwise MARS thinks I'm trying to load an immediate as I load this address)
lli:			.word		0x3a2999 6 0
li_offset:		.half		4 260 516
# the N
ln:			.word 		0x3a2999 12 0
ln_offset:		.half		0 4 256 264 512 520

.text
# canvas/framebuffer-related CONSTANTS
.eqv BASE_ADDRESS 0x10008000
.eqv BG_COLOR 0xfcfcfc
# keyboard-related CONSTANTS
.eqv KEYSTROKE 0xffff0000
# ship-related CONSTANTS
.eqv SHIP_BASE_COLOR 0x4a4a4a
# bullet-related CONSTANTS
.eqv BULLET_COLOR 0x00b081
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
	# initialize BULLET_ARR
	# $s1=&bullet_arr; $s2=bullet;
	la $s1, bullet_arr		# get bullet_arr
	
	la $s2, b1
	sw $s2, 0($s1)			# get and set b1 in bullet_arr
	la $s2, b2
	sw $s2, 4($s1)			# get and set b2 in bullet_arr
	la $s2, b3
	sw $s2, 8($s1)			# get and set b3 in bullet_arr
	# initialize SCORE
	# $s1=&score_arr; $s2=&score_type; $s3=&score_offset;
	la $s1, score_arr		# get &score_arr
	
	la $s2, s0
	la $s3, s0_offset		
	sw $s3, 8($s2)			# get and set s0_offset in s0
	sw $s2, 0($s1)			# get and set s0 in score_arr
	la $s2, s1
	la $s3, s1_offset
	sw $s3, 8($s2)			# get and set s1_offset in s1
	sw $s2, 4($s1)			# get and set s1 in score_arr
	la $s2, s2
	la $s3, s2_offset
	sw $s3, 8($s2)			# get and set s2_offset in s2
	sw $s2, 8($s1)			# get and set s2 in score_arr
	la $s2, s3
	la $s3, s3_offset
	sw $s3, 8($s2)			# get and set s3_offset in s3
	sw $s2, 12($s1)			# get and set s3 in score_arr
	la $s2, s4
	la $s3, s4_offset
	sw $s3, 8($s2)			# get and set s4_offset in s4
	sw $s2, 16($s1)			# get and set s4 in score_arr
	la $s2, s5
	la $s3, s5_offset
	sw $s3, 8($s2)			# get and set s5_offset in s5
	sw $s2, 20($s1)			# get and set s5 in score_arr
	la $s2, s6
	la $s3, s6_offset
	sw $s3, 8($s2)			# get and set s6_offset in s6
	sw $s2, 24($s1)			# get and set s6 in score_arr
	la $s2, s7
	la $s3, s7_offset
	sw $s3, 8($s2)			# get and set s7_offset in s7
	sw $s2, 28($s1)			# get and set s7 in score_arr
	la $s2, s8
	la $s3, s8_offset
	sw $s3, 8($s2)			# get and set s8_offset in s8
	sw $s2, 32($s1)			# get and set s8 in score_arr
	la $s2, s9
	la $s3, s9_offset
	sw $s3, 8($s2)			# get and set s9_offset in s9
	sw $s2, 36($s1)			# get and set s9 in score_arr
	# initialize FIN
	# $s1=fin; $s2=letter; $s3=letter_offset;
	la $s1, fin			# get &fin
	
	la $s2, lf
	la $s3, lf_offset
	sw $s3, 8($s2)			# get and set lf_offset in lf
	sw $s2, 0($s1)			# get and set lf in score_arr
	la $s2, lli
	la $s3, li_offset
	sw $s3, 8($s2)			# get and set li_offset in lli
	sw $s2, 4($s1)			# get and set lli in score_arr
	la $s2, ln
	la $s3, ln_offset
	sw $s3, 8($s2)			# get and set ln_offset in ln
	sw $s2, 8($s1)			# get and set ln in score_arr
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

	# update bullet position (verify | collision check | redraw)
	# $s6=&bullet_arr; $t0=index;
	la $s6, bullet_arr		# get &bullet_arr
	addi $t0, $zero, 0		# set index
update_bullet:
	# setup for update_bullet
	# $s5=&bullet; $t1=bullet x-coord; $t2=bullet y-coord; $t3=bullet h-speed $t4=new bullet x-coord;
	lw $s5, 0($s6)			# get &bullet
	lh $t1, 0($s5)			# get bullet x-coord
	lh $t2, 2($s5)			# get bullet y-coord
	lh $t3, 4($s5)			# get bullet h-speed
	addi $t4, $zero, 60		# set new bullet x-coord (as invalid)
	
	# check to make sure that we only update bullets that exist
	# $t1=bullet x-coord;
	beq $t1, -1, i_bullet		# jump to i_bullet if x-coord is -1
	# check to make sure that the bullets are not already at the RHS
	# $t1=bullet x-coord;
	beq $t1, 59, er_bullet		# jump to er_bullet if x-coord is 59
	
	# get new bullet-coords
	# $t1=bullet x-coord; $t3=bullet h-speed; $t4=new bullet x-coord;
	add $t4, $t1, $t3		# calc new bullet x-coord
	blt $t4, 60, col_check		# jump to col_check if new bullet x-coord is still in bounds
	addi $t4, $zero, 60		# set new bullet x-coord as 60 to indicate that it's meant to be removed 
	j er_bullet			# jump to er_bullet because we have to remove it
	
col_check:
	# check that the initial coords do not collide with other ROCKS
	# $s1=&obj_arr; $t9=index;
	la $s1, obj_arr			# get &obj_arr
	addi $t9, $zero, 0		# set index
bullet_col_loop:
	# setup for bullet_col_loop
	# $s1=&obj_arr; $s3=&obj_info; $s4=&obj_type;
	lw $s3, 0($s1)
	lw $s4, 0($s3)			# get &obj_type
	lw $s3, 4($s3)			# get &obj_info
	# check ROCK's x-coord is valid
	# $s3=&obj_info; $t5=ROCK x-coord;
	lh $t5, 0($s3)			# get ROCK's x-coord
	beq $t5, -1, i_bcl		# jump to i_bcl if ROCK's x-coord is -1
	
	# get x-y diff
	# $t1=bullet x-coord; $t2=bullet y-coord; $t5=x-diff; $t6=y-diff; 
	sub $t5, $t1, $t5		# calc (bullet x-coord - ROCK x-coord)
	lh $t6, 2($s3)			# get ROCK's y-coord
	sub $t6, $t2, $t6		# calc (bullet y-coord - ROCK y-coord)
	# get x-y padding
	# $t5=x-diff; $t6=y-diff; $t7=x-padding; $t8=y-padding;
	lw $t7, 12($s4)			# get x-padding (sub 1 for extra padding)
	addi $t7, $t7, -1
	lw $t8, 16($s4)			# get y-padding (add 1 for extra padding)
	addi $t8, $t8, 1
	
	# check for horizontal collision
	# $s7=temp; $t5=x-diff; $t7=x-padding;
	blt $t5, $t7, i_bcl		# jump to i_bcl if there is no horizontal collision
	sll $s7, $t7, 1
	sub $t7, $t7 $s7		# calc inverse of x-padding
	bgt $t5, $t7, i_bcl		# jump to i_bcl if there is no horizontal collision
	# check for vertical collision
	# $s7=temp; $t6=y-diff; $t8=y-padding;
	bgt $t6, $t8, i_bcl		# jump to i_bcl if there is no vertical collision
	sll $s7, $t8, 1
	sub $t8, $t8, $s7		# calc inverse of y-padding
	blt $t6, $t8, i_bcl		# jump to i_bcl if there is no vertical collision
	
	
	# destroy both of them (because at this point, I'm confident that they've collided)
	
	# upate score
	# $t5=&score; $t6=temp;
	la $t5, score
	lh $t6, 0($t5)
	addi $t6, $t6, 1
	sh $t6, 0($t5)			# get, increment, and set the new score
	# check if they've done the impossible 
	beq $t6, 999, end		# jump to end if you're A GAMER (if score is 999)
	
	# $s3=&obj_info; $s5=&bullet; $t4=new bullet x-coord; $t5=temp;
	# indicate this bullet's removal
	# $t4=new bullet x-coord;
	addi $t4, $zero, 60
	
	# preserve registers $t0 - $t2, $t4
	# $t0=index; $t1=bullet x-coord; $t2=bullet y-coord; $t4=new bullet x-coord;
	addi $sp, $sp, -8
	sh $t1, 0($sp)
	sh $t2, 2($sp)
	sh $t4, 4($sp)
	sh $t0, 6($sp)			# store registers $t0 - $t2, $t4 in the STACK
	# erase the ROCK
	# $s3=&obj_info; $s4=&obj_type; $t5=ROCK x-coord; $t6=ROCK y-coord;
	addi $a0, $s4, 0
	li $a1, BG_COLOR
	lh $a2, 0($s3)
	lh $a3, 2($s3)
	jal draw			# pass function-param (via registers) and call draw
	# indicate this bullet's removal
	addi $t5, $zero, -1
	sh $t5, 0($s3)
	# retrieve preserved registers 
	# $t0=index; $t1=bullet x-coord; $t2=bullet y-coord; $t4=new bullet x-coord;
	lh $t1, 0($sp)
	lh $t2, 2($sp)
	lh $t4, 4($sp)
	lh $t0, 6($sp)
	addi $sp, $sp, 8		# get preserved registers 
	
	# i think from here we stop checking for collisions (because we're already dead) and jump to er_bullet
	j er_bullet
i_bcl:
	# update obj_arr and increment index
	addi $s1, $s1, 4		# shift obj_arr to the next element
	addi $t9, $t9, 4		# increment index
e_bcl:	bne $t9, 20, bullet_col_loop	# jump to bullet_col_loop if not yet gone through whole obj_arr
	

er_bullet:
	# cover the old
	# $t1=bullet x-coord; $t2=bullet y-coord;
	li $a0, BG_COLOR
	addi $a1, $t1, 0
	addi $a2, $t2, 0
	jal draw_bullet			# pass function-param (via registers) and call draw
	
	# check that new x-coord is valid
	bne $t4, 60, dr_bullet		# jump to dr_bullet if new x-coord is valid
	addi $t1, $zero, -1		
	sh $t1, 0($s5)			# init and set an invalid x-coord in bullet
	j i_bullet			# jump to i_bullet to move on
	
dr_bullet:
	# and paint with the new
	# $t2=bullet y-coord; $t4=new bullet x-coord; 
	li $a0, BULLET_COLOR
	addi $a1, $t4, 0
	addi $a2, $t2, 0
	jal draw_bullet			# pass function-param (via registers) and call draw
	# set new bullet x-coord
	sh $t4, 0($s5)
i_bullet:
	# update bullet_arr and increment index 
	addi $s6, $s6, 4		# shift bullet_arr to the next element
	addi $t0, $t0, 4		# increment index
e_bullet:
	bne $t0, 12, update_bullet	# jump to update_bullet if not yet gone through whole bullet_arr
	
update_ship:
	# update ship position (input check | border check | redraw)
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
	beq $s5, 105, I			# input was i
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

	# iterate through bullet array and set all their x-coords to -1
	# $s5=&bullet; $s6=&bullet_arr; $t0=index; $t1=temp;
	la $s6, bullet_arr		# get &bullet_arr
	addi $t0, $zero, 0		# set index
	addi $t1, $zero, -1		# set new VAL
bullet_reset_loop:
	# setup for bullet_reset_loop
	# $s5=&bullet; $s6=&bullet_arr; 
	lw $s5, 0($s6)			# get &bullet
	sh $t1, 0($s5)			# set new VAL in bullet
	
	addi $s6, $s6, 4		# shift bullet_arr to the next element
	addi $t0, $t0, 4		# increment index
e_brl:	bne $t0, 12, bullet_reset_loop	# jump to bullet_reset_loop if not yet gone through the whole bullet_arr
	
	# reset the score
	# $t5=&score; $t6=temp;
	addi $t6, $zero, 0
	la $t5, score
	sh $t6, 0($t5)

	j start				# jump to start (after everything has been initialized, but before the canvas was made)
I:
	# check if there's room or valid space to spawn another bullet
	# $s6=&bullet_arr; $t9=index;
	la $s6, bullet_arr		# get &bullet_arr
	addi $t9, $zero, 0		# set index
bullet_loop:
	# setup for bullet_loop
	# $s5=&bullet; $s6=&bullet_arr; 
	lw $s5, 0($s6)			# get &bullet
	# check if bullet x-coord is -1
	# $t4=bullet x-coord; $t5=bullet y-coord;
	lh $t4, 0($s5)			# get bullet x-coord
	bne $t4, -1, i_bl		# jump to i_bl if bullet x-coord is NOT -1
	# check ship pos if valid (ie not 58)
	# $t0=ship x-coord;
	beq $t0, 58, draw_ship		# jump to i_bl if ship x-coord is 58 (edge of the right-screen)
	
	# there's valid room for another bullet
	j bullet_init			# jump to bullet_init because we found space to have another bullet
i_bl:
	# increment index & bullet_arr
	# $s6=&bullet_arr; $t9=index;
	addi $s6, $s6, 4		# shift bullet_arr to the next element
	addi $t9, $t9, 4		# increment index
e_bl: 	bne $t9, 12, bullet_loop	# jump to bullet_loop if not yet gone through whole bullet_arr
	# jump to draw_ship because all bullets are used up
	j draw_ship
bullet_init:
	# set new bullet-coords to be in front of the SHIP
	# $s5=&bullet; $t1=ship y-coord; $t4=bullet x-coord; 
	addi $t4, $t0, 2
	sh $t4, 0($s5)
	sh $t1, 2($s5)			# store bullet-coords in bullet
	# the ship could not possibly move at this frame, so we just draw the SHIP again on top of itself
	j draw_ship
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
	# slightly longer pause pause
	li $v0, 32
	li $a0, 700
	syscall
	# draw CANVAS
	# $s0=base_addr; $s1=canvas_color; $s2=row_i; $s3=col_i; $s4=A[i][j] (where A is the framebuffer)
	# $s3=base_addr; $s4=canvas_color; $s5=frame_buffer[i][j]; $t0=row_i; $t1=col_i; 
	li $s3, BASE_ADDRESS		# get frame_buffer address
	li $s4, BG_COLOR		# get color of the canvas
	addi $t0, $zero, 0		# set index (for row_loop)
canvas_row_loop1:
	addi $t1, $zero, 0		# set index (for col_loop)
canvas_col_loop1:
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
e_ccl1:	bne $t1, 256, canvas_col_loop1	# jump to col_loop if address of frame_buffer has not reached edge of the canvas yet
	
	addi $s3, $s3, 256		# update the address to the next row
	addi $t0, $t0, 1		# increment the index
e_crl1:	bne $t0, 32, canvas_row_loop1	# jump to row_loop if canvas has not been completely painted

	# calc digits of the score
	# $s3=&score; $s4=&score_arr; $s5=temp;
	la $s3, score			
	la $s4, score_arr		# get &score_arr
	lh $s3, 0($s3)			# get score value
	# 100th digit
	# $t0=temp (contains the 100th digit); $t1=temp;
	addi $t0, $zero, 1000
	addi $t1, $zero, 100
	div $s3, $t0
	mfhi $t0
	div $t0, $t1
	mflo $t0			# calc (score-value % 1000) // (100)
	# 10th digit
	# $t1=temp (contains the 10th digit); $t2=temp;
	addi $t1, $zero, 100
	addi $t2, $zero, 10
	div $s3, $t1
	mfhi $t1
	div $t1, $t2
	mflo $t1			# calc (score-value % 100) // (10)
	# 1st digit
	# $t2=temp (contains the 1st digit); 
	addi $t2, $zero, 10
	div $s3, $t2
	mfhi $t2			# calc (score-value % 10) 
	# preserve registers $t1 and $t2
	# $t1=10th digit; $t2=1st digit;
	addi $sp, $sp, -4
	sh $t1, 0($sp)
	sh $t2, 2($sp)			# store registers $t1, and $t2 in the STACK
	# print each digit with a pause
	sll $t0, $t0, 2
	add $s5, $s4, $t0
	lw $a0, 0($s5)
	lw $a1, 0($a0)
	li $a2, 25
	li $a3, 13
	jal draw			# pass function-param (via registers) and call draw
	# slight pause
	li $v0, 32
	li $a0, 700
	syscall
	
	lh $t1, 0($sp)			# get $t1 from the STACK
	sll $t1, $t1, 2
	add $s5, $s4, $t1
	lw $a0, 0($s5)
	lw $a1, 0($a0)
	li $a2, 30
	li $a3, 13
	jal draw			# pass function-param (via registers) and call draw
	# slight pause
	li $v0, 32
	li $a0, 700
	syscall
	
	lh $t2, 2($sp)			# get $t2 from the STACK
	sll $t2, $t2, 2
	add $s5, $s4, $t2
	lw $a0, 0($s5)
	lw $a1, 0($a0)
	li $a2, 35
	li $a3, 13
	jal draw			# pass function-param (via registers) and call draw
	# slightly longer pause pause
	li $v0, 32
	li $a0, 800
	syscall
	
	# print fin
	# $s3=&fin;
	la $s3, fin
	# the letter f
	lw $a0, 0($s3)
	li $a1, 0xc2bd27
	li $a2, 28
	li $a3, 19
	jal draw			# pass function-param (via registers) and call draw
	
	# the letter i
	lw $a0, 4($s3)
	li $a1, 0xc2bd27
	li $a2, 31
	li $a3, 19
	jal draw			# pass function-param (via registers) and call draw
	
	# the letter n
	lw $a0, 8($s3)
	li $a1, 0xc2bd27
	li $a2, 34
	li $a3, 19
	jal draw			# pass function-param (via registers) and call draw
	
restart_check:
	# check and get input
	# $s5=keystroke_val; $s6=temp;
	li $s5, KEYSTROKE
	lw $s6, 0($s5)			# get keystroke-event value
	bne $s6, 1, i_rc		# ensure that user did input something, otherwise jump to draw_ship
	lw $s5, 4($s5)			# get ASCII user input
	
	beq $s5, 112, P			# if input was P jump to P which handles all the restarting and such
	beq $s5, 113, close		# if input was Q jump to close which terminates the program
	
	# otherwise, we'll wait until you get it
i_rc:
	# sleep
	li $v0, 32
	li $a0, 40
	syscall
e_rc:	j restart_check
close:
	li $v0, 10			# gracefully terminate the program, hold the grace (with grace)
	syscall				



# FUNC PARAM	: $a0=&obj_type; $a1=color; $a2=x-coord; $a3=y-coord;
# LOCAL REG 	: $t0=&obj_offset; $t1=index; $t2=upper_bound; $t3=obj.pos; $t4=temp; $t5=temp;
draw:
	# calc obj.pos
	sll $t3, $a3, 6
	add $t3, $t3, $a2
	sll $t3, $t3, 2			# calc ((y-coord * 64) + x-coord) * 4
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
	
	
# FUNC PARAM	: $a0=color; $a1=x-coord; $a2=y-coord;
draw_bullet:
	# calc bullet-pos
	sll $a2, $a2, 6
	add $a1, $a1, $a2
	sll $a1, $a1, 2			# calc ((y-coord * 64) + x-coord) * 4
	# get address in frame_buffer
	addi $a1, $a1, BASE_ADDRESS	# calc (BASE_ADDRESS + bullet-pos)
	# paint
	sw $a0, 0($a1)
	
	jr $ra
	

