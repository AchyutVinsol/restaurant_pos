$(document).ready(function(){
  $('[data-behaviour~=change_quantity]').on('ajax:success', function(event, data, status, xhr) {
    quantity_display = $(event.target).closest("tr").children("td[data-class=quantity]");
    quantity_display.text(data);
  });
});
