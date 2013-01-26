$(document).ready ->
  $("#frmCreateAccount").validate
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

      password:
        required: true

      password_confirm:
        required: true
        equalTo: "#inputPassword"

    messages:
      login_id:
        required: "ログインIDを入力してください。"

      password:
        required: "パスワードを入力してください。"

      password_confirm:
        required: "パスワード(確認)を入力してください。"
        equalTo: "パスワードが一致しません。"


