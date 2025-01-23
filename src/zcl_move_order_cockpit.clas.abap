CLASS zcl_move_order_cockpit DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

*======================================================================*
*& Creation Date     : 20.01.2025
*& JIRAnum           : OMSAP-2644
*& JIRA WebLink      : https://decathlon.atlassian.net/browse/OMSAP-2644
*& Developer(Company): Z25CFRUH - Coriolan FRUHAUF (FairShare)
*& Requester         : Z16LDEPR - Loïc DEPREZ
*& Description       : Update règles de déménagement programme SO +
*                      sourcing en ZELOGRETENTION
*======================================================================*

  PUBLIC SECTION.
    CLASS-METHODS retention_table_maintain.
    CLASS-METHODS log_table_display
      IMPORTING iv_days_from TYPE i.
    CLASS-METHODS move_sto_execute.
    CLASS-METHODS move_so_execute.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_move_order_cockpit IMPLEMENTATION.
  METHOD retention_table_maintain.
    "Open an SM30 on table ZELOG_RETENTION
    DATA : lv_maint_view_mode_update   TYPE char01 VALUE 'U',
           lv_maintenance_view_tabname TYPE dd02v-tabname VALUE 'ZELOG_RETENTION'.

    CALL FUNCTION 'VIEW_MAINTENANCE_CALL'
      EXPORTING
        action                       = lv_maint_view_mode_update
        view_name                    = lv_maintenance_view_tabname
      EXCEPTIONS
        client_reference             = 1
        foreign_lock                 = 2
        invalid_action               = 3
        no_clientindependent_auth    = 4
        no_database_function         = 5
        no_editor_function           = 6
        no_show_auth                 = 7
        no_tvdir_entry               = 8
        no_upd_auth                  = 9
        only_show_allowed            = 10
        system_failure               = 11
        unknown_field_in_dba_sellist = 12
        view_not_found               = 13
        maintenance_prohibited       = 14
        OTHERS                       = 15.
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDMETHOD.


  METHOD log_table_display.

**********************************************************************
*Uncomment the code below to display directly the ZEFNR_LOG_ORD_MV content for the requested time slot

*    DATA: lt_seltab              TYPE STANDARD TABLE OF se16n_seltab,
*          lv_selection_date_from TYPE sy-datum.
*
*    lv_selection_date_from =  sy-datum - iv_days_from.
*
*    lt_seltab = VALUE #(
*                         (
*                            field  = 'ERDAT'
*                            low    = lv_selection_date_from
*                            high   = sy-datum
*                         )
*                       ).

*    CALL FUNCTION 'SE16N_EXTERNAL_CALL'
*      EXPORTING
*        i_tab     = 'ZEFNR_LOG_ORD_MV'
**       i_variant =
**       i_hana_active       =
**       i_dbcon   =
**       i_ojkey   =
**       i_max_lines         = 5000
**       i_gui_title         =
**       i_fcat_structure    =
**       i_layout_group      =
**       i_no_layouts        =
**       i_display_all       = ' '
**       i_temperature       = space
**       i_temperature_cold  = space
**       i_session_control   =
*        i_edit    = abap_false
**       i_no_convexit       = ' '
**       i_checkkey          = ' '
**       i_formula_name      = space
*      TABLES
*        it_seltab = lt_seltab
**       it_sum_up_fields    =
**       it_group_by_fields  =
**       it_order_by_fields  =
**       it_aggregate_fields =
**       it_toplow_fields    =
**       it_sortorder_fields =
**       it_callback_events  =
**       it_output_fields    =
**       it_having_fields    =
*      EXCEPTIONS
*        no_values = 1
*        OTHERS    = 2.
*    IF sy-subrc <> 0.
*      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*    ENDIF.

**********************************************************************
*Call SE16N transaction with table name ZEFNR_LOG_ORD_MV filled but no other filter
    SET PARAMETER ID 'DTB' FIELD 'ZEFNR_LOG_ORD_MV'.
    CALL TRANSACTION 'SE16N' AND SKIP FIRST SCREEN.

  ENDMETHOD.


  METHOD move_sto_execute.
    SUBMIT z_ap_bt_187_bis VIA SELECTION-SCREEN AND RETURN.
  ENDMETHOD.


  METHOD move_so_execute.
    SUBMIT z_ap_bt_181 VIA SELECTION-SCREEN AND RETURN.
  ENDMETHOD.

ENDCLASS.
