
App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function(data) {
    $(".js-message").val("");



    $("#messages").removeClass('hidden')
    return $('#messages').prepend(this.renderMessage(data));
  },

  renderMessage: function(data) {
    var user = JSON.parse(data.user);
    var message = JSON.parse(data.message);
    var userId = $('#messages').attr('user_id')
    console.log(userId) // Sender
    console.log(user.id) // Receiver

    if (data.current_user.id == userId) {
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
});
