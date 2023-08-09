C     ******************************************************************
      SUBROUTINE HEX2A(HEX, A)
C
C     CONVERTS 32 CHARACTERS LONG HEX STRING TO 16 CHARACTERS LONG
C     ASCII STRING.
C
      CHARACTER*32 HEX
Cf2py intent(in) HEX
      CHARACTER*16 A
Cf2py intent(out) A
      INTEGER I

      READ (HEX, 100) (A(I:I), I = 1, LEN(A))
  100 FORMAT (16Z2.2)
      END