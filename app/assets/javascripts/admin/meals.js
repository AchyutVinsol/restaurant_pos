$(document).ready(function() {
  $('[data-behaviour=change_meal_status]').on('ajax:success', function(event, data, status, xhr) {
    console.log('Here');
    console.log(data);
    console.log(event.target);
    $button = $(event.target).find("button");
    console.log($button);
    $status = $(event.target).closest('td').prev();
    if (data.status === "success") {
      if (data.active) {
        $status.html('Selling');
        $button.html('Not Selling');
        $button.removeClass('btn-success');
        $button.addClass('btn-danger');
      }
      else {
        $status.html('Not Selling');
        $button.html('Selling');
        $button.removeClass('btn-danger');
        $button.addClass('btn-success');
      }
      $status.effect("highlight", {}, 1500);
    }
    else {
      $modal = $tr.closest('table').siblings('div.modal');
      $para = $modal.find('p[data-class=errorMessages]');
      $para.html(data.errors);
      $($modal).modal('show');
    }
  });
});
