'cursor movement related procedures

'works with "parameters": p_cur_x_move_points, p_cur_y_move_points, p_cur_x, p_cur_y
'all of which are modified by this procedure as well
'to ease managing these params, call before this: p1_setup_move_cursor, p2_setup_move_cursor
'and after, call: p1_finish_move_cursor, p2_finish_move_cursor
move_cursor:   PROCEDURE
    cont_x_input = direction_offset_x(cont_input AND $1F)
    p_cur_x_move_points = p_cur_x_move_points + cont_x_input
    cont_y_input = direction_offset_y(cont_input AND $1F)
    p_cur_y_move_points = p_cur_y_move_points + cont_y_input

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

'sets up p1 variables for move_cursor calls
p1_setup_move_cursor:  PROCEDURE
    cont_input = cont_input1
    p_cur_x_move_points = p1_cur_x_move_points
    p_cur_y_move_points = p1_cur_y_move_points
    p_cur_x = p1_cur_x
    p_cur_y = p1_cur_y
END

'sets up p2 variables for move_cursor calls
p2_setup_move_cursor:  PROCEDURE
    cont_input = cont_input2
    p_cur_x_move_points = p2_cur_x_move_points
    p_cur_y_move_points = p2_cur_y_move_points
    p_cur_x = p2_cur_x
    p_cur_y = p2_cur_y
END

'sets p1 variables for after move_cursor calls
p1_finish_move_cursor: PROCEDURE
    p1_cur_x_move_points = p_cur_x_move_points
    p1_cur_y_move_points = p_cur_y_move_points
    p1_cur_x = p_cur_x
    p1_cur_y = p_cur_y
END

'set2 p2 variables for after move_cursor calls
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
