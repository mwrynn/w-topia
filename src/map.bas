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
CONST WW = 2
CONST YY = 0
CONST ZZ = 1

'map_ownership: 2D array that defines the owner of each land location
'YY means player 0, ZZ means player 1, and XX means no owner
'potential memory optimization: maybe make it sparse?
'for example we don't need to store the first two lines so we could just assume for
'a lookup of row 0 or 1 (and also whatever indexes of the last three rows), it's always OO
'another option is to set large rectangle boundaries, with water (OO) always assumed to be owned by nobody
'this being ROM it doesn't have to be so efficient. but consider once you've got multiple maps!
map_ownership:
    DATA WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW
    DATA WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW
    DATA WW,WW,YY,WW,WW,WW,WW,WW,WW,WW,ZZ,ZZ,WW,ZZ,WW,WW,ZZ,WW,WW,WW
    DATA WW,YY,YY,YY,WW,WW,WW,WW,WW,WW,ZZ,ZZ,ZZ,ZZ,ZZ,ZZ,ZZ,WW,WW,WW
    DATA WW,YY,YY,YY,WW,WW,WW,WW,WW,WW,ZZ,ZZ,WW,WW,ZZ,ZZ,ZZ,ZZ,WW,WW
    DATA WW,YY,YY,YY,YY,YY,WW,WW,WW,WW,WW,WW,WW,WW,WW,ZZ,ZZ,ZZ,ZZ,WW
    DATA WW,WW,WW,YY,YY,YY,YY,WW,WW,WW,WW,WW,WW,WW,WW,WW,ZZ,ZZ,ZZ,WW
    DATA WW,WW,WW,WW,YY,YY,YY,YY,YY,WW,WW,WW,WW,WW,WW,ZZ,ZZ,ZZ,ZZ,WW
    DATA WW,WW,WW,YY,YY,YY,WW,YY,YY,YY,YY,YY,WW,WW,WW,WW,WW,ZZ,WW,WW
    DATA WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW
    DATA WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW
    DATA WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW,WW

DIM map_ownership_result
DIM get_boat_ownership_result
DIM ret_has_building
DIM building_index
DIM ret_is_dock_tile_occupied
DIM map_index_to_set_boat_at

'''

'PROCEDURE get_map_index_at_cursor: gets the map tile that the cursor is most closely placed over
'PRECONDITIONS:
'   set p (the player index)
'PARAMETERS:
'   cur_x: item-per-player array: pixel coordinate of the cursor's upper left corner for, x dimension
'   cur_y: item-per-player array: pixel coordinate of the cursor's upper left corner for, y dimension
'RETURNS:
'   map_tile_x: x tile index of the tile that the cursor is most closely placed over
'   map_tile_y: y tile index of the tile that the cursor is most closely placed over
'   map_index: derived from map_tile_x and map_tile_y, the one-dimensional index of the tile
'       (since we need to access the data via a single index)
'NOTES:
'   a "tile index" refers to not a pixel coordinate, but rather the index from 0 to 19 across (x) or 0 to 11 up and down (y)
get_map_index_at_cursor:   PROCEDURE 'translates upper-left coordinates of cursor to a map tile; estimates to closest if not exact match: e.g (17, 10) => 2, 1
    DIM map_tile_x, map_tile_y, map_index
    'map_tile_x = ((cur_x(p)-8+4) - (cur_x(p)-8+4) % 8) / 8 '8 for card size in x dimension; 4 is half of 8; minus 8 is because p_cur_x and p_cur_y are upper left
    map_tile_x = (cur_x(p)-4) / 8 'simplified from commented out expression in immediately preceding line
    'map_tile_y = ((p_cur_y-8+4) - (p_cur_y-8+4) % 8) / 8 '8 for card size in y dimension; 4 is half of 8; minus 8 is because p_cur_x and p_cur_y are upper left
    map_tile_y = (cur_y(p)-4) / 8 'simplified from commented out expression in immediately preceding line
    map_index = (16 * map_tile_y + 4 * map_tile_y) + map_tile_x 'intybasic docs say powers of 2 mult is internally optimized as bit shifts, so this is an optimization attempt
END

'helper macros for the complex procedure get_cursor_backtab_overlaps below
DEF FN card_is_land(#card) = (#card >= FIRST_LAND) AND (#card <= LAST_LAND)
DEF FN is_fishing_boat(#card) = ((#card AND $FF00) = CARD_INDEX_FISHING_BOAT)  'selected card is fishing boat (as a card, not sprite, it is parked)
DEF FN card_color_is_opponents(#card, p) = (#card AND $0007) = player_index_to_opponent_color(p)
DEF FN get_collision_bits(#cursor_backtab_overlaps, i1, i2) = (#cursor_backtab_overlaps OR ((i1 + i2) * 4) OR $0002)  'set bit 1 and set collision index at bit 2-9


'''

