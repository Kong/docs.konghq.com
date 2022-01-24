jQuery(function () {
  var closed = localStorage.getItem("closebanner-webinar-020822");
  if (
    closed !== "closebanner"
  ) {
    $(".navbar-v2").removeClass("closed");
    $("body").addClass("banner");
  } else {
    $(".navbar-v2").addClass("closed");
    $("body").removeClass("banner");
  }
});
var scrolling = false;
$(document).on("scroll", function () {
  scrolling = true;
});
setInterval(function () {
  if (scrolling) {
    scrolling = false;
    if ($(document).scrollTop() < 85) {
      $(".navbar-v2").removeClass("compress");
    } else {
      $(".navbar-v2").addClass("compress");
    }
  }
}, 10);
$(".closebanner").on("click", function () {
  $(".navbar-v2").addClass("closed");
  localStorage.setItem("closebanner-webinar-020822", "closebanner");
});
