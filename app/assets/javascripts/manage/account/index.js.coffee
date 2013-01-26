# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# テーブルをソート可能にする。
$(document).ready ->
  $("#enabled_account_list").dataTable
    sDom: "<'row'<'span5 dt-margin-left'l><'span6 pull-right'f>r>t<'row'<'span5 dt-margin-left'i><'span6 pull-right'p>>"
    sPaginationType: "bootstrap"
    bStateSave: true
    oLanguage:
      sLengthMenu: "一度に表示する件数: _MENU_"

  $("#disabled_account_list").dataTable
    sDom: "<'row'<'span5 dt-margin-left'l><'span6 pull-right'f>r>t<'row'<'span5 dt-margin-left'i><'span6 pull-right'p>>"
    sPaginationType: "bootstrap"
    bStateSave: true
    oLanguage:
      sLengthMenu: "一度に表示する件数: _MENU_"



