'******************************************
'*          const-game-player.bas         *
'******************************************
'*                                        *
'* Constants pertaining to players'       *
'* cursors, money, population, other data *
'*                                        *
'******************************************

cur_starting_x: 'pixel index for starting location (x coord), indexed by player index
	DATA 20,100

cur_starting_y: 'pixel index for starting location (y coord), indexed by player index
	DATA 20,20

player_default_color:
    DATA DARK_GREEN, RED

CONST STARTING_MONEY = 500 'in original game this is 100
CONST STARTING_POPULATION = 1000 'in original game this is 1000 (I think; should verify)

CONST CUR_MOVE_THRESHOLD = 6 'how many "move points" trigger the cursor to move a pixel; increase to make cursor slower
CONST BOAT_MOVE_THRESHOLD = 6 ' same as CUR_MOVE_THRESHOLD but for boats; maybe we don't need distinct speeds

CONST FORM_CURSOR = 0
CONST FORM_PT_BOAT = 1
CONST FORM_FISHING_BOAT = 2
CONST FORM_DYING_PT_BOAT = 3
CONST FORM_DYING_FISHING_BOAT = 4