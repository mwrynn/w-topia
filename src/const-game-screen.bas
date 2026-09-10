'*************************************************
'*             const-game-screen.bas             *
'*************************************************
'*                                               *
'* constants related to special screen locations *
'* for this game (not inherent console consts)   *
'*                                               *
'*************************************************

screen_status_pos_begin: 'pixel index for starting location (x coord), indexed by player index
	DATA 220,234

CONST SCREEN_STATUS_POS_TURNS_LEFT = 226
CONST SCREEN_STATUS_POS_TIME_LEFT = 230
CONST X_MAX_BOUND = 160
CONST X_MIN_BOUND = 8
CONST Y_MAX_BOUND = 96 '96 pixels with 8 for status bar
CONST Y_MIN_BOUND = 8

