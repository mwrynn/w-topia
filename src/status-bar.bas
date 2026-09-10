'code pertaining to display bar; showing money, socre, etc.

'PRECONDITIONS:
    'p is set
get_should_show_vars:    PROCEDURE
    GOSUB get_should_show_population
    GOSUB get_should_show_score
    GOSUB get_should_show_last_turns_score
END

show_money:  PROCEDURE
    PRINT AT screen_status_pos_begin(p) COLOR player_color(p),<.4>#money(p)
END

show_score:  PROCEDURE
    PRINT AT screen_status_pos_begin(p) COLOR player_color(p),<.4>#score(p)
END

show_population: PROCEDURE
    PRINT AT screen_status_pos_begin(p) COLOR player_color(p),<.4>#population(p)
END

show_last_turns_score:  PROCEDURE
    PRINT AT screen_status_pos_begin(p) COLOR player_color(p),<.4>#last_turns_score(p)
END
    
update_status_bar:  PROCEDURE
    FOR p = 0 to (N_PLAYERS-1)
        GOSUB get_should_show_vars

        IF should_show_population(p) THEN
            GOSUB show_population
        ELSEIF should_show_score(p) THEN
            GOSUB show_score
        ELSEIF should_show_last_turns_score(p) THEN
            GOSUB show_last_turns_score
        ELSE
            GOSUB show_money
        END IF
    NEXT p

    'show turns left, spaces on the left (support 3 digits)
    IF turns_left <> last_turns_left THEN
        PRINT AT SCREEN_STATUS_POS_TURNS_LEFT COLOR YELLOW,<.3>turns_left
        last_turns_left = turns_left
    END IF

    'show time left (seconds), spaces on the left (support 3 digits)
    IF seconds_left <> last_seconds_left THEN 'optimization - only print if seconds_left changed, PRINT is expensive
        PRINT AT SCREEN_STATUS_POS_TIME_LEFT COLOR YELLOW,<.3>seconds_left
        last_seconds_left = seconds_left
    END IF
END
