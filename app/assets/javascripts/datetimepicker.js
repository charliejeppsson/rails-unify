$( document ).ready(function() {
  $('#datetimepicker1').datetimepicker(format: 'yyyy-mm-dd hh:ii'});
  $('#datetimepicker2').datetimepicker(format: 'yyyy-mm-dd hh:ii'});

  $("#datetimepicker1").on("dp.change", function (e) {
  $('#datetimepicker2').data("DateTimePicker").minDate(e.date);
  });
});
