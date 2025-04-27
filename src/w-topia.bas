'Game of W-Topia

'any procedure definitions in includes would get executed as any other code
'so jump to main to get right into our program flow without surprises
GOTO main

'note: cannot give INCLUDE a relative path, just a filename; so don't try to refactor :)
'note: you also cannot have recursive includes,
'therefore we could not make for example a const-all.bas that includes all the following
includes_const:
    INCLUDE "const-intv-color.bas"
    INCLUDE "const-intv-sprite.bas"
    INCLUDE "const-intv-cont.bas"
    INCLUDE "const-intv-card.bas"
    INCLUDE "const-game-screen.bas"
    INCLUDE "const-game-player.bas"
    INCLUDE "const-game-card.bas"
    INCLUDE "const-game-misc.bas"

includes_bitmap:
    INCLUDE "bitmap-cursor.bas"
    INCLUDE "bitmap-land.bas"
    INCLUDE "bitmap-build.bas"

includes_other:
    INCLUDE "init.bas"
    INCLUDE "sound.bas"
    INCLUDE "move-cursor.bas"
    INCLUDE "side-buttons.bas"
    INCLUDE "map.bas"
    INCLUDE "cursor-move-data.bas"
    INCLUDE "build.bas"
    INCLUDE "num-keys.bas"
    INCLUDE "status-bar.bas"

main:
    GOSUB init
    SCREEN map_cards
    GOSUB update_status_bar
    GOTO game_loop

game_loop:
    SPRITE 0, p1_cur_x + CUR_X_PARAMS, p1_cur_y + Y_NORMAL_SCALE, #p1_cur_f
    SPRITE 1, p2_cur_x + CUR_X_PARAMS, p2_cur_y + Y_NORMAL_SCALE, #p2_cur_f

    'capture input
    p1_cont_input = CONT1
    p1_cont_input_key = CONT1.key 'can't "reference" cont_input1.key later so must capture like this
    p2_cont_input = CONT2
    p2_cont_input_key = CONT2.key

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

    GOSUB if_second_passed_dec_timer
    GOSUB update_status_bar

    IF seconds_left = 0 THEN
        GOSUB end_turn
    END IF
     
    WAIT
    GOTO game_loop

if_second_passed_dec_timer:  PROCEDURE
    'potential optimization: do a quicker check than mod that can catch most false case more quickly
    'for example if the last bit is 1 then it's odd so cannot be divisible by FRAMES_PER_SEC
    '(which should only ever be 60 or 50)
    'but need to think about and test a better optimization
    IF FRAME % FRAMES_PER_SEC = 0 THEN
        seconds_left = seconds_left - 1
    END IF
END

end_turn:   PROCEDURE
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
