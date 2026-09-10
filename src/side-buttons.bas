'input processing for side buttons

'PROCEDURE get_side_button_state:
'PRECONDITIONS:
    'p is set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'cont_input: item-per-player array
'RETURNS:
    'side_button_state (for p index)
get_side_button_state:    PROCEDURE
    side_button_state(p) = cont_input(p) AND $E0
END

'PROCEDURE get_should_show_score:
'PRECONDITIONS:
    'p is set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'side_button_state: item-per-player array 
'RETURNS:
    'should_show_score set to 0 or 1 (for p index)
get_should_show_score:   PROCEDURE
    should_show_score(p) = (side_button_state(p) = SIDE_BUTTON_TOP) 
END

'PROCEDURE get_should_show_population:
'PRECONDITIONS:
    'p is set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'side_button_state: item-per-player array 
'RETURNS:
    'should_show_population set to 0 or 1 (for p index)
get_should_show_population:   PROCEDURE
    should_show_population(p) = (side_button_state(p) = SIDE_BUTTON_LEFT_BOTTOM) 
END

'PROCEDURE get_should_show_last_turns_score:
'PRECONDITIONS:
    'p is set
'POSTCONDITIONS:
    'NONE
'PARAMETERS:
    'side_button_state: item-per-player array 
'RETURNS:
    'should_show_population set to 0 or 1 (for p index)
get_should_show_last_turns_score:   PROCEDURE
    should_show_last_turns_score(p) = (side_button_state(p) = SIDE_BUTTON_RIGHT_BOTTOM)
END

