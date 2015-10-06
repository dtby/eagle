$ ->
  # 页面加载改变checkbox显示样式
  CKboxDisable = Array::slice.call(document.querySelectorAll(".js-switch-disabled"))
  CKboxDisable.forEach (html) ->
    new Switchery(html,
      color: "#1AB394"
      disabled: true
      size: 'small'
    )

$ ->
  CKbox = Array::slice.call(document.querySelectorAll(".js-switch"))
  CKbox.forEach (html) ->
    new Switchery(html,
      color: "#1AB394"
      size: 'small'
    )