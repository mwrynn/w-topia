'********************************************
'*           cursor-move-data.bas           *
'********************************************
'*                                          *
'* a map FROM the 16 directions on the      *
'* controller disc TO how much to move x, y *
'*                                          *
'********************************************

'indicates how many cursor "move points" (see move-cursor.bas) are added when moving in each
'of the 16 directions. 0s are for non-existent direction values (this could be perhaps be optimized)
direction_offset_x:
    DATA  0, 0, 2, 1, 0, 0, 2, 0   '$00 - $07
    DATA -2,-2, 0, 0,-1, 0, 0, 0   '$08 - $0F
    DATA  0,-1, 2, 2, 1, 0, 2, 0   '$10 - $17
    DATA -2,-2, 0, 0,-2, 0, 0, 0   '$18 - $1F

direction_offset_y:
    DATA  0, 2, 0, 2,-2, 0,-1, 0   '$00 - $07
    DATA  0, 1, 0, 0,-2 ,0, 0, 0   '$08 - $0F
    DATA  0, 2, 1, 2,-2, 0,-2, 0   '$10 - $17
    DATA -1, 2, 0, 0,-2, 0, 0, 0   '$18 - $1F
