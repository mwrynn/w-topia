'Game of W-Topia
INCLUDE "const-intv-color.bas"
INCLUDE "const-intv-sprite.bas"
INCLUDE "const-intv-cont.bas"
INCLUDE "const-intv-card.bas"
INCLUDE "const-screen.bas"

GOTO main 'not necessary but stops "label 'MAIN' never used" warning

main:
    GOSUB init
    SCREEN map_cards
    GOSUB update_status_bar
    GOTO game_loop

INCLUDE "init.bas"
INCLUDE "sound.bas"

game_loop:
    SPRITE 0, p1_cur_x + CUR_X_PARAMS, p1_cur_y + Y_NORMAL_SCALE, #p1_cur_f
    SPRITE 1, p2_cur_x + CUR_X_PARAMS, p2_cur_y + Y_NORMAL_SCALE, #p2_cur_f

    'capture input
    cont_input1 = CONT1
    cont_input1_key = CONT1.key 'can't "reference" cont_input1.key later so must capture like this
    cont_input2 = CONT2
    cont_input2_key = CONT2.key

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

    'process number key presses
    GOSUB p1_setup_get_num_key_press
    GOSUB get_num_key_press
    GOSUB p1_finish_get_num_key_press

    GOSUB p1_setup_process_key_press
    GOSUB process_key_press
    GOSUB p1_finish_process_key_press

    GOSUB p2_setup_get_num_key_press
    GOSUB get_num_key_press
    GOSUB p2_finish_get_num_key_press

    GOSUB p2_setup_process_key_press
    GOSUB process_key_press
    GOSUB p2_finish_process_key_press

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

    'show turns left, spaces on the left (support 3 digits)
    PRINT AT SCREEN_STATUS_POS_TURNS_LEFT COLOR YELLOW,<.3>turns_left

    'show time left (seconds), spaces on the left (support 3 digits)
    PRINT AT SCREEN_STATUS_POS_TIME_LEFT COLOR YELLOW,<.3>seconds_left
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
    PRINT AT SCREEN_P1_STATUS_POS_BEGIN COLOR p1_color,<.5>#p1_money
END

p1_show_score:  PROCEDURE
    PRINT AT SCREEN_P1_STATUS_POS_BEGIN COLOR p1_color,<.5>#p1_score
END

p1_show_population: PROCEDURE
    PRINT AT SCREEN_P1_STATUS_POS_BEGIN COLOR p1_color,<.5>#p1_population
END

p1_show_last_turns_score:  PROCEDURE
    PRINT AT SCREEN_P1_STATUS_POS_BEGIN COLOR p1_color,<.5>#p1_show_last_turns_score
END

p2_show_money:  PROCEDURE
    PRINT AT SCREEN_P2_STATUS_POS_BEGIN COLOR p2_color,<.5>#p2_money
END

p2_show_score:  PROCEDURE
    PRINT AT SCREEN_P2_STATUS_POS_BEGIN COLOR p2_color,<.5>#p2_score
END

p2_show_population: PROCEDURE
    PRINT AT SCREEN_P2_STATUS_POS_BEGIN COLOR p2_color,<.5>#p2_population
END

p2_show_last_turns_score:  PROCEDURE
    PRINT AT SCREEN_P2_STATUS_POS_BEGIN COLOR p2_color,<.5>#p2_show_last_turns_score
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
    
    'do end of turn displays + sounds (bing bong bung)
    'bing: scores for this turn that is ending; says SCORES (one char to the left of right most turn number) in white
    PRINT AT 225 COLOR WHITE,"SCORES"
    GOSUB p1_show_last_turns_score
    GOSUB p2_show_last_turns_score
    GOSUB play_sound_bing
    
    'bong: total scores; says TOTALS in same location
    PRINT AT 225 COLOR WHITE,"TOTALS"
    GOSUB p1_show_score
    GOSUB p2_show_score

    GOSUB play_sound_bong
    
    'bung: back to the game
    PRINT AT 225 COLOR WHITE,"       "
    GOSUB play_sound_bung

    seconds_left = max_seconds_left
END

INCLUDE "move-cursor.bas"
INCLUDE "side-buttons.bas"
INCLUDE "bitmap.bas"
INCLUDE "map.bas"
INCLUDE "cursor-move-data.bas"
INCLUDE "build.bas"
INCLUDE "num-keys.bas"