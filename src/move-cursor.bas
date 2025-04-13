'********************************************
'*              move-cursor.bas             *
'********************************************
'*                                          *
'*  cursor movement related procedures      *
'*                                          *
'********************************************

p1_setup_move_cursor:  PROCEDURE
    p_cont_input = p1_cont_input
    p_cur_x_move_points = p1_cur_x_move_points
    p_cur_y_move_points = p1_cur_y_move_points
    p_cur_x = p1_cur_x
    p_cur_y = p1_cur_y
END

p2_setup_move_cursor:  PROCEDURE
    p_cont_input = p2_cont_input
    p_cur_x_move_points = p2_cur_x_move_points
    p_cur_y_move_points = p2_cur_y_move_points
    p_cur_x = p2_cur_x
    p_cur_y = p2_cur_y
END

'move_cursor: potentially moves the cursor, taking into account "slow down" according to CUR_MOVE_THRESHOLD
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
'RETURNS:
'   p_cur_x_move_points: the updated move points in the x dimension
'   p_cur_y_move_points: the updated move points in the y dimension
'   p_cur_x: the updated position of the cursor, x dimension (only updated if updated p_cur_x_move_points exceeds threshold) 
'   p_cur_y: the updated position of the cursor, y dimension (only updated if updated p_cur_y_move_points exceeds threshold) 

move_cursor:   PROCEDURE
    'don't move if a key is pressed (magic from Óscar's book)
    IF ((p_cont_input AND $E0) = $80) + ((p_cont_input AND $E0) = $40) + ((p_cont_input AND $E0) = $20) THEN 
        RETURN
    END IF

    p_cur_x_move_points = p_cur_x_move_points + direction_offset_x(p_cont_input AND $1F)
    p_cur_y_move_points = p_cur_y_move_points + direction_offset_y(p_cont_input AND $1F)

    IF p_cur_x_move_points >= CUR_MOVE_THRESHOLD THEN
        p_cur_x_move_points = 0 
        p_cur_x = p_cur_x + 1
        GOSUB keep_cur_in_bounds_x_max
    ELSEIF p_cur_x_move_points <= -CUR_MOVE_THRESHOLD THEN
        p_cur_x_move_points = 0
        p_cur_x = p_cur_x - 1
        GOSUB keep_cur_in_bounds_x_min
    END IF

    IF p_cur_y_move_points >= CUR_MOVE_THRESHOLD THEN
        p_cur_y_move_points = 0 
        p_cur_y = p_cur_y + 1
        GOSUB keep_cur_in_bounds_y_max
    ELSEIF p_cur_y_move_points <= -CUR_MOVE_THRESHOLD THEN
        p_cur_y_move_points = 0 
        p_cur_y = p_cur_y - 1
        GOSUB keep_cur_in_bounds_y_min
    END IF
END

p1_finish_move_cursor: PROCEDURE
    p1_cur_x_move_points = p_cur_x_move_points
    p1_cur_y_move_points = p_cur_y_move_points
    p1_cur_x = p_cur_x
    p1_cur_y = p_cur_y
END

p2_finish_move_cursor: PROCEDURE
    p2_cur_x_move_points = p_cur_x_move_points
    p2_cur_y_move_points = p_cur_y_move_points
    p2_cur_x = p_cur_x
    p2_cur_y = p_cur_y
END

keep_cur_in_bounds_x_min:   PROCEDURE
    IF p_cur_x < 8 THEN
        p_cur_x = 8
    END IF
END

keep_cur_in_bounds_x_max:   PROCEDURE
    IF p_cur_x > 159 THEN '159 pixels; this keeps cursor right at the edge, so apparently x is the right side of the card??
    	p_cur_x	= 159
    END IF
END

keep_cur_in_bounds_y_min:   PROCEDURE
    IF p_cur_y < 8 THEN
    	p_cur_y = 8
    END IF
END

keep_cur_in_bounds_y_max:   PROCEDURE
    IF p_cur_y > 89 THEN '96 pixels with 8 for status bar; y counts from bottom?
        p_cur_y = 89
    END IF
END
