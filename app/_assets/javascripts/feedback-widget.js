// feedback widget
function sendFeedback(result, comment = "") {
  $.ajax({
    type: "POST",
    url:
      "https://script.google.com/macros/s/AKfycbzA9EgTcX2aEcfHoChlTNA-MKX75DAOt4gtwx9WMcuMBNHHAQ4/exec",
    data: JSON.stringify([result, comment, window.location.pathname]),
  });

  $(".feedback-thankyou").css("visibility", "visible");
  setTimeout(() => {
    $("#feedback-widget-checkbox").prop("checked", false);
  }, 2000);
}

$("#feedback-comment-button-back").on("click", function () {
  $(".feedback-options").css("visibility", "visible");
  $(".feedback-comment").css("visibility", "hidden");
});

$("#feedback-comment-button-submit").on("click", function () {
  $(".feedback-comment").css("visibility", "hidden");
  sendFeedback("no", $("#feedback-comment-text").val());
});

$(".feedback-options-button").on("click", function () {
  const button = $(this);
  const result = button.data("feedback-result");

  $(".feedback-options").css("visibility", "hidden");
  if (result === "yes") {
    sendFeedback("yes");
  } else {
    $(".feedback-comment").css("visibility", "visible");
  }
});
  