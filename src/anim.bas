update_anim_global: PROCEDURE
    'handle dying boat animation
    IF dying_boat_backtab_index <> BACKTAB_OUT_OF_BOUNDS_INDEX THEN
        IF backtab_anim_frame = 0 THEN
            #backtab(dying_boat_backtab_index) = #backtab(dying_boat_backtab_index) AND $F807 OR (CARD_BASELINE + CARD_NUM_FISHING_BOAT_DEATH_ANIM * CARD_MULT) 'TODO comment what $F807 is
        END IF

        backtab_anim_frame_timer = backtab_anim_frame_timer + 1

        IF backtab_anim_frame_timer = FRAMES_PER_BOAT_DEATH_INCREMENT THEN
            backtab_anim_frame_timer = 0
            backtab_anim_frame = backtab_anim_frame + 1

            IF backtab_anim_frame > FISHING_BOAT_DEATH_ANIM_FINAL_INDEX THEN 'done dying
                backtab_anim_frame = 0
                backtab_anim_frame_timer = 0
                'empty out
                '#backtab(dying_boat_backtab_index) = #backtab(dying_boat_backtab_index) AND $F807 OR (CARD_BASELINE + OO)
                #backtab(dying_boat_backtab_index) = OO
                dying_boat_backtab_index = BACKTAB_OUT_OF_BOUNDS_INDEX
            ELSE
                #backtab(dying_boat_backtab_index) = #backtab(dying_boat_backtab_index) AND $F807 OR (CARD_BASELINE + (CARD_NUM_FISHING_BOAT_DEATH_ANIM + backtab_anim_frame) * CARD_MULT)
            END IF
        END IF
    END IF
END

' update player-specific animations
' PRECONDITIONS:
    'p is set
update_anim_player: PROCEDURE
    'case of player's active fishing boat dying
    IF current_form(p) = FORM_DYING_FISHING_BOAT THEN

        IF anim_frame(p) = 0 THEN 'hacky case for first death frame
            #cur_f(p) = CARD_BASELINE + player_color_low_bits(p) + (CARD_NUM_FISHING_BOAT_DEATH_ANIM + anim_frame(p)) * CARD_MULT
        END IF

        anim_frame_timer(p) = anim_frame_timer(p) + 1

        IF anim_frame_timer(p) = FRAMES_PER_BOAT_DEATH_INCREMENT THEN
            anim_frame_timer(p) = 0
            anim_frame(p) = anim_frame(p) + 1

            IF anim_frame(p) > FISHING_BOAT_DEATH_ANIM_FINAL_INDEX THEN 'done dying
                current_form(p) = FORM_CURSOR
                other_current_form(p XOR 1) = FORM_CURSOR
                anim_frame(p) = 0
                anim_frame_timer(p) = 0
                #cur_f(p) = CARD_BASELINE + player_color_low_bits(p) + CARD_NUM_CURSOR * CARD_MULT
            ELSE
                #cur_f(p) = CARD_BASELINE + player_color_low_bits(p) + (CARD_NUM_FISHING_BOAT_DEATH_ANIM + anim_frame(p)) * CARD_MULT
            END IF
        END IF
    END IF
END