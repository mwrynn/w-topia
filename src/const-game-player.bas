'******************************************
'*          const-game-player.bas         *
'******************************************
'*                                        *
'* Constants pertaining to players'       *
'* cursors, money, population, other data *
'*                                        *
'******************************************

'player 1 cursor constants
CONST P1_CUR_STARTING_X = 20
CONST P1_CUR_STARTING_Y = 20

'player 2 cursor constants
CONST P2_CUR_STARTING_X = 100
CONST P2_CUR_STARTING_Y = 20

CONST STARTING_MONEY = 500 'in original game this is 100
CONST STARTING_POPULATION = 1000 'in original game this is 1000 (I think; should verify)

CONST CUR_MOVE_THRESHOLD = 6 'how many "move points" trigger the cursor to move a pixel; increase to make cursor slower
CONST BOAT_MOVE_THRESHOLD = 6 ' same as CUR_MOVE_THRESHOLD but for boats; maybe we don't need distinct speeds