'PROCEDURE get_cursor_backtab_overlaps: gets whether the four coordinates associated with a
'   given p_cur_x/p_cur_y (which represents the upper left corner of sprite) overlaps with
'   things of concern in #backtabs for collision purposes
'   gets "flags" to indicate ALL types of things collided with
'   different bits set for each type (see below)
'PRECONDITIONS:
'   set p (the player index)
'PARAMETERS:
'   cur_x: item-per-player array: pixel coordinate of the cursor's upper left corner for, x dimension
'   cur_y: item-per-player array: pixel coordinate of the cursor's upper left corner for, y dimension
'RETURNS:
'   #cursor_backtab_overlaps:
'       bit 0 (LSB): 1 if overlaps with land, else 0
'       bit 1: 1 if overlaps with parked fishing boat belonging to opponent, else 0
'       bit 2-9: if overlap with parked fishing boat, this is the backtab index of that boat; if no overlap then 00000000; if multiple collisiosn with parked fishing boats, an arbitrary one is chosen
'NOTES:
'   a "tile index" refers to not a pixel coordinate, but rather the index from 0 to 19 across (x) or 0 to 11 up and down (y)
'   this will not return overlaps with any sprites - can use sprite collision detection for that
get_cursor_backtab_overlaps:   PROCEDURE 
    'a lot of repetition in this proc - part of intentional optimization - this was causing slow boat movement prior

    'could potentially optimize this proc more using early RETURNs: if both bits are set an early RETURN may be possible
    'however the vast majority of calls to this proc should be for non-collisions
    'the collision case being suboptimal isn't the worst thing

    'could also potentially optimize if a "parameter" is current cursor's form. if irrelvant type exit out of some logic sooner
    #cursor_backtab_overlaps = $0000

    '--- TOP LEFT CHECKS ---
    DIM left_i, top_i, right_i, bottom_i, #card
    left_i = (cur_x(p) - 8) / 8       'cursor sprite's left edge index component
    top_i = 20 * ((cur_y(p) - 8) / 8) 'cursor sprite's top edge index component; needs to be multiplied by 20 to get correct row

    '--- content at top-left corner ---
    #card = #BACKTAB(top_i + left_i)

    '--- land check ---
    IF card_is_land(#card) THEN
        #cursor_backtab_overlaps = $0001 'set bit 0
    END IF

    '--- parked fishing boat check ---
    IF is_fishing_boat(#card) THEN
        IF (card_color_is_opponents(#card, p)) THEN ' combining this with above expression ANDed is slow due to apparent lack of short circuiting
            #cursor_backtab_overlaps = get_collision_bits(#cursor_backtab_overlaps, top_i, left_i)
        END IF
    END IF
    '--- END TOP LEFT CHECKS ---

    '--- TOP RIGHT CHECKS ---
    right_i = (cur_x(p) - 1) / 8 'simplified from (p_cur_x - 8 + 7) / 8 
    'top_i already computed above in TOP LEFT CHECKS section

    '--- content at top-right corner ---
    #card = #BACKTAB(top_i + right_i)

    '--- land check ---
    IF card_is_land(#card) THEN
        #cursor_backtab_overlaps = #cursor_backtab_overlaps OR $0001 'set first bit
    END IF

    '--- parked fishing boat check ---
    IF is_fishing_boat(#card) THEN
        IF (card_color_is_opponents(#card, p)) THEN 
            #cursor_backtab_overlaps = get_collision_bits(#cursor_backtab_overlaps, top_i, right_i)
        END IF
    END IF

    '--- END TOP RIGHT CHECKS ---

    '--- BOTTOM LEFT CHECKS ---
    'corner_check_left already computed above in TOP LEFT CHECKS section

    bottom_i = 20 * ((cur_y(p) - 1) / 8) 'cursor sprite's bottom edge index component; needs to be multiplied by 20 to get correct row; simplified expr from 20 * ((p_cur_y - 8 + 7) / 8)

    '--- content at bottom-left corner ---
    #card = #BACKTAB(bottom_i + left_i)

    '--- land check ---
    IF card_is_land(#card) THEN
        #cursor_backtab_overlaps = #cursor_backtab_overlaps OR $0001 'set bit 0
    END IF

    '--- parked fishing boat check ---
    IF is_fishing_boat(#card) THEN
        IF (card_color_is_opponents(#card, p)) THEN 
            #cursor_backtab_overlaps = get_collision_bits(#cursor_backtab_overlaps, bottom_i, left_i)
        END IF
    END IF

    '--- BOTTOM RIGHT CHECKS ---
    'already have bottom_i and right_i from above

    '--- content at bottom-left corner ---
    #card = #BACKTAB(bottom_i + right_i)

    '--- land check ---
    IF card_is_land(#card) THEN
        #cursor_backtab_overlaps = #cursor_backtab_overlaps OR $0001 'set bit 0
    END IF

    '--- parked fishing boat check ---
    IF is_fishing_boat(#card) THEN
        IF (card_color_is_opponents(#card, p)) THEN 
             #cursor_backtab_overlaps = get_collision_bits(#cursor_backtab_overlaps, bottom_i, right_i)
        END IF
    END IF
    '--- END BOTTOM RIGHT CHECKS ---
END


'''

'PROCEDURE: get_map_ownership: gets the owner of a tile given the one-dimensional map_index,
    'by looking up in DATA array map_ownership
'PRECONDITIONS:
'   none
'PARAMETERS:
    'map_index: the one-dimensional index of the tile in the map for which the owner is returned
'RETURNS:
    'map_ownership_result: the owner bits, 2 = no owner, 0 = player 0, 1 = player 1
get_map_ownership:  PROCEDURE
    map_ownership_result = map_ownership(map_index) AND &00000011
END

'''
'PROCEDURE: get_boat_ownership gets the player number of the boat at map_index
'PRECONDITIONS:
'   p is set
'PARAMETERS:
    'map_index: the one-dimensional index of the tile in the map at which the boat's owner is returned
'RETURNS:
    'get_boat_ownership_result: the owner bits: 0 = player 0, 1 = player 1; -1 means no boat at map_index
'''
get_boat_ownership: PROCEDURE
    ' last 4 bits in backtab are color; used to determine player
    FOR i = 0 TO (N_PLAYERS-1)
        IF (#backtab(map_index) AND 7) = player_color(i) THEN
            get_boat_ownership_result = i
            RETURN
        END IF
    NEXT i

    get_boat_ownership_result = -1
END

''' 

'PROCEDURE set_building: sets a building card in #backtab (background table) at the position indicated by map_index
'PRECONDITIONS:
    'set p
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

'PROCEDURE is_dock_tile_occupied: checks whether the dock tile is already occupied by a boat
'PRECONDITIONS:
    'set p
'PARAMETERS
    'dock_map_index: item-per-player array: index (not pixel location) of the dock to check 
'RETURNS
    'ret_is_dock_tile_occupied: 1 if a boat was found at the dock position, 0 if not found

is_dock_tile_occupied:  PROCEDURE
    IF #backtab(dock_map_index(p)) = OO THEN
        ret_is_dock_tile_occupied = 0
    ELSE
        ret_is_dock_tile_occupied = 1
    END IF 
END

'PROCEDURE set_boat: sets boat at location
'   does no validations; assumes already done
'PRECONDITION:
'   set p
'PARAMETERS:
'   building_index: building index of the boat to set, must only be one of the boat values, not a true "building"
'       such as a factory; does no validation
'   map_index_to_set_boat_at: location (card index) to set buliding at
'MODIFIES:
'   #backtab state to set the boat indicated by building_index at dock_map_index(p)
set_boat:   PROCEDURE
    #backtab(map_index_to_set_boat_at) = (CARD_BASELINE + (CARD_NUM_BUILD + building_index) * CARD_MULT + player_index_to_color(p)) AND #NEGATE_COLOR_STACK_BG_SHIFT
END

