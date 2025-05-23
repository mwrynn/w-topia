'********************************************
'*              move-cursor.bas             *
'********************************************
'*                                          *
'*  cursor movement related procedures      *
'*  also includes boat moving logic         *
'*                                          *
'********************************************

p1_setup_move_cursor:  PROCEDURE
    p_cont_input = p1_cont_input
    p_cur_x_move_points = p1_cur_x_move_points
    p_cur_y_move_points = p1_cur_y_move_points
    p_cur_x = p1_cur_x
    p_cur_y = p1_cur_y
    p_current_form = p1_current_form
    p_mirror_x = p1_mirror_x
END

p2_setup_move_cursor:  PROCEDURE
    p_cont_input = p2_cont_input
    p_cur_x_move_points = p2_cur_x_move_points
    p_cur_y_move_points = p2_cur_y_move_points
    p_cur_x = p2_cur_x
    p_cur_y = p2_cur_y
    p_current_form = p2_current_form
    p_mirror_x = p2_mirror_x
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
'   p_mirror_x: 0/1 for whether to mirror the sprite in the x dim
'   p_current_form: used to determine whether to use cursor vs. boat logic
'RETURNS:
'   p_cur_x_move_points: the updated move points in the x dimension
'   p_cur_y_move_points: the updated move points in the y dimension
'   p_cur_x: the updated position of the cursor, x dimension (only updated if updated p_cur_x_move_points exceeds threshold) 
'   p_cur_y: the updated position of the cursor, y dimension (only updated if updated p_cur_y_move_points exceeds threshold) 
'   p_mirror_x: updated 0/1 for whether to mirror the sprite in the x dim

move_cursor:   PROCEDURE
    'exit out quick if disc not pressed (first condition, this is an optimization)
    'or if a key is pressed (the second, large condition - magic from Óscar's book - intended to match original game's UI behavior)
    IF ((p_cont_input AND $1F) = 0) OR (((p_cont_input AND $E0) = $80) + ((p_cont_input AND $E0) = $40) + ((p_cont_input AND $E0) = $20)) THEN
        RETURN
    END IF

    p_cur_x_move_points = p_cur_x_move_points + direction_offset_x(p_cont_input AND $1F)
    p_cur_y_move_points = p_cur_y_move_points + direction_offset_y(p_cont_input AND $1F)

    'keep in screen bounds: x dimension
    IF p_cur_x_move_points >= CUR_MOVE_THRESHOLD THEN
        p_cur_x_move_points = 0 
        p_last_cur_x = p_cur_x
        p_cur_x = p_cur_x + 1
        GOSUB keep_cur_in_bounds_x_max
    ELSEIF p_cur_x_move_points <= -CUR_MOVE_THRESHOLD THEN
        p_cur_x_move_points = 0
        p_last_cur_x = p_cur_x
        p_cur_x = p_cur_x - 1
        GOSUB keep_cur_in_bounds_x_min
    END IF

    'keep in screen bounds: y dimension
    IF p_cur_y_move_points >= CUR_MOVE_THRESHOLD THEN
        p_cur_y_move_points = 0 
        p_last_cur_y = p_cur_y
        p_cur_y = p_cur_y + 1
        GOSUB keep_cur_in_bounds_y_max
    ELSEIF p_cur_y_move_points <= -CUR_MOVE_THRESHOLD THEN
        p_cur_y_move_points = 0 
        p_last_cur_y = p_cur_y
        p_cur_y = p_cur_y - 1
        GOSUB keep_cur_in_bounds_y_min
    END IF

    'if a boat, keep off the land!
    IF p_current_form <> FORM_CURSOR THEN
        'if change in x dim set facing accordingly
        IF (direction_offset_x(p_cont_input AND $1F) < 0) OR ((direction_offset_x(p_cont_input AND $1F) = 0) AND p_mirror_x = 1) THEN
            p_mirror_x = 1
        ELSE
            p_mirror_x = 0
        END IF

        GOSUB keep_boat_in_water
    END IF
    'PRINT AT 3 COLOR p1_color, <.3>p_cur_x
    'PRINT AT 8 COLOR p1_color, <.3>p_cur_y
END

p1_finish_move_cursor: PROCEDURE
    p1_cur_x_move_points = p_cur_x_move_points
    p1_cur_y_move_points = p_cur_y_move_points
    p1_cur_x = p_cur_x
    p1_cur_y = p_cur_y
    p1_mirror_x = p_mirror_x
    'p1_current_form = p_current_form 'doesn't get modified
END

p2_finish_move_cursor: PROCEDURE
    p2_cur_x_move_points = p_cur_x_move_points
    p2_cur_y_move_points = p_cur_y_move_points
    p2_cur_x = p_cur_x
    p2_cur_y = p_cur_y
    p2_mirror_x = p_mirror_x
    'p2_current_form = p_current_form 'doesn't get modified
END

'PROCEDUERE keep_cur_in_bounds_x_min: used to validate that x position isn't less than its minimum possible (out of bounds) value.
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

'PROCEDUERE keep_boat_in_water: used to validate that position is within the water, in other words not on land
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

keep_boat_in_water:   PROCEDURE
    'remember (p_cur_x, p_cur_y) is the lower-right corner of the sprite controlled by the player
    'check if it overlaps with a map tile 

    'probably cannot reuse map.get_map_tile_at_cursor as that gets the most overlapping "tile"

    'check four corners separately maybe?
    'upper left for starters (p_cur_x, p_cur_y)
    'a "soft" TODO: possibly optimize this
    GOSUB get_does_any_corner_of_cursor_overlap_land

    IF does_overlap = 1 THEN
        'bump back 
        p_cur_x = p_last_cur_x
        p_cur_y = p_last_cur_y
    END IF
END
