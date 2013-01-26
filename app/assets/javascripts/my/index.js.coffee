@show_description = (id) ->
  $(".anime_description").hide()
  $("#anime_" + id).show 300

# テーブルをソート可能にする。
$(document).ready ->
  $("#anime_list").dataTable
    sDom: "<'row'<'span5 dt-margin-left'l><'span6 pull-right'f>r>t<'row'<'span5 dt-margin-left'i><'span6 pull-right'p>>"
    sPaginationType: "bootstrap"
    bStateSave: true
    oLanguage:
      sLengthMenu: "一度に表示する件数: _MENU_"

  $("#story_list").dataTable
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

