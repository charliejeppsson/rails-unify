//= require action_cable
//= require_self
//= require_tree .

this.App = {};

App.cable = ActionCable.createConsumer();
