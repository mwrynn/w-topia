'code pertaining to display bar; showing money, socre, etc.

p1_get_should_show_vars:    PROCEDURE
    GOSUB p1_setup_should_show_population
    GOSUB should_show_population
    GOSUB p1_finish_should_show_population

    GOSUB p1_setup_should_show_score
    GOSUB should_show_score
    GOSUB p1_finish_should_show_score

    GOSUB p1_setup_should_show_last_turns_score
    GOSUB should_show_last_turns_score
    GOSUB p1_finish_should_show_last_turns_score
END

p2_get_should_show_vars:    PROCEDURE
    GOSUB p2_setup_should_show_population
    GOSUB should_show_population
    GOSUB p2_finish_should_show_population

    GOSUB p2_setup_should_show_score
    GOSUB should_show_score
    GOSUB p2_finish_should_show_score

    GOSUB p2_setup_should_show_last_turns_score
    GOSUB should_show_last_turns_score
    GOSUB p2_finish_should_show_last_turns_score
END

p1_show_money:  PROCEDURE
    PRINT AT SCREEN_P1_STATUS_POS_BEGIN COLOR p1_color,<.5>#p1_money
END

p1_show_score:  PROCEDURE
    PRINT AT SCREEN_P1_STATUS_POS_BEGIN COLOR p1_color,<.5>#p1_score
END

p1_show_population: PROCEDURE
    PRINT AT SCREEN_P1_STATUS_POS_BEGIN COLOR p1_color,<.5>#p1_population
END

p1_show_last_turns_score:  PROCEDURE
    PRINT AT SCREEN_P1_STATUS_POS_BEGIN COLOR p1_color,<.5>#p1_show_last_turns_score
END

p2_show_money:  PROCEDURE
    PRINT AT SCREEN_P2_STATUS_POS_BEGIN COLOR p2_color,<.5>#p2_money
END

p2_show_score:  PROCEDURE
    PRINT AT SCREEN_P2_STATUS_POS_BEGIN COLOR p2_color,<.5>#p2_score
END

p2_show_population: PROCEDURE
    PRINT AT SCREEN_P2_STATUS_POS_BEGIN COLOR p2_color,<.5>#p2_population
END

p2_show_last_turns_score:  PROCEDURE
    PRINT AT SCREEN_P2_STATUS_POS_BEGIN COLOR p2_color,<.5>#p2_show_last_turns_score
END

update_status_bar:  PROCEDURE
    GOSUB p1_get_should_show_vars
    GOSUB p2_get_should_show_vars

    IF p1_should_show_population THEN
        GOSUB p1_show_population
    ELSEIF p1_should_show_score THEN
     	GOSUB p1_show_score
    ELSEIF p1_should_show_last_turns_score THEN
        GOSUB p1_show_last_turns_score
    ELSE
        GOSUB p1_show_money
    END IF

    IF p2_should_show_population THEN
        GOSUB p2_show_population
    ELSEIF p2_should_show_score THEN
        GOSUB p2_show_score
    ELSEIF p2_should_show_last_turns_score THEN
        GOSUB p2_show_last_turns_score
    ELSE
        GOSUB p2_show_money
    END IF

    'show turns left, spaces on the left (support 3 digits)
    PRINT AT SCREEN_STATUS_POS_TURNS_LEFT COLOR YELLOW,<.3>turns_left

    IF seconds_left <> last_seconds_left THEN 'optimization - only print if seconds_left changed, PRINT is expensive
        'show time left (seconds), spaces on the left (support 3 digits)
        PRINT AT SCREEN_STATUS_POS_TIME_LEFT COLOR YELLOW,<.3>seconds_left
        last_seconds_left = seconds_left
    END IF
END
