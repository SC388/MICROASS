
#
# WepSIM (https://wepsim.github.io/wepsim/)
#

# Begin

begin {
            # R0 <- 0
            (EXCODE=0, T11, MR=1, SelC=0, LC=1),

    fetch:  # MAR <- PC
            (T2, C0),
            # MBR <- Mem[MAR]
            (TA, R, BW=11, M1=1, C1=1),
            # IR  <- MBR, PC <- PC + 4
            (M2, C2, T1, C3),
            # jump to associated microcode for op. code
            (A0, B=0, C=0)
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
      (A0, B= 1, C = 0)
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

sc R1, R2, (R3) {  #MEM[R3+0] ← BR[R1] / MEM[R3+4] ← BR[R2]
   co= 010010,
   nwords=1,
   R1 = reg(25, 21)
   R2 = reg(20, 16)
   R3 = reg(15, 11)
    {
    # MAR <- BR[R3]
    (SelA = 01011, MR = 0, T9, C0)
    # MBR <- BR[R1]
    (SelB = 10101, M1 = 0, T10, C1)
    # MAR[R1] <- MBR[R3]
    (Ta, TD, W, BW = 11)
    #RT1 <- R3
    (SelA = 01011, MR = 0, T9, C4)
		# MAR <- RT1 + 4
    (MA, MB = 10, SelCop = 01010, MC, T6, C0)
    # MBR <- BR[R2]
    (SelB = 10000, M1 = 0, T10, C1)
    # MAR[R2] <- MBR[R3]
    (Ta, TD, W, BW = 11)   
    #Jump to fetch
          (A0, B= 1, C = 0)
         }
}
                 
lc R1, R2, (R3) {  #BR[R1] ← MEM[R3+0] / BR[RR2] ← MEM[R3+4]
   co= 010011,
   nwords=1,
   R1 = reg(25, 21)
   R2 = reg(20, 16)
   R3 = reg(15, 11)
    {
    # MAR <- BR[R3]
    (SelA = 01011, MR = 0, T9, C0)
    # MBR[R1] <- MAR[R3]
    (Ta, R, BW = 11, M1, C1)
    # BR[R1] <- MBR
		(T1, SelC = 10101, MR = 0, LC = 1 )
    #RT1 <- R3
    (SelA = 01011, MR = 0, T9, C4)   
    # MAR <- RT1 + 4
    (MA, MB = 10, SelCop = 01010, MC, T6, C0)
    # MBR[R2] <- MAR[R3]
    (Ta, R, BW = 11, M1, C1)
    # BR[R2] <- MBR
		(T1, SelC = 10000, MR = 0, LC = 1 )
    #Jump to fetch
          (A0, B= 1, C = 0)
    		}
}

addc R1, R2, R3, R4 {  #BR[R1] ← BR[R1] + BR[R3] / BR[R2] ← BR[R2] + BR[R4]
   co=  010100,
   nwords=1,
   R1 = reg(25, 21)
   R2 = reg(20, 16)
   R3 = reg(15, 11)
   R4 = reg(10, 6)
   {
    #RT1 <- BR[R1]
    (SelA = 10101, MR = 0, T9, C4)
    #RT2 <- BR[R3]
    (SelB = 01011, MR = 0, T10, C5)
    #BR[R1] <- RT1 + RT2
    (MA, MB = 01, SelCop = 01010, MC, T6, LC, SelC = 10101, MR = 0)
    #RT1 <- BR[R2]
    (SelA = 10000, MR = 0, T9, C4)
    #RT2 <- BR[R4]
    (SelB = 00110, MR = 0, T10, C5)
    #BR[R2] <- RT1 + RT2
    (MA, MB = 01, SelCop = 01010, MC, T6, LC, SelC = 10000, MR = 0)
    #Jump to fetch
    (A0, B= 1, C = 0)
    		}
}

mulc R1, R2, R3, R4 {  # BR[R1] ← BR[R1] * BR[R3] - BR[R2] * BR[R4] | BR[R2] ← BR[R1] * BR[R4] + BR[R2] * BR[R3]
   co=  010101,
   nwords=1,
   R1 = reg(25, 21)
   R2 = reg(20, 16)
   R3 = reg(15, 11)
   R4 = reg(10, 6)
   {
    #RT1 <- BR[R1]
    (SelA = 10101, MR = 0, T9, C4)
    #RT2 <- BR[R3]
    (SelB = 01011, MR = 0, T10, C5)
    #RT3 <- RT1 * RT2
    (MA, MB = 01, SelCop = 01100, MC, C6)
     
    #RT1 <- BR[R2]
    (SelA = 10000, MR = 0, T9, C4)
    #RT2 <- BR[R4]
    (SelB = 00110, MR = 0, T10, C5)
    #RT2 <- RT1 * RT2
    (MA, MB = 01, SelCop = 01100, MC, T6, C5)
     
    #RT1 <- RT3
    (T7, C4)
    # BR[R5] <- RT1 - RT2
    (MA, MB = 01, SelCop = 01011, MC, T6, LC, SelC = 00101, MR)
     
    
    #RT1 <- BR[R1]
    (SelA = 10101, MR = 0, T9, C4)
    #RT2 <- BR[R4]
    (SelB = 00110, MR = 0, T10, C5)
    #RT3 <- RT1 * RT2
    (MA, MB = 01, SelCop = 01100, MC, C6)
    
    #RT1 <- BR[R2]
    (SelA = 10000, MR = 0, T9, C4)
    #RT2 <- BR[R3]
    (SelB = 01011, MR = 0, T10, C5)
    #RT2 <- RT1 * RT2
    (MA, MB = 01, SelCop = 01100, MC, T6, C5)
    
    #RT1 <- RT3
    (T7, C4)
    #BR[R2] <- RT1 + RT2
    (MA, MB = 01, SelCop = 01010, MC, T6, LC, SelC = 10000, MR = 0)

    #RT1 <- BR[R5]
    (MR, SelA = 00101, T9, C4)
    #BR[R1] <- RT1
    (T4, MR = 0, SelC = 10101, LC)

    #Jump to fetch
    (A0, B= 1, C = 0)
    		}
}


beqc R1, R2, R3, R4, S6 {  # IF (R1 == R3) AND (R2 == R4): PC ← PC + S6
   co=  110100,
   nwords=1,
   R1 = reg(25, 21)
   R2 = reg(20, 16)
   R3 = reg(15, 11)
   R4 = reg(10, 6) 
   S6 = address(5,0)rel
   {
    #MBR <- SR
    (T8, M1 = 0, C1)
    #BR[R1] - BR[R3]
    (SelA = 10101, SelB = 01011, MC , SelCop = 01011, M7, SelP = 11, M7, C7)
    # If R1 != R3, jump to end
    (A0 = 0, B = 1, C = 110, MADDR=bck2ftch2c)
    #Reset SR                       
    (T1, M7 = 0, C7)    
    #BR[R2] - BR[R4]                    
    (SelA = 10000, SelB = 00110, MC , SelCop = 01011, M7, SelP = 11, M7, C7)
    # If R2 != R4 jump to end
    (A0 = 0, B = 1, C = 110, MADDR=bck2ftch2c)
    #Reset SR                       
    (T1, M7 = 0, C7) 
    #RT2 <- S6
    (SE = 1, OFFSET = 0, SIZE = 00110, T3, C5)
    #RT1 <- PC
    (T2, C4)
    #RT1 + RT2:
    (MA, MB = 01, SelCop = 01010, MC, T6, M2 = 0, C2)
bck2ftch2c: #MBR <- SR
    (T1, M7 = 0, C7)
    #Jump to fetch
    (A0, B= 1, C = 0)
    		}
}

call U20 {  #BR[ra] ← PC / PC ← U20
   co= 100001,
   nwords=1,
   U20 = inm(19,0)
   { 
   #BR[ra] <- PC
   (T2, LC, SelC = 00001, MR)
   #PC <- U20
   (SE = 0, SIZE = 10100, OFFSET = 0, T3, M2 = 0, C2)
	 #Jump to fetch
   (A0, B= 1, C = 0)
   }
}

ret {
    co = 100010
    {
    # PC <- BR[ra] 
    (SelA = 00001, T9, C2, MR)
    #Jump to fetch
    (A0, B= 1, C = 0)

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
        #Jump to fetch (not really needed in this instruction since it is a hcf instruction xD)
        (A0, B= 1, C = 0)

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

