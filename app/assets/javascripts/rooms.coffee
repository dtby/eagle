jQuery ->
  $('#alarm-container-switch')
    .on 'click', (evt) ->
      _container = $('#room-alarm-container')
      if _container.css('bottom') == '26px'
        $('#room-alarm-container').animate({
          bottom: '-140px'
        }, 'slow')
      else
        $('#room-alarm-container').animate({
          bottom: '26px'
        }, 'slow')
      $('#alarm-container-switch').toggleClass('glyphicon-menu-up')
