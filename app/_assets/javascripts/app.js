/* globals $, history, analytics */

"use strict";

jQuery(function () {
  var NAV_HEIGHT = 56;

  var $window = $(window);
  var $docs = $("#documentation");

  // Active link
  var url = $(".page.v2").data("url");
  if (url) {
    var urlNoSlash = url.slice(0, -1);
    var activeNav = $(
      ".docs-sidebar li a[href='" +
        url +
        "'], .docs-sidebar li a[href='" +
        urlNoSlash +
        "'] "
    ).addClass("active");
    activeNav.parents(".accordion-item").addClass("active");
  }

  // Open active sidebar section in left nav
  $(".docs-sidebar a.active, li.accordion-item.active").each(function (
    index,
    a
  ) {
    $(a)
      .parents("li.accordion-item")
      .each(function (index, item) {
        $(item).addClass("active");
        $(item).find("> input").prop("checked", true);
      });
  });

  $('.docs-sidebar .accordion-item input').each(function(index, input) {
    $(input).on('click', function(event) {
      var value = $('#accordion-opened').val();
      var id = input.id.split('-')[1];

      if (value === '') {
        if ($('.accordion-item.active')[0]) {
          value = $('.accordion-item.active')[0].firstElementChild.id.split('-')[1];
        } else {
          $('#accordion-opened').val(id.toString());
          return;
        }
      }
      if (value !== id.toString()) {
        $('#accordion-' + value).prop('checked', false);
        $('#accordion-opened').val(id.toString());
      }

    });
  });

  $('.dropdown-button').on('click', function(e) {
    e.preventDefault();
    e.stopPropagation();
    var dropdownMenu = $(e.currentTarget).next('.dropdown-menu')[0];

    $(".dropdown-menu").each(function(_index, element) {
      if (element !== dropdownMenu) {
        $(element).removeClass("open");
      }
    });
    $(dropdownMenu).toggleClass("open");

    $(document)
      .one("click", function closeMenu(e) {
        if ($(".dropdown-menu").has(e.currentTarget).length === 0) {
          $(".dropdown-menu").removeClass("open");
        } else {
          $(document).one("click", closeMenu);
        }
      })
      .on("keypress keydown", function (e) {
        closeDropdownOnEscape();
      });
  });

  // Function to close menus on pressing the "Escape" key
  function closeDropdownOnEscape() {
    if (event.key === "Escape") {
      $(".dropdown-menu").removeClass("open");
    }
  }

  // Enables tabbing through the version menu
  $(".dropdown-button:not(#version-dropdown)").on("keypress keydown", function (e) {
    if (e.keyCode == 13) {
      e.preventDefault();
      e.stopPropagation();

      $(e.currentTarget).next('.dropdown-menu')
        .toggleClass("open")
        .setAttribute("aria-hidden", "false")
        .setAttribute("aria-expanded", "true");
      return false;
    }
    $(document).on("keypress keydown", function (e) {
      closeDropdownOnEscape();
    });
  });

  // Enables tabbing through the module menu
  $("#module-dropdown").on("keypress keydown", function (e) {
    if (e.keyCode == 13) {
      e.preventDefault();
      e.stopPropagation();

      $("#module-list")
        .toggleClass("open")
        .setAttribute("aria-hidden", "false")
        .setAttribute("aria-expanded", "true");
      return false;
    }
    // if user doesn't open product submenu, move focus to version menu item
    let submenu = $("#module-list");
    if (!submenu.hasClass("open")) {
      $("#version-list").focus();
    }

    // close docs dropdown menu when tabbing to the version dropdown
    $("#version-dropdown").on("focus", function (e) {
      $("#module-list").removeClass("open");
    });

    // close product or version dropdown menu when tabbing on the first navigation menu item
    $(".accordion-link").on("focus", function (e) {
      $("#module-list").removeClass("open");
      $("#version-list").removeClass("open");
    });

    $(document).on("keypress keydown", function (e) {
      closeDropdownOnEscape();
    });
  });

  // Cookie functions

  function getCookie(cname) {
    var name = cname + "=";
    var ca = document.cookie.split(";");
    for (var i = 0; i < ca.length; i++) {
      var c = ca[i];
      while (c.charAt(0) === " ") {
        c = c.substring(1);
      }
      if (c.indexOf(name) === 0) {
        return c.substring(name.length, c.length);
      }
    }
    return "";
  }

  function setCookie(cname, cvalue) {
    var CookieDate = new Date();
    CookieDate.setFullYear(CookieDate.getFullYear() + 1);
    document.cookie =
      cname +
      "=" +
      cvalue +
      "; expires=" +
      CookieDate.toGMTString() +
      ";path=/";
  }

  var isCookieSet = getCookie("cookie-policy");
  if (isCookieSet === "") {
    $(".cookie-policy-container").addClass("showing");
    $(".page").addClass("page-cookie-policy");
  }

  // set utm_ values from query parameter
  var getUrlParameter = function getUrlParameter(sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1));
    var sURLVariables = sPageURL.split("&");
    var sParameterName;
    var i;
    var x;
    var status = false;
    var urlParams = [
      "utm_source",
      "utm_campaign",
      "utm_medium",
      "utm_content",
      "utm_term",
    ];
    var paramValues = [];
    for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split("=");

      if ($.inArray(sParameterName[0], urlParams) >= 0) {
        setCookie(sParameterName[0], sParameterName[1], 30);
        paramValues.push(sParameterName[0]);
        status = true;
      }
    }

    if (status === true) {
      for (i = 0; i < urlParams.length; i++) {
        if ($.inArray(urlParams[i], paramValues) < 0) {
          setCookie(urlParams[i], " ", 30);
        }
      }
    }

    for (x = 0; x < urlParams.length; x++) {
      if (getCookie(urlParams[x])) {
        $('input[name="' + urlParams[x] + '"]').val(getCookie(urlParams[x]));
      }
    }
  };

  getUrlParameter();

  // RIGHT-HAND NAVIGATION: Docs page navigation
  if ($docs.length) {
    var $nav = $docs.find(".page-navigation");
    var $navItems = $nav.find("a");
    var hash = window.location.hash;

    var setNavItemActive = function () {
      $navItems.removeClass("active").filter(this).addClass("active");
    };

    if (hash) {
      $navItems.each(function () {
        if ($(this).attr("href").indexOf(hash) !== -1) {
          setNavItemActive.call(this);
        }
      });
    }

    $navItems.on("click", setNavItemActive);

    $(".sidebar-toggle").on("click", function () {
      $(".page-navigation").addClass("sidebar-open");
      $(".docs-sidebar").addClass("sidebar-open");
    });
    $(".page-navigation > .close-sidebar").on("click", function () {
      $(".page-navigation").removeClass("sidebar-open");
    });
    $(".docs-sidebar > .close-sidebar").on("click", function () {
      $(".docs-sidebar").removeClass("sidebar-open");
    });

    $(".toc-sidebar-toggle").on("click", function () {
      $(".docs-toc").addClass("sidebar-open");
    });
    $(".docs-toc > .close-sidebar").on("click", function () {
      $(".docs-toc").removeClass("sidebar-open");
    });
    $(".docs-toc .scroll-to").on("click", function () {
      $(".docs-toc").removeClass("sidebar-open");
    });

    $(".docs-toc > .collapse-toc").on("click", function () {
      $(".docs-toc").addClass("collapsed");
      $(".page-content-container").addClass("toc-collapsed");
      setCookie("toc-collapsed", "true");
    });
    $(".docs-toc > .expand-toc").on("click", function () {
      $(".docs-toc").removeClass("collapsed");
      $(".page-content-container").removeClass("toc-collapsed");
      setCookie("toc-collapsed", "false");
    });
    if (getCookie("toc-collapsed") === "true") {
      $(".docs-toc").addClass("collapsed");
      $(".page-content-container").addClass("toc-collapsed");
    }

    $("#search-version-icon").on("click", function () {
      const searchVersion = $(".search-version-row");
      if (searchVersion.hasClass("visible")) {
        searchVersion.removeClass("visible");
      } else {
        searchVersion.addClass("visible");
      }
    });
  }

  // Responsive Tables
  if ($window.width() <= 1099) {
    mobileTable();
  }

  $(window).on("resize", function () {
    if ($window.width() <= 1099) {
      mobileTable();
    }

    if ($window.width() > 1099) {
      $("table").each(function (index, value) {
        $(this).removeClass("mobile");
      });
    }
  });

  function mobileTable() {
    $("table").each(function (index, value) {
      $(this).addClass("mobile");
      var headerCount = $(this).find("thead th").length;

      for (var i = 0; i <= headerCount; i++) {
        var headerLabel = $(this)
          .find("thead th:nth-child(" + i + ") .mobile-label")
          .text();
        if (!headerLabel) {
          headerLabel = $(this)
            .find("thead th:nth-child(" + i + ")")
            .text();
        }

        $(this)
          .find(
            "tr td:not([colspan],.no-mobile,.header-row):nth-child(" + i + ")"
          )
          .replaceWith(function () {
            return $('<td data-label="' + headerLabel + '">').append(
              $(this).contents()
            );
          });
      }
    });
  }

  // watch scroll and update active scroll-to anchor links
  $window.on("scroll", () => {
    const anchors = $("a.header-link");
    const scrollToLinks = $("a.scroll-to");
    if (!anchors.length || !scrollToLinks.length) {
      return;
    }

    let activeSet = false;
    scrollToLinks.removeClass("active");
    $(anchors.get().reverse()).each((index, element) => {
      const $element = $(element);

      // window top + header section
      if (window.scrollY + NAV_HEIGHT + 80 >= $element.offset().top) {
        $(`a.scroll-to[href$="${$element.attr("href")}"]`).addClass("active");
        activeSet = true;
        return false;
      }
    });

    if (!activeSet) {
      scrollToLinks.first().addClass("active");
    }
  });

  // navtabs
  const navtabs = $("div[data-navtab-id]");

  navtabs.on("click", function () {
    activateNavTab($(this));
  });

  navtabs.on("keypress", function (e) {
    if (e.keyCode === 13) {
      activateNavTab($(this));
    }
  });

  function activateNavTab(navtabTitle, skipScroll) {
    // Toggle all nav tabs that match this title
    const text = navtabTitle.text();
    const search = $(".navtab-title")
      .filter(function () {
        return $(this).text().trim().toLowerCase() == text.trim().toLowerCase();
      })
      .each(function (k, v) {
        activateSingleNavTab($(v));
      });

    const elementTop = navtabTitle.offset().top;
    const elementBottom = elementTop + navtabTitle.outerHeight();
    const screenTop = $(window).scrollTop();
    const screenBottom = $(window).scrollTop() + $(window).innerHeight();

    if (!skipScroll) {
      // If the element isn't on screen, scroll to it
      if (elementBottom < screenTop || elementTop > screenBottom) {
        $([document.documentElement, document.body]).animate(
          {
            scrollTop: elementTop - 120,
          },
          0
        );
      }
    }
  }

  function activateSingleNavTab(navtabTitle) {
    const navtabID = navtabTitle.data("navtab-id");
    const navtabContent = $(`div[data-navtab-content='${navtabID}']`);

    if (navtabContent.length === 0) {
      console.err(`No navtab content found for navtab=${navtabID}`);
      return;
    }

    navtabTitle.siblings().removeClass("active");
    navtabTitle.addClass("active");
    navtabContent.siblings().css("display", "none");
    navtabContent.css("display", "block");
  }

  // set first navtab as active
  // This MUST happen before setting navtab via URL as there may be
  // a mix of tabs on a page e.g. use-admin-api/use-deck and curl/httpie
  $(".navtabs").each(function (index, navtabs) {
    $(navtabs).find("div[data-navtab-content]").css("display", "none");
    const navtabsTabs = $(navtabs).find("div[data-navtab-id]");
    navtabsTabs.first().addClass("active");
    $(
      `div[data-navtab-content='${navtabsTabs.first().data("navtab-id")}']`
    ).css("display", "block");
  });

  // Ability to set NavTab via URL
  const getParams = new Proxy(new URLSearchParams(window.location.search), {
    get: (searchParams, prop) => searchParams.get(prop),
  });

  if (getParams.tab) {
    const matches = decodeURI(getParams.tab).toLowerCase().split(",");
    for (const i in matches) {
      const navTab = $(".navtab-title[data-slug='" + matches[i] + "']").first();
      if (navTab.length) {
        activateNavTab(navTab);
      }
    }
  }

  // Handle EE/OSS Sidebar switcher
  const ossEeToggle = $("#oss-ee-toggle");
  if ($(".external-trigger").length) {
    ossEeToggle.show();
  }

  ossEeToggle.on("click", function () {
    const t = $(this);
    const current = t.data("current");
    let next;
    let slug;
    if (current == "Enterprise" || !current) {
      next = "OSS";
      slug = "kong-gateway-oss";
    } else {
      next = "Enterprise";
      slug = "kong-gateway";
    }
    t.data("current", next);
    t.find("#switch-to-version").text(current);

    activateNavTab($(".navtab-title[data-slug='" + slug + "']").first(), true);
  });

  if (getParams.install == "oss" && ossEeToggle.is(":visible")) {
    ossEeToggle.click();
  }

  // Signup confirmation for nurture campaigns
  if (getParams.signup == "nurture") {
    $("#nurture-signup").html(
      "Thanks for signing up! Check your emails to see the first step of your learning journey."
    );
  }

  if (getParams.signup == "error") {
    $("#nurture-signup")
      .removeClass("note")
      .addClass("warning")
      .prepend(
        '<span class="cta-error">There was an error adding your free training. Please try again.</span>'
      );
  }

  /**
   * Expandable images
   *
   * To enable on specific page, add the following include directive at the bottom of the page html:
   * {% include_cached image-modal.html disable_image_expand=page.disable_image_expand %}
   *
   * To disable for a specific img tag add 'no-image-expand' class. Example:
   * <img class="install-icon no-image-expand" src="/assets/images/docs/install-logos/docker.png" alt="docker" />
   *
   * To disable for whole page you can add 'disable_image_expand: true' to page Front Matter block. Example:
   * ---
   * title: Install Kong Gateway Enterprise
   * disable_image_expand: true
   * ---
   */
  const imageModal = $("#image-modal");

  function closeModal() {
    $(document.body).removeClass("image-modal-no-scroll");
    imageModal.removeClass("visible");
    document.removeEventListener("keydown", imageModalKeyDown);
  }

  function imageModalKeyDown(e) {
    if (e.key === "Escape") {
      closeModal();
    }
  }

  if (imageModal.length > 0 && !imageModal.data("image-expand-disabled")) {
    imageModal.find("i").on("click", closeModal);
    imageModal.find(".image-modal-backdrop").on("click", closeModal);

    $(".page-content > .content img:not(.no-image-expand)").each(function (
      index,
      img
    ) {
      const $img = $(img);

      img.style.cursor = "pointer";
      $img.on("click", function () {
        $(document.body).addClass("image-modal-no-scroll");
        imageModal.addClass("visible");
        imageModal.find("img").attr("src", $img.attr("src"));
        imageModal.find("img").attr("alt", $img.attr("alt"));

        document.addEventListener("keydown", imageModalKeyDown);
      });
    });
  }

  const scrollToTopButton = $("#scroll-to-top-button");

  function updateScrollToTopButttonVisibility() {
    if ($window.scrollTop() >= $window.height()) {
      scrollToTopButton.addClass("visible");
    } else {
      scrollToTopButton.removeClass("visible");
    }
  }

  scrollToTopButton.on("click", function () {
    $("html, body").animate({ scrollTop: 0 }, "slow");
  });
  updateScrollToTopButttonVisibility();
  $window.on("scroll", updateScrollToTopButttonVisibility);

  /**
   * Custom table column widths in markdown files
   *
   * Usage:
   *
   * | Concept/Feature {:width=250px:} | Description {:width=20%:} | OSS or Enterprise |
   * |-----------------|-------------|-------------------|
   *
   */
  const WIDTH_REGEX = /(.*)\s*{:width=(.+):}/;
  $("table thead tr th").each(function (index, th) {
    const $th = $(th);

    const match = WIDTH_REGEX.exec($th.text());
    if (match) {
      $th.text(match[1]);
      th.style.width = match[2];
    }
  });

  $('.field-subfield__expand').on('click', function(event) {
    var $field = $(event.target).closest('.field');
    $field.find('.fa-chevron-down').toggleClass('rotated');
    $field.find('.field-description-and-children > .field-subfield__params:first').toggle('hidden');
  });


  var ctaKonnectCardClosed = getCookie("konnect-cta-card");
  if (ctaKonnectCardClosed === "") {
    $("#modal-open").click();
  }

  $(".konnect-cta-card .button").on("click", function(e) {
    setCookie("konnect-cta-card", "true");
  });

  $(".cta-card-close").on("click", function(e) {
    e.preventDefault();
    setCookie("konnect-cta-card", "false");
    analytics.track("Docs Konnect CTA Dismissed");
  });
});

