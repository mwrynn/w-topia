'********************************************
'*              move-cursor.bas             *
'********************************************
'*                                          *
'*  cursor movement related procedures      *
'*  also includes boat moving logic         *
'*                                          *
'********************************************

p1_setup_move_cursor:  PROCEDURE
    player = 0
    p_cont_input = p1_cont_input
    p_cur_x_move_points = p1_cur_x_move_points
    p_cur_y_move_points = p1_cur_y_move_points
    p_cur_x = p1_cur_x
    p_cur_y = p1_cur_y
    p_last_cur_x = p1_last_cur_x
    p_last_cur_y = p1_last_cur_y
    p_current_form = p1_current_form
    p_mirror_x = p1_mirror_x
    p_col = COL0
    p_sprite_index = 1

    p_anim_frame = p1_anim_frame
    p_anim_frame_timer = p1_anim_frame_timer

    'other player's info
    other_cur_x = p2_cur_x
    other_cur_y = p2_cur_y
    other_current_form = p2_current_form
    other_col = COL1
    other_sprite_index = 2
END

p2_setup_move_cursor:  PROCEDURE
    player = 1
    p_cont_input = p2_cont_input
    p_cur_x_move_points = p2_cur_x_move_points
    p_cur_y_move_points = p2_cur_y_move_points
    p_cur_x = p2_cur_x
    p_cur_y = p2_cur_y
    p_last_cur_x = p2_last_cur_x
    p_last_cur_y = p2_last_cur_y
    p_current_form = p2_current_form
    p_mirror_x = p2_mirror_x
    p_col = COL1
    player_sprite_index = 2

    p_anim_frame = p2_anim_frame
    p_anim_frame_timer = p2_anim_frame_timer

    'other player's info
    other_cur_x = p1_cur_x
    other_cur_y = p1_cur_y
    other_current_form = p1_current_form
    other_col = COL0
    other_sprite_index = 1
END

'PROCEDURE move_cursor: updates cursor move points, and may move the cursor as well,
'   considering the threshold CUR_MOVE_THRESHOLD. respects screen boundaries
'PRECONDITIONS:
'   call p[1|2]_setup_move_cursor
'POSTCONDITIONS:
'   call [p1|2]_finish_move_cursor
'PARAMETERS:
'   p_cont_input: input that will figure into how to adjust both x and y move points
'   p_cur_x_move_points: the current move points in the x dimension, will be updated acc. to p_cont_input
'   p_cur_y_move_points: the current move points in the y dimension, will be updated acc. to p_cont_input
'   p_cur_x: the current position of the cursor, x dimension, will be updated acc. to whether p_cur_x_move_points exceeds threshold
'   p_cur_y: the current position of the cursor, y dimension, will be updated acc. to whether p_cur_x_move_points exceeds threshold
'   p_last_cur_x: "last" position of the cursor, x dimension, used to keep track of where to "bump" back to in case of boat collision with land or screen edge
'   p_last_cur_y: "last" position of the cursor, y dimension, used to keep track of where to "bump" back to in case of boat collision with land or screen edge
'   p_mirror_x: 0/1 for whether to mirror the sprite in the x dim
'   p_current_form: used to determine whether to use cursor vs. boat logic
'   player: current player
'   p_anim_frame: used only in case of fishing boat death (so far)
'   p_anim_frame_timer: used only in case of fishing boat death (so far)
'RETURNS:
'   p_cur_x_move_points: the updated move points in the x dimension
'   p_cur_y_move_points: the updated move points in the y dimension
'   p_cur_x: the updated position of the cursor, x dimension (only updated if updated p_cur_x_move_points exceeds threshold) 
'   p_cur_y: the updated position of the cursor, y dimension (only updated if updated p_cur_y_move_points exceeds threshold) 
'   p_last_cur_x: updated to keep track of last position of cursor, x dimension
'   p_last_cur_y: updated to keep track of last position of cursor, y dimension
'   p_mirror_x: updated 0/1 for whether to mirror the sprite in the x dim
'   p_anim_frame: set beginning of frame of animation only in case of fishing boat death (so far)
'   p_anim_frame_timer: only in case of fishing boat death (so far)


