
#
# WepSIM (https://wepsim.github.io/wepsim/)
#

# Begin

begin {
              # R0 <- 0
              (EXCODE=0, T11, MR=1, SelC=0, LC=1),

    fetch:    # MAR <- PC
              # MBR <- Mem[MAR]
              # IR  <- MBR, PC <- PC + 4
              # jump to associated microcode for op. code
}


#
# RISC-V base to be used
# Base RISC-V a usar
#

rdcycle reg1  {
      co=111111,
      nwords=1,
      reg1=reg(25,21),
      help='reg1 = load accumulated clock cycles',
      {
           (MH=1, T12=1, SELC=10101, LC=1, A0=1, B=1, C=0)
      }
}

add reg1 reg2 reg3 {
      co=111111,
      nwords=1,
      reg1=reg(25,21),
      reg2=reg(20,16),
      reg3=reg(15,11),
      help='r1 = r2 + r3',
      {
          (MC=1, MR=0, SELA=1011, SELB=10000, MA=0, MB=0, SELCOP=1010, T6=1, SELC=10101, LC=1, SELP=11, M7, C7, A0=1, B=1, C=0)
      }
}

sub reg1 reg2 reg3 {
      co=111111,
      nwords=1,
      reg1=reg(25,21),
      reg2=reg(20,16),
      reg3=reg(15,11),
      help='r1 = r2 - r3',
      {
          (MC=1, MR=0, SELB=1011, SELA=10000, MA=0, MB=0, SELCOP=1011, T6=1, SELC=10101, LC=1, SELP=11, M7, C7, A0=1, B=1, C=0)
      }
}

mul reg1 reg2 reg3 {
      co=111111,
      nwords=1,
      reg1=reg(25,21),
      reg2=reg(20,16),
      reg3=reg(15,11),
      help='reg1 = reg2 * reg3',
      {
          (MC=1, MR=0, SELA=1011, SELB=10000, MA=0, MB=0, SELCOP=1100, T6=1, SELC=10101, LC=1, SELP=11, M7, C7, A0=1, B=1, C=0)
      }
}

lw rd offset(rs1) {
      co=111111,
      nwords=1,
      rd=reg(25,21),
      offset=inm(15,0),
      rs1=reg(20,16),
      help='rd = (MEM[rs1+offset+3] .. MEM[rs1+offset])',
      {
          (SE=1, OFFSET=0, SIZE=10000, T3=1, C5=1),
          (MR=0, SELA=10000, MA=0, MB=1, MC=1, SELCOP=1010, T6=1, C0=1),
          (TA=1, R=1, BW=11, M1=1, C1=1),
          (T1=1, LC=1, MR=0, SELC=10101, A0=1, B=1, C=0)
      }
}

sw reg1 val(reg2) {
      co=111111,
      nwords=1,
      reg1 = reg(25,21),
      val  = inm(15,0),
      reg2 = reg(20,16),
      help='MEM[rs1+offset+3 .. rs1+offset] = rs2',
      {
          (SE=1, OFFSET=0, SIZE=10000, T3=1, C5=1),
          (MR=0, SELA=10000, MA=0, MB=1, MC=1, SELCOP=1010, T6=1, C0=1),
          (MR=0,  SELA=10101, T9=1, M1=0, C1=1),
          (BW=11, TA=1, TD=1, W=1,  A0=1, B=1, C=0)
      }
}

beq rs1 rs2 offset {
      co=111111,
      nwords=1,
      rs1=reg(25,21),
      rs2=reg(20,16),
      offset=address(15,0)rel,
      help='if (rs1 == rs2) pc += offset',
      {
           (T8, C5),
           (SELA=10101, SELB=10000, MC=1, SELCOP=1011, SELP=11, M7, C7),
           (A0=0, B=1, C=110, MADDR=bck2ftch2),
           (T5, M7=0, C7),
           (T2, C4),
           (SE=1, OFFSET=0, SIZE=10000, T3, C5),
           (MA=1, MB=1, MC=1, SELCOP=1010, T6, C2, A0=1, B=1, C=0),
bck2ftch2: (T5, M7=0, C7),
           (A0=1, B=1, C=0)
      }
}


#
# Complex numbers
#

# la    r1 u32         { ... }
# sc    r1 r2 (r3)     { ... }
# lc    r1 r2 (r3)     { ... }
# addc  r1 r2 r3 r4    { ... }
# mulc  r1 r2 r3 r4    { ... }
# beqc  r1 r2 r3 r4 s6 { ... }





call U20 {
    co = 100001,
    nwords = 1
    U20 = inm(19, 0)
    {
    # BR[ra] ← PC
    (T2, SelC = 00001, LC),
    # PC ← U20
    ()

    }
}





ret {
    co = 100010
    {
    # PC ← BR[ra] 
    (SelA = 00001, T9, M2 = 0, C2)

    }
}






hcf {
    co = 100011,
    nwords = 1
    {
        # PC <- 0x00
        (SelA = 00000, T9, M2 = 0, C2),
        # SR <- 0x00
        (SelA = 00000, SelC = 00010, T9, LC)

    }
}










# Registers

registers {
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
