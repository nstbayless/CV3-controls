# Castlevania III Improved Controls

This hack for *Castlevania III* modernizes the control scheme to make it more
like Symphony of the Night and Mega Man, allowing the player more
control while in the air.

Source code and build instructions available [here](https://github.com/nstbayless/CV1-controls). Feel free to combine this hack with any other hack, but please credit the author (Sodium) if distributed.

## Complete list of changes

Some of these are optional, and depend on the specific patch.

- Enables all characters to control their x-velocity in mid-air while jumping (including while jump attacking); Grant’s jumping controls remain unchanged. 
- (Optional) When releasing the jump button, one immediately starts falling again; this allows the player to make smaller hops if desired. (Does not apply to Grant.)
    - apply `vcancel` hack for this (Recommended).
- After being knocked back, the player regains control after a split second and can angle their fall.
- When walking off an edge, the player retains control instead of dropping straight down.
- All characters can jump off of stairs at any point in the climb (however, it is still impossible to land on stairs, so be careful jumping from long flights of stairs over pits)

## Compatability

This hack is comaptible with both the US and JP versions of *Castlevania III*. Additionally, it is compatible with the following hacks:

- [Relocalization + Alucard skin](https://www.romhacking.net/hacks/1983/) (Recommended!)
- [Fast Character Switching](https://www.romhacking.net/hacks/8039/) (Recommended!)
- [Linear Version](https://www.romhacking.net/hacks/4735/)

## How to apply

First, verify that your ROM has one of the hashes listed in "ROM information" below. You can use [ROM Hasher](https://www.romhacking.net/utilities/1002/) to find the file hash of your ROM. If your ROM doesn't match the exact hash given, it's still possible the hack will work, but you might encounter glitches or crashes.

Use an ips patcher, such as [flips](https://www.smwcentral.net/?p=section&a=details&id=11474) or [Lunar IPS](https://www.romhacking.net/utilities/240/). Several `.ips` files are provided depending on what you want and what base ROM you are using.

## Similar Hacks

Similar controls hacks are available for [Castlevania](https://www.romhacking.net/hacks/3867/), [Castlevania II: Simon's Quest](https://www.romhacking.net/hacks/4150/), [Castlevania: The Adventure](https://www.romhacking.net/hacks/7083/), and [Castlevania II: Belmont's Revent](https://www.romhacking.net/hacks/6987/), all by Sodium (aka NaOH*).

*For chemistry nerds, NaOH is [Sodium Hydroxide](https://en.wikipedia.org/wiki/Sodium_hydroxide), a strong base.

## Credits

ASM hacking:
    Sodium

Tools:
    `fceux` and `asm6f`
    
Special thanks:
    revility
    OmegaJP

## ROM information

US:
```
CRC32: 7CC9C669
SHA-1: F91281D5D9CC26BCF6FB4DE2F5BE086BC633D49B
```

JP:
```
CRC32: 2E93CE72
SHA-1: A0F3B31D4E3B0D2CA2E8A34F91F14AD99A5AD11F
```