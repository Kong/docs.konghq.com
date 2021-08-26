/* globals $, history, analytics */

"use strict";

jQuery(function () {
  var NAV_HEIGHT = 56;

  var $window = $(window);
  var $docs = $("#documentation");

  // smooth scroll
  $(".scroll-to").on("click", function (e) {
    e.preventDefault();
    if ($(window).width() <= 1000) {
      var offset = NAV_HEIGHT + 40;
    } else {
      var offset = NAV_HEIGHT;
    }
    $("html, body").animate(
      {
        scrollTop: $($(this).attr("href")).offset().top - offset, // Header height
      },
      700
    );
  });

  // Active link
  var url = $(".page.v2").data("url");
  if (url){
    var urlNoSlash = url.slice(0, -1);
    var activeNav = $(".docs-sidebar li a[href='"+url+"'], .docs-sidebar li a[href='"+urlNoSlash+"'] ").addClass("active");
    activeNav.parents(".accordion-item").addClass("active");
  };

  // MODULE DROPDOWN: dropdown menu functionality (handles main product dropdown)
  $("#module-dropdown").on("click", function(e) {
    e.preventDefault();
    e.stopPropagation();

    $("#module-list").toggleClass("open");

    $(document).one('click', function closeMenu (e){
        if($('#module-list').has(e.target).length === 0){
            $('#module-list').removeClass('open');
        } else {
            $(document).one('click', closeMenu);
        }
    });
  });

  // VERSION DROPDOWN: dropdown menu functionality (handles plugin detail page, lua, and main versions dropdown)
  $("#version-dropdown").on("click", function(e) {
    e.preventDefault();
    e.stopPropagation();

    $("#version-list").toggleClass("open");

    $(document).one('click', function closeMenu (e){
        if($('#version-list').has(e.target).length === 0){
            $('#version-list').removeClass('open');
        } else {
            $(document).one('click', closeMenu);
        }
    });
  });

  // COOKIE MODAL: Hide banner on "I accept" and set cookie
  $(".cookie-policy-accept").on("click", function (e) {
    e.preventDefault();

    $(".cookie-policy-container").removeClass("showing");
    $(".page").removeClass("page-cookie-policy");
    setCookie("cookie-policy", "agreed");
  });

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

  // Add Smooth scroll when link with attr clicked
  $('a[data-link="scroll"]').on("click", function () {
    $("html, body").animate(
      {
        scrollTop: $($.attr(this, "href")).offset().top - NAV_HEIGHT, // Add spacing on top after scroll
      },
      600
    ); // Adjust scroll speed
    // Remove any active classes that may already be applied
    $('a[data-link="scroll"').removeClass("active");
    // Add active class sidebar a
    $(this).addClass("active");
    return false;
  });

  // Smooth scroll if hash in URL
  if (window.location.hash) {
    if ($(window).width() <= 1000) {
      var offset = NAV_HEIGHT + 40;
    } else {
      var offset = NAV_HEIGHT;
    }
    $("html, body").scrollTop(0).show();
    $("html, body").animate(
      {
        scrollTop: $(window.location.hash).offset().top - offset, // Add spacing on top after scroll
      },
      600
    ); // Adjust scroll speed
  }

  // Plugins filter
  $("a[data-filter]").on("click", function () {
    var target = $(this).data("filter");

    // Remove any active classes that may already be applied
    $("a[data-filter]").removeClass("active");
    // Add active class sidebar a
    $(this).addClass("active");

    // For all faded cards, replace href with data-href target
    $(".plugin-card.fadeOut").each(function () {
      var link = $(this).find("a");
      link.attr("href", $(link).attr("data-href"));
      link.removeAttr("data-href");
    });

    // Remove any fade states that may already be applied
    $(".plugin-card").removeClass("fadeOut");

    // If the target of the li is not all continue
    if (target !== "all") {
      // Fade all cards that don't have matching filter
      $(".plugin-card")
        .not("." + target)
        .addClass("fadeOut");
      // For each faded card, move href to data-href and remove href
      $(".plugin-card.fadeOut").each(function () {
        var link = $(this).find("a");
        link.attr("data-href", $(link).attr("href"));
        link.removeAttr("href");
      });
    }
  });

  // Responsive Tables
  if ($window.width() <= 1099) {
    mobileTable();
  }

  $(window).on("resize", (function(){
    if ($window.width() <= 1099) {
      mobileTable();
    }
  }));

  function mobileTable() {
    $("table").each(function (index, value) {
      var headerCount = $(this).find("thead th").length;

      for (i = 0; i <= headerCount; i++) {
        var headerLabel = $(this)
          .find("thead th:nth-child(" + i + ")")
          .text();

        $(this)
          .find("tr td:not([colspan]):nth-child(" + i + ")")
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
    const navtabTitle = $(this);
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
  });
  // set first navtab as active
  $(".navtabs").each(function (index, navtabs) {
    $(navtabs).find("div[data-navtab-content]").css("display", "none");

    const navtabsTabs = $(navtabs).find("div[data-navtab-id]");
    navtabsTabs.first().addClass("active");
    $(
      `div[data-navtab-content='${navtabsTabs.first().data("navtab-id")}']`
    ).css("display", "block");
  });

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

  /**
   * Expandable images
   *
   * To enable on specific page, add the following include directive at the bottom of the page html:
   * {% include image-modal.html %}
   *
   * To disable for a specific img tag add 'no-image-expand' class. Example:
   * <img class="install-icon no-image-expand" src="https://doc-assets.konghq.com/install-logos/docker.png" alt="docker" />
   *
   * To disable for whole page you can add 'disable_image_expand: true' to page Front Matter block. Example:
   * ---
   * title: Install Kong Enterprise
   * toc: false
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

  /**
   * Edition based element visibility
   *
   * Usage in markdown files:
   * Wrap any of the [content] within {% edition [edition] %}[content]{% endedition %} to see the content
   * only when edition=[edition] query parameter is specified.
   *
   * Example:
   * {% edition gateway-oss %}
   * ### {{site.ce_product_name}}
   * {{site.ce_product_name}} is an open-source, lightweight API gateway optimized for microservices, delivering unparalleled...
   * {% endedition %}
   *
   * Usage in docs_nav_.yml files:
   * Use edition: [edition] property for specific item which should be visible
   * only when edition=[edition] query parameter is specified.
   *
   * Example:
   * - title: Getting Started Guide
   *   icon: /assets/images/icons/documentation/icn-quickstart-color.svg
   *   items:
   *     - text: Overview
   *       url: /overview
   *     - text: Prepare to Administer
   *       url: /prepare
   *       edition: enterprise
   *     - text: Expose your Services
   *       url: /expose-services
   *       edition: gateway-oss
   */
  const edition = decodeURIComponent(window.location.search)
    .substring(1)
    .split("&")
    .map((queryParam) => queryParam.split("="))
    .filter((params) => params[0] === "edition")
    .map((params) => params[1])[0];

  const editionSwitch = $(".edition-switch");
  editionSwitch.on("click", function () {
    if (edition === "gateway-oss") {
      window.location.search = "?edition=enterprise";
    } else {
      window.location.search = "?edition=gateway-oss";
    }
  });

  if (edition) {
    $("*[data-edition]")
      .not(`[data-edition="${edition}"]`)
      .each(function (index, element) {
        element.style.display = "none";
      });
    editionSwitch.addClass(edition);
  }
});

jQuery(function () {
  var closed = localStorage.getItem("closebanner-konnect");
  if (
    closed !== "closebanner"
  ) {
    $(".navbar-v2").removeClass("closed");
    $("body").addClass("banner");
  } else {
    $(".navbar-v2").addClass("closed");
    $("body").removeClass("banner");
  }

  // open docs sidebar items
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
  localStorage.setItem("closebanner-konnect", "closebanner");
});
