
App.messages = App.cable.subscriptions.create('MessagesChannel', {
  received: function(data) {
    $(".js-message").val("");



    $("#messages").removeClass('hidden')
    return $('#messages').prepend(this.renderMessage(data));
  },

  renderMessage: function(data) {
    var user = JSON.parse(data.user);
    var message = JSON.parse(data.message);

      return '<div class="panel-body">\
                <div class="container-fluid bubble">\
                  <p class="message name">'+user.first_name+'</p>\
                  <p class="message content">- '+message.content+'</p>\
                  <p class="message created-at">'+message.created_at+'</p>\
                </div>\
              </div>';

  }
});
