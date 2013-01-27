# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery.fn.dataTableExt.oSort["slashed-num-asc"] = (x, y) ->
  x = x.split("/")
  y = y.split("/")
  return parseInt(x[1]) - parseInt(y[1])  if x[0] is y[0]
  parseInt(x[0]) - parseInt(y[0])

jQuery.fn.dataTableExt.oSort["slashed-num-desc"] = (x, y) ->
  x = x.split("/")
  y = y.split("/")
  return parseInt(y[1]) - parseInt(x[1])  if y[0] is x[0]
  parseInt(y[0]) - parseInt(x[0])

# テーブルをソート可能にする。
$(document).ready ->
  $("#enabled_anime_list").dataTable
    sDom: "<'row'<'span5 dt-margin-left'l><'span6 pull-right'f>r>t<'row'<'span5 dt-margin-left'i><'span6 pull-right'p>>"
    sPaginationType: "bootstrap"
    bStateSave: true
    oLanguage:
      sLengthMenu: "一度に表示する件数: _MENU_"
    aoColumnDefs: [
      sType: 'slashed-num'
      aTargets: [ 2 ]
    ]

  $("#finished_anime_list").dataTable
    sDom: "<'row'<'span5 dt-margin-left'l><'span6 pull-right'f>r>t<'row'<'span5 dt-margin-left'i><'span6 pull-right'p>>"
    sPaginationType: "bootstrap"
    bStateSave: true
    oLanguage:
      sLengthMenu: "一度に表示する件数: _MENU_"
    aoColumnDefs: [
      sType: 'slashed-num'
      aTargets: [ 2 ]
    ]

  $("#frozen_anime_list").dataTable
    sDom: "<'row'<'span5 dt-margin-left'l><'span6 pull-right'f>r>t<'row'<'span5 dt-margin-left'i><'span6 pull-right'p>>"
    sPaginationType: "bootstrap"
    bStateSave: true
    oLanguage:
      sLengthMenu: "一度に表示する件数: _MENU_"
    aoColumnDefs: [
      sType: 'slashed-num'
      aTargets: [ 2 ]
    ]



