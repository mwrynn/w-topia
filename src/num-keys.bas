'********************************************
'*              num-keys.bas                *
'********************************************
'*                                          *
'* constants and procedures related to      *
'* input processing for number keys, incl.  *
'* CLEAR and ENTER                          *
'*                                          *
'********************************************

CONST KEY_CURSOR_SELECT = 0
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
'   last_num_key_pressed, registered_command, key_pressed have been DIM'd
'POSTCONDITIONS:
'   none
'RETURNS:
'   last_num_key_pressed set to KEY_NOTHING (all p indexes)
'   registered_command set to KEY_NOTHING (all p indexes)
'   key_pressed set to KEY_NOTHING (all p indexes)

init_num_key_states:    PROCEDURE
    FOR i = 0 TO (N_PLAYERS-1)
        last_num_key_pressed(i) = KEY_NOTHING
        registered_command(i) = KEY_NOTHING
        key_pressed(i) = KEY_NOTHING
    NEXT i
END

'''

'PROCEDURE get_num_key_press: returns key pressed; 0-9 for numbers, 10=clear, 11=enter, 12=nothing pressed
'   kind of not the most useful proc in and of itself, as the setup and finish could alone do it all
'   but I want to be consistent with the typical pattern of setup/main proc/finish
'PRECONDITIONS:
'   p is set
'POSTCONDITIONS:
'   
'PARAMETERS:
'   cont_input_key: item-per-player array: keypress value, 0-9 for numbers, 10=clear, 11=enter, 12=nothing pressed 
'RETURNS:
'   key_pressed: keypress value, 0-9 for numbers, 10=clear, 11=enter, 12=nothing pressed
get_num_key_press:  PROCEDURE 
    key_pressed(p) = cont_input_key(p)
END

'PROCEDURE process_key_press: this is the "main" proc of handling key presses
'   only takes action when this frame's key press <> previous frame's keypress (release of the key basically)
'PRECONDITIONS:
'   p is set
'POSTCONDITIONS:
'PARAMETERS:
'   key_pressed: item-per-player array: the current key press that we may be processing an action for
'   last_num_key_pressed: item-per-player array: the key press from the last frame: if same as current do nothing
'   current_form: item-per-player array: player's current form (FORM_CURSOR, FORM_PT_BOAT, FORM_FISHING_BOAT)
'                   used for handling 0 keypresses as well as the building commands
'   cur_x: item-per-player array: x position of the top-left corner of the cursor in pixels
'            not used directly by this proc, but by another that it calls
'   cur_y: item-per-player array: y position of the top-left corner of the cursor in pixels
'            not used directly by this proc, but by another that it calls
'   money: item-per-player array: money of the current player
'   registered_command: item-per-player array: the current command that has been registered, but unconfirmed (with ENTER press) as of yet
'   dock_map_index: item-per-player array: card index of the dock for current player
'   player_color_low_bits item-per-player array: 
'   cur_f: item-per-player array:
'RETURNS:
'   registered_command is set if a new command is registered (for p index)
'   last_num_key_pressed is set to the num key pressed if no command is processed AND key_pressed <> last_num_key_pressed (for p index)
'   #cur_f card of player cursor that is updated if necessary (for p index)
'   current_form (for p index)
'   cur_x: updated location of cursor, upper left of selected boat. if no boat selection, not modified (for p index)
'   cur_y: updated location of cursor, upper left of selected boat. if no boat selection, not modified (for p index)

process_key_press:  PROCEDURE
    'ignore keypresses spanning multiple iterations - player holding the key for longer than exactly one frame is expected
    IF key_pressed(p) = last_num_key_pressed(p) THEN 'this will be checked a ton - any room for optimization?
        RETURN
    END IF

    IF current_form(p) = FORM_CURSOR THEN
        IF key_pressed(p) = KEY_NOTHING THEN
            'lock in building selection command once the player releases the key
            IF last_num_key_pressed(p) >= 1 AND last_num_key_pressed(p) <= 9 THEN 
                registered_command(p) = last_num_key_pressed(p)
            END IF 

        ELSEIF key_pressed(p) = KEY_ENTER THEN 
            IF registered_command(p) = KEY_NOTHING THEN 
                GOSUB invalid_key_press
                RETURN
            ELSE 'command good so try to build the thing
                IF #money(p) < build_costs(last_num_key_pressed(p)-1) THEN 'player cannot afford it
                    GOSUB invalid_key_press
                    RETURN
                ELSE 'player can afford it
                    GOSUB build
                    registered_command(p) = KEY_NOTHING
                END IF 
            END IF

        ELSEIF key_pressed(p) >= 1 AND key_pressed(p) <= 9 THEN
            IF registered_command(p) = KEY_NOTHING THEN
                registered_command(p) = key_pressed(p)
            ELSE
                GOSUB invalid_key_press
                RETURN
            END IF
        ELSEIF key_pressed(p) = KEY_CURSOR_SELECT THEN
            'check if cursor on boat that player owns, and if so, select the boat!
            GOSUB attempt_to_select_boat
        END IF
    ELSE 'catch-all for both boat types which can be handled the same
        IF key_pressed(p) = KEY_CURSOR_SELECT THEN
            GOSUB attempt_to_switch_to_cursor
        ELSEIF key_pressed(p) = KEY_NOTHING THEN 'need to check this or when releasing KEY_CURSOR_SELECT logic flows into invalid_key_press case
            p = p 'noop
        ELSE
            GOSUB invalid_key_press
        END IF
    END IF

    last_num_key_pressed(p) = key_pressed(p)
END 

'''
'attempt to select a boat at the current cursor location (p_cur_x and p_cur_y)
'must match player
'if cursor not at a boat of matching player, then invalid selection
'PRECONDITIONS:
'   p is set
'PARAMETERS:
    'cur_x: item-per-player array: map pixel in x dimension (practically speaking, this is tbe top-left pixel of the cursor)
    'cur_y: item-per-player array: map pixel in y dimension (practically speaking, this is tbe top-left pixel of the cursor)
