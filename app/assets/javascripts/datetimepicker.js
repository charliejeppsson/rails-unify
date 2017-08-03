$( document ).ready(function() {
  $('#datetimepicker1').datetimepicker();
  $('#datetimepicker2').datetimepicker();

  $("#datetimepicker1").on("dp.change", function (e) {
  $('#datetimepicker2').data("DateTimePicker").minDate(e.date);
  });
});
