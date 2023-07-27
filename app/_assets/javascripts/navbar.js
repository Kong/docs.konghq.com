// from nav-v2.html

function getSearchPlaceholder() {
  var w =
    window.innerWidth ||
    document.documentElement.clientWidth ||
    document.body.clientWidth;
  if (w <= 800) {
    document.getElementById("getkong-algolia-search-input").placeholder =
      "Search...";
  } else {
    document.getElementById("getkong-algolia-search-input").placeholder =
      "Search the docs...";
  }
}

getSearchPlaceholder();
window.addEventListener("resize", getSearchPlaceholder);

function handleSearchClicked() {
  $(".navbar-v2").toggleClass("search-opened");
  $(".navbar-v2").toggleClass("menu-opened", false);
  $("#getkong-algolia-search-input").focus();
}

function toggleButtonClicked() {
  if (!$(".navbar-v2").hasClass("search-opened")) {
    $(".navbar-v2").toggleClass("menu-opened");
  } else {
    $(".navbar-v2").toggleClass("search-opened", false);
  }
}

function toggleSubmenuVisible(element) {
  $(element).toggleClass("submenu-title");
  $(element.parentElement).toggleClass("submenu-opened");
}

// open Docs menu item upon enter and enable tabbing through menu
jQuery(function () {
  $("#docs-link").on("keypress keydown", function (e) {
    if (e.keyCode == 13) {
      e.preventDefault();
      $(".with-submenu").toggleClass("submenu-opened");
      $(".navbar-item-docs").setAttribute("aria-hidden", "false");
      return false;
    }
    // if user doesn't open Docs submenu, move focus to Support menu item
    let submenu = $(".with-submenu");
    if (!submenu.hasClass("submenu-opened")) {
      $("#plugin-link").focus();
    }
  });
  // close docs dropdown menu when tabbing on Support menu item
  $("#plugin-link").on("focus", function (e) {
    $(".with-submenu").removeClass("submenu-opened");
  });

  $(".main-menu-item.with-submenu").on("click", function(e) {
    toggleSubmenuVisible(e.target);
  });

  $("#navbar-menu-toggle-button").on("click", function(e) {
    toggleButtonClicked();
  });

});
