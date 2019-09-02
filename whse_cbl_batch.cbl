       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       
       ENVIRONMENT DIVISION.
          INPUT-OUTPUT SECTION.
          FILE-CONTROL.
          SELECT FILEN ASSIGN TO INPUT.
             ORGANIZATION IS SEQUENTIAL.
             ACCESS IS SEQUENTIAL.
       
       DATA DIVISION.
          FILE SECTION.
          FD FILEN
          01 NAME PIC A(25).
          
          WORKING-STORAGE SECTION.
          01 WS-STUDENT PIC A(30).
          01 WS-ID PIC 9(5).
       
          LOCAL-STORAGE SECTION.
          01 LS-CLASS PIC 9(3).
          
          LINKAGE SECTION.
          01 LS-ID PIC 9(5).
          
       PROCEDURE DIVISION.
       
       0000-INITIALIZE-PARA.
       EXEC SQL
        SELECT   RETAIL_SECT,
              RING
        INTO    :X-RETAIL-SECT,
             :X-RING-TYPE
        FROM     TBX  X
        WHERE    X.ROG            = :X-ROG
           AND   X.CORP_ITEM_CD   = :X-CORP-ITEM-CD
           AND   X.UPC_COUNTRY    = 0
           AND   X.UPC_SYSTEM     = 4
       ORDER BY PRIMARY_UPC_SW DESC
       FETCH FIRST ROW ONLY
       QUERYNO 3676
       END-EXEC.
       
       EXEC SQL
         UPDATE   X
            SET
                     PRIMARY_UPC_SW=:X-PRIMARY-UPC-SW,
                     PACK_RETAIL=:X-PACK-RETAIL,
                     LABEL_SIZE=:X-LABEL-SIZE,
                     LABEL_NUMBERS=:X-LABEL-NUMBERS,
                     PRT_SIGN_IND=:X-PRT-SIGN-IND,
                     ITEM_SELECTION=:X-ITEM-SELECTION,
                     RING=:X-RING
            WHERE   (ROG = :X-ROG
               AND   CORP_ITEM_CD = :X-CORP-ITEM-CD
               AND   UPC_MANUF = :X-UPC-MANUF
               AND   UPC_SALES = :X-UPC-SALES
               AND   UPC_COUNTRY = :X-UPC-COUNTRY
               AND   UPC_SYSTEM = :X-UPC-SYSTEM
               AND   UNIT_TYPE = :X-UNIT-TYPE)
            QUERYNO 35
       END-EXEC.
      
       EXEC SQL
         SELECT   STATUS_RUPC
            INTO    :X-STATUS-RUPC
            FROM     X
            WHERE   (ROG = :X-ROG
               AND   CORP_ITEM_CD = :X-CORP-ITEM-CD
               AND   STATUS_RUPC ¬= 'D'
               AND   STATUS_RUPC ¬= 'X')
            FETCH FIRST ROW ONLY
            QUERYNO 29
       END-EXEC.
      

       EXEC SQL
        FETCH    COPYUPC_SSCOUPON
            INTO    :CPN_ROG,
                    :CPN_CPN_ADJ_IND
       END-EXEC. 
      
       EXEC SQL
        DECLARE  FOODSTMP_S CURSOR FOR       
            SELECT   DISTINCT FD_STMP                  
            FROM     TABX X,                    
                     TABS S                      
            WHERE X.ROG          = :X-ROG        
              AND X.CORP_ITEM_CD = :MEX7-CORP-ITEM-CD
              AND X.UNIT_TYPE    = :JUI-UNIT-TYPE   
              AND X.STATUS_RUPC ¬= 'X'             
              AND X.ROG           = S.ROG        
              AND X.UNIT_TYPE    = S.UNIT_TYPE 
              AND X.UPC_MANUF    = S.UPC_MANUF
              AND X.UPC_SALES    = S.UPC_SALES
              AND X.UPC_COUNTRY  = S.UPC_COUNTRY
              AND X.UPC_SYSTEM   = S.UPC_SYSTEM
            QUERYNO 43        
       END-EXEC. 
      
       EXEC SQL
        OPEN READNEXT       
       END-EXEC.
       EXEC SQL
        CLOSE READNEXT    
       END-EXEC.
       EXEC SQL
         SELECT   USERID
            INTO    RTL_USERID
            FROM     MERT RTL,
            CORO RGT
            WHERE     RTL.PA_ROG     = RGT.ROG
            AND     RTL.USERID     = :XF-USERID
            AND     RTL.TYPE       = 'R'
            AND     RGT.COUNTRY_CD = :PRX-COUNTRY-CD
            AND (RGT.ROG =
            CASE WHEN :WRG-WRG01 <> ' '
            THEN :WRG-WRG01
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG02 <> ' '
            THEN :WRG-WRG02
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG03 <> ' '
            THEN :WRG-WRG03
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG04 <> ' '
            THEN :WRG-WRG04
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG05 <> ' '
            THEN :WRG-WRG05
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG06 <> ' '
            THEN :WRG-WRG06
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG07 <> ' '
            THEN :WRG-WRG07
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG08 <> ' '
            THEN :WRG-WRG08
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG09 <> ' '
            THEN :WRG-WRG09
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG10 <> ' '
            THEN :WRG-WRG10
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG11 <> ' '
            THEN :WRG-WRG11
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG12 <> ' '
            THEN :WRG-WRG12
            ELSE '    '
            END
            OR  RGT.ROG =
            CASE WHEN :WRG-WRG01 =  '    '
            AND :WRG-WRG02 =  '    '
            AND :WRG-WRG03 =  '    '
            AND :WRG-WRG04 =  '    '
            AND :WRG-WRG05 =  '    '
            AND :WRG-WRG06 =  '    '
            AND :WRG-WRG07 =  '    '
            AND :WRG-WRG08 =  '    '
            AND :WRG-WRG09 =  '    '
            AND :WRG-WRG10 =  '    '
            AND :WRG-WRG11 =  '    '
            AND :WRG-WRG12 =  '    '
            THEN RTL.PA_ROG
            END)
            FETCH FIRST ROW ONLY
            QUERYNO 39
       END-EXEC.
       
      EXEC SQL
        DELETE
                FROM  COUPON
                WHERE ROG         = :X-ROG
                AND UPC_MANUF   = :HV-UPC-MANUF
                AND UPC_SALES   = :HV-UPC-SALES
                AND UPC_COUNTRY = :HV-UPC-COUNTRY
                AND UPC_SYSTEM  = :HV-UPC-SYSTEM
                AND POS_PROCESSED_IND IN (' ', 'F')
                AND PACS_ADPL_SEQ_NUM IN
                (SELECT PACS_ADPL_SEQ_NUM
                FROM   PENDING
                WHERE  ROG = :X-ROG
                AND  CORP_ITEM_CD = :MEX7-CORP-ITEM-CD
                AND  UNIT_TYPE    = :HV-UNIT-TYPE
                AND  AD_SELECT    = :HV-AD-SELECT)
                QUERYNO  74

       END-EXEC.
      
       EXEC SQL
        SELECT  COALESCE(COUNT(*),0)
            INTO    :HV-UPCCNT
            FROM    RF X
            WHERE   CORP_ITEM_CD = :X-CORP-ITEM-CD
              AND NOT EXISTS(SELECT 1
                       FROM  SC C
                       WHERE C.CORP      = :HV-CORP
                         AND C.UPC_MANUF   = X.UPC_MANUF
                         AND C.UPC_SALES   = X.UPC_SALES
                         AND C.UPC_COUNTRY = X.UPC_COUNTRY
                         AND C.UPC_SYSTEM  = X.UPC_SYSTEM)
          QUERYNO 17   
       END-EXEC.
       
      DISPLAY 'Executing COBOL program using JCL'.
       STOP RUN.
