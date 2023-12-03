
#
# WepSIM (https://wepsim.github.io/wepsim/)
#



begin {
    # R0 <- 0
    (EXCODE=0, T11, MR=1, SelC=0, LC=1),

    fetch:    
        # MAR <- PC
        (T2, C0),
        # MBR <- Mem[MAR]
        (TA, R, BW=11, M1=1, C1=1),
        # IR  <- MBR, PC <- PC + 4
        (M2, C2, T1, C3),
        # jump to associated microcode
        (A0, B=0, C=0)
}


call U20 {
    co = 100001,
    nwords = 1
    U20 = inm(19, 0)
    {
      # MBR <- MM[MAR]
      (Ta, R, BW = 11, M1, C1)
      # PC <- PC + 4
      # RT1 <- MBR
      (M2,
      T1, C4)
      # jump to fetch
			(A0, B = 1, C = 0)
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





#
# WepSIM (https://wepsim.github.io/wepsim/)
#



begin {
    # R0 <- 0
    (EXCODE=0, T11, MR=1, SelC=0, LC=1),

    fetch:    
        # MAR <- PC
        (T2, C0),
        # MBR <- Mem[MAR]
        (TA, R, BW=11, M1=1, C1=1),
        # IR  <- MBR, PC <- PC + 4
        (M2, C2, T1, C3),
        # jump to associated microcode
        (A0, B=0, C=0)
}


call U20 {
    co = 100001,
    nwords = 1
    U20 = inm(19, 0)
    {
      # MAR <- PC
      (T2, C0),
      # MBR <- MM[MAR]
      (Ta, R, BW = 11, M1, C1)
      # PC <- PC + 4
      # t0 <- MBR
      (M2,
      T1, SelA = 00101, LC)

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
    28=(t3,  x28),
    27=(s11, x27),
    29=(t4,  x29),
    30=(t5,  x30),
    31=(t6,  x31)
}

