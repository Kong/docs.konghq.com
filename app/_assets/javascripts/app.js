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

  // Function to close menus on pressing the "Escape" key
  function closeDropdownOnEscape() {
    if (event.key === "Escape") {
      $("#module-list").removeClass("open");
      $("#version-list").removeClass("open");
    }
  }

  // MODULE DROPDOWN: dropdown menu functionality (handles main product dropdown)

  // Actions that occur on click and escape button press
  $("#module-dropdown").on("click", function (e) {
    e.preventDefault();
    e.stopPropagation();

    $("#module-list").toggleClass("open");
    $("#version-list").removeClass("open");

    $(document)
      .one("click", function closeMenu(e) {
        if ($("#module-list").has(e.target).length === 0) {
          $("#module-list").removeClass("open");
        } else {
          $(document).one("click", closeMenu);
        }
      })
      .on("keypress keydown", function (e) {
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

  // VERSION DROPDOWN: dropdown menu functionality (handles plugin detail page, lua, and main versions dropdown)
  $("#version-dropdown").on("click", function (e) {
    e.preventDefault();
    e.stopPropagation();

    $("#version-list").toggleClass("open");
    $("#module-list").removeClass("open");

    $(document)
      .one("click", function closeMenu(e) {
        if ($("#version-list").has(e.target).length === 0) {
          $("#version-list").removeClass("open");
        } else {
          $(document).one("click", closeMenu);
        }
      })
      .on("keypress keydown", function (e) {
        closeDropdownOnEscape();
      });
  });

  // Enables tabbing through the version menu
  $("#version-dropdown").on("keypress keydown", function (e) {
    if (e.keyCode == 13) {
      e.preventDefault();
      e.stopPropagation();

      $("#version-list")
        .toggleClass("open")
        .setAttribute("aria-hidden", "false")
        .setAttribute("aria-expanded", "true");
      return false;
    }
    $(document).on("keypress keydown", function (e) {
      closeDropdownOnEscape();
    });
  });

  // COMPAT DROPDOWN: dropdown menu functionality (handles /archive/konnect-platform/compatibility dropdown. Currently not in use.)
  // $("#compat-dropdown").on("click", function(e) {
  //   e.preventDefault();
  //   e.stopPropagation();
  //
  //   $("#compat-list").toggleClass("open");
  //
  //   $(document).one('click', function closeMenu (e){
  //       if($('#compat-list').has(e.target).length === 0){
  //           $('#compat-list').removeClass('open');
  //       } else {
  //           $(document).one('click', closeMenu);
  //       }
  //   });
  // });

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

  // Plugin filter all / only available
  var pluginsAllOrOnly = "all";
  var showPlusWithEnterprise = false;
  function showPluginBanner(target) {
    var hubCards = $(".hub-cards");
    if (!hubCards.length) {
      return;
    }

    var allOnlyToggle = $("#plugin-banner");
    var eePlusBanner = $("#ee-plus-banner");

    var allowedFilters = ["plus", "ee-compat"];
    if (allowedFilters.indexOf(target) === -1) {
      pluginsAllOrOnly = "all";
      allOnlyToggle.hide();
      return;
    }

    allOnlyToggle.show();

    if (!allOnlyToggle.length) {
      allOnlyToggle = $(
        '<div id="plugin-banner" class="content" style="padding:0"><blockquote class="note"></blockquote></div>'
      );
      hubCards.prepend(allOnlyToggle);
    }

    if (!eePlusBanner.length) {
      eePlusBanner = $(
        '<div id="ee-plus-banner" class="content" style="padding:0"><blockquote class="important">If you run Kong Gateway on your own infrastructure, you also have access to all <strong>Plus</strong> plugins. <u id="show-plus-ee">Show Plus plugins?</u></blockquote></div>'
      );
      eePlusBanner
        .find("u")
        .css({ cursor: "pointer" })
        .click(function () {
          showPlusWithEnterprise = true;
          pluginFilter(target);
          return false;
        });
      allOnlyToggle.after(eePlusBanner);
    }

    eePlusBanner.hide();

    if (
      pluginsAllOrOnly == "only" &&
      target == "ee-compat" &&
      showPlusWithEnterprise == false
    ) {
      eePlusBanner.show();
    }

    var tierMap = {
      plus: "Plus",
      "ee-compat": "Enterprise",
    };

    var content = allOnlyToggle.find("blockquote");

    if (pluginsAllOrOnly == "all") {
      content.html(
        "Showing <strong>all</strong> plugins available on the " +
          tierMap[target] +
          " tier. <u>Show " +
          tierMap[target] +
          " only plugins?</u>"
      );
    } else {
      content.html(
        "Showing plugins <strong>only</strong> available on the " +
          tierMap[target] +
          " tier. <u>Show <strong>all</strong> " +
          tierMap[target] +
          " plugins?</u>"
      );
    }
    content
      .find("u")
      .css({ cursor: "pointer" })
      .click(function () {
        var other = pluginsAllOrOnly == "all" ? "only" : "all";
        pluginsAllOrOnly = other;
        showPlusWithEnterprise = false;
        pluginFilter(target);
        return false;
      });
  }

  // Plugins filter on click
  $("a[data-filter]").on("click", function () {
    var target = $(this).data("filter");

    // Remove any active classes that may already be applied
    $("a[data-filter]").removeClass("active");
    // Add active class sidebar a
    $(this).addClass("active");
    pluginFilter(target);
  });

  // Plugin filter on keypress
  $("a[data-filter]").on("keypress", function (e) {
    if (e.keyCode === 13) {
      var target = $(this).data("filter");
      $("a[data-filter]").removeClass("active");
      $(this).addClass("active");

      pluginFilter(target);
    }
  });

  if ($(".plugin-hub")) {
    var hash = window.location.hash;
    if (hash) {
      var filter = hash.slice(1);
      $("a[data-filter]").removeClass("active");
      $(`a[href='${hash}']`).addClass("active");
      pluginFilter(filter);
    }
  }

  function pluginFilter(target) {
    $("html, body").animate({ scrollTop: 0 });
    if (!target) {
      target = "all";
    }
    showPluginBanner(target);

    var excluded = [];
    if (pluginsAllOrOnly == "only") {
      if (target == "plus") {
        excluded = ["open-source"];
      } else if (target == "ee-compat") {
        excluded = ["open-source"];
        if (!showPlusWithEnterprise) {
          excluded.push("plus");
        }
      }
    }

    // For all faded cards, replace href with data-href target
    $(".card-group.fadeOut").each(function () {
      var link = $(this).find("a");
      link.attr("href", $(link).attr("data-href"));
      link.removeAttr("data-href");
    });

    // Remove any fade states that may already be applied
    $(".card-group").removeClass("fadeOut");
    $(".nav-link, .category").show();

    // If the target of the li is not all continue
    if (target !== "all") {
      // Fade all cards that don't have matching filter
      $(".card-group")
        .not("." + target)
        .addClass("fadeOut");

      // Fade cards that aren't exclusive to this tier if
      // we're set to "only" mode
      if (pluginsAllOrOnly == "only") {
        var selector = excluded.map((e) => "." + e).join(", ");
        $(".card-group").filter(selector).addClass("fadeOut");
      }

      // For each faded card, move href to data-href and remove href
      $(".card-group.fadeOut").each(function () {
        var link = $(this).find("a");
        link.attr("data-href", $(link).attr("href"));
        link.removeAttr("href");
      });
    }

    // Make sure to show/hide categories as needed
    $(".category").each(function () {
      var cards = $(this).find(".card-group:visible");
      var id = $(this).attr("id");
      if (!cards.length) {
        $(this).hide();
        $(".nav-link[href='#" + id + "']").hide();
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

      for (i = 0; i <= headerCount; i++) {
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
   * <img class="install-icon no-image-expand" src="https://doc-assets.konghq.com/install-logos/docker.png" alt="docker" />
   *
   * To disable for whole page you can add 'disable_image_expand: true' to page Front Matter block. Example:
   * ---
   * title: Install Kong Enterprise
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
    $(event.target).closest('.field').find('.field-description-and-children > .field-subfield__params:first').toggle('hidden');
    $(event.target).toggleClass('rotated');
  })

});

// Tooltips for badges
jQuery(function () {
  $(".badge.enterprise").append(
    '<div class="tooltip"><span class="tooltiptext">Available with Enterprise subscription - <a target="_blank" href="https://konghq.com/contact-sales">Contact Sales</a></span></div>'
  );
  $(".badge.plus").append(
    '<div class="tooltip"><span class="tooltiptext">Available with Plus subscription (Kong Konnect)</span></div>'
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
});
