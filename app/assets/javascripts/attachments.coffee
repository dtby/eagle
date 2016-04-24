jQuery ->

  $("#attachmentModalContent")
    .on 'change', '#attachment_room_id', (evt) ->
      room_id = $(this).children('option:selected').val()
      return if room_id == ''
      $.ajax "/admin/rooms/"+room_id+"/devices",
        type: 'get'
