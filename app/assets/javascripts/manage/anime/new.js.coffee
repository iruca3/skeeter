$(document).ready ->
  $("#frmCreateAnime").validate
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


