@del_confirm = ->
  if confirm("削除します。よろしいですか?")
    true
  else
    false
$(document).ready ->
  $("#episode_member_list").dataTable
    sDom: "<'row'<'span5 dt-margin-left'l><'span6 pull-right'f>r>t<'row'<'span5 dt-margin-left'i><'span6 pull-right'p>>"
    sPaginationType: "bootstrap"
    bStateSave: true
    oLanguage:
      sLengthMenu: "一度に表示する件数: _MENU_"
  $("#frmEditAnime").validate
    errorClass: "error"
    errorElement: "label"
    highlight: (label) ->
      $(label).closest(".control-group").removeClass "success"
      $(label).closest(".control-group").addClass "error"

    success: (label) ->
      $(label).text("OK!").addClass("valid").closest(".control-group").addClass "success"

    rules:
      title:
        required: true

    messages:
      title:
        required: "タイトルを入力してください。"

# DateTime Picker 
$ ->
  $("#inputDeadline").datetimepicker
    showSecond: true
    dateFormat: "yy.mm.dd"
    timeFormat: "HH:mm:ss"


