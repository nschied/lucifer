C     ******************************************************************
      SUBROUTINE A2HEX(A, HEX)
C
C     CONVERTS 16 CHARACTERS LONG ASCII STRING TO 32 CHARACTERS LONG
C     HEX STRING.
C
      CHARACTER*16 A
Cf2py intent(in) A
      CHARACTER*32 HEX
Cf2py intent(out) HEX	  
      INTEGER I
      WRITE (HEX, 100) (A(I:I), I = 1, LEN(A))
 100  FORMAT (16Z2.2)
      END