'********************************************
'*              move-cursor.bas             *
'********************************************
'*                                          *
'*  cursor movement related procedures      *
'*  also includes boat moving logic         *
'*                                          *
'********************************************

'PROCEDURE move_cursor: updates cursor move points, and may move the cursor as well,
'   considering the threshold CUR_MOVE_THRESHOLD. respects screen boundaries
'PRECONDITIONS:
'   set p
'   col must be set
'POSTCONDITIONS:
'   
'PARAMETERS:
'   cont_input: item-per-player array: input that will figure into how to adjust both x and y move points
'   cur_x_move_points: item-per-player array: the current move points in the x dimension, will be updated acc. to cont_input
'   cur_y_move_points: item-per-player array: the current move points in the y dimension, will be updated acc. to cont_input
'   cur_x: item-per-player array: the current position of the cursor, x dimension, will be updated acc. to whether cur_x_move_points exceeds threshold
'   cur_y: item-per-player array: the current position of the cursor, y dimension, will be updated acc. to whether cur_x_move_points exceeds threshold
'   last_cur_x: item-per-player array: "last" position of the cursor, x dimension, used to keep track of where to "bump" back to in case of boat collision with land or screen edge
'   last_cur_y: item-per-player array: "last" position of the cursor, y dimension, used to keep track of where to "bump" back to in case of boat collision with land or screen edge
'   mirror_x: item-per-player array: 0/1 for whether to mirror the sprite in the x dim
'   current_form item-per-player array: used to determine whether to use cursor vs. boat logic
'   anim_frame: item-per-player array: used only in case of fishing boat death (so far)
'   anim_frame_timer: item-per-player array: used only in case of fishing boat death (so far)
'RETURNS:
'   cur_x_move_points: the updated move points in the x dimension (for current index of p)
'   cur_y_move_points: the updated move points in the y dimension (for current index of p)
'   cur_x: the updated position of the cursor, x dimension (for current index of p; only updated if updated cur_x_move_points exceeds threshold) 
'   cur_y: the updated position of the cursor, y dimension (for current index of p; only updated if updated cur_y_move_points exceeds threshold) 
'   last_cur_x: updated to keep track of last position of cursor, x dimension (for current index of p)
'   last_cur_y: updated to keep track of last position of cursor, y dimension (for current index of p)
'   mirror_x: updated 0/1 for whether to mirror the sprite in the x dim (for current index of p)
'   anim_frame: set beginning of frame of animation only in case of fishing boat death (for current index of p)
'   anim_frame_timer: only in case of fishing boat death (so far) (for current index of p)

move_cursor:   PROCEDURE
    'exit out quick if disc not pressed (first condition, this is an optimization)
    'or if a key is pressed (the second, large condition - magic from Óscar's book - intended to match original game's UI behavior)
    IF ((cont_input(p) AND $1F) = 0) OR (((cont_input(p) AND $E0) = $80) + ((cont_input(p) AND $E0) = $40) + ((cont_input(p) AND $E0) = $20)) THEN
        RETURN
    END IF

    IF current_form(p) = FORM_DYING_FISHING_BOAT THEN
        RETURN
    END IF

    cur_x_move_points(p) = cur_x_move_points(p) + direction_offset_x(cont_input(p) AND $1F)
    cur_y_move_points(p) = cur_y_move_points(p) + direction_offset_y(cont_input(p) AND $1F)

    'if one of the "right" directions held long enough, increment x with checks 
    IF cur_x_move_points(p) >= CUR_MOVE_THRESHOLD THEN
        cur_x_move_points(p) = 0 
        last_cur_x(p) = cur_x(p)
        cur_x(p) = cur_x(p) + 1
        GOSUB keep_cur_in_bounds_x_max
    'if one of the "left" directions held long enough, decrement x with checks 
    ELSEIF cur_x_move_points(p) <= -CUR_MOVE_THRESHOLD THEN
        cur_x_move_points(p) = 0
        last_cur_x(p) = cur_x(p)
        cur_x(p) = cur_x(p) - 1
        GOSUB keep_cur_in_bounds_x_min
    END IF

    'if one of the "down" directions held long enough, increment y with checks
    IF cur_y_move_points(p) >= CUR_MOVE_THRESHOLD THEN
        cur_y_move_points(p) = 0 
        last_cur_y(p) = cur_y(p)
        cur_y(p) = cur_y(p) + 1
        GOSUB keep_cur_in_bounds_y_max
    'if one of the "up" directions held long enough, decrement y with checks
    ELSEIF cur_y_move_points(p) <= -CUR_MOVE_THRESHOLD THEN
        cur_y_move_points(p) = 0 
        last_cur_y(p) = cur_y(p)
        cur_y(p) = cur_y(p) - 1
        GOSUB keep_cur_in_bounds_y_min
    END IF

    'boat handling
    IF current_form(p) <> FORM_CURSOR THEN
        'if change in x dim set facing accordingly
        IF (direction_offset_x(cont_input(p) AND $1F) < 0) OR ((direction_offset_x(cont_input(p) AND $1F) = 0) AND mirror_x(p) = 1) THEN
            mirror_x(p) = 1
        ELSE
            mirror_x(p) = 0
        END IF

        'if a boat, keep off the land!
        GOSUB keep_boat_in_water

        'handle active boat vs. parked boat collisions
        'logical case we care about:
            'if PT boat moves into opponent's parked fishing boat, parked fishing boat dies
            'all other "boats touching opponent's parked boat" scenarios mean nothing

        IF current_form(p) = FORM_PT_BOAT THEN
            'PRINT AT 8 COLOR player_color(0), "P"
            'cursor_backtab_overlaps comes from keep_boat_in_water call above
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

            IF #col(p) AND bit_mask(other_sprite_index(p)) THEN
                PRINT AT 8 COLOR player_color(0), "C"
                IF other_current_form(p) = FORM_FISHING_BOAT THEN
                    PRINT AT 9 COLOR player_color(0), "F"
                    'boom! so turn other sprite into dying fishing boat
                    other_current_form(p) = FORM_DYING_FISHING_BOAT
                    current_form(p XOR 1) = FORM_DYING_FISHING_BOAT
                END IF
            END IF
        ELSEIF current_form(p) = FORM_FISHING_BOAT THEN
            IF #col(p) AND bit_mask(other_sprite_index(p)) THEN 
                IF other_current_form(p) = FORM_PT_BOAT THEN 'need to check this way (fishing boat moving into PT boat) in addition to the above (PT boat moving into fishing boat) because this proc has a quick exit if disc not pressed; therefore if a fishing boat moves into a stationary PT boat, the above collision detection logic will miss it
                    current_form(p) = FORM_DYING_FISHING_BOAT
                    other_current_form(p XOR 1) = FORM_DYING_FISHING_BOAT
                END IF
            END IF
        END IF 
    END IF
