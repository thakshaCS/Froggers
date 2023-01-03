# Demo for painting
# Bitmap Display Configuration:
 # - Unit width in pixels: 8
 # - Unit height in pixels: 8
 # - Display width in pixels: 256
 # - Display height in pixels: 256
 # - Base Address for Display: 0x10008000 ($gp)
 #####################################################################
#
#
# Student: Thakshajiny, 1005954077
#
#
 # CSC258H5S Winter 2022 Assembly Final Project
 # University of Toronto, St. George
 # Bitmap Display Configuration:
 # - Unit width in pixels: 8
 # - Unit height in pixels: 8
 # - Display width in pixels: 256
 # - Display height in pixels: 256
 # - Base Address for Display: 0x10008000 ($gp)
 # Which milestone is reached in this submission? 
 # - Milestone 5
 # Which approved additional features have been implemented? (3 easy + 2 hard)
# Display number of lives remaining (displayed as hearts) [easy]
#After final player death, display game over/retry screen. Restart game if 'r' is entered [easy]
#Displaying a pause screen  when the ‘p’ key is pressed, and returning to the game when ‘p’ is pressed again. [easy]
#Display the player’s score at the top of the screen. (hard)
# Add extra random hazards (alligators in the goal areas) (hard)

 # Any additional information that the TA needs to know: 
 # there are three lives
 # each time you move up you get 10 points and your high score is kept track off
 # press r to replay after you win, p to pause and r to retry after you lose
#####################################################################
.data
	displayAddress: .word 0x10008000
	white: 0xffffff
	green: .word 0x00ff00 
	red: .word 0xff0000 
	blue: .word 0x0000ff 
	yellow: .word 0xffff00
	magenta: .word 0xff00f
	cyan:.word 0xff00ff
	gray: .word 0x808080
	black: .word 0x000000
	brown: .word 0x964B00
	dark_green: .word 0x006400
	frog_x: .word 16
	frog_y: .word 28
	vechile_row_1: .space 512
	vechile_row_2: .space 512
	water_row_1: .space 512
	water_row_2: .space 512
	start_region: .word 0x00ff00:256
	safe_region: .word  0xffff00:256
	goal_region: .word  0x00ff00:256 
	frog_array: .space 64
	display: .space 4096
	
	
	

	
.text
la $t1, frog_x# $s1 stores adress of frog's x position
lw $s1, 0($t1)
la $t1, frog_y# $s2 stores adress of frog's y position
lw $s2, 0($t1)



# drawing goal region
jal reset_registers
addi $t5, $t5, 128 # $t5 store number of bytes added to $t0 to draw width

lw $t0, displayAddress 	# $t0 stores the base address for display
lw $t2, green	# $t2 has the adress for the colour code we want to store

  # x position of safe is 0
 # y position is 0

 #$t0  at (x,y)

addi $t7, $t7, 8 # height input
addi $t9, $t9, 32  # width input
jal draw_rectangle# call function draw_rectangle

# drawing safe region
jal reset_registers
addi $t5, $t5, 128 # $t5 store number of bytes added to $t0 to draw width
lw $t0, displayAddress 	# $t0 stores the base address for display
lw $t2, yellow		# $t2 has the adress for the colour code we want to store

  # x position of safe is 0
add $t4, $t4, 16    #stores y position of safe

sll $t4, $t4, 7 # shift y by 128 (7) -> start y position of where you want to draw
add $t0, $t0, $t4 #offset $t0 by x and y so it can start at (x,y)

addi $t7, $t7, 4 # height input
addi $t9, $t9, 32  # width input
jal draw_rectangle# call function draw_rectangle

# drawing start region
jal reset_registers

addi $t5, $t5, 128 # $t5 store number of bytes added to $t0 to draw width

lw $t0, displayAddress 	# $t0 stores the base address for display

lw $t2, green		# $t2 has the adress for the colour code we want to store

 # x position of safe is 0
add $t4, $t4, 28    #stores y position of safe

sll $t4, $t4, 7 # shift y by 128 (7) -> start y position of where you want to draw
 add $t0, $t0, $t4 #offset $t0 by x and y so it can start at (x,y)
addi $t7, $t7, 4 # height input
addi $t9, $t9, 32  # width input

jal draw_rectangle# call function draw_rectangle


#drawing frog
call_to_draw_frog: jal reset_registers

lw $t0, displayAddress 	# $t0 stores the base address for display

lw $t2, cyan	# $t2 has the adress for code for cyan



add $t3, $s1, $zero		# Fetch x position of frog store the x in $t3


add $t4, $s2, $zero		# Fetch y position of frog store the y in $t4

sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t4, $t4, 7 # shift y by 128 (7) -> frog y position of where you want to draw

add $t0, $t0, $t3 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t4

jal draw_frog





#drawing first vechile row
fill_vechile_row_1_array: jal reset_registers

la $t1, vechile_row_1 # $t1 has the address of vechile_row array
add $t3, $zero, $zero # t3 holds i = 0 
lw $t7, red #$t7 stores the colour of pixel to add to array
add $t0, $t0, 8 # t0 stores number of pixels in one line of rectangle
add $t9, $zero, $zero # $t9 stores curr number of loop  = 0
addi $t2,$t2, 24
jal fill_vechile_array # fill first road rectangle 

add $t9, $zero, $zero # reset t9
lw $t7, gray #$t7 stores the colour blue
add $t3, $zero, $zero # reset t3
add $t3, $t3, 8 # t3 holds i = 8 -> first index that holds colour stores in $t7
jal fill_vechile_array  # fill first car 


add $t9, $zero, $zero # reset t9 = 0
lw $t7, red #$t7 stores the colour blue
add $t3, $zero, $zero # reset t3 = 0
add $t3, $t3, 16 # t3 holds i = 16 
jal fill_vechile_array  # fill second car rectangle


add $t9, $zero, $zero # reset t9
lw $t7, gray #$t7 stores the colour blue
add $t3, $zero, $zero # reset t3
add $t3, $t3, 24 # t3 holds i = 24
jal fill_vechile_array  # fill second car 


draw_vechile_row: jal reset_registers
lw $t0, displayAddress 	# $t0 stores the base address for display
add $t5, $t5, 20 # store y postion of where vechile row 1 starts
sll $t5, $t5, 7 # shift y by 128 (7) ->  position of where you want to start drawing
add $t0, $t0, $t5 #offset $t0 by x and y so it can start at (x,y)
add $t3, $zero, $zero # t3 holds j = 0
la $t1, vechile_row_1# $t1 has the address of vechile_row array

jal draw_vechile_row_loop

#drawing second vechile row
fill_vechile_row_2_array: jal reset_registers

