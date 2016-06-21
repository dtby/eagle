jQuery ->

  $("#attachmentModalContent")
    .on 'change', '#attachment_room_id', (evt) ->
      room_id = $(this).children('option:selected').val()
      return if room_id == ''
      $.ajax "/admin/rooms/"+room_id+"/devices",
        type: 'get',
        dataType: 'json',
        success: (data, status) -> 
          selection_content = "<option value='主图'>主图</option>"
          $('#attachment_tag').empty()
          for device in data.devices
            selection_content += '<option value='+device[0]+'>'+device[1]+'</option>'
          $('#attachment_tag').append(selection_content)
          $('#attachment_tag').removeAttr('disabled')

