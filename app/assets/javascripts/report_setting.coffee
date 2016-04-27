jQuery ->
  $('input[type=submit]').hide()

  $("#report_room_id")
    .on 'change', (evt) ->
      room_id = $(this).children('option:selected').val()
      return if room_id == ''
      $.ajax "/admin/rooms/#{room_id}/devices",
        type: 'get'
        dataType: "json"
        success: (data, textStatus) ->
          $("#device_selection").empty()
          for device in data.devices
            $("#device_selection").append("<li class='device-item' name='#{device[0]}' data='#{device[0]}'>#{device[1]}</li>")

  $("#device_selection")
    .on 'click', ".device-item", (evt) ->
      device_id = $(this).attr('data')
      $('#device_id').val(device_id)
      $("#selection-content").empty()
      $.ajax "/admin/devices/#{device_id}/points",
        type: 'get'
        dataType: 'json'
        success: (data, textStatus) ->
          for point in data.points
            if point[2] == 1
              $('#selection-content').append("<label class='point-item'><input name='report_points[#{point[0]}]' checked type='checkbox'/>#{point[1]}</label>")
            else
              $('#selection-content').append("<label class='point-item'><input name='report_points[#{point[0]}]' type='checkbox'/>#{point[1]}</label>")
            $('input[type=submit]').show()
