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
ship:		.word		0x4a4a4a 1980 1 1 5
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


	li $v0, 10	# gracefully terminate the program (with grace)
	syscall





















