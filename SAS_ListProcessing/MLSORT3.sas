/*http://listserv.uga.edu/cgi-bin/wa?A2=ind9907C&L=sas-l&P=R1337

Dorfman
%LET LIST =
SG FJLKDSN GEWO OPITHUI GJSERO TNJEOWIJ TW9345Y TWES SDJGJSRL NWOITJN RET
POTREPOR _5TWT WPST NWP4 T924YW P9YTP9W4 NT599P DLKFGBLK SDGSGIW A AEG AEF ZG
EGH A G HA HESH AIT4Y8W3 HAW T83PTQ3Y O OYTP53YT PQYP8Y3Q SSLKGH SLIEUH AERH
DQLUEIUR SL SLSHIH4 AEK AH5WO TA AEH EU DJGLKDJ ERHISHKL QLR UHER GHSLHLSH
RBGHSD SLH SKEHRT RSKIEHB Q87O3WSL B SDKLQI WPE WEGIUQ HIHQPIG H QPGKLXK ZLQA
HQP GTHQPG Z AOIRPH PGT3Q PGHSE QAPUR HPQYPQ A XC N SLKG PZEAF RQIUH RS H
T38753QO SL KG OW7TY OQ HSL QP YOQ287 _W7 TOQR TL DSLSD YSIUYG RISWYG VQ369R4
ORA47Q3 Y94 Z Q374R R462QTQ;
%put %MLSORT3 (SORTIN=&LIST,SEQ=A,NODUP=N);
%put %MLSORT3 (SORTIN=&LIST,SEQ=D,NODUP=N);
%put %MLSORT3 (SORTIN=&LIST,SEQ=A,NODUP=Y);
%put %MLSORT3 (SORTIN=&LIST,SEQ=D,NODUP=Y);


*/


%MACRO MLSORT3 (SORTIN=,SEQ=A,NODUP=N,MSG=Y);
   %LOCAL G I INV J N T;


   %IF &SEQ EQ A %THEN %LET SEQ = G;
   %ELSE              %LET SEQ = L;


   %DO %UNTIL (&&W&N EQ);
      %LET N = %EVAL(&N+1);
      %LET W&N = %SCAN(&SORTIN,&N);
   %END;
   %LET N = %EVAL(&N-1);


   %LET G = &N;
   %DO %UNTIL (&INV AND &G=1);
      %LET INV = 1;
      %LET G  = %EVAL(&G*10/13);
      %IF &G EQ 9 OR &G EQ 10 %THEN %LET G = 11;
      %ELSE %IF &G EQ  0 %THEN %LET G =  1;


      %DO I=1 %TO %EVAL(&N-&G);
         %LET J = %EVAL(&I+&G);
         %IF &&W&I &SEQ.T &&W&J %THEN %DO;
            %LET T   = &&W&J;
            %LET W&J = &&W&I;
            %LET W&I = &T;
            %LET INV = 0;
         %END;
      %END;
   %END;


   %LET SORTIN = &W1;
   %LET T = 0;


   %IF &NODUP NE N %THEN %DO I=2 %TO &N;
      %LET J = %EVAL(&I-1);
      %IF &&W&I NE &&W&J %THEN %LET SORTIN = &SORTIN &&W&I;
      %ELSE %LET T = %EVAL(&T+1);
   %END;
   %ELSE %DO I=2 %TO &N;
      %LET SORTIN = &SORTIN &&W&I;
   %END;

   &SORTIN
%MEND MLSORT3;


