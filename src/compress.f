C     ******************************************************************
      SUBROUTINE COMPRESS(A, B, L)
C
C     COMPRESSES BIT ARRAY TO BYTE ARRAY.
C
      INTEGER A(0:*), B(0:*), L
Cf2py intent(in) A
Cf2py intent(out) B
      INTEGER I, J

C     A IS THE ARRAY IN BIT ARRAY FORMAT.
C     B IS THE ARRAY IN BYTE FORMAT.
C     L IS THE LENGTH OF THE ARRAY B IN HEXDIGITS.
C     A MUST BE 4 * L LONG.

      DO 10 I = 0, L - 1
      B(I) = 0
      DO 20 J = 0, 3
      B(I) = B(I) * 2 + MOD(A(J + I * 4), 2)
   20 CONTINUE
   10 CONTINUE
      END