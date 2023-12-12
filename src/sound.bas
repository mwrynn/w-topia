'play first tone in end-of-turn chime ("bing")

'second param to SOUND indicates the note, derived from: 3579545 / 32 / <note frequency in Hz, e.g. 440 for A> 
'(note 3579545 is for NTSC; for PAL use 4000000 - will conveniently ignore for now/ever)
'loop for sound duration - looping from 0 to 50 is 1/10 of a second

CONST SOUND_NTSC_DURATION_1_10TH_SEC = 5

'''first param to SOUND is one of these constants:
CONST SOUND_CHANNEL_A = 0
CONST SOUND_CHANNEL_B = 1
CONST SOUND_CHANNEL_C = 2
CONST SOUND_CHANNEL_ENVELOPE = 3
CONST SOUND_NOISE_AND_MIX_REGISTER = 4
CONST SOUND_ENVELOPE_ENABLE = 48

CONST SOUND_MAGIC_DIVISOR = 32

' can set 5-9 for first param, but only available with the secondary PSG in the ECS add-on module

' reference for notes and frequency: https://pages.mtu.edu/~suits/notefreqs.html
CONST SOUND_TONE_C5_HZ = 523
CONST SOUND_TONE_C5_PARAM = 3579545 / SOUND_MAGIC_DIVISOR / SOUND_TONE_C5_HZ
CONST SOUND_TONE_C4_HZ = 262
CONST SOUND_TONE_C4_PARAM = 3579545 / SOUND_MAGIC_DIVISOR / SOUND_TONE_C4_HZ
CONST SOUND_TONE_F4_HZ = 349
CONST SOUND_TONE_F4_PARAM = 3579545 / SOUND_MAGIC_DIVISOR / SOUND_TONE_F4_HZ
CONST SOUND_TONE_F1_HZ = 44
CONST SOUND_TONE_F1_PARAM = 3579545 / SOUND_MAGIC_DIVISOR / SOUND_TONE_F1_HZ

'play first tone in end-of-turn chime ("bing!")
play_sound_bing:   PROCEDURE

    'SOUND 3, 3579545 / 32 / 16 / desired_frequency, envelope
    'SOUND SOUND_CHANNEL_A, SOUND_TONE_C5_PARAM, 10
    SOUND SOUND_CHANNEL_A, SOUND_TONE_C5_PARAM, SOUND_ENVELOPE_ENABLE
    SOUND SOUND_CHANNEL_ENVELOPE, 6000, 8
    FOR i = 0 TO SOUND_NTSC_DURATION_1_10TH_SEC * 10
        WAIT
    NEXT i

    FOR i = 0 TO 50
        SOUND SOUND_CHANNEL_A,,0
        WAIT
    NEXT i

END

'play second tone in end-of-turn chime ("bong!")
play_sound_bong:    PROCEDURE
    FOR i = 0 TO SOUND_NTSC_DURATION_1_10TH_SEC * 10
        SOUND SOUND_CHANNEL_A, SOUND_TONE_C4_PARAM, 10
        WAIT
    NEXT i

    FOR i = 0 TO 50
        SOUND SOUND_CHANNEL_A,,0
        WAIT
    NEXT i
END

'play third tone in end-of-turn chime ("bung!")
play_sound_bung:    PROCEDURE
    FOR i = 0 TO SOUND_NTSC_DURATION_1_10TH_SEC * 10
        SOUND SOUND_CHANNEL_A, SOUND_TONE_F4_PARAM, 10
        WAIT
    NEXT i

    SOUND SOUND_CHANNEL_A,,0
END

'play bzzt sound to indicate something negative; such as when there is invalid input
'TODO: make this actually sound like a buzz; sort of a placeholder for now
play_sound_bzzt:    PROCEDURE
    FOR i = 0 TO SOUND_NTSC_DURATION_1_10TH_SEC * 5
        SOUND SOUND_CHANNEL_A, SOUND_TONE_F4_PARAM, 10
        WAIT
    NEXT i

    SOUND SOUND_CHANNEL_A,,0
END
