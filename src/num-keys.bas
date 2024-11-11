CONST KEY_FORT          = 1
CONST KEY_FACTORY       = 2
CONST KEY_CROPS         = 3
CONST KEY_SCHOOL        = 4
CONST KEY_HOSPITAL      = 5
CONST KEY_HOUSE         = 6
CONST KEY_REBEL         = 7
CONST KEY_PT_BOAT       = 8
CONST KEY_FISHING_BOAT  = 9
CONST KEY_CLEAR         = 10
CONST KEY_ENTER         = 11
CONST KEY_NOTHING       = 12

init_num_key_states:    PROCEDURE
    p1_last_num_key_pressed = KEY_NOTHING
    p2_last_num_key_pressed = KEY_NOTHING
    p1_registered_command = KEY_NOTHING
    p2_registered_command = KEY_NOTHING
    p1_key_pressed = KEY_NOTHING
    p2_key_pressed = KEY_NOTHING
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
    p_registered_command = p1_registered_command
    p_last_num_key_pressed = p1_last_num_key_pressed

    'setups for some procs in map.bas - I don't like it being here but it needs to call the map procs before returning to the "p#" context
    GOSUB p1_setup_get_map_tile
    GOSUB p1_setup_set_building
END

p1_finish_process_key_press: PROCEDURE
    p1_last_num_key_pressed = p_last_num_key_pressed
    p1_registered_command = p_registered_command
    #p1_money = #p_money
    GOSUB p1_finish_get_map_tile
END

p2_setup_process_key_press: PROCEDURE
    p_key_pressed = p2_key_pressed
    player = 2
    p_cur_x = p2_cur_x
    p_cur_y = p2_cur_y
    #p_money = #p2_money
    p_registered_command = p2_registered_command
    p_last_num_key_pressed = p2_last_num_key_pressed

    'setups for some procs in map.bas - I don't like it being here but it needs to call the map procs before returning to the "p#" context
    GOSUB p2_setup_get_map_tile
    GOSUB p2_setup_set_building
END

p2_finish_process_key_press: PROCEDURE
    p2_last_num_key_pressed = p_last_num_key_pressed
    p2_registered_command = p_registered_command
    #p2_money = #p_money
    GOSUB p2_finish_get_map_tile
END

process_key_press:  PROCEDURE
    'debug prints
    'PRINT AT 3 COLOR p1_color, <.2>p_registered_command
    'PRINT AT 6 COLOR p1_color, <.2>p_last_num_key_pressed
    'PRINT AT 9 COLOR p1_color, <.2>p_key_pressed

    'ignore keypresses spanning multiple iterations - player holding the key for longer than exactly 1/50 of a second is expected
    IF p_key_pressed = p_last_num_key_pressed THEN 
        RETURN

    ELSEIF p_key_pressed = KEY_NOTHING THEN
        'lock in building selection command once the player releases the key
        IF p_last_num_key_pressed >= 1 AND p_last_num_key_pressed <= 9 THEN 'this if will be checked a TON - might later need optimizing?
            p_registered_command = p_last_num_key_pressed
        END IF 

    ELSEIF p_key_pressed = KEY_ENTER THEN 
        IF p_registered_command = KEY_NOTHING THEN 
            GOSUB invalid_key_press
            RETURN
        ELSE 'command good so try to build the thing
            IF #p_money < build_costs(p_last_num_key_pressed-1) THEN 'player cannot afford it
                GOSUB invalid_key_press
                RETURN
            ELSE 'player can afford it
                GOSUB build
                p_registered_command = KEY_NOTHING
            END IF 
        END IF

    ELSEIF p_key_pressed >= 1 AND p_key_pressed <= 9 THEN
        IF p_registered_command = KEY_NOTHING THEN
            p_registered_command = p_key_pressed
        ELSE
            GOSUB invalid_key_press
            RETURN
        END IF
    END IF

    p_last_num_key_pressed = p_key_pressed
END 

'''
'would like to move the build-related functions to build.bas
'but they don't work positioned there - lol. figure out why (TODO)

'builds the building at cursor location
'PRECONDITIONS:
    'p_registered_command already set
    '#p_money already set to #p1_money or #p2_money
'validates whether location is valid, i.e. no preexisting building exists and checks ownership
'assumes that having enough money (#p_money) has already been checked
'deducts money from #p_money; after calling this, caller must set #p[1|2]_money accordingly
build:  PROCEDURE
    'any building case
    IF p_registered_command >= KEY_FORT AND p_registered_command <= KEY_HOUSE THEN 
        GOSUB can_build_at_cursor
        PRINT AT 15 COLOR p1_color, <>can_build_at_cursor_result
        IF can_build_at_cursor_result THEN
            #p_money = #p_money - build_costs(p_registered_command-1)
            building_index = p_registered_command - 1 'required for set_building and the backtab set below; could refactor to put this in a setup proc
            GOSUB set_building
        ELSE
            GOSUB invalid_key_press
        END IF
    ELSEIF p_registered_command = KEY_REBEL THEN
        p_registered_command=p_registered_command 'doing this as NOOP until I can figure out a proper way to do it
    ELSEIF p_registered_command = KEY_FISHING_BOAT OR p_registered_command = KEY_FISHING_BOAT THEN
        GOSUB can_build_at_dock
    'wtf case
    ELSE 
        p_registered_command = p_registered_command 'NOOP but maybe this should exit the program/display error msg if possible
    END IF
END

'helper function to check if can build buildings
'PRECONDITIONS:
    'p_registered_command already set
    'p#_setup_get_map_tile already called
    'player is set
'has no setup/finish funcs
'does not consider cost
can_build_at_cursor:    PROCEDURE
    IF p_registered_command >= KEY_FORT AND p_registered_command <= KEY_HOUSE THEN 'any "building" i.e. not a boat/rebel, must be on land owned by player
        GOSUB get_map_tile
        GOSUB get_map_ownership

        IF map_ownership_result = player THEN
            'verify no building preexists at location
            GOSUB has_building
            IF NOT ret_has_building THEN
                can_build_at_cursor_result = 1
                RETURN
            END IF
        END IF
    END IF
    can_build_at_cursor_result = 0
END

'does not consider cost
'PRECONDITION p_registered_command already set
'has no setup/finish funcs
can_build_at_dock:    PROCEDURE
    IF p_registered_command = 8 OR p_registered_command = 9 THEN
    END IF
    can_build_at_dock_result = 0
END

invalid_key_press:  PROCEDURE
    p_registered_command = KEY_NOTHING
    p_last_num_key_pressed = KEY_NOTHING
    GOSUB play_sound_bzzt
END