la $t1, vechile_row_2 # $t1 has the address of vechile_row array
add $t3, $zero, $zero # t3 holds i = 0 
lw $t7, red #$t7 stores the colour of pixel to add to array
add $t0, $t0, 4 # t0 stores number of pixels in one line of rectangle
add $t9, $zero, $zero # $t9 stores curr number of loop  = 0
addi $t2,$t2, 28 #$t2 stores value to increment i by to get to next line
jal fill_vechile_array # fill first road rectangle 

add $t9, $zero, $zero # reset t9
lw $t7, gray #$t7 stores the colour gray
add $t0, $zero, $zero # reset t0
add $t0, $t0, 8 # t0 stores number of pixels in one line of rectangle
add $t3, $zero, $zero # reset t3
add $t3, $t3, 4 # t3 holds i = 4 -> first index that holds colour stores in $t7
add $t2, $zero, $zero # reset t2
addi $t2,$t2, 24 #$t2 stores value to increment i by to get to next line
jal fill_vechile_array  # fill first car 


add $t9, $zero, $zero # reset t9 = 0
lw $t7, red #$t7 stores the colour red
add $t3, $zero, $zero # reset t3
add $t3, $t3, 12 # t3 holds i = 12
jal fill_vechile_array  # fill second road rectangle


add $t9, $zero, $zero # reset t9
lw $t7, gray #$t7 stores the colour gray
add $t3, $zero, $zero # reset t3
add $t3, $t3, 20 # t3 holds i = 20
jal fill_vechile_array  # fill second car 

add $t9, $zero, $zero # reset t9 = 0
lw $t7, red #$t7 stores the colour red
add $t0, $zero, $zero # reset t0
add $t0, $t0, 4 # t0 stores number of pixels in one line of rectangle
add $t3, $zero, $zero # reset t3
add $t3, $t3, 28 # t3 holds i = 32
add $t2, $zero, $zero # reset t2
addi $t2,$t2, 28 #$t2 stores value to increment i by to get to next line
jal fill_vechile_array  # fill third road rectangle

 
draw_vechile_row_2: jal reset_registers
lw $t0, displayAddress 	# $t0 stores the base address for display
add $t5, $t5, 24 # store y postion of where vechile row 1 starts
sll $t5, $t5, 7 # shift y by 128 (7) ->  position of where you want to start drawing
add $t0, $t0, $t5 #offset $t0 by x and y so it can start at (x,y)
add $t3, $zero, $zero # t3 holds j = 0
la $t1, vechile_row_2# $t1 has the address of vechile_row array

jal draw_vechile_row_loop

#drawing first water row
fill_water_row_1_array: jal reset_registers

la $t1, water_row_1 # $t1 has the address of vechile_row array
add $t3, $zero, $zero # t3 holds i = 0 
lw $t7, blue #$t7 stores the colour of pixel to add to array
add $t0, $t0, 4 # t0 stores number of pixels in one line of rectangle
add $t9, $zero, $zero # $t9 stores curr number of loop  = 0
addi $t2,$t2, 28 #$t2 stores value to increment i by to get to next line
jal fill_vechile_array # fill first water rectangle 

add $t9, $zero, $zero # reset t9
lw $t7, brown #$t7 stores the colour gray
add $t0, $zero, $zero # reset t0
add $t0, $t0, 8 # t0 stores number of pixels in one line of rectangle
add $t3, $zero, $zero # reset t3
add $t3, $t3, 4 # t3 holds i = 4 -> first index that holds colour stores in $t7
add $t2, $zero, $zero # reset t2
addi $t2,$t2, 24 #$t2 stores value to increment i by to get to next line
jal fill_vechile_array  # fill first loh 


add $t9, $zero, $zero # reset t9 = 0
lw $t7, blue #$t7 stores the colour red
add $t3, $zero, $zero # reset t3
add $t3, $t3, 12 # t3 holds i = 12
jal fill_vechile_array  # fill second waterrectangle


add $t9, $zero, $zero # reset t9
lw $t7, brown #$t7 stores the colour gray
add $t3, $zero, $zero # reset t3
add $t3, $t3, 20 # t3 holds i = 20
jal fill_vechile_array  # fill second log 

add $t9, $zero, $zero # reset t9 = 0
lw $t7,blue #$t7 stores the colour red
add $t0, $zero, $zero # reset t0
add $t0, $t0, 4 # t0 stores number of pixels in one line of rectangle
add $t3, $zero, $zero # reset t3
add $t3, $t3, 28 # t3 holds i = 32
add $t2, $zero, $zero # reset t2
addi $t2,$t2, 28 #$t2 stores value to increment i by to get to next line
jal fill_vechile_array  # fill third water rectangle

 
draw_water_row_1: jal reset_registers
lw $t0, displayAddress 	# $t0 stores the base address for display
add $t5, $t5, 8 # store y postion of where vechile row 1 starts
sll $t5, $t5, 7 # shift y by 128 (7) ->  position of where you want to start drawing
add $t0, $t0, $t5 #offset $t0 by x and y so it can start at (x,y)
add $t3, $zero, $zero # t3 holds j = 0
la $t1,water_row_1# $t1 has the address of vechile_row array

jal draw_vechile_row_loop

#drawing second water row
fill_water_row_2_array: jal reset_registers

la $t1, water_row_2 # $t1 has the address of vechile_row array
add $t3, $zero, $zero # t3 holds i = 0 
lw $t7, blue #$t7 stores the colour of pixel to add to array
add $t0, $t0, 8 # t0 stores number of pixels in one line of rectangle
add $t9, $zero, $zero # $t9 stores curr number of loop  = 0
addi $t2,$t2, 24
jal fill_vechile_array # fill first water rectangle 

add $t9, $zero, $zero # reset t9
lw $t7, brown #$t7 stores the colour blue
add $t3, $zero, $zero # reset t3
add $t3, $t3, 8 # t3 holds i = 8 -> first index that holds colour stores in $t7
jal fill_vechile_array  # fill first log


add $t9, $zero, $zero # reset t9 = 0
lw $t7, blue #$t7 stores the colour blue
add $t3, $zero, $zero # reset t3 = 0
add $t3, $t3, 16 # t3 holds i = 16 
jal fill_vechile_array  # fill second water rectangle


add $t9, $zero, $zero # reset t9
lw $t7, brown #$t7 stores the colour blue
add $t3, $zero, $zero # reset t3
add $t3, $t3, 24 # t3 holds i = 24
jal fill_vechile_array  # fill second log


draw_water_row_2: jal reset_registers
lw $t0, displayAddress 	# $t0 stores the base address for display
add $t5, $t5, 12 # store y postion of where vechile row 1 starts
sll $t5, $t5, 7 # shift y by 128 (7) ->  position of where you want to start drawing
add $t0, $t0, $t5 #offset $t0 by x and y so it can start at (x,y)
add $t3, $zero, $zero # t3 holds j = 0
la $t1, water_row_2# $t1 has the address of vechile_row array

