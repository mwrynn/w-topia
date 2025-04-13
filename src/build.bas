'***********************************************
'*                  build.bas                  *
'***********************************************
'*                                             *
'* data and functions pertaining to the things *
'* players build (buildings, boats, rebels)    *
'* (bitamps are in bitmap-build.bas)           *
'*                                             *
'* 0-5 are buildings:                          *
'* 0: Fort                                     *
'* 1: Factory                                  *
'* 2: Crops                                    *
'* 3: School                                   *
'* 4: Hospital                                 *
'* 5: Housing Project                          *
'*                                             *
'* 6: Rebel                                    *
'* 7: PT Boat                                  *
'* 8: Fishing Boat                             *
'*                                             *
'* These indexes all correspond to the         *
'* controller button minus 1                   *
'***********************************************

build_costs:
	DATA 50,40,3,35,75,60,30,40,25

build_colors: 'purples are placeholders; to be replaced with the player color
	DATA BLACK,BLACK,DARK_GREEN,WHITE,RED,YELLOW,BLACK,GREEN,GREEN

build_dock_x: 'tile location for players 1 and 2, for dock where boats are spawned, x coord
	DATA 3,20

build_dock_y: 'tile location for players 1 and 2, for dock where boats are spawned, y coord
	DATA 7,6

