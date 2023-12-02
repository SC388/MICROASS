
#
# WepSIM (https://wepsim.github.io/wepsim/)
#

begin
{
  fetch: # MAR <- PC
         # MBR <- Mem[MAR]
         # IR  <- MBR, PC <- PC + 4
         # jump to associated microcode for op. code
         (T2, C0),
         (TA, R, BW=11, M1=1, C1=1),
         (M2, C2, T1, C3),
         (A0, B=0, C=0)
}

la R1, U32 {
   co= 010001,
   nwords=2,
   R1 = reg(25, 21)
   U32 = inm(63, 32)
    {
      #MAR <- PC
      (T2, C0)
      #MBR <- MM[MAR]
      (Ta, R, BW = 11, M1, C1)
      # PC <- PC + 4
      (M2 = 1, C2)
      # BR[R1] <- MBR
      (T1, SelC = 10101, MR = 0, LC = 1 )
      #Jump to fetch
      (A0, B= 0, C = 0)
         }

}

sc R1, R2, (R3) {
   co= 010010,
   nwords=1,
   R1 = reg(25, 21)
   R2 = reg(20, 16)
   R3 = reg(15, 11)
    {
      # MEM[R3 + 0] <- BR[R1]
      (T1, SelA = 10101, MR = 0, LC = 1 )
      #Jump to fetch
      (A0, B= 0, C = 0)
         }
}

registers
{
    0=(zero,  x0),
    1=(ra,    x1),
    2=(sp,    x2) (stack_pointer),
    3=(gp,    x3),
    4=(tp,    x4),
    5=(t0,    x5),
    6=(t1,    x6),
    7=(t2,    x7),
    8=(s0,    x8),
    9=(s1,    x9),
    10=(a0,  x10),
    11=(a1,  x11),
    12=(a2,  x12),
    13=(a3,  x13),
    14=(a4,  x14),
    15=(a5,  x15),
    16=(a6,  x16),
    17=(a7,  x17),
    18=(s2,  x18),
    19=(s3,  x19),
    20=(s4,  x20),
    21=(s5,  x21),
    22=(s6,  x22),
    23=(s7,  x23),
    24=(s8,  x24),
    25=(s9,  x25),
    26=(s10, x26),
    27=(s11, x27),
    28=(t3,  x28),
    29=(t4,  x29),
    30=(t5,  x30),
    31=(t6,  x31)
}

