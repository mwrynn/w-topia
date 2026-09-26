'*********************************************
'*           const-game-card.bas             *
'*********************************************
'*                                           *
'*  consts related to card indexes and the   *
'*  like; not Intellivision system consts    *
'*  (see const-intv-card for those)          *
'*                                           *
'*********************************************

CONST CARD_NUM_CURSOR = 0
CONST CARD_NUM_LAND   = 1  'there are many but this is the first one
CONST CARD_NUM_LAND_2 = 17 'second block of land cards, because limit of 16 cards loaded at a time
CONST CARD_NUM_BUILD  = 18
CONST CARD_NUM_FORT = CARD_NUM_BUILD
CONST CARD_NUM_REBEL = CARD_NUM_BUILD + 6
CONST CARD_NUM_PT_BOAT = CARD_NUM_BUILD + 7
CONST CARD_NUM_FISHING_BOAT = CARD_NUM_BUILD + 8
CONST CARD_NUM_FISHING_BOAT_DEATH_ANIM = CARD_NUM_BUILD + 9

' for checking the card data optimally, greater half of a 16-bit word matching this means it's a fishing boat
CONST CARD_INDEX_FISHING_BOAT = 8 * $0100
CONST CARD_INDEX_PT_BOAT = 7 * $0100

CONST CARD_NUM_FIRST_BUILDING = CARD_NUM_BUILD
CONST CARD_NUM_FIRST_NON_FORT_BUILDING = CARD_NUM_FIRST_BUILDING + 1
CONST CARD_NUM_LAST_REAL_BUILDING = CARD_NUM_FIRST_NON_FORT_BUILDING + 5 ' "real" buildings, not rebels or boats, but including crops

CONST CARD_NUM_FIRST_LAND_OR_BUILDING_ON_LAND = 1
CONST CARD_NUM_LAST_LAND_OR_BUILDING_ON_LAND = CARD_NUM_BUILD + 6 ' everything you can build up to and incl. rebel