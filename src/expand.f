C     ******************************************************************
      SUBROUTINE EXPAND(A, B, L)
C
C     EXPANDS BYTE ARRAY TO BIT ARRAY.
C
      INTEGER A(0:*), B(0:*), L
Cf2py intent(out) A
Cf2py intent(in) B
      INTEGER I, J, V

C     A IS THE ARRAY IN BIT ARRAY FORMAT.
C     B IS THE ARRAY IN BYTE FORMAT.
C     L IS THE LENGTH OF THE ARRAY B IN HEXDIGITS.
C     A MUST BE 4 * L LONG.

      DO 10 I = 0, L - 1
      V = B(I)
      DO 20 J = 0, 3
      A((3 - J) + I * 4) = MOD(V, 2)
      V = V / 2
   20 CONTINUE
   10 CONTINUE
      END