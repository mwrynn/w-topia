init_side_button_states:    PROCEDURE
    p1_last_side_button_state = 0
    p2_last_side_button_state = 0
END

p1_setup_get_side_button_state: PROCEDURE
    cont_input = cont_input1
END

p2_setup_get_side_button_state: PROCEDURE
    cont_input = cont_input2
END

p1_finish_get_side_button_state: PROCEDURE
    p1_side_button_state = p_side_button_state
END
    
p2_finish_get_side_button_state: PROCEDURE
    p2_side_button_state = p_side_button_state
END

get_side_button_state:    PROCEDURE
    'PRINT AT 2 COLOR 7, cont_input
    p_side_button_state = cont_input AND $E0
    PRINT AT 5 COLOR 6, p_side_button_state
END

'''

p1_setup_get_side_button_state_delta:   PROCEDURE
    p_last_side_button_state = p1_last_side_button_state
    p_side_button_state = p1_side_button_state
END

p2_setup_get_side_button_state_delta:	PROCEDURE
    p_last_side_button_state =	p2_last_side_button_state
    p_side_button_state = p2_side_button_state
END

p1_finish_get_side_button_state_delta:  PROCEDURE
    p1_side_button_delta = p_side_button_delta
    p1_last_side_button_state = p1_side_button_state
END

p2_finish_get_side_button_state_delta:	PROCEDURE
    p2_side_button_delta = p_side_button_delta
    p2_last_side_button_state =	p2_side_button_state
END
    
get_side_button_state_delta:    PROCEDURE
    p_side_button_delta = p_last_side_button_state XOR p_side_button_state
END

'''

p1_setup_should_show_score: PROCEDURE
    p_side_button_state = p1_side_button_state
END

p2_setup_should_show_score: PROCEDURE
    p_side_button_state = p2_side_button_state
END

should_show_score:   PROCEDURE
    p_should_show_score = (p_side_button_state = SIDE_BUTTON_TOP) 
END

p1_finish_should_show_score: PROCEDURE
    p1_should_show_score = p_should_show_score
END

p2_finish_should_show_score: PROCEDURE
    p2_should_show_score = p_should_show_score
END

'''

p1_setup_should_show_population: PROCEDURE
    p_side_button_state = p1_side_button_state
END

p2_setup_should_show_population: PROCEDURE
    p_side_button_state = p2_side_button_state
END

should_show_population:   PROCEDURE
    p_should_show_population = (p_side_button_state = SIDE_BUTTON_LEFT_BOTTOM) 
END

p1_finish_should_show_population: PROCEDURE
    p1_should_show_population = p_should_show_population
END

p2_finish_should_show_population: PROCEDURE
    p2_should_show_population = p_should_show_population
END

'''

p1_setup_should_show_last_turns_score: PROCEDURE
    p_side_button_state = p1_side_button_state
END

p2_setup_should_show_last_turns_score: PROCEDURE
    p_side_button_state = p2_side_button_state
END

should_show_last_turns_score:   PROCEDURE
    p_should_show_last_turns_score = (p_side_button_state = SIDE_BUTTON_RIGHT_BOTTOM)
END

p1_finish_should_show_last_turns_score: PROCEDURE
    p1_should_show_last_turns_score = p_should_show_last_turns_score
END

p2_finish_should_show_last_turns_score: PROCEDURE
    p2_should_show_last_turns_score = p_should_show_last_turns_score
END