<% if @area.errors.present? %>
  $(".modal-backdrop").remove();
  $("#roomModalContent").html("<%= escape_javascript( render "area_modal", area: @area  )%>");
  $('#roomModal').modal('show');
<% else %>
  location.href = "<%= admin_areas_path %>"
<% end  %>