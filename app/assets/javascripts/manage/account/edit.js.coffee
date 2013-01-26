@del_confirm = ->
  if confirm("アカウントを削除します。よろしいですか?")
    true
  else
    false

$(document).ready ->
  $("#frmEditAccount").validate
    errorClass: "error"
    errorElement: "label"
    highlight: (label) ->
      $(label).closest(".control-group").removeClass "success"
      $(label).closest(".control-group").addClass "error"

    success: (label) ->
      $(label).text("OK!").addClass("valid").closest(".control-group").addClass "success"

    rules:
      login_id:
        required: true

    messages:
      login_id:
        required: "ログインIDを入力してください。"


