'play first tone in end-of-turn chime ("bing")

'second param to SOUND indicates the note, derived from: 3579545 / 32 / <note frequency in Hz, e.g. 440 for A> 
'(note 3579545 is for NTSC; for PAL use 4000000)

CONST SOUND_NTSC_DURATION_1_10TH_SEC = 6
CONST SOUND_PAL_DURATION_1_10TH_SEC = 5

'''first param to SOUND is one of these constants:
CONST SOUND_CHANNEL_A = 0
CONST SOUND_CHANNEL_B = 1
CONST SOUND_CHANNEL_C = 2
CONST SOUND_CHANNEL_ENVELOPE = 3
CONST SOUND_NOISE_AND_MIX_REGISTER = 4
CONST SOUND_ENVELOPE_ENABLE = 48

' can set 5-9 for first param, but only available with the secondary PSG in the ECS add-on module

' reference for notes and frequency: https://pages.mtu.edu/~suits/notefreqs.html

'harcoding instead of calculating these, mostly because of 16-bit overflow
'tones actually sounded right when testing it calculated,
'but received "number exceeds 16 bits" warnings
'will need separate consts and perhaps set of functions entirely if we choose to support PAL
CONST NTSC_SOUND_TONE_C5 = 214 '3579545 / 32 / 523 (523 is Hz for C5)
CONST NTSC_SOUND_TONE_C4 = 427 '3579545 / 32 / 262 (262 is Hz for C4)
CONST NTSC_SOUND_TONE_F4 = 321 '3579545 / 32 / 349 (349 is Hz for F4)
CONST NTSC_SOUND_TONE_F1 = 2542 '3579545 / 32 / 44 (44 is Hz for F1)

CONST PAL_SOUND_TONE_C5 = 239 '4000000 / 32 / 523 (523 is Hz for C5)
CONST PAL_SOUND_TONE_C4 = 477 '4000000 / 32 / 262 (262 is Hz for C4)
CONST PAL_SOUND_TONE_F4 = 358 '4000000 / 32 / 349 (349 is Hz for F4)
CONST PAL_SOUND_TONE_F1 = 2841 '4000000 / 32 / 44 (44 is Hz for F1)

'play first tone in end-of-turn chime ("bing!")
play_sound_bing:   PROCEDURE
    IF NTSC THEN
        GOSUB play_sound_bing_ntsc
    ELSE
        GOSUB play_sound_bing_pal
    END IF
END

play_sound_bing_ntsc:   PROCEDURE
    SOUND SOUND_CHANNEL_A, NTSC_SOUND_TONE_C5, SOUND_ENVELOPE_ENABLE
    SOUND SOUND_CHANNEL_ENVELOPE, 6000, 8
    FOR i = 0 TO SOUND_NTSC_DURATION_1_10TH_SEC * 10
        WAIT
    NEXT i
    FOR i = 0 TO 60
        SOUND SOUND_CHANNEL_A,,0
    NEXT i
    WAIT
END

play_sound_bing_pal:    PROCEDURE
    SOUND SOUND_CHANNEL_A, PAL_SOUND_TONE_C5, SOUND_ENVELOPE_ENABLE
    SOUND SOUND_CHANNEL_ENVELOPE, 6000, 8
    FOR i = 0 TO SOUND_PAL_DURATION_1_10TH_SEC * 10
        WAIT
    NEXT i
    FOR i = 0 TO 50
        SOUND SOUND_CHANNEL_A,,0
    NEXT i
    WAIT
END

play_sound_bong:    PROCEDURE
    IF NTSC THEN
        GOSUB play_sound_bong_ntsc
    ELSE
        GOSUB play_sound_bong_pal
    END IF
END

'play second tone in end-of-turn chime ("bong!")
play_sound_bong_ntsc:    PROCEDURE
    FOR i = 0 TO SOUND_NTSC_DURATION_1_10TH_SEC * 10
        SOUND SOUND_CHANNEL_A, NTSC_SOUND_TONE_C4, 10
        WAIT
    NEXT i

    FOR i = 0 TO 60
        SOUND SOUND_CHANNEL_A,,0
        WAIT 
    NEXT i
END

play_sound_bong_pal:    PROCEDURE
    FOR i = 0 TO SOUND_PAL_DURATION_1_10TH_SEC * 10
        SOUND SOUND_CHANNEL_A, PAL_SOUND_TONE_C4, 10
        WAIT
    NEXT i

    FOR i = 0 TO 50
        SOUND SOUND_CHANNEL_A,,0
        WAIT
    NEXT i
END

play_sound_bung:    PROCEDURE
    IF NTSC THEN
        GOSUB play_sound_bung_ntsc
    ELSE
        GOSUB play_sound_bung_pal
    END IF
END

'play third tone in end-of-turn chime ("bung!")
play_sound_bung_ntsc:    PROCEDURE
    FOR i = 0 TO SOUND_NTSC_DURATION_1_10TH_SEC * 10
        SOUND SOUND_CHANNEL_A, NTSC_SOUND_TONE_F4, 10
        WAIT
    NEXT i

    SOUND SOUND_CHANNEL_A,,0
END

play_sound_bung_pal:    PROCEDURE
    FOR i = 0 TO SOUND_PAL_DURATION_1_10TH_SEC * 10
        SOUND SOUND_CHANNEL_A, PAL_SOUND_TONE_F4, 10
        WAIT
    NEXT i

    SOUND SOUND_CHANNEL_A,,0
END

'play bzzt sound to indicate something negative; such as when there is invalid input
'TODO: make this actually sound like a buzz; sort of a placeholder for now
play_sound_bzzt:    PROCEDURE
    IF NTSC THEN
        GOSUB play_sound_bzzt_ntsc
    ELSE
        GOSUB play_sound_bzzt_pal
    END IF
END

play_sound_bzzt_ntsc:    PROCEDURE
    FOR i = 0 TO SOUND_NTSC_DURATION_1_10TH_SEC * 5
        SOUND SOUND_CHANNEL_A, NTSC_SOUND_TONE_F4, 10
        WAIT
    NEXT i

    SOUND SOUND_CHANNEL_A,,0
END

play_sound_bzzt_pal:    PROCEDURE
    FOR i = 0 TO SOUND_PAL_DURATION_1_10TH_SEC * 5
        SOUND SOUND_CHANNEL_A, PAL_SOUND_TONE_F4, 10
        WAIT
    NEXT i

    SOUND SOUND_CHANNEL_A,,0
END

'play gentle "click" sound to indicate input received successfully
'TODO: make this play the right sound; placeholder for now
play_sound_click:   PROCEDURE
    IF NTSC THEN
        GOSUB play_sound_click_ntsc
    ELSE
        GOSUB play_sound_click_pal
    END IF
END

play_sound_click_ntsc:   PROCEDURE
    FOR i = 0 TO SOUND_NTSC_DURATION_1_10TH_SEC * 5
        SOUND SOUND_CHANNEL_A, NTSC_SOUND_TONE_F4, 10
        WAIT
    NEXT i

    SOUND SOUND_CHANNEL_A,,0
END

play_sound_click_pal:   PROCEDURE
    FOR i = 0 TO SOUND_PAL_DURATION_1_10TH_SEC * 5
        SOUND SOUND_CHANNEL_A, PAL_SOUND_TONE_F4, 10
        WAIT
    NEXT i

    SOUND SOUND_CHANNEL_A,,0
END

play_sound_destroy:   PROCEDURE
    FOR i = 0 TO SOUND_NTSC_DURATION_1_10TH_SEC * 5
        SOUND SOUND_CHANNEL_A, NTSC_SOUND_TONE_F4, 10
        WAIT
    NEXT i

    SOUND SOUND_CHANNEL_A,,0
END
