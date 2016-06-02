$(document).ready(function() {
  $('[data-behaviour=change_quantity]').on('ajax:success', function(event, data, status, xhr) {
    $tr = $(event.target).closest("tr");
    quantity_display = $tr.children("td[data-class=quantity]");
    if ((data.status === "success") && quantity_display.text() != data.qty) {
      quantity_display.text(data.qty);
      quantity_display.effect("highlight", {}, 1500);
      $(event.target).find('input[type=text]').val("");
    }
    else {
      $modal = $tr.closest('table').siblings('div.modal');
      $para = $modal.find('p[data-class=errorMessages]');
      $para.html(data.errors);
      $($modal).modal('show');
    }
  });
});