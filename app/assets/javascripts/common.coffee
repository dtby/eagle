$ ->
  # 页面加载改变checkbox显示样式
  elems = Array::slice.call(document.querySelectorAll(".js-switch"))
  elems.forEach (html) ->
    switchery = new Switchery(html,
      color: "#1AB394"
      disabled: "true"
    )

