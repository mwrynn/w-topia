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

'useful for checking whether a card is ANY land (check the range)
CONST FIRST_LAND = XX
CONST LAST_LAND = QQ

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

p1_setup_get_map_index_at_cursor:  PROCEDURE
    p_cur_x = p1_cur_x
    p_cur_y = p1_cur_y
END

p2_setup_get_map_index_at_cursor:	PROCEDURE
    p_cur_x = p2_cur_x
    p_cur_y = p2_cur_y
END

'PROCEDURE get_map_index_at_cursor: gets the map tile that the cursor is most closely placed over
'PRECONDITIONS:
'   call p[1|2]_setup_get_map_index_at_cursor
'   alternatively, if already in a p1/p2-specific flow, p_cur_x, p_cur_y must have been set
'PARAMETERS:
'   p_cur_x: pixel coordinate of the cursor's upper left corner for, x dimension
'   p_cur_y: pixel coordinate of the cursor's upper left corner for, y dimension
'RETURNS:
'   map_tile_x: x tile index of the tile that the cursor is most closely placed over
'   map_tile_y: y tile index of the tile that the cursor is most closely placed over
'   map_index: derived from map_tile_x and map_tile_y, the one-dimensional index of the tile
'       (since we need to access the data via a single index)
'NOTES:
'   a "tile index" refers to not a pixel coordinate, but rather the index from 0 to 19 across (x) or 0 to 11 up and down (y)
get_map_index_at_cursor:   PROCEDURE 'translates lower-right coordinates of cursor to a map tile; estimates to closest if not exact match: e.g (17, 10) => 2, 1
    map_tile_x = ((p_cur_x-8+4) - (p_cur_x-8+4) % 8) / 8 '8 for card size in x dimension; 4 is half of 8; minus 8 is because p_cur_x and p_cur_y are upper left
    map_tile_y = ((p_cur_y-8+4) - (p_cur_y-8+4) % 8) / 8 '8 for card size in y dimension; 4 is half of 8; minus 8 is because p_cur_x and p_cur_y are upper left
    map_index = 20*map_tile_y + map_tile_x
END

p1_finish_get_map_index_at_cursor: PROCEDURE
    p1_map_tile_x = map_tile_x
    p1_map_tile_y = map_tile_y
    'p1_map_index = map_index 'not used but can uncomment if that changes
END

p2_finish_get_map_index_at_cursor: PROCEDURE
    p2_map_tile_x = map_tile_x
    p2_map_tile_y = map_tile_y
    'p2_map_index = map_index 'not used but can uncomment if that changes
END

'''
'SPECIAL due to program flow and similarity between get_map_tile_at_pixel_coord and get_map_index_at_cursor,
'including the fact that they use the same parameters, we do not use a
'p[1|2]_setup_get_does_any_corner_of_cursor_overlap_land, but instead reuse p[1|2]_setup_get_map_index_at_cursor

'PROCEDURE get_does_any_corner_of_cursor_overlap_land: gets whether the four coordinates associated with a
'   given p_cur_x/p_cur_y (which represents the upper left corner of sprite) overlaps with land
'PRECONDITIONS:
'   call p[1|2]_setup_get_map_index_at_cursor
'   alternatively, if already in a p1/p2-specific flow, p_cur_x, p_cur_y must have been set
'PARAMETERS:
'   p_cur_x: pixel coordinate of the cursor's upper left corner for, x dimension
'   p_cur_y: pixel coordinate of the cursor's upper left corner for, y dimension
'RETURNS:
'   does_overlap: 1/0
'NOTES:
'   a "tile index" refers to not a pixel coordinate, but rather the index from 0 to 19 across (x) or 0 to 11 up and down (y)
get_does_any_corner_of_cursor_overlap_land:   PROCEDURE 
    '8 is the card size in both dimensions
    does_overlap=0

    'PRINT AT 3 COLOR p1_color, <.3>(p_cur_x / 8)
    'PRINT AT 7 COLOR p1_color, <.3>((p_cur_y / 8))
    'PRINT AT 3 COLOR p1_color, #backtab(20*2+2)

    'TODO these variables make the calcluations below nice to look at, but kind of a waste of ram
    ul_tile_loc_x=(p_cur_x / 8)-1
    ul_tile_loc_y=(p_cur_y / 8)-1

    ur_tile_loc_x=((p_cur_x + 7) / 8)-1
    ur_tile_loc_y=(p_cur_y / 8)-1

    ll_tile_loc_x=(p_cur_x / 8)-1
    ll_tile_loc_y=((p_cur_y + 7) / 8)-1

    lr_tile_loc_x=((p_cur_x + 7)/ 8)-1
    lr_tile_loc_y=((p_cur_y + 7)/ 8)-1

    'PRINT AT 3 COLOR p1_color, <.3>(20*tile_loc_y+tile_loc_x)
    
    'the range checks below are to check if it is a land card - perhaps refactor into an is_land proc

    'upper left
    IF #backtab(20 * ul_tile_loc_y + ul_tile_loc_x) >= XX AND #backtab(20 * ul_tile_loc_y + ul_tile_loc_x) <= QQ THEN
        does_overlap=1
        PRINT AT 3 COLOR p1_color, <.3>1
        RETURN
    END IF

    'upper right
    IF #backtab(20 * ur_tile_loc_y + ur_tile_loc_x) >= XX AND #backtab(20 * ur_tile_loc_y + ur_tile_loc_x) <= QQ THEN
        does_overlap=1
        PRINT AT 3 COLOR p1_color, <.3>2
        RETURN
    END IF

    'lower left
    IF #backtab(20 * (ll_tile_loc_y) + ll_tile_loc_x) >= XX AND #backtab(20 * (ll_tile_loc_y) + ll_tile_loc_x) <= QQ THEN
        does_overlap=1
        PRINT AT 3 COLOR p1_color, <.3>3
        RETURN
    END IF

    'lower right
    IF #backtab(20 * (lr_tile_loc_y) + lr_tile_loc_x) >= XX AND #backtab(20 * (lr_tile_loc_y) + lr_tile_loc_x) <= QQ THEN
        does_overlap=1
        PRINT AT 3 COLOR p1_color, <.3>4
        RETURN
    END IF
END

'''
'commented out setup and finish procs because main proc get_map_ownership only called from a p1/p2 call stack (so far)
' p1_setup_get_map_ownership: PROCEDURE
'     map_index = p1_map_index
' END

