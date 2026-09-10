'**********************************************
'*                 init.bas                   *
'**********************************************
'*                                            *
'*  initializes various variables such as     *
'*  colors, cursor positions, global data     *
'*  (turns, seconds per turn, etc.)           *
'*  Also initializes graphics.                *
'*                                            *
'*  The caller should just call the init proc *
'*  as the rest are "private"                 *
'*                                            *
'**********************************************

init:   PROCEDURE
    'init graphics
    CLS
    MODE 0, BLUE, TAN, BLUE, TAN
    WAIT
    DEFINE CARD_NUM_CURSOR, 1, cursor_bitmap 'define cursor as card 0; 1 means load just 1 card (can do multiple)
    WAIT 'cards will get garbled if no WAIT between DEFINEs
    DEFINE CARD_NUM_LAND, 16, land_bitmaps
    WAIT
    DEFINE CARD_NUM_LAND_2, 1, land_bitmaps_2 'second block of land cards, because limit of 16 cards loaded at a time
    WAIT
    DEFINE CARD_NUM_BUILD, 9, build_bitmaps
    WAIT
    DEFINE CARD_NUM_FISHING_BOAT_DEATH_ANIM, 5, fishing_boat_death_anim_bitmaps
    WAIT

    GOSUB init_player_colors
    GOSUB init_cursor
    GOSUB init_player_stats
    GOSUB init_game_stats
    GOSUB init_num_key_states
    GOSUB init_dock_map_indexes
    GOSUB init_misc
END

'set up color data including high and low bits for both players; used in SPRITE call
init_player_colors: PROCEDURE
    DIM player_color(N_PLAYERS)
    DIM player_color_high_bit(N_PLAYERS)
    DIM player_color_low_bits(N_PLAYERS)
    DIM player_index_to_color(N_PLAYERS)
    DIM player_index_to_opponent_color(2)

    FOR i = 0 TO (N_PLAYERS-1)
        player_color(i) = player_default_color(i)

        IF player_color(i) > $7 THEN
            player_color_high_bit(i) = 1
            player_color_low_bits(i) = player_color(i) AND $7
        ELSE
            player_color_high_bit(i) = 0
            player_color_low_bits(i) = player_color(i)
        END IF

        player_index_to_color(i) = player_color(i)

        player_index_to_opponent_color(i) = player_color(i XOR 1)
    NEXT i
END
    
init_cursor:    PROCEDURE
    DIM cur_x(N_PLAYERS) 
    DIM cur_y(N_PLAYERS)
    DIM last_cur_x(N_PLAYERS)
    DIM last_cur_y(N_PLAYERS)
    DIM cur_x_move_points(N_PLAYERS)
    SIGNED cur_x_move_points
    DIM cur_y_move_points(N_PLAYERS)
    SIGNED cur_y_move_points
    DIM #cur_f(N_PLAYERS)
    DIM mirror_x(N_PLAYERS)
    DIM other_cur_x(N_PLAYERS)
    DIM other_cur_y(N_PLAYERS)
    DIM current_form(N_PLAYERS)
    DIM other_current_form(N_PLAYERS)

    FOR i = 0 TO (N_PLAYERS-1)
        cur_x(i) = cur_starting_x(i)
        cur_y(i) = cur_starting_y(i)

        #cur_f(i) = CARD_BASELINE + player_color_low_bits(i) + CARD_NUM_CURSOR * CARD_MULT

        IF player_color_high_bit(i) = 1 THEN 'to avoid using a 16-bit int just for high bit. ($1000 AND player_color_high_bit(i)) doesn't work
            #cur_f(i) = #cur_f(i) + $1000
        END IF

        current_form(i) = FORM_CURSOR
        other_current_form(i XOR 1) = FORM_CURSOR

        cur_x_move_points(i) = 0
        cur_y_move_points(i) = 0
    NEXT i
END


init_player_stats:  PROCEDURE
    DIM #money(N_PLAYERS)
    DIM #score(N_PLAYERS)
    DIM #population(N_PLAYERS)
    DIM #last_turns_score(N_PLAYERS)
    DIM anim_frame(N_PLAYERS)
    DIM anim_frame_timer(N_PLAYERS)

    FOR i = 0 TO (N_PLAYERS-1)
        #money(i) = STARTING_MONEY
        #score(i) = 0
        #population(i) = STARTING_POPULATION
        #last_turns_score(i) = 0
        anim_frame(i) = 0
        anim_frame_timer(i) = 0
    NEXT i
END

init_game_stats:  PROCEDURE
    turns_left = HARDCODED_TURNS_LEFT
    seconds_per_turn = HARDCODED_SECONDS_PER_TURN
    seconds_left = seconds_per_turn
END

init_misc:  PROCEDURE
    CONST #COLOR_STACK_BG_SHIFT = &0010000000000000
    CONST #NEGATE_COLOR_STACK_BG_SHIFT = &1101111111111111
    UNSIGNED #tmp_frame
    #tmp_frame = 0
    CONST BACKTAB_OUT_OF_BOUNDS_INDEX = 240
    dying_boat_backtab_index = BACKTAB_OUT_OF_BOUNDS_INDEX
    backtab_anim_frame = 0
    backtab_anim_frame_timer = 0
    UNSIGNED frames_per_sec
    IF NTSC THEN
        frames_per_sec = 60
    ELSE
        frames_per_sec = 50
    END IF
    
    DIM cont_input(N_PLAYERS)
    DIM cont_input_key(N_PLAYERS)
    DIM #col(N_PLAYERS) 'collision data
    DIM sprite_index(N_PLAYERS)
    DIM other_sprite_index(N_PLAYERS)
    DIM should_show_score(N_PLAYERS)
    DIM should_show_population(N_PLAYERS)
    DIM should_show_last_turns_score(N_PLAYERS)
    DIM side_button_state(N_PLAYERS)
    DIM last_num_key_pressed(N_PLAYERS)
    DIM registered_command(N_PLAYERS)
    DIM key_pressed(N_PLAYERS) 
    
    FOR i = 0 TO (N_PLAYERS-1)
        sprite_index(i) = i
        other_sprite_index(i) = (i XOR 1)
    NEXT i
END

init_dock_map_indexes:  PROCEDURE
    DIM dock_map_index(N_PLAYERS)

    FOR i = 0 TO (N_PLAYERS-1)
        dock_map_index(i) = 20*build_dock_y(i) + build_dock_x(i)
    NEXT i
END
