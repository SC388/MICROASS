.data
a: .word 35, 15
b: .word 10, 20

.text
    no_ext:
            # To implement with RISC-V instructions (without extension)
            lw s3, 0(a0)                # load the first part of the complex number a
            lw s4, 4(a0)                # load the second part
            lw s5, 0(a1)                # load the first part of the complex number b
            lw s6, 4(a1)                # load the second part
            

            beq s3 s5 real_eq_noext     # check if the real parts are equal

                add a0 s3 s5                # add real parts
                add a1 s4 s6                # add imaginary parts

                ret                         # return a + b;

            real_eq_noext:
            beq s4 s6 imag_eq_noext     # check if the imaginary parts are equal

                add a0 s3 s5                # add real parts
                add a1 s4 s6                # add imaginary parts

                ret                         # return a + b;

            imag_eq_noext:              # the complex numbers are equal
                # Calculate a * b;
                mul s11 s3 s5               # multiply real parts
                mul s10 s4 s6               # multiply imaginary parts
                sub s11 s11 s10             # substract these two parts

                mul s10 s3 s6               # multiply real part of a with imaginary part of b
                mul s9 s4 s5                # multiply imaginary part of a with real part of b
                add s10 s10 s9              # add these two parts

                add a0 s11 zero             # move the result to a0 
                add a1 s10 zero             # and a1 to return it

                ret                         # return




    with_ext:
            # To implement with RISC-V instructions (with extension)
            lc s3, s4, (a0)             # load the complex number a and
            lc s5, s6, (a1)             # b using the new instruction

            beqc s3 s4 s5 s6 eq_ext     # check if the real parts are equal

                addc s3, s4, s5, s6         # add the two complex numbers using the new instruction

                add a0 s3 zero              # move the results to a0
                add a1 s4 zero              # and a1 to return them (using add because we dont have mv)

                ret                         

            eq_ext:                         # the complex numbers are equal
                
                mulc s3, s4, s5, s6         # multiply the two complex numbers using the new instruction
            
                add a0 s3 zero              # move the results to a0
                add a1 s4 zero              # and a1 to return them (using add because we dont have mv)

                ret               



    main:   rdcycle s0
            la a0, a
            la a1, b
            call with_ext
            rdcycle s1
            sub s1 s1 s0
            
            rdcycle s0
            la a0, a
            la a1, b
            call no_ext
            rdcycle s2
            sub s2 s2 s0
            
            hcf # https://en.wikipedia.org/wiki/Halt_and_Catch_Fire_(computing)