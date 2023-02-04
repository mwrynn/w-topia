'Game of W-Topia
    'color constants
    CONST BLACK = 0
    CONST BLUE = 1
    CONST RED = 2
    CONST TAN = 3
    CONST DARK_GREEN = 4
    CONST GREEN = 5
    CONST YELLOW = 6
    CONST WHITE = 7
    CONST GRAY = 8
    CONST CYAN = 9
    CONST ORANGE = 10
    CONST BROWN = 11
    CONST PINK = 12
    CONST LIGHT_BLUE = 13
    CONST YELLOW_GREEN = 14
    CONST PURPLE = 15

    'player 1 cursor constants
    CONST P1_CUR_STARTING_X = 20
    CONST P1_CUR_STARTING_Y = 20

    'player 2 cursor constants
    CONST P2_CUR_STARTING_X = 100
    CONST P2_CUR_STARTING_Y = 20

    'general cursor constants
    CONST CUR_MOVE_THRESHOLD = 6 'how many "move points" trigger the cursor to move a pixel; increase to make cursor slower
    
    'intv card constants
    CONST CARD_BASELINE = $0800
    CONST CARD_MULT = 8

    'game card constants
    CONST CARD_NUM_CURSOR = 0

    'sprite constants
    CONST X_NO_INTERACT  = $0000
    CONST X_INTERACT     = $0100
    CONST X_VISIBLE      = $0200
    CONST X_INVISIBLE    = $0000
    CONST X_DOUBLE_SIZE  = $0400
    CONST X_NORMAL_SIZE  = $0000
    
    CONST Y_NORMAL_SCALE = $0100
    CONST Y_HALF_SCALE   = $0000
    CONST Y_DOUBLE_SCALE = $0200
    CONST Y_QUAD_SCALE   = $0300
    CONST Y_MIRROR_X     = $0400
    CONST Y_MIRROR_Y     = $0800 

    'controller constants
    CONST UP               = $04
    CONST DOWN             = $01
    CONST LEFT             = $08
    CONST RIGHT            = $02
    CONST UP_LEFT          = $1C
    CONST UP_RIGHT         = $16
    CONST DOWN_LEFT        = $19
    CONST DOWN_RIGHT       = $13
    CONST UP_UP_LEFT       = $0C
    CONST UP_LEFT_LEFT     = $18
    CONST UP_UP_RIGHT      = $14
    CONST UP_RIGHT_RIGHT   = $06
    CONST DOWN_DOWN_LEFT   = $11
    CONST DOWN_LEFT_LEFT   = $09
    CONST DOWN_DOWN_RIGHT  = $03
    CONST DOWN_RIGHT_RIGHT = $12

main:
    GOSUB init
    GOTO game_loop
        
init:   PROCEDURE
    'init graphics
    CLS
    MODE 0, BLUE, TAN, BLUE, TAN
    WAIT
    DEFINE CARD_NUM_CURSOR, 1, cursor_bitmap 'define cursor as card 0; 1 means load just 1 card (can do multiple)
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

game_loop:
    SPRITE 0, p1_cur_x + CUR_X_PARAMS, p1_cur_y + Y_NORMAL_SCALE, #p1_cur_f
    SPRITE 1, p2_cur_x + CUR_X_PARAMS, p2_cur_y + Y_NORMAL_SCALE, #p2_cur_f

    'p1 move cursor logic
    GOSUB p1_setup_move_cursor
    GOSUB move_cursor
    GOSUB p1_finish_move_cursor

    'p2 move cursor logic
    GOSUB p2_setup_move_cursor
    GOSUB move_cursor
    GOSUB p2_finish_move_cursor
    
    WAIT
    GOTO game_loop

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

p1_setup_move_cursor:  PROCEDURE
    c_input = CONT1
    p_cur_x_move_points = p1_cur_x_move_points
    p_cur_y_move_points = p1_cur_y_move_points
    p_cur_x = p1_cur_x
    p_cur_y = p1_cur_y
END

p2_setup_move_cursor:  PROCEDURE
    c_input = CONT2
    p_cur_x_move_points = p2_cur_x_move_points
    p_cur_y_move_points = p2_cur_y_move_points
    p_cur_x = p2_cur_x
    p_cur_y = p2_cur_y
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

cursor_bitmap:
    BITMAP "XXXXXXXX"
    BITMAP "X......X"
    BITMAP "X......X"
    BITMAP "X......X"
    BITMAP "X......X"
    BITMAP "X......X"
    BITMAP "X......X"
    BITMAP "XXXXXXXX"

'indicates how many cursor "move points" are added when moving in each of the 16 directions
'0s are for non-existent direction values; more efficient way? sparsely populated?
direction_offset_x: 
    DATA  0, 0, 2, 1, 0, 0, 2, 0   '$00 - $07
    DATA -2,-2, 0, 0,-1, 0, 0, 0   '$08 - $0F
    DATA  0,-1, 2, 2, 1, 0, 2, 0   '$10 - $17
    DATA -2,-2, 0, 0,-2, 0, 0, 0   '$18 - $1F

direction_offset_y:
    DATA  0, 2, 0, 2,-2, 0,-1, 0   '$00 - $07
    DATA  0, 1, 0, 0,-2 ,0, 0, 0   '$08 - $0F
    DATA  0, 2, 1, 2,-2, 0,-2, 0   '$10 - $17
    DATA -1, 2, 0, 0,-2, 0, 0, 0   '$18 - $1F