jal draw_vechile_row_loop
li $a2, 0
li $a3, 1
jal random_number



redraw_screen: beq $s4, 3, lost_game

#Fetching Key board input
jal reset_registers
# 'a' 0x61
# 'w' 0xC7
# 's' 0x73
# 'd' 0x64
# 'p' 0 x 70

lw $t8, 0xffff0000 # check if a key was pressed
beq $t8, 1, move_frog # key pressed
beq $t8, 0, drawing_regions # no key pressed
move_frog: lw $t2, 0xffff0004 # get value of key
beq $t2,0x61, respond_to_a # check it against the ascii value of each char and call an approaite function
beq $t2,0x77, respond_to_w
beq $t2,0x73, respond_to_s
beq $t2,0x64, respond_to_d
beq $t2,0x70, respond_to_p

jal drawing_regions

respond_to_a: addi $s1, $s1, -4 # frog moves right  -> x position  + 4
jal drawing_regions

respond_to_w: addi $s2, $s2, -4 # frog moves upward -> y position - 4
jal drawing_regions

respond_to_s: addi $s2, $s2, 4 # frog moves down  -> y position + 4
jal drawing_regions

respond_to_d: addi $s1, $s1, 4 # frog moves left-> x position - 4
jal drawing_regions

respond_to_p: jal reset_registers

lw $t0, displayAddress 	# $t0 stores the base address for display
add $t3, $zero, $zero # t3 holds j = 0
lw $t7, black

draw_black_display_for_pause:beq $t3, 1024, draw_pause_display # loop through from j = 0 to j = 1023 since size of vechile row  is 128 pixels
sll $t4, $t3, 2 #shift j by 4 (2) ->  Since array pos are incremented by 1 to get every fourth index
sw $t7 , 0($t0)# display at adress stored in $t0 a pixel of colour vechile_row[i]
addi $t3, $t3, 1# increment j by 1
addi $t0, $t0, 4 # increment $t0 by 4
j draw_black_display_for_pause

# draw pause
draw_pause_display: 
jal reset_registers
jal pause_display

keep_pausing: beq $t2, 0x70, redraw_screen
lw $t8, 0xffff0000 # check if a key was pressed
beq $t8, 1, key_pressed
j keep_pausing
key_pressed: lw $t2, 0xffff0004 # get value of key
j keep_pausing


drawing_regions:
jal reset_registers
la $t2, start_region # $t2 stores start_region_array
la $t1, display 
addi $t3, $t3, 896 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_without_blocks

jal reset_registers
la $t2, safe_region # $t1 has the address of vechile_row_1 array
la $t1, display
addi $t3, $t3, 512 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_with_blocks


jal reset_registers
la $t2, goal_region # $t1 has the address of vechile_row_1 array
la $t1,  display
addi $t3, $t3, 0 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_without_blocks


# store value at A[0]
call_to_redraw_vechile_row_1: 
jal reset_registers
la $t1, vechile_row_1 # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 0 # t3 holds i = 1
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change 
sll $t5, $t4, 2 #shift i by 4 (2) -> $t4 stores postion of array where has value want to change to 
add $t6, $t1, $t4 #$t6 stores adress of vechile_row[i] 
lw $t9, 0($t6) # get value of vechile_row[i] 
sub $t4, $t4, $t4
sub $t5, $t5, $t5
sub $t6, $t6, $t6
add $t2, $t2, 248

jal shift_pixels

jal reset_registers
la $t2, vechile_row_1 # $t2 has the address of vechile_row_1 array
la $t1, display # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 640 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_with_blocks


call_to_redraw_vechile_row_2: 
jal reset_registers
la $t1, vechile_row_2 # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 1 # t3 holds i = 1
add $t6, $t1, $zero #$t6 stores adress of vechile_row[i] 
lw $t8, 0($t6) # get value of vechile_row[i] 
sub $t6, $t6, $t6
jal shift_pixels_right

jal reset_registers
la $t2, vechile_row_2 # $t1 has the address of vechile_row_1 array
la $t1, display # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 768 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_with_blocks



call_to_redraw_water_row_1: 
jal reset_registers
la $t1, water_row_1 # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 0 # t3 holds i = 0
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change 
sll $t5, $t4, 2 #shift i by 4 (2) -> $t4 stores postion of array where has value want to change to 
add $t6, $t1, $t4 #$t6 stores adress of vechile_row[i] 
lw $t9, 0($t6) # get value of vechile_row[i] 
sub $t4, $t4, $t4
sub $t5, $t5, $t5
sub $t6, $t6, $t6
jal shift_pixels


jal reset_registers
la $t2, water_row_1 # $t1 has the address of vechile_row_1 array
la $t1, display # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 256 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_with_blocks


call_to_redraw_water_row_2: 
jal reset_registers
la $t1, water_row_2 # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 1 # t3 holds i = 1
add $t6, $t1, $zero #$t6 stores adress of vechile_row[i] 
lw $t8, 0($t6) # get value of vechile_row[i] 
sub $t6, $t6, $t6
jal shift_pixels_right

jal reset_registers
la $t2, water_row_2 # $t1 has the address of vechile_row_1 array
la $t1, display # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 384 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_with_blocks



call_to_draw_display: jal reset_registers
lw $t0, displayAddress 	# $t0 stores the base address for display
add $t3, $zero, $zero # t3 holds j = 0
la $t1, display# $t1 has the address of vechile_row array

draw_display:beq $t3, 1024, draw_frog_lives# loop through from j = 0 to j = 1023 since size of vechile row  is 128 pixels
sll $t4, $t3, 2 #shift j by 4 (2) ->  Since array pos are incremented by 1 to get every fourth index
add $t6, $t1, $t4 #store adress of vechile_row[i]
lw $t7, 0($t6) # store value of vechile_row[i]
sw $t7 , 0($t0)# display at adress stored in $t0 a pixel of colour vechile_row[i]
addi $t3, $t3, 1# increment j by 1
addi $t0, $t0, 4 # increment $t0 by 4
j draw_display

draw_frog_lives: jal frog_lives

draw_score: 
jal reset_registers
jal display_score


call_to_draw_alliagtors:
#draw aligator in goal area at random spot
jal reset_registers
add $t1, $s0, 9
add $t3, $s7, 1
jal draw_aligator

# check over lap before redraw frog
checking_overlap:
jal reset_registers
lw $t0, displayAddress 	# $t0 stores the base address for display
add $t3, $s1, $zero		# Fetch x position of frog store the x in $t3


add $t4, $s2, $zero		# Fetch y position of frog store the y in $t4

sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t4, $t4, 7 # shift y by 128 (7) -> frog y position of where you want to draw

