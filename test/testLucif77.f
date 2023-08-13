C     ******************************************************************
C
C     TEST PROGRAM FOR LUCIFER CIPHER.
C
C     ******************************************************************
      PROGRAM MAIN
      EXTERNAL TEST1, TEST2, TEST3, TEST4
     
      CALL SRAND(TIME())

      CALL TEST1()
      CALL TEST2()
      CALL TEST3()
      CALL TEST4()
      END
C     ******************************************************************
      SUBROUTINE TEST1()
      EXTERNAL CIPHER
      CHARACTER*32 KEY, MSG, REF1 , REF2

      LOGICAL ISOK
      ISOK = .FALSE.

      KEY = '0123456789ABCDEFFEDCBA9876543210'
      MSG = 'AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB'
      REF1 = '7C790EFDE03679E4BF28FE2D199E41A0'
      REF2 = MSG

      CALL CIPHER(0, KEY, MSG)

      IF(MSG.EQ.REF1) THEN
        ISOK = .TRUE.
      ELSE
        ISOK = .FALSE.
      ENDIF

      CALL CIPHER(1, KEY, MSG)

      IF(MSG.EQ.REF2) THEN
          ISOK = .TRUE.
      ELSE
        ISOK = .FALSE.
      ENDIF
c	  
      IF(ISOK) THEN
              PRINT*, '>>> F77 TEST 1: OK'
      ELSE
              PRINT*, '>>> F77 TEST 1: KO'
      ENDIF

      END
C     ******************************************************************
      SUBROUTINE TEST2()
      EXTERNAL CIPHER
      CHARACTER*32 KEY, MSG, REF
      INTEGER I

      WRITE (KEY, 100) (INT(RAND() * 16), I = 1, 32)

      MSG = 'AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB'
      REF = MSG

      CALL CIPHER(0, KEY, MSG)
      CALL CIPHER(1, KEY, MSG)

      IF(MSG.EQ.REF) THEN
        PRINT*, '>>> F77 TEST 2: OK'
      ELSE
        PRINT*, '>>> F77 TEST 2: KO'  
      ENDIF

  100 FORMAT (32Z1.1)
      END
C     ******************************************************************
      SUBROUTINE TEST3()
      EXTERNAL CIPHER
      CHARACTER*32 KEY, MSG, REF
      INTEGER I, J , K , LL
      REAL T1, T2, DT
      T1=0.
      T2=0.

      MSG = 'AAAAAAAAAAAAAAAABBBBBBBBBBBBBBBB'
      REF = MSG

      CALL CPU_TIME(T1)

      DO 10 J = 1, 10000
      WRITE (KEY, 100) (INT(RAND() * 16), I = 1, 32)
      CALL CIPHER(0, KEY, MSG)
      CALL CIPHER(1, KEY, MSG)
   10 CONTINUE
   
C     Loop to consume CPU time
      LL = 10
C    LL = 10
      K=0
      DO 666 I=1,LL
      K=K+I
      DO 667 J=1,LL
      K=K-J
  667 CONTINUE
c      PRINT*, K
  666 CONTINUE
  
      CALL CPU_TIME(T2)
      DT = ABS(T2-T1)

      IF((DT.LE.1.).AND.(MSG.EQ.REF)) THEN
              PRINT*, '>>> F77 TEST 3: OK' 
      ELSE
              PRINT*, '>>> F77 TEST 3: KO' 
      ENDIF

  100 FORMAT (32Z1.1)
  200 FORMAT (' 1000 RUNS IN ',F12.8,' SECONDS')
      END
C     ******************************************************************
      SUBROUTINE TEST4()
      EXTERNAL A2HEX, CIPHER, HEX2A
      CHARACTER*16 RAWKEY, RAWMSG
      CHARACTER*32 KEY, MSG, REF, RESU
      LOGICAL ISOK

      RAWKEY = 'SUPERSECRET'
      RAWMSG = 'ATTACK AT DAWN'
      REF = RAWMSG

      CALL A2HEX(RAWKEY, KEY)
      CALL A2HEX(RAWMSG, MSG)
      CALL CIPHER(0, KEY, MSG)
      CALL CIPHER(1, KEY, MSG)
      CALL HEX2A(MSG, RESU)
c  
      IF(RESU(1:14).EQ.REF(1:14)) THEN
        PRINT*,  '>>> F77 TEST 4: OK'
      ELSE
        PRINT*,  '>>> F77 TEST 4: KO'
      ENDIF

      END
