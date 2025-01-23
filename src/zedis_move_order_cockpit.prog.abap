*&---------------------------------------------------------------------*
*& Report zedis_move_order_cockpit
*&---------------------------------------------------------------------*
*&
*======================================================================*
*& Creation Date     : 20.01.2025
*& JIRAnum           : OMSAP-2644
*& JIRA WebLink      : https://decathlon.atlassian.net/browse/OMSAP-2644
*& Developer(Company): Z25CFRUH - Coriolan FRUHAUF (FairShare)
*& Requester         : Z16LDEPR - Loïc DEPREZ
*& Description       : Update règles de déménagement programme SO +
*                      sourcing en ZELOGRETENTION
*======================================================================*
*&---------------------------------------------------------------------*

REPORT zedis_move_order_cockpit.

*Selection screen declaration
"Tables block
SELECTION-SCREEN BEGIN OF BLOCK block_01 WITH FRAME TITLE TEXT-001.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN  PUSHBUTTON /17(79) b_rettab USER-COMMAND ret_table.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN  PUSHBUTTON /17(79)  b_logtab USER-COMMAND log_table.
PARAMETERS p_days TYPE i VISIBLE LENGTH 3 DEFAULT '100' NO-DISPLAY.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN END OF BLOCK block_01.

"Programs block
SELECTION-SCREEN BEGIN OF BLOCK block_02 WITH FRAME TITLE TEXT-002.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN  PUSHBUTTON /17(79) b_stoprg USER-COMMAND sto_prog.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN  PUSHBUTTON /17(79) b_soprg USER-COMMAND so_prog.
SELECTION-SCREEN SKIP.
SELECTION-SCREEN END OF BLOCK block_02.


INITIALIZATION.
  "Buttons labels
  b_rettab   = TEXT-011.
  b_logtab   = TEXT-012.
  b_stoprg   = TEXT-013.
  b_soprg    = TEXT-014.


AT SELECTION-SCREEN.
  CONSTANTS:
    gc_btn_ret_delay_table TYPE sy-ucomm VALUE 'RET_TABLE',
    gc_btn_log_table       TYPE sy-ucomm VALUE 'LOG_TABLE',
    gc_btn_sto_prog        TYPE sy-ucomm VALUE 'STO_PROG',
    gc_btn_so_prog         TYPE sy-ucomm VALUE 'SO_PROG'.

  CASE sy-ucomm.
    WHEN gc_btn_ret_delay_table.
      zcl_move_order_cockpit=>retention_table_maintain( ).

    WHEN gc_btn_log_table.
      "Open a SE16N on table ZEFNR_LOG_ORD_MV
      zcl_move_order_cockpit=>log_table_display( iv_days_from = p_days ).


    WHEN gc_btn_sto_prog.
      "Run program Z_AP_BT_187_BIS for STOs
      zcl_move_order_cockpit=>move_sto_execute( ).

    WHEN gc_btn_so_prog.
      "Run program Z_AP_BT_181 for SOs
      zcl_move_order_cockpit=>move_so_execute( ).

  ENDCASE.
