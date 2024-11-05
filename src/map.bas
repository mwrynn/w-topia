CONST OO = 0
CONST XX = CARD_BASELINE + 1 * CARD_MULT + TAN
CONST AA = CARD_BASELINE + 2 * CARD_MULT + TAN
CONST BB = CARD_BASELINE + 3 * CARD_MULT + TAN
CONST CC = CARD_BASELINE + 4 * CARD_MULT + TAN
CONST DD = CARD_BASELINE + 5 * CARD_MULT + TAN
CONST EE = CARD_BASELINE + 6 * CARD_MULT + TAN
CONST FF = CARD_BASELINE + 7 * CARD_MULT + TAN
CONST GG = CARD_BASELINE + 8 * CARD_MULT + TAN
CONST HH = CARD_BASELINE + 9 * CARD_MULT + TAN
CONST II = CARD_BASELINE +10 * CARD_MULT + TAN
CONST JJ = CARD_BASELINE +11 * CARD_MULT + TAN
CONST KK = CARD_BASELINE +12 * CARD_MULT + TAN
CONST LL = CARD_BASELINE +13 * CARD_MULT + TAN
CONST MM = CARD_BASELINE +14 * CARD_MULT + TAN
CONST NN = CARD_BASELINE +15 * CARD_MULT + TAN
CONST PP = CARD_BASELINE +16 * CARD_MULT + TAN
CONST QQ = CARD_BASELINE +17 * CARD_MULT + TAN

map_cards:
    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
    DATA OO,OO,AA,OO,OO,OO,OO,OO,OO,OO,GG,BB,OO,AA,OO,OO,AA,OO,OO,OO
    DATA OO,GG,XX,BB,OO,OO,OO,OO,OO,OO,KK,XX,PP,FF,NN,MM,LL,OO,OO,OO
    DATA OO,KK,XX,LL,OO,OO,OO,OO,OO,OO,EE,II,OO,OO,EE,XX,XX,BB,OO,OO
    DATA OO,EE,FF,XX,MM,BB,OO,OO,OO,OO,OO,OO,OO,OO,OO,EE,XX,XX,BB,OO
    DATA OO,OO,OO,EE,XX,XX,BB,OO,OO,OO,OO,OO,OO,OO,OO,OO,JJ,XX,LL,OO
    DATA OO,OO,OO,OO,JJ,XX,QQ,MM,BB,OO,OO,OO,OO,OO,OO,DD,FF,XX,II,OO
    DATA OO,OO,OO,DD,FF,II,OO,EE,FF,NN,PP,CC,OO,OO,OO,OO,OO,HH,OO,OO
    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO

'player ownership
CONST YY = 1
CONST ZZ = 2

'building plus ownership algorithm:
'player 1 ownership is rightmost bit on, second-to-rightmost bit off
'player 2 ownership is rightmost bit off, second-to-rightmost bit on
'building number 1-7 shifted over by two bits, ORed with ownership two bits

'TODO I think this has to be an array if we want to write to it; kinda big though so may need a hack
map_ownership:
    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
    DATA OO,OO,YY,OO,OO,OO,OO,OO,OO,OO,ZZ,ZZ,OO,ZZ,OO,OO,ZZ,OO,OO,OO
    DATA OO,YY,YY,YY,OO,OO,OO,OO,OO,OO,ZZ,ZZ,ZZ,ZZ,ZZ,ZZ,ZZ,OO,OO,OO
    DATA OO,YY,YY,YY,OO,OO,OO,OO,OO,OO,ZZ,ZZ,OO,OO,ZZ,ZZ,ZZ,ZZ,OO,OO
    DATA OO,YY,YY,YY,YY,YY,OO,OO,OO,OO,OO,OO,OO,OO,OO,ZZ,ZZ,ZZ,ZZ,OO
    DATA OO,OO,OO,YY,YY,YY,YY,OO,OO,OO,OO,OO,OO,OO,OO,OO,ZZ,ZZ,ZZ,OO
    DATA OO,OO,OO,OO,YY,YY,YY,YY,YY,OO,OO,OO,OO,OO,OO,ZZ,ZZ,ZZ,ZZ,OO
    DATA OO,OO,OO,YY,YY,YY,OO,YY,YY,YY,YY,YY,OO,OO,OO,OO,OO,ZZ,OO,OO
    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO

'map_background_flip:
'    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
'    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
'    DATA OO,OO,YY,YY,OO,OO,OO,OO,OO,OO,YY,OO,YY,YY,YY,OO,YY,YY,OO,OO
'    DATA OO,YY,OO,OO,YY,OO,OO,OO,OO,OO,YY,OO,OO,OO,OO,OO,OO,YY,OO,OO
'    DATA OO,YY,OO,OO,YY,OO,OO,OO,OO,OO,YY,OO,YY,OO,YY,OO,OO,OO,YY,OO
'    DATA OO,YY,OO,OO,OO,OO,YY,OO,OO,OO,OO,OO,OO,OO,OO,YY,OO,OO,OO,YY
'    DATA OO,OO,OO,YY,OO,OO,OO,YY,OO,OO,OO,OO,OO,OO,OO,OO,YY,OO,OO,YY
'    DATA OO,OO,OO,OO,YY,OO,OO,OO,OO,YY,OO,OO,OO,OO,OO,YY,OO,OO,OO,YY
'    DATA OO,OO,OO,YY,OO,OO,YY,YY,OO,OO,OO,OO,YY,YY,OO,OO,OO,YY,YY,OO
'    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
'    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO
'    DATA OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO,OO


