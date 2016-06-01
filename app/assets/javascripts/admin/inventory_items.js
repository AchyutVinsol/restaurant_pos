$(document).ready(function(){
  $('[data-behaviour=change_quantity]').on('ajax:success', function(event, data, status, xhr) {
    // FIXME_AB: handle success and failure. success will hightlight he qty error should display in modal 
    // FIXME_AB: reset text field 
    quantity_display = $(event.target).closest("tr").children("td[data-class=quantity]");
    quantity_display.text(data);
    // FIXME_AB: highlight the updated qty
  });
});