add $t0, $t0, $t3 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t4
jal frog_overlaps # check if frog overlaps water or cars
beq $t8, 0, game_won # check if return value $t8 states there is overlap or not
j restart #overlap so restart

game_won: beq $s6, 1, draw_winner_display




# draw frog but if it overlaps reset $s1 and $s2 and redraw frog again
call_to_draw_frog_2: jal reset_registers

beq $s3, 1, check_frog_reached_goal

lw $t0, displayAddress 	# $t0 stores the base address for display

lw $t2, cyan	# $t2 has the adress for code for cyan



add $t3, $s1, $zero		# Fetch x position of frog store the x in $t3


add $t4, $s2, $zero		# Fetch y position of frog store the y in $t4

sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t4, $t4, 7 # shift y by 128 (7) -> frog y position of where you want to draw

add $t0, $t0, $t3 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t4

jal draw_frog 


jal frog_lives

jal display_score

frog_moving_on_log:
#check if frog on a log and return adress of one of its pixel, if not on log do nothing
jal reset_registers

la $t0, display 	# $t0 stores the base address for display

add $t3, $s1, $zero		# Fetch x position of frog store the x in $t3


add $t4, $s2, $zero		# Fetch y position of frog store the y in $t4

sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t4, $t4, 7 # shift y by 128 (7) -> frog y position of where you want to draw

add $t0, $t0, $t3 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t4


jal frog_on_log # return $t8 which stores adress of a pixel that the frog overlaps 

#if pixel matches row 1 or row 2
add $t0, $zero, $zero # reset t7
add $t1, $zero, $zero # reset t7
add $t2, $zero, $zero # reset t7
add $t3, $zero, $zero # reset t7
add $t4, $zero, $zero # reset t7
add $t5, $zero, $zero # reset t7
add $t6, $zero, $zero # reset t7
add $t7, $zero, $zero # reset t7
add $t9, $zero, $zero # reset t7

la $t1, display # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 256 # t3 holds i = 0
addi $t5, $t5, 256
jal move_frog_based_on_water_row


frog_on_secod_water_row:
add $t0, $zero, $zero # reset t7
add $t1, $zero, $zero # reset t7
add $t2, $zero, $zero # reset t7
add $t3, $zero, $zero # reset t7
add $t4, $zero, $zero # reset t7
add $t5, $zero, $zero # reset t7
add $t6, $zero, $zero # reset t7
add $t7, $zero, $zero # reset t7
add $t9, $zero, $zero # reset t7

la $t1, display
addi $t3, $t3, 384 # t3 holds i = 0
addi $t5, $t5, 384
jal move_frog_based_on_water_row


check_frog_reached_goal: # check if frog reached goal region

jal reset_registers

lw $t2, cyan	# $t2 has the adress for code for cyan
 
lw $t0, displayAddress



add $t3, $s1, $zero		# Fetch x position of frog store the x in $t3


add $t4, $s2, $zero		# Fetch y position of frog store the y in $t4

sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t4, $t4, 7 # shift y by 128 (7) -> frog y position of where you want to draw

add $t8, $t8, $t3 #offset $t0 by x and y so it can start at (x,y)
add $t8, $t8, $t4


add $t0, $t0, $t3 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t4

add $t3, $zero, $zero # t3 holds i = 0
add $t4, $zero, $zero # reset $t4

addi $s3, $zero, 2
jal frog_reached_goal # return $t8 which stores adress of a pixel that the frog overlaps 
jal frog_lives
jal display_score


display_drawn: 
li $v0, 32
li $a0, 250 #should be 16
syscall
j redraw_screen

draw_winner_display: jal reset_registers # draw black diaplsy
lw $t0, displayAddress 	# $t0 stores the base address for display
add $t3, $zero, $zero # t3 holds j = 0
lw $t7, black

draw_black_display_after_won:beq $t3, 1024, call_to_draw_winner # loop through from j = 0 to j = 1023 since size of vechile row  is 128 pixels
sll $t4, $t3, 2 #shift j by 4 (2) ->  Since array pos are incremented by 1 to get every fourth index
sw $t7 , 0($t0)# display at adress stored in $t0 a pixel of colour vechile_row[i]
addi $t3, $t3, 1# increment j by 1
addi $t0, $t0, 4 # increment $t0 by 4
j draw_black_display_after_won


call_to_draw_winner: 
jal reset_registers
jal winner_display

# keeping doing this till user presses 'r' if they do set $s4 back to 0 and jump to redraw screen


winner: beq $t2, 0x72, replay_game # if r was pressed restart game
lw $t8, 0xffff0000 # check if a key was pressed
lw $t2, 0xffff0004 # get value of key
j winner

replay_game: add $s4, $zero, $zero
add $s5, $zero, $zero
add $s6, $zero, $zero
#reset frog position to begging

la $t1, frog_x# $s1 stores adress of frog's x position
lw $s1, 0($t1)
la $t1, frog_y# $s2 stores adress of frog's y position
lw $s2, 0($t1)

j redraw_screen


restart: 

# draw the overlapped frog
call_to_draw_frog_overlapping: jal reset_registers

lw $t0, displayAddress 	# $t0 stores the base address for display

lw $t2, cyan	# $t2 has the adress for code for cyan



add $t3, $s1, $zero		# Fetch x position of frog store the x in $t3


add $t4, $s2, $zero		# Fetch y position of frog store the y in $t4

sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t4, $t4, 7 # shift y by 128 (7) -> frog y position of where you want to draw

add $t0, $t0, $t3 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t4

jal draw_frog 


#reset frog position to begging

la $t1, frog_x# $s1 stores adress of frog's x position
lw $s1, 0($t1)
la $t1, frog_y# $s2 stores adress of frog's y position
lw $s2, 0($t1)


#draw frog on start region

jal random_number
j call_to_draw_frog_2












# all lives lost
lost_game:
drawing_regions_after_lost:
jal reset_registers
la $t2, start_region # $t2 stores start_region_array
la $t1, display 
addi $t3, $t3, 896 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_without_blocks

jal reset_registers
la $t2, safe_region # $t1 has the address of vechile_row_1 array
la $t1, display
addi $t3, $t3, 512 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_with_blocks


jal reset_registers
la $t2, goal_region # $t1 has the address of vechile_row_1 array
la $t1,  display
addi $t3, $t3, 0 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_without_blocks


# store value at A[0]
call_to_redraw_vechile_row_1_after_lost: 
jal reset_registers
la $t1, vechile_row_1 # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 0 # t3 holds i = 1
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change 
sll $t5, $t4, 2 #shift i by 4 (2) -> $t4 stores postion of array where has value want to change to 
add $t6, $t1, $t4 #$t6 stores adress of vechile_row[i] 
lw $t9, 0($t6) # get value of vechile_row[i] 
sub $t4, $t4, $t4
sub $t5, $t5, $t5
sub $t6, $t6, $t6
add $t2, $t2, 248

