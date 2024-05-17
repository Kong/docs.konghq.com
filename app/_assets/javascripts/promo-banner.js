jQuery(document).ready(function () {
  var closed = localStorage.getItem("closebanner-summit-2023");
  if (closed !== "closebanner") {
    $(".navbar-v2").removeClass("closed");
    $("body").addClass("banner");
    $("#mosaic-provider-react-aria-0-1").addClass("banner-offset");
  } else {
    $(".navbar-v2").addClass("closed");
    $("body").removeClass("banner");
    $("#mosaic-provider-react-aria-0-1").removeClass("banner-offset");
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
  localStorage.setItem("closebanner-summit-2023", "closebanner");
  $("#mosaic-provider-react-aria-0-1").removeClass("banner-offset");
});