'''
p1_setup_get_map_tile:  PROCEDURE
    x_coord = p1_cur_x
    y_coord = p1_cur_y
END

p2_setup_get_map_tile:	PROCEDURE
    x_coord = p2_cur_x
    y_coord = p2_cur_y
END

get_map_tile:   PROCEDURE 'translates lower-right coordinates of cursor to a map tile; estimates to closest if not exact match: e.g (17, 10) => 2, 1
    map_tile_x = ((x_coord-8+4) - (x_coord-8+4) % 8) / 8 '8 for card size in x dimension; 4 is half of 8; minus 8 is because x_coord and y_coord are lower right
    map_tile_y = ((y_coord-8+4) - (y_coord-8+4) % 8) / 8 '8 for card size in y dimension; 4 is half of 8; minus 8 is because x_coord and y_coord are lower right
    map_index = 20*map_tile_y + map_tile_x
END

p1_finish_get_map_tile: PROCEDURE
    p1_map_tile_x = map_tile_x
    p1_map_tile_y = map_tile_y
    'p1_map_index = map_index 'don't need?
END

p2_finish_get_map_tile: PROCEDURE
    p2_map_tile_x = map_tile_x
    p2_map_tile_y = map_tile_y
    'p2_map_index = map_index 'don't need?
END

'''

'PRECONDITION: call get_map_tile first (and therefore call its setup function first)
'rightmost two bits indicate ownership, so this returns 0 (no owner) or 1 or 2 for player 1 or 2
get_map_ownership:  PROCEDURE
    map_ownership_result = map_ownership(20*map_tile_y + map_tile_x) AND &00000011
END

'''
p1_setup_set_building:  PROCEDURE
    map_tile_x = p1_map_tile_x
    map_tile_y = p1_map_tile_y
END

p2_setup_set_building:  PROCEDURE
    map_tile_x = p2_map_tile_x
    map_tile_y = p2_map_tile_y
END

'PRECONDITION: these vars are set: building_index, map_index
'does no validations - assumes validations already done
set_building:   PROCEDURE

    'check prev card - if prev has building, then set this bg bit off 
    'check that all subsequent cards have bit off until you hit a non-building, then set that one to on

    'have to enable the bit and redraw for the subsequent map location that does NOT have a building

    map_index = map_index - 1
    GOSUB has_building
    map_index = map_index + 1
    PRINT AT 1 COLOR p1_color, <>ret_has_building
    IF ret_has_building THEN 'last card has a building
        #backtab(map_index) = (CARD_BASELINE + (CARD_NUM_BUILD + building_index) * CARD_MULT + build_colors(building_index)) AND #NEGATE_COLOR_STACK_BG_SHIFT
    ELSE
        #backtab(map_index) = (CARD_BASELINE + (CARD_NUM_BUILD + building_index) * CARD_MULT + build_colors(building_index)) OR #COLOR_STACK_BG_SHIFT
    END IF

    map_index = map_index + 1
    GOSUB has_building

    'subsequent cards' bg bits
    WHILE ret_has_building = 1
        #backtab(map_index) = #backtab(map_index) AND #NEGATE_COLOR_STACK_BG_SHIFT
        map_index = map_index + 1
        GOSUB has_building
    WEND 

    #backtab(map_index) = #backtab(map_index) OR #COLOR_STACK_BG_SHIFT
END

'PRECONDITION: map_index is set
has_building:   PROCEDURE
    IF (#backtab(map_index) AND #NEGATE_COLOR_STACK_BG_SHIFT) >= (CARD_BASELINE + CARD_NUM_BUILD*CARD_MULT) THEN
        ret_has_building = 1
        RETURN
    END IF
    ret_has_building = 0
END 

p1_setup_is_dock_tile_occupied: PROCEDURE
    dock_x = build_dock_x(1)
    dock_y = build_dock_y(1)
END

p1_finish_is_dock_tile_occupied: PROCEDURE
    p1_is_dock_tile_occupied_result = is_dock_tile_occupied_result
END

p2_setup_is_dock_tile_occupied: PROCEDURE
    dock_x = build_dock_x(2)
    dock_y = build_dock_y(2)
END

p2_finish_is_dock_tile_occupied: PROCEDURE
    p2_is_dock_tile_occupied_result = is_dock_tile_occupied_result
END

is_dock_tile_occupied:  PROCEDURE
    map_tile_x = ((dock_x-8+4) - (dock_x-8+4) % 8) / 8 
    map_tile_y = ((dock_y-8+4) - (dock_y-8+4) % 8) / 8 

    map_index = 20*dock_y + dock_x

    IF #backtab(map_index) = OO THEN ' not sure if one-liner works
        is_dock_tile_occupied_result = 1
    ELSE
        is_dock_tile_occupied_result = 0
    END IF 
END