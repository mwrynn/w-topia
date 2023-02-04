'Game of W-Topia
    INCLUDE "const-intv-color.bas"
    INCLUDE "const-intv-sprite.bas"
    INCLUDE "const-intv-cont.bas"
    INCLUDE "const-intv-card.bas"
    
    'player 1 cursor constants
    CONST P1_CUR_STARTING_X = 20
    CONST P1_CUR_STARTING_Y = 20

    'player 2 cursor constants
    CONST P2_CUR_STARTING_X = 100
    CONST P2_CUR_STARTING_Y = 20

    'general cursor constants
    CONST CUR_MOVE_THRESHOLD = 6 'how many "move points" trigger the cursor to move a pixel; increase to make cursor slower
    
    'game card constants
    CONST CARD_NUM_CURSOR = 0

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

INCLUDE "move-cursor.bas"
INCLUDE "bitmap.bas"
INCLUDE "cursor-move-data.bas"