// Tooltips for badges
jQuery(function () {
  if ($(".page.page-hub").length === 0) {
    $(".badge.enterprise").append(
      '<div class="tooltip"><span class="tooltiptext">Available with Kong Gateway Enterprise subscription - <a target="_blank" href="https://konghq.com/contact-sales">Contact Sales</a></span></div>'
    );
    $(".badge.free").append(
      '<div class="tooltip"><span class="tooltiptext">Available in Enterprise Free mode (without a license)</span></div>'
    );
    $(".badge.oss").append(
      '<div class="tooltip"><span class="tooltiptext" >Available in Kong open-source only</span></div>'
    );
    $(".badge.dbless").append(
      '<div class="tooltip"><span class="tooltiptext">Compatible with DB-less deployments</span></div>'
    );
    $(".badge.konnect").append(
      '<div class="tooltip"><span class="tooltiptext">Available in the Kong Konnect app</span></div>'
    );
    $(".badge.techpartner").append(
      '<div class="tooltip"><span class="tooltiptext">Verified Kong technical partner</span></div>'
    );
    $(".badge.paid").append(
      '<div class="tooltip"><span class="tooltiptext">Available with Konnect Paid subscription </span></div>'
    );
    $(".badge.premium").append(
      '<div class="tooltip"><span class="tooltiptext">Available with Konnect Premium subscription - <a target="_blank" href="https://konghq.com/contact-sales">Contact Sales</a></span></div>'
    );
  }
});

// Expand version list

$(".see-more").on("click", function () { 
  $(".compat-list").addClass("compat-list-expanded");
  $(".compat-list").removeClass("compat-list-collapsed");
});