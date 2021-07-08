// Check and submit form data
$("#subscribe-form").submit(function(e){
  e.preventDefault();

  $.ajax({
    url: 'https://go.konghq.com/l/392112/2018-09-04/bh3chb',
    type: "POST",
    dataType: "jsonp",
    crossDomain: true,
    async: false,
    data: jQuery("#subscribe-input").serialize(),
    xhrFields: {
      withCredentials: true,
    },
    statusCode: {
      302: function () {
        $("#subscribe-form").css("display", "none");
        $("#form-response").html("<br>Thank you for signing up!<br>");
      }
    },
    success: function () {
      $("#subscribe-form").css("display", "none");
      $("#form-response").html("<br>Thank you for signing up!<br>");
    },
    error: function () {
      $("#subscribe-form").css("display", "none");
      $("#form-response").html("<br>There was an error. Please try again.<br><br>");
    }
  })
});