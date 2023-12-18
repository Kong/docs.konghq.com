// from nav-v2.html

function handleSearchClicked() {
  $(".navbar-v2").toggleClass("search-opened");
  $(".navbar-v2").toggleClass("menu-opened", false);
}

function toggleButtonClicked() {
  if (!$(".navbar-v2").hasClass("search-opened")) {
    $(".navbar-v2").toggleClass("menu-opened");
  } else {
    $(".navbar-v2").toggleClass("search-opened", false);
  }
}

function toggleSubmenuVisible(element, show) {
  element.classList.toggle("submenu-title", show);
  element.classList.toggle("submenu-opened", show);
  element.closest("ul.navbar-items").classList.toggle("submenu-opened", show);

  if (show) {
    element.setAttribute("aria-expanded", true);
    element.querySelectorAll("a").forEach(function(link) {
      link.removeAttribute("tabindex");
    });
  } else {
    element.setAttribute("aria-expanded", false);
    element.querySelectorAll("a").forEach(function(link) {
      link.setAttribute("tabindex", "-1");
    });
  }
}

// open Docs menu item upon enter and enable tabbing through menu
$(document).ready(function() {
  const topNavSubmenus = document.querySelectorAll(".main-menu-item.with-submenu");

  function toggleNav(nav) {
    // show submenu
    const visible = nav.classList.contains("submenu-opened");
    toggleSubmenuVisible(nav, !visible);
  }

  topNavSubmenus.forEach(function(nav) {
    nav.addEventListener("keydown", function(e) {
      if (e.keyCode == 13) {
        toggleNav(nav);
        return false;
      }
    });

    nav.addEventListener("click", function(e) {
      toggleNav(nav);
    });
  });

  document.querySelectorAll(".navbar-item, .main-menu-item-title").forEach(function(elem) {
    elem.addEventListener("focus", function(e) {
      topNavSubmenus.forEach(function(menuItem) {
        toggleSubmenuVisible(menuItem, false);
      });
    });
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
