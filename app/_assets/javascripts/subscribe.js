// Check and submit form data

$(document).ready(function () {
  $("#subscribe-form").submit(function (e) {
    e.preventDefault();

    $.ajax({
      url: "https://go.konghq.com/l/392112/2018-09-04/bh3chb",
      type: "POST",
      dataType: "jsonp",
      crossDomain: true,
      async: false,
      data: jQuery("#subscribe-input").serialize(),
      xhrFields: {
        withCredentials: true
      },
      success: function () {
        $("#subscribe-form").css("display", "none");
        $("#form-response").html("<br>Thank you for signing up!<br><br>");
      },
      error: function (response) {
        if (response.status == "302" || response.status == "200") {
          $("#subscribe-form").css("display", "none");
          $("#form-response").html("<br>Thank you for signing up!<br><br>");
        } else {
          $("#subscribe-form").css("display", "none");
          $("#form-response").html("<br>There was an error. Please try again.<br><br>");
        }
      }
    })
  })
});