jal shift_pixels

jal reset_registers
la $t2, vechile_row_1 # $t2 has the address of vechile_row_1 array
la $t1, display # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 640 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_with_blocks


call_to_redraw_vechile_row_2_after_lost: 
jal reset_registers
la $t1, vechile_row_2 # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 1 # t3 holds i = 1
add $t6, $t1, $zero #$t6 stores adress of vechile_row[i] 
lw $t8, 0($t6) # get value of vechile_row[i] 
sub $t6, $t6, $t6
jal shift_pixels_right

jal reset_registers
la $t2, vechile_row_2 # $t1 has the address of vechile_row_1 array
la $t1, display # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 768 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_with_blocks



call_to_redraw_water_row_1_after_lost: 
jal reset_registers
la $t1, water_row_1 # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 0 # t3 holds i = 0
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change 
sll $t5, $t4, 2 #shift i by 4 (2) -> $t4 stores postion of array where has value want to change to 
add $t6, $t1, $t4 #$t6 stores adress of vechile_row[i] 
lw $t9, 0($t6) # get value of vechile_row[i] 
sub $t4, $t4, $t4
sub $t5, $t5, $t5
sub $t6, $t6, $t6
jal shift_pixels


jal reset_registers
la $t2, water_row_1 # $t1 has the address of vechile_row_1 array
la $t1, display # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 256 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_with_blocks


call_to_redraw_water_row_2_after_lost: 
jal reset_registers
la $t1, water_row_2 # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 1 # t3 holds i = 1
add $t6, $t1, $zero #$t6 stores adress of vechile_row[i] 
lw $t8, 0($t6) # get value of vechile_row[i] 
sub $t6, $t6, $t6
jal shift_pixels_right

jal reset_registers
la $t2, water_row_2 # $t1 has the address of vechile_row_1 array
la $t1, display # $t1 has the address of vechile_row_1 array
addi $t3, $t3, 384 # t3 holds i = 0
addi $t8, $t8, 0 # t5 holds j = 0
jal add_to_display_array_with_blocks



call_to_draw_display_after_lost: jal reset_registers
lw $t0, displayAddress 	# $t0 stores the base address for display
add $t3, $zero, $zero # t3 holds j = 0
la $t1, display# $t1 has the address of vechile_row array

draw_display_after_lost:beq $t3, 1024, checking_overlap_after_lost # loop through from j = 0 to j = 1023 since size of vechile row  is 128 pixels
sll $t4, $t3, 2 #shift j by 4 (2) ->  Since array pos are incremented by 1 to get every fourth index
add $t6, $t1, $t4 #store adress of vechile_row[i]
lw $t7, 0($t6) # store value of vechile_row[i]
sw $t7 , 0($t0)# display at adress stored in $t0 a pixel of colour vechile_row[i]
addi $t3, $t3, 1# increment j by 1
addi $t0, $t0, 4 # increment $t0 by 4
j draw_display_after_lost



checking_overlap_after_lost:
jal reset_registers
lw $t0, displayAddress 	# $t0 stores the base address for display
add $t3, $s1, $zero		# Fetch x position of frog store the x in $t3


add $t4, $s2, $zero		# Fetch y position of frog store the y in $t4

sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t4, $t4, 7 # shift y by 128 (7) -> frog y position of where you want to draw

add $t0, $t0, $t3 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t4
jal frog_overlaps # check if frog overlaps water or cars
beq $t8, 0, call_to_draw_frog_2_after_lost # check if return value $t8 states there is overlap or not
j restart_after_lost #overlap so restart


# draw frog but if it overlaps reset $s1 and $s2 and redraw frog again
call_to_draw_frog_2_after_lost: jal reset_registers

beq $s3, 1, display_drawn_after_lost

lw $t0, displayAddress 	# $t0 stores the base address for display

lw $t2, cyan	# $t2 has the adress for code for cyan



add $t3, $s1, $zero		# Fetch x position of frog store the x in $t3


add $t4, $s2, $zero		# Fetch y position of frog store the y in $t4

sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t4, $t4, 7 # shift y by 128 (7) -> frog y position of where you want to draw

add $t0, $t0, $t3 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t4

jal draw_frog




jal frog_lives
jal display_score

display_drawn_after_lost: 

# draw a black screen



call_to_draw_black_display: jal reset_registers
lw $t0, displayAddress 	# $t0 stores the base address for display
add $t3, $zero, $zero # t3 holds j = 0
lw $t7, black

draw_black_display_after_lost:beq $t3, 1024, draw_game_over # loop through from j = 0 to j = 1023 since size of vechile row  is 128 pixels
sll $t4, $t3, 2 #shift j by 4 (2) ->  Since array pos are incremented by 1 to get every fourth index
sw $t7 , 0($t0)# display at adress stored in $t0 a pixel of colour vechile_row[i]
addi $t3, $t3, 1# increment j by 1
addi $t0, $t0, 4 # increment $t0 by 4
j draw_black_display_after_lost

# draw game over
draw_game_over: jal reset_registers
jal game_over_display

# keeping doing this till user presses 'r' if they do set $s4 back to 0 and jump to redraw screen


game_over: beq $t2, 0x72, restart_game # if r was pressed restart game
lw $t8, 0xffff0000 # check if a key was pressed
lw $t2, 0xffff0004 # get value of key
j game_over

restart_game: add $s4, $zero, $zero
add $s5, $zero, $zero
add $s6, $zero, $zero
add $s0, $zero, $zero
jal random_number


j redraw_screen


restart_after_lost: 

# draw the overlapped frog
call_to_draw_frog_overlapping_after_lost: jal reset_registers

lw $t0, displayAddress 	# $t0 stores the base address for display

lw $t2, cyan	# $t2 has the adress for code for cyan



add $t3, $s1, $zero		# Fetch x position of frog store the x in $t3


add $t4, $s2, $zero		# Fetch y position of frog store the y in $t4

sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t4, $t4, 7 # shift y by 128 (7) -> frog y position of where you want to draw

add $t0, $t0, $t3 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t4

jal draw_frog 


#reset frog position to begging

la $t1, frog_x# $s1 stores adress of frog's x position
lw $s1, 0($t1)
la $t1, frog_y# $s2 stores adress of frog's y position
lw $s2, 0($t1)

#draw frog on start region

j call_to_draw_frog_2_after_lost






#functions
random_number: 
li $v0, 42 # generate random x coordinate
li $a0, 0
li $a1, 10
syscall
add $s0, $a0, $zero

li $v0, 42 # generate random x coordinate
li $a0, 0
li $a1, 5
syscall
add $s7, $a0, $zero


