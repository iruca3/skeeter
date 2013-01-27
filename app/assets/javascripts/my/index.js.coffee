@show_description = (id) ->
  $(".anime_description").hide()
  $("#anime_" + id).show 300

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
  $("#anime_list").dataTable
    sDom: "<'row'<'span5 dt-margin-left'l><'span6 pull-right'f>r>t<'row'<'span5 dt-margin-left'i><'span6 pull-right'p>>"
    sPaginationType: "bootstrap"
    bStateSave: true
    oLanguage:
      sLengthMenu: "一度に表示する件数: _MENU_"
    aoColumnDefs: [
      sType: 'slashed-num'
      aTargets: [ 2 ]
    ]

  $("#episode_list").dataTable
    sDom: "<'row'<'span5 dt-margin-left'l><'span6 pull-right'f>r>t<'row'<'span5 dt-margin-left'i><'span6 pull-right'p>>"
    sPaginationType: "bootstrap"
    bStateSave: true
    oLanguage:
      sLengthMenu: "一度に表示する件数: _MENU_"

  $("#cut_list").dataTable
    sDom: "<'row'<'span5 dt-margin-left'l><'span6 pull-right'f>r>t<'row'<'span5 dt-margin-left'i><'span6 pull-right'p>>"
    sPaginationType: "bootstrap"
    bStateSave: true
    oLanguage:
      sLengthMenu: "一度に表示する件数: _MENU_"