' p2_setup_get_map_ownership: PROCEDURE
'     map_index = p2_map_index
' END

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

'''
'PROCEDURE: get_boat_ownership gets the player number of the boat at map_index
'PRECONDITIONS:
    'map_index must have been set
'PARAMETERS:
    'map_index: the one-dimensional index of the tile in the map at which the boat's owner is returned
'RETURNS:
    'get_boat_ownership_result: the owner bits: 1 = player 1, 2 = player 2; 0 means no boat at map_index
'''
get_boat_ownership: PROCEDURE
    ' last 4 bits in backtab are color; used to determine player
    IF (#backtab(map_index) AND 7) = p1_color THEN
        get_boat_ownership_result = 1
        RETURN
    END IF

    IF (#backtab(map_index) AND 7) = p2_color THEN
        get_boat_ownership_result = 2
        RETURN
    END IF

    get_boat_ownership_result = 0
END


'commented out setup and finish procs because main proc get_map_ownership only called from a p1/p2 call stack (so far)
' p1_finish_get_map_ownership: PROCEDURE
'     p1_map_ownership_result = map_ownership_result
' END

' p2_finish_get_map_ownership: PROCEDURE
'     p2_map_ownership_result = map_ownership_result
' END

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

    DO
        map_index = map_index + 1
        GOSUB has_building

        IF ret_has_building = 1 THEN
          #backtab(map_index) = #backtab(map_index) AND #NEGATE_COLOR_STACK_BG_SHIFT
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
'commented out setup and finish procs because main proc is_dock_tile_occupied only called from a p1/p2 call stack (so far)
' p1_setup_is_dock_tile_occupied: PROCEDURE
'     p_dock_map_index=p1_dock_map_index
' END

' p2_setup_is_dock_tile_occupied: PROCEDURE
'     p_dock_map_index=p2_dock_map_index
' END

'PROCEDURE is_dock_tile_occupied: checks whether the dock tile is already occupied by a boat
'PRECONDITIONS:
    'p[1|2]_setup_is_dock_tile_occupied has been called
    'alternatively, if already in a p1/p2-specific flow, dock_x and dock_y must have been set
'PARAMETERS
    'p_dock_map_index: index (not pixel location) of the dock to check 
'RETURNS
    'ret_is_dock_tile_occupied: 1 if a boat was found at the dock position, 0 if not found

is_dock_tile_occupied:  PROCEDURE
    IF #backtab(p_dock_map_index) = OO THEN
        ret_is_dock_tile_occupied = 0
    ELSE
        ret_is_dock_tile_occupied = 1
    END IF 
END

'commented out setup and finish procs because main proc is_dock_tile_occupied only called from a p1/p2 call stack (so far)
' p1_finish_is_dock_tile_occupied: PROCEDURE
'     p1_ret_is_dock_tile_occupied = ret_is_dock_tile_occupied
' END

' p2_finish_is_dock_tile_occupied: PROCEDURE
'     p2_ret_is_dock_tile_occupied = ret_is_dock_tile_occupied
' END

'''

'PROCEDURE set_boat: sets boat at location
'   does no validations; assumes already done
'PRECONDITION:
'   these vars are set: building_index, p_dock_map_index
'PARAMETERS:
'   building_index: building index of the boat to set, must only be one of the boat values, not a true "building"
'       such as a factory; does no validation
'   map_index_to_set_boat_at: location (card index) to set buliding at
'   player: need this to get the right color
'MODIFIES: #backtab state to set the boat indicated by building_index at p_dock_map_index
set_boat:   PROCEDURE
    'doing this a bit silly to save a variable (setting boat_color = p[1|2]_color in the IF), may be able to inline the logic
    IF player = 1 THEN 
        #backtab(map_index_to_set_boat_at) = (CARD_BASELINE + (CARD_NUM_BUILD + building_index) * CARD_MULT + p1_color) AND #NEGATE_COLOR_STACK_BG_SHIFT
    ELSE
        #backtab(map_index_to_set_boat_at) = (CARD_BASELINE + (CARD_NUM_BUILD + building_index) * CARD_MULT + p2_color) AND #NEGATE_COLOR_STACK_BG_SHIFT
    END IF
END
