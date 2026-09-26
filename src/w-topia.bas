'Game of W-Topia

OPTION EXPLICIT ON

'any procedure definitions in includes would get executed as any other code
'so jump to main to get right into our program flow without surprises
GOTO main

'note: cannot give INCLUDE a relative path, just a filename; so don't try to reorg into subdirs :)
'note: you also cannot have recursive includes,
'therefore we could not make for example a const-all.bas that includes all the const includes

'includes: const
INCLUDE "const-intv-color.bas"
INCLUDE "const-intv-sprite.bas"
INCLUDE "const-intv-cont.bas"
INCLUDE "const-intv-card.bas"
INCLUDE "const-game-screen.bas"
INCLUDE "const-game-player.bas"
INCLUDE "const-game-card.bas"
INCLUDE "const-game-sprite.bas"
INCLUDE "const-game-misc.bas"
INCLUDE "const-game-player-anim.bas"

'includes: bitmap
INCLUDE "bitmap-cursor.bas"
INCLUDE "bitmap-land.bas"
INCLUDE "bitmap-build.bas"
INCLUDE "bitmap-fishing-boat-death-anim.bas"

'includes: other
INCLUDE "init.bas"
INCLUDE "sound.bas"
INCLUDE "move-cursor.bas"
INCLUDE "side-buttons.bas"
INCLUDE "map.bas"
INCLUDE "cursor-move-data.bas"
INCLUDE "build.bas"
INCLUDE "num-keys.bas"
INCLUDE "status-bar.bas"
INCLUDE "anim.bas"

main:
    GOSUB init
    SCREEN map_cards
    GOSUB update_status_bar
    GOTO game_loop

game_loop:
    SPRITE 0, cur_x(0) + CURSOR_X_PARAMS, cur_y(0) + Y_NORMAL_SCALE + (mirror_x(0) * Y_MIRROR_X), #cur_f(0)
    SPRITE 1, cur_x(1) + CURSOR_X_PARAMS, cur_y(1) + Y_NORMAL_SCALE + (mirror_x(1) * Y_MIRROR_X), #cur_f(1)

    'capture input
    cont_input(0) = CONT1
    cont_input_key(0) = CONT1.key 'can't "reference" key later so must capture like this
    cont_input(1) = CONT2
    cont_input_key(1) = CONT2.key

    'capture collision state
    #col(0) = COL0
    #col(1) = COL1

    'move cursor logic
    FOR p = 0 TO (N_PLAYERS-1)
        other_p = p XOR 1
        GOSUB move_cursor
        GOSUB get_side_button_state
        GOSUB get_num_key_press
        GOSUB process_key_press
        GOSUB update_anim_player
    NEXT p

    GOSUB update_anim_global
    GOSUB if_second_passed_dec_timer
    GOSUB update_status_bar

    IF seconds_left = 0 THEN
        GOSUB end_turn
    END IF
     
    WAIT
    GOTO game_loop

if_second_passed_dec_timer:  PROCEDURE
    IF FRAME - #tmp_frame >= frames_per_sec THEN
        seconds_left = seconds_left - 1
        #tmp_frame = FRAME
    END IF
END

end_turn:   PROCEDURE
    'do end of turn displays + sounds (bing bong bung)
    'bing: scores for this turn that is ending; says SCORES (one char to the left of right most turn number) in white
    PRINT AT 225 COLOR WHITE,"SCORES"
    p = 0 
    GOSUB show_last_turns_score
    p = 1
    GOSUB show_last_turns_score
    GOSUB play_sound_bing
    
    'bong: total scores; says TOTALS in same location
    PRINT AT 225 COLOR WHITE,"TOTALS"
    p = 0
    GOSUB show_score
    p = 1
    GOSUB show_score

    GOSUB play_sound_bong
    
    'bung: back to the game
    PRINT AT 225 COLOR WHITE,"       "
    GOSUB play_sound_bung

    seconds_left = seconds_per_turn
    turns_left = turns_left - 1
    'TODO: check if end of game after decrementing turns_left and handle that
END
