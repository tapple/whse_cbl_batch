       IDENTIFICATION DIVISION.
       PROGRAM-ID.    WHSE_CBL_BATCH.
      *SECURITY.      OPERACTION, REVISION, AND DISTRIBUTION
      *            OF THIS PROGRAM BY WRITTEN AUTHORIZATION
      *            OF THE ABOVE INSTALLACTION ONLY.
      *DATE-WRITTEN.  06/09/18.
      *DATE-COMPLETED.
      **************************CC109**********************************
       ENVIRONMENT DIVISION.
       CONFIGURATION SECTION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
        SELECT INFILE ASSIGN TO INFILE
            FILE STATUS IS FL-STAT-INP.
        SELECT OUT ASSIGN TO OUT
            FILE STATUS IS FL-STAT-OUT.
       DATA DIVISION.
       FILE SECTION.

       FD INFILE
          LABEL RECORDS ARE STANDARD
          RECORDING MODE IS F
          BLOCK CONTAINS 0 CHARACTERS.
       01 INPUT-RECORD.
          03 INPUT-LAYOUT                PIC X(32).

       FD OUT
          LABEL RECORDS ARE STANDARD
          RECORDING MODE IS F
          BLOCK CONTAINS 0 CHARACTERS.
       01 INPUT-RECORD.
          03 INPUT-LAYOUT                PIC X(32).

       WORKING-STORAGE SECTION.
       01   PROGRAM-WORK-AREA.
        03 D-WHEN-COMPILED           PIC X(8)BBX(8)     VALUE SPACES.
        03 DUMP-CODE                 PIC S9(9) COMP     VALUE ZERO.
       01 SWITCHES.
          03 INP-EOF-SW              PIC    X   VALUE 'N'.

       01 FILE-STATUS.
          03 FL-STAT-INP                 PIC X(2)   VALUE SPACES
          03 FL-STAT-OUT                 PIC X(2)   VALUE SPACES.

       01 COUNTRIES.
          03 ITEM-RECDS-READ             PIC S9(9)  COMP-3 CALUE ZERO.
          03 OUTPUT-RECDS-WRITTEN        PIC S9(9)  COMP-3 CALUE ZERO.
          03 ITEM-RECDS-UPDATED      PIC S9(9)  COMP-3 CALUE ZERO.
          03 ITEM-RECDS-INSERTED         PIC S9(9)  COMP-3 CALUE ZERO.

       01 SAMPLE-TABLE-DATA.
          03 ITEM-NUM                   PIC X(10).
          03 STORAGE-LOC                PIC X(10)
          03 MOV-STATUS             PIC X(10).
       PROCEDURE DIVISION.

       0000-INITIALIZE-PARA.

          MOVE WHEN-COMPILED TO D-WHEN-COMPILED.
          DISPLAY 'SAMPLE COMPLIED ON : ' D-WHEN-COMPILED.
          OPEN INPUT INFILE.
          IF FL-STAT-INP NOT = 00
          DISPLAY 'OPEN INPUT FILE ERROR - STAT :' FL-STAT-INP
          MOVE  +10                   TO DUMP-CODE
          CALL 'CEE3ABD' USING DUMP-CODE
        END-IF.

        OPEN OUTPUT OUT.
        IF FL-STAT-OUT NOT = 00
          DISPLAY 'OPEN OUTPUT FILE ERROR - STAT :' FL-STAT-OUT
          MOVE  +20                    TO DUMP-CODE
          CALL 'CEE3ABD' USING DUMP-CODE
        END-IF.

        PERFORM 1000-READ-INPUT UNTIL INP-EOF-SW = 'Y'.
        PERFORM 6000-FINAL-COUNT.
        GOBACK.

      ******************************************************************
      * READ INPUT RECORD.                                             *
      ******************************************************************
       1000-READ-INPUT.
        READ INFILE
            AT END MOVE 'Y'     TO INP-EOF-SW.
        IF INP-EOF-SW = 'N'
            ADD +1 TO ITEM-RECDS-READ
            PERFORM 2000-PROCESS-INPUT
            END-IF.
      ******************************************************************
      * FORMAT INPUT RECORDS                                           *
      ******************************************************************
       2000-PROCESS-INPUT.

        INITIALIZE OUTPUT-RECORD.
        MOVE INPUT-RECORD TO  OUTPUT-RECORD.
        INSPECT OUTPUT-RECORD REPLACING
            ALL 'PENDING  ' BY 'COMPLETED'.
        UNSTRING OUTPUT-RECORD DELIMITED BY ','
                INTO ITEM-NUM , STORAGE-LOC , MOV-STATUS
        END-UNSTRING.
        PERFORM 3000-UPDATE-TABLE.
        PERFORM 5000-WRITE-OUTPUT.
      ******************************************************************
      * TABLE UPDATE                                                   *
      ******************************************************************
       3000-UPDATE-TABLE.

        EXEC SQL
             UPDATE STORELOC_TABLE
                SET ITEM_NUM        =
                            :SAMPLE-TABLE-DATA.ITEM-NUM,
                    STORAGE_LOC      =
                            :SAMPLE-TABLE-DATA.STORAGE-LOC,
                    MOVE_STATUS     =
                            :SAMPLE-TABLE-DATA.MOVE-STATUS
                WHERE ITEM_NUM        = :SAMPLE-TABLE-DATA.ITEM-NUM
                    AND STORAGE_LOC   = :SAMPLE-TABLE-DATA.STORAGE-LOC
        END-EXEC.

        EVALUATE SQLCODE
            WHEN 0
                ADD 1 TO ITEM-RECDS-UPDATED
            WHEN +100
                PERFORM 4000-INSERT-TABLE
            WHEN OTHER
                DISPLAY '3000-UPDATE-TABLE'
                DISPLAY 'ERROR ON UPDATE '
                DISPLAY 'ITEM_NUM : '   ITEM-NUM OF
                                        SAMPLE-TABLE-DATA
                DISPLAY 'STORAGE-LOC : ' STORAGE-LOC OF
                                        SAMPLE-TABLE-DATA
        END-EVALUATE.

      ******************************************************************
      * TABLE INSERT                                                   *
      ******************************************************************
       4000-INSERT-TABLE.

       EXEC SQL
        INSERT INTO STORELOC_TABLE
                (ITEM_NUM
                ,STORAGE_LOC
                ,MOV_STATUS)
        VALUES
            (:SAMPLE-TABLE-DATA.ITEM-NUM
            ,:SAMPLE-TABLE-DATA.STORAGE-LOC
            ,:SAMPLE-TABLE-DATA.MOVE-STATUS)

       END-EXEC.

       EVALUATE SQLCODE
        WHEN 0
            ADD 1 TO ITEM-RECDS-INSERTED
        WHEN OTHER
            DISPLAY '4000-INSERT-TABLE'
            DISPLAY 'ERROR ON INSERT '
            DISPLAY 'ITEM_NUM : '       ITEM-NUM OF
                                    SAMPLE-TABLE-DATA
            DISPLAY 'ITEM_NUM : '       STORAGE-LOC OF
                                    SAMPLE-TABLE-DATA
        END-EVALUATE.

      ******************************************************************
      *WRITE OUTPUT RECORD.                                            *
      ******************************************************************
       5000-WRITE-OUTPUT.

        WRITE OUTPUT-RECORD.
        ADD +1                      TO OUTPUT-RECDS-WRITTEN.
      ******************************************************************
      * FINAL DISPLAY OF COUNTS                                        *
      ******************************************************************
       6000-FINAL-COUNT.

        CLOSE INFILE
              OUT.
        DISPLAY "-----------------------------------------------------".
        DISPLAY "*** SAMPLE - READ,WRITE,UPDATE,INSERT  OUNTS      ***".
        DISPLAY "-----------------------------------------------------".
        DISPLAY 'INPUT      RECDS READ          ' ITEM-RECDS-READ.
        DISPLAY 'OUTPUT     RECDS WRITTEN       ' OUTPUT-RECDS-WRITTEN.
        DISPLAY 'RECORDS    UPDATED IN DB       ' ITEM-RECDS-UPDATED.
        DISPLAY 'RECORDS    UPDATED IN DB       ' ITEM-RECDS-INSERTED.
        DISPLAY "-----------------------------------------------------".

