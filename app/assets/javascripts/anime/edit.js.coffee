@del_confirm = ->
  if confirm("アニメを削除します。よろしいですか?")
    true
  else
    false

# DateTime Picker 
$ ->
  $("#inputDeadline").datetimepicker
    showSecond: true
    dateFormat: "yy.mm.dd"
    timeFormat: "HH:mm:ss"


