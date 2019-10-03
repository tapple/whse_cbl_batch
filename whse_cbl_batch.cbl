       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLO.
       
       ENVIRONMENT DIVISION.
          INPUT-OUTPUT SECTION.
          FILE-CONTROL.
          SELECT FILEN ASSIGN TO INFILE.
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
       
      DISPLAY 'Executing COBOL program using JCL'.
      STOP RUN.
