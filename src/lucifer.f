C     ******************************************************************
      SUBROUTINE LUCIFER(D, K, M)

C     LUCIFER, A DIRECT PREDECESSOR OF THE DES ALGORITHM, IS A
C     BLOCK-CIPHER HAVING A 128 BIT BLOCK SIZE AND 128 BIT KEY
C     LENGTH.
C
C     BASED ON THE FORTRAN IV CODE IN THE FOLLOWING PAPER:
C
C       ARTHUR SORKIN: LUCIFER, A CRYPTOGRAPHIC ALGORITHM. IN:
C       CRYPTOLOGIA, VOLUME 8, NUMBER 1, JANUARY 1984

      INTEGER D
Cf2py intent(in)::A
      INTEGER K(0:7, 0:15)
Cf2py intent(in)::K
      INTEGER M(0:7, 0:7, 0:1)
Cf2py intent(out)::M

C     MESSAGE BLOCK STORED ONE BIT/LOCATION.
C     KEY STORED ONE BIT/LOCATION.
C     VALUE MUST BE 0 OR 1. THIS SUBROUTINE DOESN'T VERIFY THAT
C     CONDITION FOR MESSAGE OR KEY.
C
C     FORTRAN STORES DATA WITH INNERMOST SUBSCRIPT VARYING THE
C     FASTEST. THEREFORE, WE HAVE M(COLUM, ROW, PLANE) AND
C     K(COLUMN, ROW). THE ROWS ARE THE BYTES OF THE MESSAGE AND
C     KEY. THE COLUMNS ARE THE BITS IN THE BYTE. FOR A NORMAL
C     LANGUAGE SUCH AS PL/1, WE WOULD DECLARE M(ROW, COLUMN, PLANE)
C     AND K(ROW, COLUMN). WE CAN EQUIVALENCE A LINEAR ARRAY OF
C     128 ENTRIES TO THE MESSAGE AND KEY BECAUSE OF THE WAY IN
C     WHICH THEY ARE STORED.

      INTEGER O(0:7), SW(0:7, 0:7), PR(0:7), TR(0:7), C(0:1)
      INTEGER S0(0:15), S1(0:15)
      INTEGER H, L, V
      INTEGER H0, H1, KC, KS
      INTEGER II, JJ, KK, LL

      EQUIVALENCE (C(0), H), (C(1), L)

C     DIFFUSION PATTERN.
      DATA O /7,6,2,1,5,0,3,4/

C     INVERSE OF FIXED PERMUTATION.
      DATA PR /2,5,4,0,3,1,7,6/

C     S-BOX PERMUTATIONS.
      DATA S0 /12,15,7,10,14,13,11,0,2,6,3,1,9,4,5,8/
      DATA S1 /7,2,14,9,3,11,0,4,12,13,1,10,6,15,8,5/

C     THE HALVES OF THE MESSAGE BYTE SELECTED ARE USED AS INPUT
C     TO S0 AND S1 TO PRODUCE 4 V BITS EACH. IF K(JJ, KS) = 0 THEN
C     THE LOW ORDER 4 BITS ARE USED WITH S0 AND THE HIGH ORDER 4
C     BITS ARE USED WITH S1. IF K(JJ, KS) = 1 THEN THE LOW ORDER
C     4 BITS ARE USED WITH S1 AND THE HIGH ORDER 4 BITS ARE USED
C     WITH S0.
C
C     WE DON'T PHYSICALLY SWAP THE HALVES OF THE MESSAGE OR ROTATE
C     THE MESSAGE HALVES OR KEY. WE USE POINTERS INTO THE ARRAYS
C     TO TELL WHICH BYTES ARE BEING OPERATED ON.
C
C     D = 1 INDICATES DECIPHER, ENCIPHER OTHERWISE.
C
C     H0 AND H1 POINT TO THE TWO HALVES OF THE MESSAGE.
C     VALUE 0 IS THE LOWER HALF AND VALUE 1 IS THE UPPER.

      H0 = 0
      H1 = 1
      KC = 0

      IF (D .EQ. 1) KC = 8

      DO 10 II = 1, 16

C     C-I-D CYCLE.
      IF (D. EQ. 1) KC = MOD(KC + 1, 16)

C     KS IS THE INDEX OF THE TRANSFORM CONTROL BYTE.
      KS = KC

      DO 20 JJ = 0, 7

      L = 0
      H = 0

C     CONSTRUCT THE INTEGER VALUES OF THE HEXDIGITS OF ONE BYTE
C     OF THE MESSAGE.
C     CALL COMPRESS(M(0, JJ, H1), C, 2) IS EQUIVALENT AND SIMPLER
C     BUT WAS SLOWER. C(0) = H AND C(1) = L BY EQUIVALENCE.

      DO 30, KK = 0, 3
      L = L * 2 + M(7 - KK, JJ, H1)
   30 CONTINUE

      DO 40, KK = 4, 7
      H = H * 2 + M(7 - KK, JJ, H1)
   40 CONTINUE

C     CONTROLLED INTERCHANGE AND S-BOX PERMUTATION.
      V = (S0(L) + 16 * S1(H)) * (1 - K(JJ, KS)) +
     &    (S0(H) + 16 * S1(L)) * K(JJ, KS)

C     CONVERT V BACK INTO BIT ARRAY FORMAT.
C     CALL EXPAND(V, TR, 2) IS EQUIVALENT AND SIMPLER BUT
C     WAS SLOWER.

      DO 50, KK = 0, 7
      TR(KK) = MOD(V, 2)
      V = V / 2
   50 CONTINUE

C     KEY-INTERRUPTION AND DIFFUSION COMBINED
C     THE K + TR TERM IS THE PERMUTED KEY INTERRUPTION.
C     MOD(O(KK) + JJ, 8) IS THE DIFFUSION ROW FOR COLUMN KK.
C     ROW = BYTE AND COLUMN = BIT WITHIN BYTE.

      DO 60, KK = 0, 7
      M(KK, MOD(O(KK) + JJ, 8), H0) = MOD(K(PR(KK), KC) + TR(PR(KK)) +
     &  M(KK, MOD(O(KK) + JJ, 8), H0), 2)
   60 CONTINUE

      IF (JJ .LT. 7 .OR. D .EQ. 1) KC = MOD(KC + 1, 16)
   20 CONTINUE

C     SWAP VALUES IN H0 AND H1 TO SWAP HALVES OF MESSAGE.
      LL = H0
      H0 = H1
      H1 = LL
   10 CONTINUE

C     PHYSICALLY SWAP UPPER AND LOWER HALVES OF THE MESSAGE AFTER
C     THE LAST ROUND. WE WOULDN'T HAVE NEEDED TO DO THIS IF WE
C     HAD BEEN SWAPPING ALL ALONG.

      DO 70 JJ = 0, 7
      DO 80 KK = 0, 7
      SW(KK, JJ) = M(KK, JJ, 0)
      M(KK, JJ, 0) = M(KK, JJ, 1)
      M(KK, JJ, 1) = SW(KK, JJ)
   80 CONTINUE
   70 CONTINUE
      END
