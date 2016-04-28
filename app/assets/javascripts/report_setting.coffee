jQuery ->
  $('input[type=submit]').hide()

  $('#all-selected')
    .on 'click', (evt) ->
      items = $("#selection-content").children()
      for item in items
        console.log(item)
        $(item).find('input').attr('checked', 'checked')
      evt.preventDefault()

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
            names = point[1].split('-')
            if names.length > 1
              name = names[1]
            else
              name = names[0]

            if point[2] == 1
              $('#selection-content').append("<label class='point-item'><input name='report_points[#{point[0]}]' checked type='checkbox'/>#{name}</label>")
            else
              $('#selection-content').append("<label class='point-item'><input name='report_points[#{point[0]}]' type='checkbox'/>#{name}</label>")
            $('input[type=submit]').show()
            $('#all-selected').show()
