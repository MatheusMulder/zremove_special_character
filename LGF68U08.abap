FUNCTION zremove_special_character .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(TEXT1)
*"     REFERENCE(I_CONDENSE) TYPE  XFELD OPTIONAL
*"     REFERENCE(I_CONV_UPPER) TYPE  XFELD DEFAULT 'X'
*"     REFERENCE(I_DESCONS_CHARS) TYPE  CHAR35 OPTIONAL
*"     REFERENCE(I_CONSID_ACENTO) TYPE  XFELD DEFAULT 'X'
*"  EXPORTING
*"     REFERENCE(CORR_STRING)
*"----------------------------------------------------------------------

  "Variáveis locais ****************************************************
  DATA:
    l_chk_cr_lf    TYPE char01,                             "1000035916
    l_chk_str(51)  TYPE c,
    "VALUE '*–-+''!$?#%()º°=?¿¡}><[]{ª\/"_@&•.´`µ??',
    l_chk_stra(10) TYPE c,
    "VALUE 'ÄäÀàÂâÃãÁá',               "#EC *
    l_chk_strc(2)  TYPE c,
    "VALUE 'Çç',                   "#EC * "1309426
    l_chk_stre(8)  TYPE c,
    "VALUE 'ËëÈèÊêÉé',                 "#EC *
    l_chk_stri(8)  TYPE c,
    "VALUE 'ÏïÌìÎîÍí',                 "#EC *
    l_chk_stro(10) TYPE c,
    "VALUE 'ÖöÒòÔôÕõóÓ',               "#EC *
    l_chk_stru(8)  TYPE c,
    "VALUE 'ÜüÙùÛûÚú',                 "#EC *
    l_chk_strn(2)  TYPE c,
    "VALUE 'Ññ',                       "#EC *
    l_chk_strf(2)  TYPE c,
    "VALUE 'ƒƒ',                       "#EC *
    l_chk_std(62)  TYPE c,
    "VALUE 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789', "#EC *

    lt_char        TYPE TABLE OF c,
    l_hex          TYPE xstring,
    l_idx          TYPE i,
    l_str1(1000)   TYPE c,
    l_lnth         TYPE i,
    l_lnth1        TYPE i.                                  "1309426

  "Constantes locais ***************************************************
  CONSTANTS: lc_a0(2) VALUE 'A0',
             lc_2e(2) VALUE '2E',
             lc_0a(2) VALUE '0A',
             lc_fd(2) VALUE 'FD',
             lc_26(2) VALUE '26'.                           "1000043137

  l_chk_cr_lf = cl_abap_char_utilities=>cr_lf.              "1000035916
  l_chk_str   = text-001.                                   "1000035916
  l_chk_stra  = text-002.                                   "1000035916
  l_chk_strc  = text-003.                                   "1000035916
  l_chk_stre  = text-004.                                   "1000035916
  l_chk_stri  = text-005.                                   "1000035916
  l_chk_stro  = text-006.                                   "1000035916
  l_chk_stru  = text-007.                                   "1000035916
  l_chk_strn  = text-008.                                   "1000035916
  l_chk_strf  = text-009.                                   "1000035916
  l_chk_std   = text-010.                                   "1000035916

  l_str1 = text1.
  l_lnth = strlen( l_str1 ).
  l_lnth1 = l_lnth + 1.                                     "1309426

  DO l_lnth TIMES.

    IF l_lnth1 EQ sy-index.                                 "1309426
      EXIT.
    ENDIF.
    l_idx = sy-index - 1.

    IF i_descons_chars IS NOT INITIAL.
      IF l_str1+l_idx(1) CA i_descons_chars.
        CONTINUE.
      ENDIF.
    ENDIF.

    IF l_str1+l_idx(1) CA l_chk_stra AND
       i_consid_acento IS NOT INITIAL.
      l_str1+l_idx(1) = 'A'.
    ELSEIF l_str1+l_idx(1) CA l_chk_strc AND
           i_consid_acento IS NOT INITIAL.                  "1309426
      l_str1+l_idx(1) = 'C'.                                "1309426
    ELSEIF l_str1+l_idx(1) CA l_chk_stre AND
           i_consid_acento IS NOT INITIAL.
      l_str1+l_idx(1) = 'E'.
    ELSEIF l_str1+l_idx(1) CA l_chk_stri AND
           i_consid_acento IS NOT INITIAL.
      l_str1+l_idx(1) = 'I'.
    ELSEIF l_str1+l_idx(1) CA l_chk_stro AND
           i_consid_acento IS NOT INITIAL.
      l_str1+l_idx(1) = 'O'.
    ELSEIF l_str1+l_idx(1) CA l_chk_stru AND
           i_consid_acento IS NOT INITIAL.
      l_str1+l_idx(1) = 'U'.
    ELSEIF l_str1+l_idx(1) CA l_chk_strn.                   "1469494
      l_str1+l_idx(1) = 'N'.                                "1469494
    ELSEIF l_str1+l_idx(1) CA l_chk_strf.
      l_str1+l_idx(1) = 'F'.
    ELSEIF l_str1+l_idx(1) CA l_chk_str.
      l_str1+l_idx(1) = ' '.
    ELSEIF l_str1+l_idx(1) CA l_chk_cr_lf.                  "1000035916
      l_str1+l_idx(1) = ' '.                                "1000035916
    ELSEIF NOT l_str1+l_idx(1) CA l_chk_std.
      " Remove caracteres especiais "ocultos"
      CLEAR: lt_char, l_hex.
      APPEND l_str1+l_idx(1) TO lt_char.
      CALL FUNCTION 'SCMS_BINARY_TO_XSTRING'
        EXPORTING
          input_length = 1
        IMPORTING
          buffer       = l_hex
        TABLES
          binary_tab   = lt_char
        EXCEPTIONS
          failed       = 1
          OTHERS       = 2.
      IF sy-subrc EQ 0 AND
        ( l_hex EQ lc_a0 OR
          l_hex EQ lc_2e OR
          l_hex EQ lc_0a OR
          l_hex EQ lc_fd OR
          l_hex EQ lc_26 ).                                 "1000043137
        l_str1+l_idx(1) = ' '.
      ENDIF.
    ENDIF.

  ENDDO.

  IF i_conv_upper NE space.
    TRANSLATE l_str1 TO UPPER CASE.
  ENDIF.

  IF i_condense EQ 'X'.
    CONDENSE l_str1 NO-GAPS.
  ENDIF.

  corr_string = l_str1.

ENDFUNCTION.