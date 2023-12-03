
#
# WepSIM (https://wepsim.github.io/wepsim/)
#

.text
main: la x1, 0x12345678
			sc x1, x2, (x3)
      lc x1, x2, (x3)
      addc x1, x2, x3, x4
      mulc x1, x2, x3, x4

