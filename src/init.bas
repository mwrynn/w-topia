init:   PROCEDURE
    'init graphics
    CLS
    MODE 0, BLUE, TAN, BLUE, TAN
    WAIT
    DEFINE CARD_NUM_CURSOR, 1, cursor_bitmap 'define cursor as card 0; 1 means load just 1 card (can do multiple)
    WAIT 'cards will get garbled if no WAIT between DEFINEs
    DEFINE CARD_NUM_LAND, 17, land_bitmaps
    WAIT

    GOSUB init_player_colors
    GOSUB init_cursor
    
    SIGNED cont_input
END
    
init_cursor:    PROCEDURE
    p_cur_x = 0 'used in procedure
    p_cur_y = 0 'used in procedure
    p1_cur_x = P1_CUR_STARTING_X
    p1_cur_y = P1_CUR_STARTING_Y
    p2_cur_x = P2_CUR_STARTING_X
    p2_cur_y = P2_CUR_STARTING_Y
    SIGNED p_cur_x_move_points, p_cur_y_move_points   'for procedure call; maybe make generic arg1 etc.
    SIGNED p1_cur_x_move_points, p1_cur_y_move_points
    SIGNED p2_cur_x_move_points, p2_cur_y_move_points
    p_cur_x_move_points = 0 'for procedure call; maybe make generic arg1, etc.
    p_cur_y_move_points = 0 'for procedure call; maybe make generic arg1, etc.
    p1_cur_x_move_points = 0
    p1_cur_y_move_points = 0
    p2_cur_x_move_points = 0
    p2_cur_y_move_points = 0
    CONST CUR_X_PARAMS = X_NO_INTERACT + X_VISIBLE + X_NORMAL_SIZE
    #p1_cur_f = CARD_BASELINE + p1_color_low_bits + CARD_NUM_CURSOR * CARD_MULT

    'to avoid using a scarce 16-bit int just for high bit.
    '($1000 AND p1_color_high_bit) in the sprite call doesn't work
    'maybe because a 16-bit int AND an 8-bit int doesn't result in a 16-bit int?
    IF p1_color_high_bit = 1 THEN 'to avoid using a 16-bit int just for high bit. ($1000 AND p1_color_high_bit) doesn't work
        #p1_cur_f = #p1_cur_f + $1000
    END IF

    #p2_cur_f = CARD_BASELINE + p2_color_low_bits + CARD_NUM_CURSOR * CARD_MULT
    IF p2_color_high_bit = 1 THEN 'to avoid using a 16-bit int just for high bit. ($1000 AND p2_color_high_bit) doesn't work
        #p2_cur_f = #p2_cur_f + $1000
    END IF
END

'set up color data including high and low bits for both players; used in SPRITE call
init_player_colors: PROCEDURE
    p1_color = DARK_GREEN 'the intention is eventually to allow user input to choose player colors
    p2_color = RED

    IF p1_color > $7 THEN '$7 is 111 in binary, so anything greater requires the high bit to be set in call to SPRITE
        p1_color_high_bit = 1
        p1_color_low_bits = p1_color AND $7
    ELSE
        p1_color_high_bit = 0
        p1_color_low_bits = p1_color
    END IF

    IF p2_color > 7 THEN
        p2_color_high_bit = 1
        p2_color_low_bits = p2_color AND $7
    ELSE
        p2_color_high_bit = 0
        p2_color_low_bits = p2_color
    END IF
END
