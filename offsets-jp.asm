detour_to_custom_knockback=$8338
standard_crouch=$9920
crouch_resolve=$840C
trevor_jump_table=$9376
attack=$942F
jump_attack_step=$94C9
attack_resolve=$97A3
set_fall_state=$974F
fall_adjust=$9756
standard_jump=$9777
standard_stair_idle=$99A4
standard_stair_walk=$9AAB
stair_walk_resume=$9A43
sypha_jumptable=$9C19
alucard_jumptable=$A59B
empty_bank_e=$BF90 ; actually $BF39
empty_bank_jump=$BED0 ; actually can go a bit earlier
setAndSaveLowerBank=$E2D0
PLAYER_UPDATE_BANK=$E
CUSTOM_JUMP_BANK=$1

; if $0, disabled
; otherwise, between $1 and $255 enabled
; higher values are actually less inertia, with $1 being the weightiest.
INERTIA=$40