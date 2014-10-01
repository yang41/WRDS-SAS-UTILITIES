OPTIONS SASAUTOS=('/wrds/wrdsmacros/', SASAUTOS) MAUTOSOURCE SOURCE NOCENTER LS=80 PS=MAX;
%INCLUDE "~/UTILITIES/UTILITIES.GENERAL.sas";


LIBNAME HOME "/scratch/uvanl";

LIBNAME BS "/wrds/bvd/sasdata/bs";

PROC CONTENTS
    DATA = BS.BS_BANK
    VARNUM
    DETAILS;
RUN;

PROC CONTENTS
    DATA = BS.BS_FINANCIALS
    VARNUM
    DETAILS;
RUN;

PROC FREQ
    DATA = BS.BS_BANK (KEEP = STATUS ENTITYTYPE DATA9427 CONSOL SOURCES FORMAT MODELID SPECIAL);
RUN;

PROC SQL;
    CREATE TABLE CAPRAT AS
        SELECT INDEX, AVG(DATA30690) AS CAP1, MIN(CLOSDATE) AS FDATE FORMAT DATE., MAX(CLOSDATE) AS CDATE FORMAT DATE.
        FROM BS.BS_FINANCIALS 
        /* WHERE '01JAN2008'd <= CLOSDATE <= '01JAN2010'd  */
        GROUP BY INDEX
        HAVING AVG(DATA30690) IS NOT NULL;
    
    CREATE TABLE RESULT AS
        SELECT  A.NAME, A.INDEX, A.CTRYCODE, A.SD_DELISTED_DATE FORMAT DATE., A.STATUS, A.SCP_INACTIVITY_DATE, B.*
        FROM
        BS.BS_BANK AS A,
        CAPRAT AS B

        WHERE
        A.INDEX = B.INDEX AND
        UPPER(A.STATUS) IN ('ACTIVE (RECEIVERSHIP)','BANKRUPTCY','DISSOLVED','DISSOLVED (MERGER)','IN LIQUIDATION');              

RUN;    
QUIT;


PROC PRINT DATA=RESULT(OBS = 10); RUN;
PROC CONTENTS DATA=RESULT; RUN;
PROC FREQ DATA=RESULT(KEEP = CTRYCODE STATUS);RUN;
PROC MEANS DATA=RESULT; CLASS CTRYCODE; RUN;    