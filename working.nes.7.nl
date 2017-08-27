$B57F#check for stairs (proper)#
$B5F4#.. null stair#
$B5AA#.. scale up to pix coords#
$B5B2#.. check if yint equals that#
$B5BD#.. compare xint#
$B59A#.. start of loop#
$BF55#.. return false#
$BF57#.. return true#
$BF5C#check diagonal for stairs#
$BF58#BEQ $BF57#
$BFCA#.. increase y#
$BFD4#.. adjust x#
$BFED#.. decrease x#
$BF85#.. start of outer loop#
$BF59#check diagonal for stairs#
$BF87#.. start of inner loop#
$BFB2#continue +++#
$BFB3#continue ++#
$BFB4#continue +#
$BFB7#adjust xy#
