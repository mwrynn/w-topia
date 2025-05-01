'********************************************
'*              num-keys.bas                *
'********************************************
'*                                          *
'* constants and procedures realted to      *
'* input processing for number keys, incl.  *
'* CLEAR and ENTER                          *
'*                                          *
'********************************************

CONST KEY_CURSOR_SELECT = 1
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

'PROCEDURE init_num_key_states: initializes all keypress-related variables to indicate nothing is pressed
'PRECONDITIONS:
'   none
'POSTCONDITIONS:
'   none
'PARAMETERS:
'   none
'RETURNS:
'   [p1|p2]_last_num_key_pressed set to KEY_NOTHING
'   [p1|p2]_registered_command set to KEY_NOTHING
'   [p1|p2]_key_pressed set to KEY_NOTHING

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
    p_cont_input_key = p1_cont_input_key
END

p2_setup_get_num_key_press: PROCEDURE
    p_cont_input_key = p2_cont_input_key
END

'PROCEDURE get_num_key_press: returns key pressed; 0-9 for numbers, 10=clear, 11=enter, 12=nothing pressed
'   kind of not the most useful proc in and of itself, as the setup and finish could alone do it all
'   but I want to be consistent with the typical pattern of setup/main proc/finish
'PRECONDITIONS:
'   call p[1|2]_setup_get_num_key_press
'POSTCONDITIONS:
'   call [p1|2]_finish_get_num_key_press
'PARAMETERS:
'   p_cont_input_key: keypress value, 0-9 for numbers, 10=clear, 11=enter, 12=nothing pressed
'RETURNS:
'   p_key_pressed: keypress value, 0-9 for numbers, 10=clear, 11=enter, 12=nothing pressed
get_num_key_press:  PROCEDURE 
    p_key_pressed = p_cont_input_key
END

p1_finish_get_num_key_press: PROCEDURE
    p1_key_pressed = p_key_pressed
END

p2_finish_get_num_key_press: PROCEDURE
    p2_key_pressed = p_key_pressed
END

'''

'note this setup proc (and p2 below) copies several variables, and in the vast majority of calls to the proc
'that this proc supports (process_key_press), it simply exits out due to IF p_key_pressed = p_last_num_key_pressed
'evaluating to true. therefore a potential optimization may be to squeeze in such a check here, or even at
'the caller
p1_setup_process_key_press: PROCEDURE
    p_key_pressed = p1_key_pressed
    player = 1
    p_cur_x = p1_cur_x
    p_cur_y = p1_cur_y
    #p_money = #p1_money
    p_registered_command = p1_registered_command
    p_last_num_key_pressed = p1_last_num_key_pressed

    'need to set dock position so that we can hand off to a player-agnostic flow from here
    p_dock_map_index = p1_dock_map_index

    'setups for some procs in map.bas - I don't like it being here but it needs to call the map procs before returning to the "p#" context
    GOSUB p1_setup_get_map_tile_at_cursor
    GOSUB p1_setup_set_building
END

p2_setup_process_key_press: PROCEDURE
    p_key_pressed = p2_key_pressed
    player = 2
    p_cur_x = p2_cur_x
    p_cur_y = p2_cur_y
    #p_money = #p2_money
    p_registered_command = p2_registered_command
    p_last_num_key_pressed = p2_last_num_key_pressed

    'need to set dock position so that we can hand off to a player-agnostic flow from here
    p_dock_map_index = p2_dock_map_index

    'setups for some procs in map.bas - I don't like it being here but it needs to call the map procs before returning to the "p#" context
    GOSUB p2_setup_get_map_tile_at_cursor
    GOSUB p2_setup_set_building
END

'PROCEDURE process_key_press: this is the "main" proc of handling key presses
'   only takes action when this frame's key press <> previous frame's keypress (release of the key basically)
'PRECONDITIONS:
'   [p1|p2]_setup_process_key_press is called
'POSTCONDITIONS:
'   [p1|p2]_finish_process_key_press is called
'PARAMETERS:
'   p_key_pressed: the current key press that we may be processing an action for
'   p_last_num_key_pressed: the key press from the last frame: if same as current do nothing
'   player: the current player number, not used directly by this proc, but by another that it calls
'   p_cur_x: x position of the top-left corner of the cursor in pixels
'            not used directly by this proc, but by another that it calls
'   p_cur_y: y position of the top-left corner of the cursor in pixels
'            not used directly by this proc, but by another that it calls
'   #p_money: money of the current player
'   p_registered_command: the current command that has been registered, but unconfirmed (with ENTER press) as of yet
'   p_dock_map_index: card index of the dock for current player
'RETURNS:
'   [p1|p2]_registered_command is set if a new command is registered
'   [p1|p2]_last_num_key_pressed is set to the num key pressed if no command is processed AND p_key_pressed <> p_last_num_key_pressed

process_key_press:  PROCEDURE
    'ignore keypresses spanning multiple iterations - player holding the key for longer than exactly one frame is expected
    IF p_key_pressed = p_last_num_key_pressed THEN 'this will be checked a ton - any room for optimization?
        RETURN
    ELSEIF p_key_pressed = KEY_NOTHING THEN
        'lock in building selection command once the player releases the key
        IF p_last_num_key_pressed >= 1 AND p_last_num_key_pressed <= 9 THEN 
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
    ELSEIF p_key_pressed = KEY_CURSOR_SELECT THEN
        'if current state is cursor and 
    END IF

    p_last_num_key_pressed = p_key_pressed
END 

p1_finish_process_key_press: PROCEDURE
    p1_last_num_key_pressed = p_last_num_key_pressed
    p1_registered_command = p_registered_command
    #p1_money = #p_money
    GOSUB p1_finish_get_map_tile_at_cursor
END


p2_finish_process_key_press: PROCEDURE
    p2_last_num_key_pressed = p_last_num_key_pressed
    p2_registered_command = p_registered_command
    #p2_money = #p_money
    GOSUB p2_finish_get_map_tile_at_cursor
END

'''

