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

function toggleSubmenuVisible(element, visible) {
  $(element).toggleClass("submenu-title", visible);
  $(element).toggleClass("submenu-opened", visible);
  $(element).closest('ul.navbar-items').toggleClass("submenu-opened", visible);
}

// open Docs menu item upon enter and enable tabbing through menu
$(document).ready(function() {
  $("#docs-link").on("keypress keydown", function (e) {
    if (e.keyCode == 13) {
      e.preventDefault();

      document.querySelector("#top-module-list").classList.toggle("submenu-opened");
      document.querySelector("#top-module-list ul.navbar-item-submenu").setAttribute("aria-hidden", "false");
      return false;
    }

    // if user doesn't open Docs submenu, move focus to Support menu item
    let submenu = document.querySelector("#top-module-list");
    if (!submenu.classList.contains("submenu-opened")) {
      document.querySelector("#plugin-link").click();
    }
  });

  $("ul.navbar-items").on("click", function(e) {
    const mainMenuItem = $(e.target).closest('.main-menu-item')[0];
    $("ul.navbar-items .main-menu-item").each(function(i, elem) {
      if (mainMenuItem !== elem) {
        toggleSubmenuVisible(elem, false);
      }
    });
    toggleSubmenuVisible($(mainMenuItem), !$(mainMenuItem).hasClass('submenu-opened'));
  });

  $(".search-input-wrapper img").on("click", function(e) {
    handleSearchClicked();
  });

  $("#navbar-menu-toggle-button").on("click", function(e) {
    toggleButtonClicked();
  });

  $(".search-input-wrapper img").on("click", function(e) {
    handleSearchClicked();
  });
});