jr $ra
draw_aligator:
lw $t2, dark_green

 # t1 stores x coordinate of hearts
sll $t1, $t1, 2 # shift x by 4 (2) -> frog y position of where you want to draw
 # t2 stores y coordinate of hearts
sll $t3, $t3, 7 # shift x by 4 (2) -> frog y position of where you want to draw
lw $t0, displayAddress # t0 should have display adress
add $t0, $t0, $t1 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t3 #offset $t0 by x and y so it can start at (x,y)

sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)



addi $t0, $t0, -20
addi $t0, $t0, -128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)



addi $t0, $t0, -28
addi $t0, $t0, 128
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 12
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

jr $ra

winner_display:
lw $t2, green
add $t1, $zero, 11 # t1 stores y coordinate of hearts
add $t3, $zero, 1	# Fetch x position of frog store the x in $t3
sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t1, $t1, 7 # shift y by 128 (7) -> frog y position of where you want to draw
lw $t0, displayAddress # t0 should have display adress
add $t0, $t0, $t1 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t3 

# draw first row of winner

sw $t2, 0($t0)
addi $t0, $t0, 16
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 12
sw $t2, 0($t0)


addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 12
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

# second row of winner
addi $t0, $t0, -116
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 16
sw $t2, 0($t0)


addi $t0, $t0, 12
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)


addi $t0, $t0, 12
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 20
sw $t2, 0($t0)
addi $t0, $t0, 12
sw $t2, 0($t0)

#third row of winner
addi $t0, $t0, -116
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 16
sw $t2, 0($t0)

addi $t0, $t0, 12
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 12
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

# fourth row of winner
addi $t0, $t0, -116
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 12
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 12
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 20
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

# draw last row of winner
addi $t0, $t0, -112
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 12
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 12
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 12
sw $t2, 0($t0)

jr $ra
pause_display:

lw $t2, cyan
add $t1, $zero, 9 # t1 stores y coordinate of hearts
add $t3, $zero, 7	# Fetch x position of frog store the x in $t3
sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t1, $t1, 7 # shift y by 128 (7) -> frog y position of where you want to draw
lw $t0, displayAddress # t0 should have display adress
add $t0, $t0, $t1 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t3 

# draw first row of pause
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)


addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

# draw second row of pause
addi $t0, $t0, -72
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 16
sw $t2, 0($t0)

# draw third row of pause
addi $t0, $t0, -64
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

# draw fourth row
addi $t0, $t0, -72
addi $t0, $t0, 128
sw $t2, 0($t0)

addi $t0, $t0, 16
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 16
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)

#draw fifth row
addi $t0, $t0, -64
addi $t0, $t0, 128
sw $t2, 0($t0)

addi $t0, $t0, 16
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

jr $ra


game_over_display:
lw $t2, red
add $t1, $zero, 9 # t1 stores y coordinate of hearts
add $t3, $zero, 7	# Fetch x position of frog store the x in $t3
sll $t3, $t3, 2 # shift x by 4 (2) -> frog x position of where you want to draw
sll $t1, $t1, 7 # shift y by 128 (7) -> frog y position of where you want to draw
lw $t0, displayAddress # t0 should have display adress
add $t0, $t0, $t1 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t3 

# drawing first row of game
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 16
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

# drawing second row of game

addi $t0, $t0, -64
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

# draw third throw of game
addi $t0, $t0, -56
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)


#draw fourth row of game
addi $t0, $t0, -56
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 16
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

# drawing last row of game
addi $t0, $t0, -56
addi $t0, $t0, 128

sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 16
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

# drawing first row of over
addi $t0, $t0, -64
addi $t0, $t0, 128
addi $t0, $t0, 128

sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)


# drawing second row of  over

addi $t0, $t0, -60
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0,8
sw $t2, 0($t0)


addi $t0, $t0,16
sw $t2, 0($t0)
addi $t0, $t0,12
sw $t2, 0($t0)

# draw third row of over
addi $t0, $t0, -60
addi $t0, $t0, 128


sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0,8
sw $t2, 0($t0)
addi $t0, $t0,4
sw $t2, 0($t0)
addi $t0, $t0,4
sw $t2, 0($t0)

addi $t0, $t0,8
sw $t2, 0($t0)
addi $t0, $t0,4
sw $t2, 0($t0)
addi $t0, $t0,4
sw $t2, 0($t0)
addi $t0, $t0,4
sw $t2, 0($t0)

# draw fourth row of over
addi $t0, $t0, -60
addi $t0, $t0, 128

sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0,8
sw $t2, 0($t0)

addi $t0, $t0,16
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

# draw fifth row of over
addi $t0, $t0, -56
addi $t0, $t0, 128

sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 12
sw $t2, 0($t0)

addi $t0, $t0, 12
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 12
sw $t2, 0($t0)

jr $ra






frog_lives:

lw $t2, red
add $t1, $zero, 29 # t1 stores y coordinate of hearts
sll $t1, $t1, 7 # shift y by 128 (7) -> frog y position of where you want to draw
lw $t0, displayAddress # t0 should have display adress
add $t0, $t0, $t1 #offset $t0 by x and y so it can start at (x,y)

beq $s4, 0, drawing_two_hearts# if s4 == 0 then draw 2 hearts in the startr 
beq $s4, 1, drawing_one_heart# if s4 == 1 then draw a 1 heart
beq $s4, 2, drawing_no_hearts# if s4 == 2 then draw a no hearts, in other word do nothing
beq $s4, 3, drawing_no_hearts# if s4 == 2 then draw a no hearts, in other word do nothing

drawing_two_hearts: 
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, -24
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, -20
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 16
sw $t2, 0($t0)
j done_drawing_lives

drawing_one_heart: 

sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, -4
addi $t0, $t0, 128
sw $t2, 0($t0)
j done_drawing_lives

drawing_no_hearts:
j done_drawing_lives 


done_drawing_lives: jr $ra



display_score:

lw $t2, white
add $t1, $zero, 25 # t1 stores x coordinate of score
sll $t1, $t1, 2 # shift x by 1 (2) -> 
add $t2, $zero, 1 # t1 stores x coordinate of score
sll $t2, $t2, 7 # shift x by 1 (2) -> 
lw $t0, displayAddress # t0 should have display adress
add $t0, $t0, $t1 #offset $t0 by x and y so it can start at (x,y)
add $t0, $t0, $t2 #offset $t0 by x and y so it can start at (x,y)

beq $s2, 0, draw_sixty# if s2 == 0 then draw a 60 in the goal region after display has been drawn

beq $s2, 4, draw_sixty# if s2 == 4 then draw a 60 in the goal region after display has been drawn

beq $s2, 8, draw_fifty# if s2 == 8 then draw a 50