move_cursor:   PROCEDURE
    'exit out quick if disc not pressed (first condition, this is an optimization)
    'or if a key is pressed (the second, large condition - magic from Óscar's book - intended to match original game's UI behavior)
    IF ((p_cont_input AND $1F) = 0) OR (((p_cont_input AND $E0) = $80) + ((p_cont_input AND $E0) = $40) + ((p_cont_input AND $E0) = $20)) THEN
        RETURN
    END IF

    IF p_current_form = FORM_DYING_FISHING_BOAT THEN
        RETURN
    END IF

    p_cur_x_move_points = p_cur_x_move_points + direction_offset_x(p_cont_input AND $1F)
    p_cur_y_move_points = p_cur_y_move_points + direction_offset_y(p_cont_input AND $1F)

    'if one of the "right" directions held long enough, increment x with checks 
    IF p_cur_x_move_points >= CUR_MOVE_THRESHOLD THEN
        p_cur_x_move_points = 0 
        p_last_cur_x = p_cur_x
        p_cur_x = p_cur_x + 1
        GOSUB keep_cur_in_bounds_x_max
    'if one of the "left" directions held long enough, decrement x with checks 
    ELSEIF p_cur_x_move_points <= -CUR_MOVE_THRESHOLD THEN
        p_cur_x_move_points = 0
        p_last_cur_x = p_cur_x
        p_cur_x = p_cur_x - 1
        GOSUB keep_cur_in_bounds_x_min
    END IF

    'if one of the "down" directions held long enough, increment y with checks
    IF p_cur_y_move_points >= CUR_MOVE_THRESHOLD THEN
        p_cur_y_move_points = 0 
        p_last_cur_y = p_cur_y
        p_cur_y = p_cur_y + 1
        GOSUB keep_cur_in_bounds_y_max
    'if one of the "up" directions held long enough, decrement y with checks
    ELSEIF p_cur_y_move_points <= -CUR_MOVE_THRESHOLD THEN
        p_cur_y_move_points = 0 
        p_last_cur_y = p_cur_y
        p_cur_y = p_cur_y - 1
        GOSUB keep_cur_in_bounds_y_min
    END IF

    'boat handling
    IF p_current_form <> FORM_CURSOR THEN
        'if change in x dim set facing accordingly
        IF (direction_offset_x(p_cont_input AND $1F) < 0) OR ((direction_offset_x(p_cont_input AND $1F) = 0) AND p_mirror_x = 1) THEN
            p_mirror_x = 1
        ELSE
            p_mirror_x = 0
        END IF

        'if a boat, keep off the land!
        GOSUB keep_boat_in_water

        'PRINT AT 8 COLOR p1_color, <.3>cursor_backtab_overlaps

        'handle active boat vs. parked boat collisions
        'logical case we care about:
            'if PT boat moves into opponent's parked fishing boat, parked fishing boat dies
            'all other "boats touching opponent's parked boat" scenarios mean nothing

        IF p_current_form = FORM_PT_BOAT THEN
             'PRINT AT 4 COLOR p1_color, "PT"
            'cursor_backtab_overlaps comes from keep_boat_in_water call above
            'PRINT AT 24 COLOR p1_color, <.5>#cursor_backtab_overlaps
            '
            '   #cursor_backtab_overlaps will look like:
            '       bit 0 (LSB): 1 if overlaps with land, else 0
            '       bit 1: 1 if overlaps with parked fishing boat belonging to opponent, else 0
            '       bit 2-9: if overlap with parked fishing boat, this is the backtab index of that boat; if no overlap then 00000000; if multiple collisiosn with parked fishing boats, an arbitrary one is chosen

            IF (#cursor_backtab_overlaps AND $0002) = $0002 THEN 'if collided with parked opposing fishing boat (I had $01FE and compared it to <> $0000 here before but I don't know why, which means 0000 0001 1111 1110)
                'boom
                'only one death animation a time. if already in progress, other card boats cannot die until finished! (original game's behavior)
                IF dying_boat_backtab_index = BACKTAB_OUT_OF_BOUNDS_INDEX THEN 'if death animation in progress already
                    dying_boat_backtab_index = (#cursor_backtab_overlaps / 4)
                END IF
            END IF

            'if the current PT boat collided with a fishing boat sprite (as opposed to a parked fishing boat which is NOT a sprite)
            IF p_col AND other_sprite_index THEN
                'PRINT AT 6 COLOR p1_color, "C"
                IF other_current_form = FORM_FISHING_BOAT THEN
                    'boom! so turn other sprite into dying fishing boat
                    other_current_form = FORM_DYING_FISHING_BOAT
                END IF
            END IF
        ELSEIF p_current_form = FORM_FISHING_BOAT THEN
            IF p_col AND other_sprite_index THEN 
                IF other_current_form = FORM_PT_BOAT THEN 'need to check this way (fishing boat moving into PT boat) in addition to the above (PT boat moving into fishing boat) because this proc has a quick exit if disc not pressed; therefore if a fishing boat moves into a stationary PT boat, the above collision detection logic will miss it
                    p_current_form = FORM_DYING_FISHING_BOAT
                END IF
            END IF
        END IF 
    END IF
END

p1_finish_move_cursor: PROCEDURE
    p1_cur_x_move_points = p_cur_x_move_points
    p1_cur_y_move_points = p_cur_y_move_points
    p1_cur_x = p_cur_x
    p1_cur_y = p_cur_y
    p1_last_cur_x = p_last_cur_x
    p1_last_cur_y = p_last_cur_y 
    p1_mirror_x = p_mirror_x
    p1_current_form = p_current_form 'doesn't get modified
    p2_current_form = other_current_form 

    p1_anim_frame = p_anim_frame
    p1_anim_frame_timer = p_anim_frame_timer
END

p2_finish_move_cursor: PROCEDURE
    p2_cur_x_move_points = p_cur_x_move_points
    p2_cur_y_move_points = p_cur_y_move_points
    p2_cur_x = p_cur_x
    p2_cur_y = p_cur_y
    p2_last_cur_x = p_last_cur_x
    p2_last_cur_y = p_last_cur_y
    p2_mirror_x = p_mirror_x
    p2_current_form = p_current_form 'doesn't get modified
    p1_current_form = other_current_form 

    p2_anim_frame = p_anim_frame
    p2_anim_frame_timer = p_anim_frame_timer
END

'PROCEDURE keep_cur_in_bounds_x_min: used to validate that x position isn't less than its minimum possible (out of bounds) value.
'   if it IS out of bounds, adjusts it to minimum possible value, else it is not modified
'PRECONDITIONS:
'   p_cur_x is set
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   p_cur_x is the x coordinate to validate/potentially adjust
'RETURNS:
'   p_cur_x: if within the minimum bounds in x dimension it remains the same, else it is set to minimum bounds in x dimension

keep_cur_in_bounds_x_min:   PROCEDURE
    IF p_cur_x < 8 THEN
        p_cur_x = 8
    END IF
END

'PROCEDURE keep_cur_in_bounds_x_max: used to validate that x position isn't greater than its maximum possible (out of bounds) value.
'   if it IS out of bounds, adjusts it to maximum possible value, else it is not modified
'PRECONDITIONS:
'   p_cur_x is set
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   p_cur_x is the x coordinate to validate/potentially adjust
'RETURNS:
'   p_cur_x: if within the maximum bounds in x dimension it remains the same, else it is set to maximum  bounds in x dimension

keep_cur_in_bounds_x_max:   PROCEDURE
    IF p_cur_x > 160 THEN
    	p_cur_x	= 160
    END IF
END

'PROCEDURE keep_cur_in_bounds_y_min: used to validate that y position isn't less than its minimum possible (out of bounds) value.
'   if it IS out of bounds, adjusts it to minimum possible value, else it is not modified
'PRECONDITIONS:
'   p_cur_y is set
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   p_cur_y is the x coordinate to validate/potentially adjust
'RETURNS:
'   p_cur_y: if within the minimum bounds in y dimension it remains the same, else it is set to minimum bounds in y dimension

keep_cur_in_bounds_y_min:   PROCEDURE
    IF p_cur_y < 8 THEN
    	p_cur_y = 8
    END IF
END

'PROCEDURE keep_cur_in_bounds_y_max: used to validate that y position isn't greater than its maximum possible (out of bounds) value.
'   if it IS out of bounds, adjusts it to maximum possible value, else it is not modified
'PRECONDITIONS:
'   p_cur_y is set
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   p_cur_y is the y coordinate to validate/potentially adjust
'RETURNS:
'   p_cur_y: if within the maximum bounds in y dimension it remains the same, else it is set to maximum  bounds in y dimension

keep_cur_in_bounds_y_max:   PROCEDURE
    IF p_cur_y > 96 THEN '96 pixels with 8 for status bar; y counts from bottom?
        p_cur_y = 96
    END IF
END

''' 

'PROCEDURE keep_boat_in_water: used to validate that position is within the water, in other words not on land
'   if it IS on land, bumps x, y position back 
'PRECONDITIONS:
'   p_cur_x is set
'   p_cur_y is set
'   p_last_cur_x is set
'   p_last_cur_y is set
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   p_cur_x is the x coordinate to validate/potentially adjust, represents upper left of boat sprite's card
'   p_cur_y is the y coordinate to validate/potentially adjust, represents upper left of boat sprite's card
'   p_last_cur_x is the previous x coordinate to fall back to if validation fails
'   p_last_cur_y is the previous y coordinate to fall back to if validation fails
'RETURNS:
'   p_cur_x: if p_cur_x not on land in x dimension it remains the same, else it is adjusted by one pixel
'   p_cur_y: same as above but for y
'   #cursor_backtab_overlaps: 
'       bit 0 (LSB): 1 if overlaps with land, else 0
'       bit 1: 1 if overlaps with parked fishing boat belonging to opponent, else 0
'       bit 2-9: if overlap with parked fishing boat, this is the backtab index of that boat; if no overlap then 00000000; if multiple collisiosn with parked fishing boats, an arbitrary one is chosen

keep_boat_in_water:   PROCEDURE
    'remember (p_cur_x, p_cur_y) is the upper-left corner of the sprite controlled by the player
    'check if it overlaps with a map tile 

    'PRINT AT 0 COLOR p1_color, <.3>p_cur_x
    'PRINT AT 4 COLOR p1_color, <.3>p_cur_y

    GOSUB get_cursor_backtab_overlaps

    IF (#cursor_backtab_overlaps AND $0001) = $0001 THEN 'LSB "on" means colliding with land
        'bump back 
        p_cur_x = p_last_cur_x
        p_cur_y = p_last_cur_y
    END IF
END
