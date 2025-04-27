'********************************************
'*                  map.bas                 *
'********************************************
'*                                          *
'*  map-related constants, map locations    *
'*  and functions                           *
'*                                          *
'********************************************

'defines map card constants to be used in a map
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

'map_cards: 2D array that defines the land graphics (cards) to be used for each location
'OO means the sea and everythinge else is a land card
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

'map_ownership: 2D array that defines the owner of each land location
'YY means player 1, ZZ means player 2, and OO means nothing
'potential memory optimization: maybe make it sparse?
'for example we don't need to store the first two lines so we could just assume for
'a lookup of row 0 or 1 (and also whatever indexes of the last three rows), it's always OO
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

'''

p1_setup_get_map_tile_at_cursor:  PROCEDURE
    x_coord = p1_cur_x
    y_coord = p1_cur_y
END

p2_setup_get_map_tile_at_cursor:	PROCEDURE
    x_coord = p2_cur_x
    y_coord = p2_cur_y
END

'PROCEDURE get_map_tile_at_cursor: gets the map tile that the cursor is most closely placed over
'PRECONDITIONS:
'   call p[1|2]_setup_get_map_tile_at_cursor
'   alternatively, if already in a p1/p2-specific flow, x_coord, y_coord must have been set
'PARAMETERS:
'   x_coord: pixel coordinate of the cursor's upper left corner for, x dimension
'   y_coord: pixel coordinate of the cursor's upper left corner for, y dimension
'RETURNS:
'   map_tile_x: x tile index of the tile that the cursor is most closely placed over
'   map_tile_y: y tile index of the tile that the cursor is most closely placed over
'   map_index: derived from map_tile_x and map_tile_y, the one-dimensional index of the tile
'       (since we need to access the data via a single index)
'NOTES:
'   a "tile index" refers to not a pixel coordinate, but rather the index from 0 to 19 across (x) or 0 to 11 up and down (y)
get_map_tile_at_cursor:   PROCEDURE 'translates lower-right coordinates of cursor to a map tile; estimates to closest if not exact match: e.g (17, 10) => 2, 1
    map_tile_x = ((x_coord-8+4) - (x_coord-8+4) % 8) / 8 '8 for card size in x dimension; 4 is half of 8; minus 8 is because x_coord and y_coord are lower right
    map_tile_y = ((y_coord-8+4) - (y_coord-8+4) % 8) / 8 '8 for card size in y dimension; 4 is half of 8; minus 8 is because x_coord and y_coord are lower right
    map_index = 20*map_tile_y + map_tile_x
END

p1_finish_get_map_tile_at_cursor: PROCEDURE
    p1_map_tile_x = map_tile_x
    p1_map_tile_y = map_tile_y
    p1_map_index = map_index
END

p2_finish_get_map_tile_at_cursor: PROCEDURE
    p2_map_tile_x = map_tile_x
    p2_map_tile_y = map_tile_y
    p2_map_index = map_index
END

'''

p1_setup_get_map_ownership: PROCEDURE
    map_index = p1_map_index
END

p2_setup_get_map_ownership: PROCEDURE
    map_index = p2_map_index
END

'PROCEDURE: get_map_ownership: gets the owner of a tile given the one-dimensional map_index,
    'by looking up in DATA array map_ownership
'PRECONDITIONS:
    'call p[1|2]_setup_get_map_ownership
    'alternatively, if already in a p1/p2-specific flow, map_index must have been set
'PARAMETERS:
    'map_index: the one-dimensional index of the tile in the map for which the owner is returned
'RETURNS:
    'map_ownership_result: the owner bits, 0 = no owner, 1 = player 1, 2 = player 2
get_map_ownership:  PROCEDURE
    map_ownership_result = map_ownership(map_index) AND &00000011
END

p1_finish_get_map_ownership: PROCEDURE
    p1_map_ownership_result = map_ownership_result
END

p2_finish_get_map_ownership: PROCEDURE
    p2_map_ownership_result = map_ownership_result
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

'PROCEDURE set_building: sets a building card in #backtab (background table) at the position indicated by map_index
'PRECONDITIONS:
    'call p[1|2]_setup_set_building
    'alternatively, if already in a p1/p2-specific flow, building_index and map_index must have been set
    'assumes all validations (ownership, land vs. water checks) have already been done
'PARAMETERS:
    'building_index: the index of which building to place
    'map_index: the one-dimensional index of the tile in the map for which the building is be placed
'RETURNS:
    'nothing (may be worth returning a success status?)
'MODIFIES:
    '#backtab - sets the new building of building_index at map_index