'would like to move the build-related functions to build.bas
'but they don't work positioned there - lol. figure out why (TODO)

'builds the building at cursor location, or a boat at the dock (or auto-adjusted close-to-dock location)
'PRECONDITIONS:
    'params all set
'PARAMETERS:
    'p_registered_command: 
    '#p_money: 
    'player: number of current player
    'p_dock_map_index: index of current player's dock in case a dock is being built
    'p_cur_x: map pixel in x dimension (practically speaking, this is tbe top-left pixel of the cursor)
    'p_cur_y: map pixel in y dimension (practically speaking, this is tbe top-left pixel of the cursor)
'POSTCONDITIONS:
    'none
'RETURNS:
    'none
'validates whether location is valid, i.e. no preexisting building exists and checks ownership
'assumes that having enough money (#p_money) has already been checked
'deducts money from #p_money; after calling this, caller must set #p[1|2]_money accordingly
build:  PROCEDURE
    'any building case
    'PRINT AT 3 COLOR p1_color, <.2>p_registered_command
    building_index = p_registered_command - 1
    'PRINT AT 3 COLOR p1_color, <.2>building_index
    IF p_registered_command >= KEY_FORT AND p_registered_command <= KEY_HOUSE THEN 
        GOSUB can_build_at_cursor
        IF can_build_at_cursor_result THEN
            
            #p_money = #p_money - build_costs(building_index)         
            GOSUB set_building
        ELSE
            GOSUB invalid_key_press
        END IF
    ELSEIF p_registered_command = KEY_REBEL THEN
        p_registered_command=p_registered_command 'doing this as NOOP until I can figure out a proper way to do it
    ELSEIF p_registered_command = KEY_PT_BOAT OR p_registered_command = KEY_FISHING_BOAT THEN
        GOSUB can_build_at_dock
        IF can_build_at_dock_result THEN
            PRINT AT 3 COLOR p1_color, "X"
            #p_money = #p_money - build_costs(building_index)
            GOSUB set_boat
        END IF
    'wtf case
    ELSE 
        p_registered_command = p_registered_command 'NOOP but maybe this should exit the program/display error msg if possible
    END IF
END

'PROCEDURE can_build_at_cursor: helper function to check if can build buildings at a given location
    'considers:
        'tile that cursor is most overlapping with
        'owner of that tile
        'whether command is for a building (e.g. a fort but not a PT Boat)
    'does not consider:
        'if player has enough money
    'does not actually create/set the building
'PRECONDITIONS:
    'p_registered_command is set
    'p#_setup_get_map_tile_at_cursor already called
        'therefore setting p_cur_x, p_cur_y
    'player is set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'p_registered_command: command indicating what is being attempted to build (or other command)
    'p_cur_x: map pixel in x dimension (practically speaking, this is tbe top-left pixel of the cursor)
    'p_cur_y: map pixel in y dimension (practically speaking, this is tbe top-left pixel of the cursor)
    'player: player number to be used in ownership check
'RETURNS:
    'can_build_at_cursor_result (1/0)
can_build_at_cursor:    PROCEDURE
    IF p_registered_command >= KEY_FORT AND p_registered_command <= KEY_HOUSE THEN 'any "building" i.e. not a boat/rebel, must be on land owned by player
        GOSUB get_map_tile_at_cursor
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
'has no setup/finish funcs
'PROCEDURE can_build_at_dock: helper function to check if can build boat at a given dock location
    'considers:
        'owner of that tile
        'whether command is for a boat (e.g. a PT boat or a fishing boat, but not a hospital, etc.)
    'does not consider:
        'if player has enough money
    'does not actually create/set the building
'PRECONDITIONS:
    'parameters have all been set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'p_registered_command: command indicating what is being attempted to build (or other command)
    'player: player number to be used in ownership check
    'p_dock_map_index: dock location (not pixels but "tile")
'RETURNS:
    'can_build_at_dock_result (1/0)

can_build_at_dock:    PROCEDURE
    IF p_registered_command = KEY_PT_BOAT OR p_registered_command = KEY_FISHING_BOAT THEN    
        PRINT AT 3 COLOR p1_color, "A"
        GOSUB is_dock_tile_occupied
        IF ret_is_dock_tile_occupied = 1 THEN
            PRINT AT 3 COLOR p1_color, "B"
            can_build_at_dock_result = 0
            RETURN
        END IF
        PRINT AT 3 COLOR p1_color, "C"
        can_build_at_dock_result = 1
        RETURN
    END IF
    PRINT AT 3 COLOR p1_color, "D"
    can_build_at_dock_result = 0
END

invalid_key_press:  PROCEDURE
    p_registered_command = KEY_NOTHING
    p_last_num_key_pressed = KEY_NOTHING
    GOSUB play_sound_bzzt
END