$(document).ready(function(){
  $('[data-behaviour=change_quantity]').on('ajax:success', function(event, data, status, xhr) {

    if (data.status === "success") {
      quantity_display = $(event.target).closest("tr").children("td[data-class=quantity]");
      quantity_display.text(data.qty);
      quantity_display.effect("highlight", {}, 1500);
    }
    else {
      $moadal = $('<div>').attr('class','modal')
        .append($('<div>').attr('class','modal-dailog')
          .append($('<div>').attr('class','modal-dailog')
            .append($('<div>').attr('class','modal-dbody')
              .append($('<button>')
                .attr('type', 'button')
                .attr('class', 'close')
                .attr('data-dismiss', 'modal')
                .attr('aria-hidden', 'true')
              )
            )
          .append($('<div>').attr('class','modal-dbody')
            .append($('<p>').html(data.errors))
            )
          )
        );
      $(event.target).appent($modal);
      // do stuff like attach 
      // display errors in modal
    }
    $(event.target).siblings('input[type=text]').val("");
  });
});
