'cursor movement related procedures

'works with "parameters": p_cur_x_move_points, p_cur_y_move_points, p_cur_x, p_cur_y
'all of which are modified by this procedure as well
'to ease managing these params, call before this: p1_setup_move_cursor, p2_setup_move_cursor
'and after, call: p1_finish_move_cursor, p2_finish_move_cursor
move_cursor:   PROCEDURE
    cont_input = direction_offset_x(c_input AND $1F)
    p_cur_x_move_points = p_cur_x_move_points + cont_input
    cont_input = direction_offset_y(c_input AND $1F)
    p_cur_y_move_points = p_cur_y_move_points + cont_input

    IF p_cur_x_move_points >= CUR_MOVE_THRESHOLD THEN
        p_cur_x_move_points = 0 
        p_cur_x = p_cur_x + 1
    ELSEIF p_cur_x_move_points <= -CUR_MOVE_THRESHOLD THEN
        p_cur_x_move_points = 0
        p_cur_x = p_cur_x - 1
    END IF

    IF p_cur_y_move_points >= CUR_MOVE_THRESHOLD THEN
        p_cur_y_move_points = 0 
        p_cur_y = p_cur_y + 1
    ELSEIF p_cur_y_move_points <= -CUR_MOVE_THRESHOLD THEN
        p_cur_y_move_points = 0 
        p_cur_y = p_cur_y - 1
    END IF
END

'sets up p1 variables for move_cursor calls
p1_setup_move_cursor:  PROCEDURE
    c_input = CONT1
    p_cur_x_move_points = p1_cur_x_move_points
    p_cur_y_move_points = p1_cur_y_move_points
    p_cur_x = p1_cur_x
    p_cur_y = p1_cur_y
END

'sets up p2 variables for move_cursor calls
p2_setup_move_cursor:  PROCEDURE
    c_input = CONT2
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
