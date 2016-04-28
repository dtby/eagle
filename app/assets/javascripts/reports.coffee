jQuery ->

  $("#report_device")
    .on 'change', (evt) ->
      device_id = $(this).children('option:selected').val()
      return if device_id == ''
      $.ajax "/devices/#{device_id}/points",
        type: 'get'
        dataType: "json"
        success: (data, textStatus) ->
          $("#report-device-points").empty()
          for point in data.points
            names = point[1].split('-')
            if names.length > 1
              name = names[1]
            else
              name = names[0]
            $("#report-device-points").append("<label class='btn btn-primary'><input name='points[#{point[0]}]' data='#{point[0]}' type='checkbox' autocomplete='off'>#{name}</label>")