'RETURNS:
    '#cur_f new card if a boat is selected (p index)
    'current_form (p index)
    'cur_x: if boat is selected, this is the upper left pixel coordinate of the boat location, x dim (p index)
    'cur_y: if boat is selected, this is the upper left pixel coordinate of the boat location, y dim (p index)
    'last_cur_x: needs to be set for the "snap" when boat is selected, else if collision we will go back to cursor location (p index)
    'last_cur_y: see above (p index)
'MODIFIES:
    'backtab to remove boat from location
attempt_to_select_boat:  PROCEDURE
    GOSUB can_select_boat_at_cursor

    DIM can_select_boat_at_cursor_result
    DIM get_boat_type_at_cursor_result
    DIM can_leave_boat_at_cursor_result

    IF can_select_boat_at_cursor_result = 1 THEN
         'change form and remove boat from map and have fun!
        GOSUB get_boat_type_at_cursor
        current_form(p) = get_boat_type_at_cursor_result
        other_current_form(p XOR 1) = current_form(p)
        #backtab(map_index) = OO
        '"snap" current coordinates into place so that boat is not skewed - place at the top-left of selected "tile"
        'TODO: might want to move this map math to map.bas
        cur_x(p) = (map_index % 20 + 1) * 8
        cur_y(p) = (map_index / 20 + 1) * 8
        last_cur_x(p) = cur_x(p)
        last_cur_y(p) = cur_y(p)

        IF current_form(p) = FORM_FISHING_BOAT THEN
            #cur_f(p) = (#cur_f(p) AND $F807) OR (CARD_NUM_FISHING_BOAT * CARD_MULT) 'AND F807 wipes all the card bits, then OR the fishing boat bits in
        ELSEIF current_form(p) = FORM_PT_BOAT THEN
            #cur_f(p) = (#cur_f(p) AND $F807) OR (CARD_NUM_PT_BOAT * CARD_MULT) 'AND F807 wipes all the card bits, then OR the PT boat bits in
        ELSE
            'SHOULDN'T GET HERE!
            PRINT AT 8 COLOR player_color(p), "WUT"
        END IF 
    ELSE
        GOSUB invalid_key_press
    END IF
END

