$(document).ready(function() {
    $(".panel").each(function() {
      $(this).animate({scrollTop:$(this).find('.messages-wrap').height()}, 300);
   });
});



App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function(data) {
    $(".js-message").val("");
    $(".messages-wrap").removeClass('hidden');
    $('.messages-wrap').append(this.renderMessage(data));

    $(".panel").each(function() {
      $(this).animate({scrollTop:$(this).find('.messages-wrap').height()}, 300);
   });

  },

  renderMessage: function(data) {
    var user = JSON.parse(data.user);
    var message = JSON.parse(data.message);
    var userId = parseInt($('.messages-wrap').attr('data-userid'), 10);

    console.log(userId) // Sender
    console.log(user.id) // Receiver

    if (user.id === data.current_user.id || user.id === userId) {

      if (data.current_user.id === userId) {
        return '<div class="panel-body">\
                  <div class="bubble-right">\
                    <h5 class="message name">'+user.first_name+':</h5>\
                    <p class="message content">- '+message.content+'</p>\
                  </div>\
                </div>';
      } else {
        return '<div class="panel-body">\
                  <div class="bubble-left">\
                    <h5 class="message name">'+user.first_name+':</h5>\
                    <p class="message content">- '+message.content+'</p>\
                  </div>\
                </div>';
      }

    }


  }
});