beq $s2, 12, draw_fourty# if s2 == 12 then draw a 40

beq $s2, 16, draw_thirty# if s2 == 16 then draw a 30

beq $s2, 20, draw_twenty# if s2 == 20 then draw a 20

beq $s2, 24, draw_ten# if s2 == 24 then draw a 10

beq $s2, 28, draw_just_zero# if s2 == 28 then draw a 0


draw_sixty:

# if $s4 is less than  60 then score is 50 or less



addi $s5, $zero, 60

sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)

addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
addi $t0, $t0, -512
j draw_zero



draw_fifty:

slti $t5, $s5, 51

beq $t5, 0, not_less_than_fifty

addi $s5, $zero, 50


sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)


addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 128
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
addi $t0, $t0, -512
j draw_zero


not_less_than_fifty: j draw_sixty

draw_fourty:

slti $t5, $s5, 41

beq $t5, 0, not_less_than_fourty

addi $s5, $zero, 40 # stores highest score

sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 128
sw $t2, 0($t0)

addi $t0, $t0, 128
sw $t2, 0($t0)

addi $t0, $t0, 8
addi $t0, $t0, -512
j draw_zero


not_less_than_fourty: j draw_fifty


draw_thirty: 

slti $t5, $s5, 31

beq $t5, 0, not_less_than_thirty

addi $s5, $zero, 30 # stores highest score

sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 128
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 128
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
addi $t0, $t0, -512
j draw_zero

not_less_than_thirty: j draw_fourty



draw_twenty:

slti $t5, $s5, 21

beq $t5, 0, not_less_than_twenty


addi $s5, $zero, 20 # stores highest score
# draw top of two
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)



# draw | of two
addi $t0, $t0, 128
sw $t2, 0($t0)

# draw middle line of two
addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

# draw bottom | of two
addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)

# draw bottom line of two
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, 8
addi $t0, $t0, -512
j draw_zero

not_less_than_twenty: j draw_thirty

draw_ten:

slti $t5, $s5, 11

beq $t5, 0, not_less_than_ten

addi $s5, $zero, 10 # stores highest score

addi $t0, $t0, 8
sw $t2, 0($t0)
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 128
sw $t2, 0($t0)

addi $t0, $t0, 8
addi $t0, $t0, -512
j draw_zero

not_less_than_ten: j draw_twenty


draw_zero:

sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)


addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

j done_drawing_score


draw_just_zero:

slti $t5, $s5, 1

beq $t5, 0, not_less_than_zero

sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)

addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 8
sw $t2, 0($t0)


addi $t0, $t0, -8
addi $t0, $t0, 128
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

j done_drawing_score

not_less_than_zero: j draw_ten



done_drawing_score: jr $ra

frog_reached_goal:

beq $t7, 256, nothing_changed
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change 
add $t6, $t1, $t4 #$t6 stores adress of display
beq $t6, $t8, on_goal # check if frog is within goal region
addi $t3, $t3, 1 #increment i
addi $t7, $t7, 1 # increment loop counter
j frog_reached_goal

on_goal: 
lw $t5, green

sw $t2, 0($t0)# draw first row of frog -> two pixels
addi $t0, $t0, 12
sw $t2, 0($t0)



addi $t0, $t0, -12 # (og_x, y + 1)
addi $t0, $t0, 128
sw $t5, 0($t0) #draw second row of frog -> four pixels
addi $t0, $t0, 4
sw $t5, 0($t0)
addi $t0, $t0, 4
sw $t5, 0($t0)
addi $t0, $t0, 4
sw $t5, 0($t0)



addi $t0, $t0, -12 # (x + 1, y + 1) 
addi $t0, $t0, 128
sw $t2, 0($t0)#draw third row of frog -> 2 pixels
addi $t0, $t0, 4
sw $t5, 0($t0)
addi $t0, $t0, 4
sw $t5, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)



addi $t0, $t0, -12 # (og_x, y + 1) 
addi $t0, $t0, 128
sw $t5, 0($t0) #draw fourth row of frog -> four pixels
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t5, 0($t0)
addi $s3, $s3, -1

add $s6, $zero, 1

nothing_changed: 
jr $ra



move_frog_based_on_water_row:
beq $t7, 128, done_looking
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change 
add $t6, $t1, $t4 #$t6 stores adress of display
beq $t6, $t8, row_found
addi $t3, $t3, 1 #increment i
addi $t7, $t7, 1 # increment loop counter
j move_frog_based_on_water_row

row_found: beq $t5, 256, frog_on_row_1
beq $t5, 384, frog_on_row_2
#if matches row 1 minus 4 from x pos
# if matches row 2 add 4 to x pos
frog_on_row_1: add $s1, $s1, -1
j done_looking
frog_on_row_2:  add $s1, $s1, 1
j done_looking

done_looking: 
jr $ra

add_to_display_array_without_blocks:beq $t7, 256, all_added  # i ==  last index of array
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change 
sll $t5, $t8, 2 #shift j by 4 (2) -> $t4 stores postion of array where has value want to change to 
add $t6, $t1, $t4 #$t6 stores adress of display
add $t0, $t2, $t5 #$t0 stores adress of start/safe/goal/water/road[j] 
lw $t9, 0($t0) # get value of display[j] 
sw $t9, 0($t6)# vechile_row[i] =  display[j]
addi $t3, $t3, 1 #increment i
addi $t8, $t8, 1 #increment i
addi $t7, $t7, 1 # increment loop counter
j add_to_display_array_without_blocks

all_added:
jr $ra

add_to_display_array_with_blocks:beq $t7, 128, all_added_with_blocks  # i ==  last index of array
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change 
sll $t5, $t8, 2 #shift j by 4 (2) -> $t4 stores postion of array where has value want to change to 
add $t6, $t1, $t4 #$t6 stores adress of display
add $t0, $t2, $t5 #$t0 stores adress of start/safe/goal/water/road[j] 
lw $t9, 0($t0) # get value of display[j] 
sw $t9, 0($t6)# vechile_row[i] =  display[j]
addi $t3, $t3, 1 #increment i
addi $t8, $t8, 1 #increment i
addi $t7, $t7, 1 # increment loop counter
j add_to_display_array_with_blocks

all_added_with_blocks:
jr $ra


shift_pixels_right:  beq $t3, 128, wrap_around_right  # i ==  last index of array + 1

sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change  #i should start with value of 2
add $t6, $t1, $t4 #$t6 stores adress of vechile_row[i] 
lw $t9, 0($t6) # get value of vechile_row[i]
sw $t8, 0($t6) # vechile_row[i] = vechile_row[i - 1]
sub $t8, $t8, $t8 #reset
add $t8, $t9, $zero#vechile_row[i] value before step above
addi $t3, $t3, 1 #increment i
j shift_pixels_right

