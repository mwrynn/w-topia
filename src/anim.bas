p1_setup_update_anim: PROCEDURE
    #p_cur_f = #p1_cur_f
    p_anim_frame = p1_anim_frame
    p_anim_frame_timer = p1_anim_frame_timer
    p_current_form = p1_current_form
    p_color_low_bits = p1_color_low_bits
END

update_anim: PROCEDURE
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

    'case of player's active fishing boat dying
    IF p_current_form = FORM_DYING_FISHING_BOAT THEN

        IF p_anim_frame = 0 THEN 'hacky case for first death frame
            #p_cur_f = CARD_BASELINE + p_color_low_bits + (CARD_NUM_FISHING_BOAT_DEATH_ANIM + p_anim_frame) * CARD_MULT
        END IF

        p_anim_frame_timer = p_anim_frame_timer + 1

        IF p_anim_frame_timer = FRAMES_PER_BOAT_DEATH_INCREMENT THEN
            p_anim_frame_timer = 0
            p_anim_frame = p_anim_frame + 1

            IF p_anim_frame > FISHING_BOAT_DEATH_ANIM_FINAL_INDEX THEN 'done dying
                p_current_form = FORM_CURSOR
                p_anim_frame = 0
                p_anim_frame_timer = 0
                #p_cur_f = CARD_BASELINE + p_color_low_bits + CARD_NUM_CURSOR * CARD_MULT
            ELSE
                #p_cur_f = CARD_BASELINE + p_color_low_bits + (CARD_NUM_FISHING_BOAT_DEATH_ANIM + p_anim_frame) * CARD_MULT
            END IF
        END IF
    END IF
END

p1_finish_update_anim: PROCEDURE
    #p1_cur_f = #p_cur_f
    p1_anim_frame = p_anim_frame
    p1_anim_frame_timer = p_anim_frame_timer
    p1_current_form = p_current_form
END