'''
'attempt_to_switch_to_cursor - must already be in boat form
'PRECONDITIONS:
    'p is set
'PARAMETERS:
    'cur_x: item-per-player array: map pixel in x dimension (practically speaking, this is tbe top-left pixel of the cursor)
    'cur_y: item-per-player array: map pixel in y dimension (practically speaking, this is tbe top-left pixel of the cursor)
    'color_low_bits: item-per-player array: for use in setting card to a new one if necessary
    'current_form item-per-player array
'RETURNS:
    'current_form (p index)
    'cur_x: if boat is selected, this is the upper left pixel coordinate of the boat location, x dim (p index)
    'cur_y: if boat is selected, this is the upper left pixel coordinate of the boat location, y dim (p index)
    '#cur_f: card for the current form (p index)
'MODIFIES:
    'backtab to set boat at location
attempt_to_switch_to_cursor:  PROCEDURE
    GOSUB can_leave_boat_at_cursor

    IF can_leave_boat_at_cursor_result = 0 THEN
        GOSUB invalid_key_press
        RETURN 
    END IF

    building_index = 6 + current_form(p) 'a bit hacky but the form should be 1 or 2, add 6 offsets properly for boats
    current_form(p) = FORM_CURSOR
    other_current_form(p XOR 1) = FORM_CURSOR
    #cur_f(p) = CARD_BASELINE + player_color_low_bits(p) + CARD_NUM_CURSOR * CARD_MULT

    GOSUB get_map_index_at_cursor 

    map_index_to_set_boat_at = map_index

    GOSUB set_boat
END

'PROCEDURE can_select_boat_at_cursor: helper function to check if can select a boat at a given location
    'considers:
        'tile that cursor is most overlapping with
        'owner of the boat
'PRECONDITIONS:
    'p is set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'registered_command: item-per-player array
    'cur_x: item-per-player array: map pixel in x dimension (practically speaking, this is the top-left pixel of the cursor)
    'cur_y: item-per-player array: map pixel in y dimension (practically speaking, this is the top-left pixel of the cursor)
'RETURNS:
    'can_select_boat_at_cursor_result: 0 if cannot select boat, 1 if can select boat
can_select_boat_at_cursor:    PROCEDURE
    GOSUB get_map_index_at_cursor
    GOSUB get_boat_ownership

    IF get_boat_ownership_result = p THEN
        can_select_boat_at_cursor_result = 1
        RETURN
    END IF
    can_select_boat_at_cursor_result = 0
END

'''
'PROCEDURE can_leave_boat_at_cursor: helper function to check if can build buildings at a given location
    'considers: whether the most overlapped tile has a boat.
'PRECONDITIONS:
    'p is set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'registered_command: item-per-player array
    'cur_x: item-per-player array: map pixel in x dimension (practically speaking, this is the top-left pixel of the cursor)
    'cur_y: item-per-player array: map pixel in y dimension (practically speaking, this is the top-left pixel of the cursor)
'RETURNS:
    'can_leave_boat_at_cursor_result: 0 if cannot select boat, 1 if can select boat
can_leave_boat_at_cursor:    PROCEDURE
    GOSUB get_boat_type_at_cursor

    IF get_boat_type_at_cursor_result = FORM_PT_BOAT OR get_boat_type_at_cursor_result = FORM_FISHING_BOAT THEN
        can_leave_boat_at_cursor_result = 0
        RETURN
    END IF

    can_leave_boat_at_cursor_result = 1
END

'''
'PROCEDURE get_boat_type_at_cursor: helper function to check which boat type is at the tile indicated by the given coordinates
'PARAMETERS:
    'cur_x: item-per-player array: map pixel in x dimension (practically speaking, this is the top-left pixel of the cursor)
    'cur_y: item-per-player array: map pixel in y dimension (practically speaking, this is the top-left pixel of the cursor)
'RETURNS:
    'get_boat_type_at_cursor_result: returns FORM_PT_BOAT or FORM_FISHING_BOAT or something else if no boat is there
get_boat_type_at_cursor:    PROCEDURE
    GOSUB get_map_index_at_cursor
    'TODO document the formula below
    get_boat_type_at_cursor_result = (((#backtab(map_index) AND NOT 7) - CARD_BASELINE) / CARD_MULT) - CARD_NUM_BUILD - 6
END

'''

'would like to move the build-related functions to build.bas
'but they don't work positioned there - lol. figure out why (TODO)

'builds the building at cursor location, or a boat at the dock (or auto-adjusted close-to-dock location)
'PRECONDITIONS:
    'p is set
