VSP_CONTROL_ZERO_VSPEED=$1C
MINIMUM_VSP_CANCEL=$0E

; these don't really need to be powers of 2
ifdef INERTIA_64
    INERTIA=64
endif

ifdef INERTIA_0
    INERTIA=0
endif

ifdef INERTIA_32
    INERTIA=32
endif

REDUCE_JUMP_LAG=1