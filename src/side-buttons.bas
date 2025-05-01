'input processing for side buttons

'''

p1_setup_get_side_button_state: PROCEDURE
    p_cont_input = p1_cont_input
END

p2_setup_get_side_button_state: PROCEDURE
    p_cont_input = p2_cont_input
END

get_side_button_state:    PROCEDURE
    p_side_button_state = p_cont_input AND $E0
END

p1_finish_get_side_button_state: PROCEDURE
    p1_side_button_state = p_side_button_state
END
    
p2_finish_get_side_button_state: PROCEDURE
    p2_side_button_state = p_side_button_state
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
