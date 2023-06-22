CONST KEY_CLEAR   = 10
CONST KEY_ENTER   = 11
CONST KEY_NOTHING = 12

init_num_key_states:    PROCEDURE
    p1_last_num_key_pressed = KEY_NOTHING
    p2_last_num_key_pressed = KEY_NOTHING
END

'''
p1_setup_get_num_key_press: PROCEDURE
    cont_input_key = cont_input1_key
END

p2_setup_get_num_key_press: PROCEDURE
    cont_input_key = cont_input2_key
END

p1_finish_get_num_key_press: PROCEDURE
    p1_key_pressed = p_key_pressed
END

p2_finish_get_num_key_press: PROCEDURE
    p2_key_pressed = p_key_pressed
END
'''

'returns key pressed; 0-9 for numbers, 10=clear, 11=enter, 12=nothing pressed
get_num_key_press:  PROCEDURE 
    p_key_pressed = cont_input_key
END

'''
p1_setup_process_key_press: PROCEDURE
    p_key_pressed = p1_key_pressed
    player = 1
    p_cur_x = p1_cur_x
    p_cur_y = p1_cur_y
    #p_money = #p1_money
    GOSUB p1_setup_get_map_tile
END

p1_finish_process_key_press: PROCEDURE
    p1_last_num_key_pressed = p_last_num_key_pressed
    #p1_money = #p_money
END

p2_setup_process_key_press: PROCEDURE
    p_key_pressed = p2_key_pressed
    player = 2
    p_cur_x = p2_cur_x
    p_cur_y = p2_cur_y
    #p_money = #p2_money
    GOSUB p2_setup_get_map_tile
END

p2_finish_process_key_press: PROCEDURE
    p2_last_num_key_pressed = p_last_num_key_pressed
    #p_money2 = #p_money
END

process_key_press:  PROCEDURE
    IF p_key_pressed = KEY_NOTHING THEN
        RETURN
    END IF

    'case when nothing has been pressed before, so (hopefully) 
    IF p_last_num_key_pressed = KEY_NOTHING THEN 
        IF p_key_pressed = KEY_ENTER THEN 'TODO probably need to handle other keys such as CLEAR and 0
            GOSUB invalid_key_press
        END IF
        p_last_num_key_pressed = p_key_pressed
    ELSEIF p_last_num_key_pressed >= 1 AND p_last_num_key_pressed <= 9 THEN
        IF p_key_pressed = KEY_ENTER THEN
            'building something
            IF #p_money < build_costs(p_last_num_key_pressed-1) THEN
                GOSUB invalid_key_press
            ELSE 'player can afford it
                GOSUB build
            END IF 
            p_last_num_key_pressed = KEY_NOTHING
        ELSE
            GOSUB invalid_key_press
        END IF
    ELSE 'TODO: might not be right but i'm deferring thinking about this
        GOSUB invalid_key_press
    END IF
END 

'''

'important: only to be called from process_key_press!
build:  PROCEDURE
    GOSUB get_can_build_at_cursor
    'PRINT AT 100 COLOR p1_color, <>can_build_at_cursor
    IF can_build_at_cursor THEN
        'check cursor at valid location
        GOSUB get_map_tile
        GOSUB get_map_ownership
        IF map_ownership_result = player THEN
            #p_money = #p_money - build_costs(p_last_num_key_pressed-1)
            building_index = p_last_num_key_pressed-1 'required for set_building and the backtab set below; could refactor to put this in a setup proc
            GOSUB set_building
        ELSE
            GOSUB invalid_key_press
        END IF
    'TODO: ELSE 'boat

    END IF
END

get_can_build_at_cursor:    PROCEDURE
    IF p_last_num_key_pressed >= 1 AND p_last_num_key_pressed <= 7 THEN 'any "building" i.e. not a boat
        can_build_at_cursor = 1
    ELSE
        can_build_at_cursor = 0
    END IF
END

invalid_key_press:  PROCEDURE
    p_last_num_key_pressed = KEY_NOTHING
    'GO BZZZT
END