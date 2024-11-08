# w-topia
Remake of Utopia for Intellivision, with extra features, written using IntyBASIC

# Special way this project works with procedures wrt parameters and return value
Intybasic only has global variables so this project fakes it, every proc has a corresponding pair of procs used for initialization and cleanup: setup and finish. Also, since many procedures can apply to either of the two players, there are setup and finish procedures that are prefixed with p1_ and p2_ for player 1 and player 2 respectively.

Example usage:

    'This is the core procedure that does the work
    should_show_score:   PROCEDURE
        p_should_show_score = (p_side_button_state = SIDE_BUTTON_TOP) 
    END
    
    'These are the two setup functions, for player 1 and player 2 respectively
    p1_setup_should_show_score: PROCEDURE
        p_side_button_state = p1_side_button_state
    END
    
    p2_setup_should_show_score: PROCEDURE
        p_side_button_state = p2_side_button_state
    END
    
    'These are the two finish functions, for player 1 and player 2 respectively
    p1_finish_should_show_score: PROCEDURE
        p1_should_show_score = p_should_show_score
    END
    
    p2_finish_should_show_score: PROCEDURE
        p2_should_show_score = p_should_show_score
    END

The variables set in the finish procs should be considered the return value

Naming convention:
Let's generalize the above.

For the procs that can apply to two players, first of all the main proc can be called anything: `do_the_thing`
Then prefixes are `p1_setup_`, `p2_setup_`, `p1_finish_`, `p2_finish_`
Return values are named `p1_do_the_thing` or `p2_do_the_thing`

For the procs that DO NOT apply to two players, it is simply a standalone proc. Returned values are global variables so far. Will see if it is necessary to deviate from that convention in the future.
