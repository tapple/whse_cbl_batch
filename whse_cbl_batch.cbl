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

