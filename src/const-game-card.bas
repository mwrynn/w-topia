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
CONST CARD_NUM_PT_BOAT = CARD_NUM_BUILD + 7
CONST CARD_NUM_FISHING_BOAT = CARD_NUM_BUILD + 8