set_building:   PROCEDURE
    'much of this proc has to do with handling background bit complexity
    'the logic:
    'check prev card - if prev has building, then set the background bit to off for the new building's card
    'check that all subsequent cards have background bit off until you hit a non-building, then set that one to on
    'have to enable the bit and redraw for the subsequent map locations that do NOT have a building

    'look back to the previous card and check if there is a building
    map_index = map_index - 1
    GOSUB has_building

    'put map_index back to where we want to set the new building
    map_index = map_index + 1

    IF ret_has_building THEN 'previous card has a building
        'set the new building at map_index with background bit off
        #backtab(map_index) = (CARD_BASELINE + (CARD_NUM_BUILD + building_index) * CARD_MULT + build_colors(building_index)) AND #NEGATE_COLOR_STACK_BG_SHIFT
    ELSE
        'set the new building at map_index with background bit on
        #backtab(map_index) = (CARD_BASELINE + (CARD_NUM_BUILD + building_index) * CARD_MULT + build_colors(building_index)) OR #COLOR_STACK_BG_SHIFT
    END IF

    PRINT AT 3 COLOR p1_color, <.2>building_index 'debug

    DO
        map_index = map_index + 1
        GOSUB has_building

        IF ret_has_building = 1 THEN
          #BACKTAB(map_index) = #BACKTAB(map_index) AND #NEGATE_COLOR_STACK_BG_SHIFT
        END IF
    LOOP WHILE ret_has_building = 1

    #backtab(map_index) = #backtab(map_index) OR #COLOR_STACK_BG_SHIFT
END

'''

'PROCEDURE has_building: checks whether given tile has a building
'PRECONDITIONS:
    'map_index is set
'PARAMETERS
    'map_index: the backtab index for which to check for a building
'RETURNS
    'ret_has_building: 1 if a building was found at map_index, 0 if not found
has_building:   PROCEDURE
    IF (#backtab(map_index) AND #NEGATE_COLOR_STACK_BG_SHIFT) >= (CARD_BASELINE + CARD_NUM_BUILD*CARD_MULT) THEN
        ret_has_building = 1
        RETURN
    END IF
    ret_has_building = 0
END 

'''

p1_setup_is_dock_tile_occupied: PROCEDURE
    dock_x = build_dock_x(1)
    dock_y = build_dock_y(1)
END

p2_setup_is_dock_tile_occupied: PROCEDURE
    dock_x = build_dock_x(2)
    dock_y = build_dock_y(2)
END

'PROCEDURE is_dock_tile_occupied: checks whether the dock tile is already occupied by a boat
'PRECONDITIONS:
    'p[1|2]_setup_is_dock_tile_occupied has been called
    'alternatively, if already in a p1/p2-specific flow, dock_x and dock_y must have been set
'PARAMETERS
    'dock_x: x position (index, not pixels) of the dock to check 
    'dock_y: y position (index, not pixels) of the dock to check
'RETURNS
    'ret_is_dock_tile_occupied: 1 if a boat was found at the dock position, 0 if not found

is_dock_tile_occupied:  PROCEDURE
    map_tile_x = ((dock_x-8+4) - (dock_x-8+4) % 8) / 8 
    map_tile_y = ((dock_y-8+4) - (dock_y-8+4) % 8) / 8 

    map_index = 20*dock_y + dock_x

    IF #backtab(map_index) = OO THEN
        ret_is_dock_tile_occupied = 1
    ELSE
        ret_is_dock_tile_occupied = 0
    END IF 
END

p1_finish_is_dock_tile_occupied: PROCEDURE
    p1_ret_is_dock_tile_occupied = ret_is_dock_tile_occupied
END

p2_finish_is_dock_tile_occupied: PROCEDURE
    p2_ret_is_dock_tile_occupied = ret_is_dock_tile_occupied
END

'''

'PROCEDURE set_boat: sets boat at location
'   'oes no validations; assumes already done
'PRECONDITION:
'   these vars are set: building_index, p_dock_map_index
'PARAMETERS:
'   building_index: building index of the boat to set, must only be one of the boat values, not a true "building"
'       such as a factory; does no validation
'   p_dock_map_index: location (card index) to set buliding at
'MODIFIES: #backtab state to set the boat indicated by building_index at p_dock_map_index
set_boat:   PROCEDURE
    #backtab(p_dock_map_index) = (CARD_BASELINE + (CARD_NUM_BUILD + building_index) * CARD_MULT + build_colors(building_index)) AND #NEGATE_COLOR_STACK_BG_SHIFT
END
