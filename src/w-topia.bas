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
    CONST CARD_NUM_LAND   = 1 'there are many but this is the first one
    CONST CARD_NUM_LAND_2 = 17 'second block of land cards

    CONST FRAMES_PER_SEC = 60
main:
    GOSUB init
    SCREEN map_cards
    GOSUB update_status_bar
    GOTO game_loop

INCLUDE "init.bas"
    
game_loop:
    SPRITE 0, p1_cur_x + CUR_X_PARAMS, p1_cur_y + Y_NORMAL_SCALE, #p1_cur_f
    SPRITE 1, p2_cur_x + CUR_X_PARAMS, p2_cur_y + Y_NORMAL_SCALE, #p2_cur_f

    'capture input
    cont_input1 = CONT1
    cont_input2 = CONT2

    'p1 move cursor logic
    GOSUB p1_setup_move_cursor
    GOSUB move_cursor
    GOSUB p1_finish_move_cursor

    'p2 move cursor logic
    GOSUB p2_setup_move_cursor
    GOSUB move_cursor
    GOSUB p2_finish_move_cursor

    'process side button/status bar changes
    GOSUB p1_setup_get_side_button_state
    GOSUB get_side_button_state
    GOSUB p1_finish_get_side_button_state
    
    GOSUB p2_setup_get_side_button_state
    GOSUB get_side_button_state
    GOSUB p2_finish_get_side_button_state

    GOSUB do_turn_timer
    GOSUB update_status_bar
    IF seconds_left = 0 THEN
        GOSUB end_turn
    END IF
     
    WAIT
    GOTO game_loop

update_status_bar:  PROCEDURE
    GOSUB p1_get_should_show_vars
    GOSUB p2_get_should_show_vars

    IF p1_should_show_population THEN
        GOSUB p1_show_population
    ELSEIF p1_should_show_score THEN
     	GOSUB p1_show_score
    ELSEIF p1_should_show_last_turns_score THEN
        GOSUB p1_show_last_turns_score
    ELSE
        GOSUB p1_show_money
    END IF

    IF p2_should_show_population THEN
        GOSUB p2_show_population
    ELSEIF p2_should_show_score THEN
        GOSUB p2_show_score
    ELSEIF p2_should_show_last_turns_score THEN
        GOSUB p2_show_last_turns_score
    ELSE
        GOSUB p2_show_money
    END IF

    'show turns left at 226, spaces on the left (support 3 digits)
    PRINT AT 226 COLOR YELLOW,<.3>turns_left

    'show turns left at 230, spaces on the left (support 3 digits)
    PRINT AT 230 COLOR YELLOW,<.3>seconds_left
END

p1_get_should_show_vars:    PROCEDURE
    GOSUB p1_setup_should_show_population
    GOSUB should_show_population
    GOSUB p1_finish_should_show_population

    GOSUB p1_setup_should_show_score
    GOSUB should_show_score
    GOSUB p1_finish_should_show_score

    GOSUB p1_setup_should_show_last_turns_score
    GOSUB should_show_last_turns_score
    GOSUB p1_finish_should_show_last_turns_score
END

p2_get_should_show_vars:    PROCEDURE
    GOSUB p2_setup_should_show_population
    GOSUB should_show_population
    GOSUB p2_finish_should_show_population

    GOSUB p2_setup_should_show_score
    GOSUB should_show_score
    GOSUB p2_finish_should_show_score

    GOSUB p2_setup_should_show_last_turns_score
    GOSUB should_show_last_turns_score
    GOSUB p2_finish_should_show_last_turns_score
END

p1_show_money:  PROCEDURE
    PRINT AT 220 COLOR p1_color,<.5>#p1_money
END

p1_show_score:  PROCEDURE
    PRINT AT 220 COLOR p1_color,<.5>#p1_score
END

p1_show_population: PROCEDURE
    PRINT AT 220 COLOR p1_color,<.5>#p1_population
END

p1_show_last_turns_score:  PROCEDURE
    PRINT AT 220 COLOR p1_color,<.5>#p1_show_last_turns_score
END

p2_show_money:  PROCEDURE
    PRINT AT 234 COLOR p2_color,<.5>#p2_money
END

p2_show_score:  PROCEDURE
    PRINT AT 234 COLOR p2_color,<.5>#p2_score
END

p2_show_population: PROCEDURE
    PRINT AT 234 COLOR p2_color,<.5>#p2_population
END

p2_show_last_turns_score:  PROCEDURE
    PRINT AT 234 COLOR p2_color,<.5>#p2_show_last_turns_score
END

do_turn_timer:  PROCEDURE
    IF FRAME % FRAMES_PER_SEC = 0 THEN
        seconds_left = seconds_left - 1
    END IF
END

end_turn:   PROCEDURE

    'get the map ownership of the selected tile
    'GOSUB p1_setup_get_map_tile
    'GOSUB get_map_tile
    'GOSUB get_map_ownership
    'PRINT AT 108 COLOR RED, <>map_ownership_result
    
    'do bing bong bang
    'bing: scores for this turn that is ending; says SCORES (one char to the left of right most turn number) in white
    PRINT AT 225 COLOR WHITE,"SCORES"
    GOSUB p1_show_last_turns_score
    GOSUB p2_show_last_turns_score
    FOR i = 0 TO 50
        SOUND 0, 213, 10
        WAIT
    NEXT i

    FOR i = 0 TO 50
        SOUND 0,,0
        WAIT
    NEXT i
    
    'bong: total scores; says TOTALS in same location
    PRINT AT 225 COLOR WHITE,"TOTALS"
    FOR i = 0 TO 50
        SOUND 0, 427, 10
        WAIT
    NEXT i
    GOSUB p1_show_score
    GOSUB p2_show_score

    FOR i = 0 TO 50
       SOUND 0,,0
       WAIT
    NEXT i
    
    'bang: back to the game
    PRINT AT 225 COLOR WHITE,"       "
    FOR i = 0 TO 50
        SOUND 0, 320, 10
        WAIT
    NEXT i

    SOUND 0,,0

    seconds_left = max_seconds_left
END

INCLUDE "move-cursor.bas"
INCLUDE "side-buttons.bas"
INCLUDE "bitmap.bas"
INCLUDE "map.bas"
INCLUDE "cursor-move-data.bas"