C     ******************************************************************
      SUBROUTINE CIPHER(D, KEY, MSG)
C
C     ENCRYPTS HEX STRING WITH HEX KEY IF D IS 0, DECRYPTS IF D IS 1.
C
      INTEGER D
Cf2py intent(in)::D
      CHARACTER*32 KEY, MSG
Cf2py intent(in)::KEY
Cf2py intent(in,out)::MSG

C     D = 1 INDICATES DECIPHER, ENCIPHER OTHERWISE.
C     KEY AND MESSAGE MUST BE 32 CHARACTERS LONG HEX-DIGITS.

      EXTERNAL COMPRESS, EXPAND, LUCIFER

      INTEGER I
      INTEGER K(0:7, 0:15), M(0:7, 0:7, 0:1)
      INTEGER KK(0:127), MM(0:127)
      INTEGER KB(0:31), MB(0:31)

      EQUIVALENCE (K, KK), (M, MM)

      READ (KEY, 100) (KB(I), I = 0, 31)
      READ (MSG, 100) (MB(I), I = 0, 31)

      CALL EXPAND(KK, KB, 32)
      CALL EXPAND(MM, MB, 32)
      CALL LUCIFER(D, K, M)
      CALL COMPRESS(MM, MB, 32)
C BUG
C      WRITE (MSG, 100) (MB(I), I = 0, 31)
C
  100 FORMAT (32Z1.1)
      END
