'**********************************************
'*            const-game-misc.bas             *
'**********************************************
'*                                            *
'*     catch-all for other game constants     *
'*                                            *
'**********************************************

'the following should eventually be user definable (therefore not consts)
CONST HARDCODED_TURNS_LEFT = 30
CONST HARDCODED_SECONDS_PER_TURN = 10
CONST N_PLAYERS = 2 'note that although this project generally works with N_PLAYERS const instead of a hardcoded 2, currently there are many assumptions of two such as the player_sprite_index vs. other_sprite_index, as well as other "other_*" variables

bit_mask:
    DATA $0001, $0002, $0004, $0008, $0010, $0020, $0040, $0080