'PARAMETERS:
    'registered_command: 
    '#money: 
    'dock_map_index: item-per-player array: index of current player's dock in case a dock is being built
    'cur_x: item-per-player array: map pixel in x dimension (practically speaking, this is tbe top-left pixel of the cursor)
    'cur_y: item-per-player array: map pixel in y dimension (practically speaking, this is tbe top-left pixel of the cursor)
'POSTCONDITIONS:
    'none
'RETURNS:
    '#money - subtracted from by the cost of thing to build (for p index)
'MODIFIES:
    '#backtab to create building or boat
'validates whether location is valid, i.e. no preexisting building exists and checks ownership
'assumes that having enough money (#p_money) has already been checked
'deducts money from #p_money; after calling this, caller must set #p[1|2]_money accordingly
build:  PROCEDURE
    DIM can_build_at_cursor_result
    DIM can_build_at_dock_result
    'any building case
    building_index = registered_command(p) - 1
    IF registered_command(p) >= KEY_FORT AND registered_command(p) <= KEY_HOUSE THEN 
        GOSUB can_build_at_cursor
        IF can_build_at_cursor_result THEN
            #money(p) = #money(p) - build_costs(building_index)         
            GOSUB set_building
        ELSE
            GOSUB invalid_key_press
        END IF
    ELSEIF registered_command(p) = KEY_REBEL THEN
        GOSUB select_rebel_index
        map_index = ret_select_rebel_index
        '#money(p) = #money(p) - build_costs(building_index)

        IF ret_select_rebel_index_destroyed_something THEN
            GOSUB play_sound_destroy
            'make destruction sound here
        END IF

        GOSUB set_building
    ELSEIF registered_command(p) = KEY_PT_BOAT OR registered_command(p) = KEY_FISHING_BOAT THEN
        GOSUB can_build_at_dock

        IF can_build_at_dock_result THEN
            #money(p) = #money(p) - build_costs(building_index)
            map_index_to_set_boat_at = dock_map_index(p)
            GOSUB set_boat
        END IF
    ELSE 'wtf case
        p = p 'NOOP; try ASM NOP
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
    'p is set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'registered_command: item-per-player array: command indicating what is being attempted to build (or other command)
    'cur_x: item-per-player array: map pixel in x dimension (practically speaking, this is tbe top-left pixel of the cursor)
    'cur_y: item-per-player array: map pixel in y dimension (practically speaking, this is tbe top-left pixel of the cursor)
'RETURNS:
    'can_build_at_cursor_result (1/0)
can_build_at_cursor:    PROCEDURE

    IF registered_command(p) >= KEY_FORT AND registered_command(p) <= KEY_HOUSE THEN 'any "building" i.e. not a boat/rebel, must be on land owned by player
        GOSUB get_map_index_at_cursor
        GOSUB get_map_ownership

        IF map_ownership_result = p THEN
            'verify no building preexists at location
            GOSUB has_building_or_rebel
            IF NOT ret_has_building_or_rebel THEN
                can_build_at_cursor_result = 1
                RETURN
            END IF
        'ELSE
            'PRINT AT 8 COLOR player_color(p), "can-build-1c"
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
    'p is set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'registered_command: item-per-player array: command indicating what is being attempted to build (or other command)
    'dock_map_index: item-per-player array: dock location (not pixels but "tile")
'RETURNS:
    'can_build_at_dock_result (1/0)

can_build_at_dock:    PROCEDURE
    IF registered_command(p) = KEY_PT_BOAT OR registered_command(p) = KEY_FISHING_BOAT THEN    
        GOSUB is_dock_tile_occupied
        IF ret_is_dock_tile_occupied = 1 THEN
            'PRINT AT 23 COLOR player_color(p), <.3>ret_is_dock_tile_occupied
            can_build_at_dock_result = 0
            RETURN
        END IF
        can_build_at_dock_result = 1
        RETURN
    END IF
    can_build_at_dock_result = 0
END

'PROCEDURE invalid_key_press: resets variables pertaining to an invalid key press
'PRECONDITIONS:
    'p is set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'NONE
'RETURNS:
    'registered_command (p index)
    'last_num_key_pressed (p index)
invalid_key_press:  PROCEDURE
    registered_command(p) = KEY_NOTHING
    last_num_key_pressed(p) = KEY_NOTHING
    GOSUB play_sound_bzzt
END