wrap_around_right:
# A[0] = stored value of A[last_index]
sw $t8, 0($t1)#  vechile_row[0]  = vechile_row[last_index] 
jr $ra



# shift all pixel in vechile_row to the left -> A[i] = A[i + 1] -> go upto second last index
shift_pixels : beq $t3, 127, wrap_around  # i ==  last index of array
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change 
add $t5, $t3, 1 #shift i by 4 (2) -> $t4 stores postion of array where has value want to change to 
sll $t7, $t5, 2
add $t6, $t1, $t4 #$t6 stores adress of vechile_row[i] 
add $t0, $t1, $t7 #$t6 stores adress of vechile_row[i + 1] 
lw $t8, 0($t0) # get value of vechile_row[i + 1] 
sw $t8, 0($t6)# vechile_row[i] =  vechile_row[i + 1] 
addi $t3, $t3, 1 #increment i
j shift_pixels

wrap_around:
# A[last index] = stored value of A[0]
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to change 
add $t6, $t1, $t4 #$t6 stores adress of vechile_row[i] 
sw $t9, 0($t6)# vechile_row[last_index] =  vechile_row[0] 
jr $ra


#loop




draw_vechile_row_loop:
beq $t3, 128, vechile_row_drawn # loop through from j = 0 to j = 128 since size of vechile row  is 128 pixels
sll $t4, $t3, 2 #shift j by 4 (2) ->  Since array pos are incremented by 1 to get every fourth index
add $t6, $t1, $t4 #store adress of vechile_row[i]
lw $t7, 0($t6) # store value of vechile_row[i]
sw $t7 , 0($t0)# display at adress stored in $t0 a pixel of colour vechile_row[i]
addi $t3, $t3, 1# increment j by 1
addi $t0, $t0, 4 # increment $t0 by 4
j draw_vechile_row_loop

vechile_row_drawn:
jr $ra


fill_vechile_array: beq  $t9, 4, filled #stop when four loop done
add $t8, $zero, $zero #t8 stores number of pixels drawn 
filling_one_line_of_vechile_array: beq $t8, $t0, next_line #stop when number of pixels drawn == number of pixels in one line of rectangle
sll $t4, $t3, 2 #shift i by 4 (2) -> $t4 stores postion of array where want to add to 
add $t6, $t1, $t4 #$t6 stores adress of vechile_row[i] 
sw $t7, 0($t6)# store at vechile_row[i] the colour in $t7
addi $t3, $t3, 1 #increment i
addi $t8, $t8, 1 # increment number of pixels drawn
j filling_one_line_of_vechile_array

next_line:
add $t3, $t3, $t2 # increment i by $t2 ->  index of next line of array
addi $t9, $t9, 1 # increment loop counter by 1
j fill_vechile_array

filled:
jr $ra

frog_on_log:

lw $t1, brown
lw $t2, 0($t0) # load value of display at adress in $t0
beq $t2, $t1, on_log # check if at this pixel, it red meaning frog is overlaps with car

addi $t0, $t0, 12 # check next pixel of frog
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, -12
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, 128
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, overlap

addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, -8
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, 128
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, -8
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, 128
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, on_log

addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, on_log

on_log: add $t8, $t0, $zero # if $t8 is 1 -> no overlap, 0 -> overlap
return_if_on_or_not_on_log:  jr $ra




frog_overlaps: 

lw $t1, red
lw $t5, blue
lw $t6, dark_green
lw $t2, 0($t0) # load value of display at adress in $t0
beq $t2, $t1, overlap # check if at this pixel, it red meaning frog is overlaps with car
beq $t2, $t5, overlap# check if at this pixel, it blue meaning frog is overlaps with water
beq $t2, $t6, overlap# check if at this pixel, it blue meaning frog is overlaps with aligator
addi $t0, $t0, 12 # check next pixel of frog
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t5, overlap
addi $t0, $t0, -12
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, 128
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, -8
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, 128
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, -8
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, 128
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
addi $t0, $t0, 4
lw $t2, 0($t0)
beq $t2, $t1, overlap
beq $t2, $t5, overlap
beq $t2, $t6, overlap
j no_overlap

overlap:  
add $t8, $t8, 1
addi $s4, $s4, 1

no_overlap:  # if $t8 is 0 -> no overlap, 1 -> overlap
jr $ra











draw_frog: 


sw $t2, 0($t0)# draw first row of frog -> two pixels
addi $t0, $t0, 12
sw $t2, 0($t0)



addi $t0, $t0, -12 # (og_x, y + 1)
addi $t0, $t0, 128
sw $t2, 0($t0) #draw second row of frog -> four pixels
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)



addi $t0, $t0, -8 # (x + 1, y + 1) 
addi $t0, $t0, 128
sw $t2, 0($t0)#draw third row of frog -> 2 pixels
addi $t0, $t0, 4
sw $t2, 0($t0)



addi $t0, $t0, -8 # (og_x, y + 1) 
addi $t0, $t0, 128
sw $t2, 0($t0) #draw fourth row of frog -> four pixels
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)
addi $t0, $t0, 4
sw $t2, 0($t0)

jr $ra # jump back to the calling program




reset_registers:

add $t0, $zero, $zero # reset t7
add $t1, $zero, $zero # reset t7
add $t2, $zero, $zero # reset t7
add $t3, $zero, $zero # reset t7
add $t4, $zero, $zero # reset t7
add $t5, $zero, $zero # reset t7
add $t6, $zero, $zero # reset t7
add $t7, $zero, $zero # reset t7
add $t8, $zero, $zero # reset t7
add $t9, $zero, $zero # reset t7

jr $ra


# drawing rectangle
draw_rectangle: add $t6, $zero, $zero #$t6 stores curr height of rectangle

drawing_rectangle_loop: beq $t6, $t7, end_drawing_rect # stop when the height drawn so far ($t6) matches the height want to draw ($t7) 

add $t8, $zero, $zero #$t8 stores curr width of rectangle
drawing_line: beq $t8, $t9, end_draw_line # stop when the width drawn so far ($t8) matches the width want to draw ($t9) 
sw $t2, 0($t0)# draw at the adress of $t0 the pixel of colour stored in $t2
addi $t0, $t0, 4 # increment $t0 by four to draw the next pixel
addi $t8, $t8, 1 # increment the width by 1
j drawing_line


end_draw_line: # when width want to draw reached
sub $t0, $t0, $t5#  set $t0  to (og_x,y)
addi $t0, $t0, 128#  set $t0  to (og_x,y + 1)
addi $t6, $t6, 1# add one to curr height
j drawing_rectangle_loop

end_drawing_rect: # rectangle has been drawn
jr $ra # jump back to the calling program




Exit:

 li $v0, 10 # terminate the program gracefully
 syscall
 
