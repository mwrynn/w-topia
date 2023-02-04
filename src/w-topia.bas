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
        
INCLUDE "init.bas"

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

INCLUDE "bitmap.bas"
INCLUDE "cur-move-data.bas"