END

'PROCEDURE keep_cur_in_bounds_x_min: used to validate that x position isn't less than its minimum possible (out of bounds) value.
'   if it IS out of bounds, adjusts it to minimum possible value, else it is not modified
'PRECONDITIONS:
'   p is set
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   cur_x: item-per-player array: is the x coordinate to validate/potentially adjust
'RETURNS:
'   cur_x: if within the minimum bounds in x dimension it remains the same, else it is set to minimum bounds in x dimension (for p index only)

keep_cur_in_bounds_x_min:   PROCEDURE
    IF cur_x(p) < X_MIN_BOUND THEN
        cur_x(p) = X_MIN_BOUND
    END IF
END

'PROCEDURE keep_cur_in_bounds_x_max: used to validate that x position isn't greater than its maximum possible (out of bounds) value.
'   if it IS out of bounds, adjusts it to maximum possible value, else it is not modified
'PRECONDITIONS:
'   p is set
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   cur_x: item-per-player array: is the x coordinate to validate/potentially adjust
'RETURNS:
'   cur_x: if within the maximum bounds in x dimension it remains the same, else it is set to maximum  bounds in x dimension (p index only)

keep_cur_in_bounds_x_max:   PROCEDURE
    IF cur_x(p) > X_MAX_BOUND THEN
    	cur_x(p) = X_MAX_BOUND
    END IF
END

'PROCEDURE keep_cur_in_bounds_y_min: used to validate that y position isn't less than its minimum possible (out of bounds) value.
'   if it IS out of bounds, adjusts it to minimum possible value, else it is not modified
'PRECONDITIONS:
'   p is set
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   cur_y: item-per-player array: is the x coordinate to validate/potentially adjust
'RETURNS:
'   cur_y: if within the minimum bounds in y dimension it remains the same, else it is set to minimum bounds in y dimension (p index only)

keep_cur_in_bounds_y_min:   PROCEDURE
    IF cur_y(p) < Y_MIN_BOUND THEN
    	cur_y(p) = Y_MIN_BOUND
    END IF
END

'PROCEDURE keep_cur_in_bounds_y_max: used to validate that y position isn't greater than its maximum possible (out of bounds) value.
'   if it IS out of bounds, adjusts it to maximum possible value, else it is not modified
'PRECONDITIONS:
'   p is set
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   cur_y (item-per-player array) is the y coordinate to validate/potentially adjust
'RETURNS:
'   cur_y: if within the maximum bounds in y dimension it remains the same, else it is set to maximum  bounds in y dimension (p index only)

keep_cur_in_bounds_y_max:   PROCEDURE
    IF cur_y(p) > Y_MAX_BOUND THEN 
        cur_y(p) = Y_MAX_BOUND
    END IF
END

''' 

'PROCEDURE keep_boat_in_water: used to validate that position is within the water, in other words not on land
'   if it IS on land, bumps x, y position back 
'PRECONDITIONS:
'   p is set
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   cur_x (item-per-player array) is the x coordinate to validate/potentially adjust, represents upper left of boat sprite's card
'   cur_y (item-per-player array) is the y coordinate to validate/potentially adjust, represents upper left of boat sprite's card
'   last_cur_x (item-per-player array) is the previous x coordinate to fall back to if validation fails
'   last_cur_y (item-per-player array) is the previous y coordinate to fall back to if validation fails
'RETURNS:
'   cur_x: if cur_x not on land in x dimension it remains the same, else it is adjusted by one pixel 
'   cur_y: same as above but for y (p index)
'   #cursor_backtab_overlaps: 
'       bit 0 (LSB): 1 if overlaps with land, else 0
'       bit 1: 1 if overlaps with parked fishing boat belonging to opponent, else 0
'       bit 2-9: if overlap with parked fishing boat, this is the backtab index of that boat; if no overlap then 00000000; if multiple collisiosn with parked fishing boats, an arbitrary one is chosen

keep_boat_in_water:   PROCEDURE
    'remember (cur_x, cur_y) is the upper-left corner of the sprite controlled by the player
    'check if it overlaps with a map tile 

    GOSUB get_cursor_backtab_overlaps

    IF (#cursor_backtab_overlaps AND $0001) = $0001 THEN 'LSB "on" means colliding with land
        'bump back 
        cur_x(p) = last_cur_x(p)
        cur_y(p) = last_cur_y(p)
    END IF
END
