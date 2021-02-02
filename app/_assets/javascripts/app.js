/* globals $, history, analytics */

"use strict";

$(function () {
  var NAV_HEIGHT = 56;

  var $window = $(window);
  var $docs = $("#documentation");

  $(".navbar-toggle").on("click", function () {
    var $navbar = $($(this).data("target"));
    $navbar.slideToggle(150);
  });

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

  // Change header download button color

  if (!$("body#enterprise").length) {
    var introSectionHeight = $(".section.intro-section").outerHeight() || 38;
    var $downloadBtn = $(".navbar-nav").find(".button");

    $window.on("scroll", function () {
      var scrollTop = $(this).scrollTop();

      if (scrollTop > introSectionHeight) {
        $downloadBtn.removeClass("button-dark").addClass("button-primary");
      } else {
        $downloadBtn.removeClass("button-primary").addClass("button-dark");
      }
    });
  }

  // Hide banner on "I accept" and set cookie
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

  // Page section on contribute page

  $(".toggle-page-section").on("click", function (e) {
    e.preventDefault();
    var $link = $(this);

    $link
      .parent()
      .next(".page-section")
      .stop()
      .slideToggle(300, function () {
        $link.toggleClass("active");
      });
  });

  // Tabs on download page

  var $tabs = $(".tab-list li");
  var $tabPanes = $(".tab-pane");

  $tabs.on("click", function (e, disableTracking) {
    e.preventDefault();

    var tabId = $(this).find("a").attr("href");

    $tabs.removeClass("active").filter(this).addClass("active");
    $tabPanes.removeClass("active").filter(tabId).addClass("active");

    if (history.pushState) {
      history.pushState(null, null, tabId);
    } else {
      window.location.hash = tabId;
    }

    if (!disableTracking) {
      analytics.track("Choose installation method", {
        installationMethod: tabId.substr(1),
      });
    }
  });

  if (window.location.hash) {
    $tabs.find('a[href="' + window.location.hash + '"]').trigger("click", true);
  }

  // Subscribe form

  $("#subscription_form, #follow_up_subscription_form").on("submit", function (
    e
  ) {
    e.preventDefault();

    var form = $(this);
    var email = form.find('[name="email"]').val();
    var time = new Date().toString();

    var traits = {
      email: email,
      environment: "kong",
      newsletter_updates: true,
      created_at: time,
    };

    form.find(".message").html("");
    form.find('[name="email"]').removeClass("error");
    if (!email || !isEmail(email)) {
      $(this)
        .find(".error-message")
        .html("The e-mail address entered is invalid.");
      form.find('[name="email"]').addClass("error");
      return false;
    }

    form.addClass("loading");

    $.ajax({
      url: form.attr("action"),
      type: "POST",
      async: false,
      data: form.serialize(),
      xhrFields: {
        withCredentials: true,
      },
      success: function () {
        console.log("Success");
      },
    });

    var track = function () {
      analytics.track("request_newsletter_updates", {
        email: email,
        request_date: time,
      });
    };

    analytics.identify(email, traits, track);

    form.find('[name="email"]').val();
    $(this).find(".success-message").text("Thank you for signing up!");
    return false;
  });

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

  // Check for email validation

  function isEmail(email) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/;
    return regex.test(email);
  }

  // Enterprise page demo request form

  $(".demo-request-form").on("submit", function (e) {
    e.preventDefault();

    var form = $(this);
    var data = form.serializeArray();
    var submitTime = new Date().toString();
    var payload = {};
    var fieldValues = {};
    var relateiqFieldIds = {
      title: 8,
      tell_us_more: 6,
      email: 7,
      phone: 9,
      deployment: 14,
      company: 10,
      name: 13,
      environment: 16,
    };

    form.addClass("loading");

    for (var i = 0; i < data.length; i++) {
      payload[data[i].name] = data[i].value;
    }

    payload.environment = "kong";

    var traits = $.extend(
      {
        enterprise: true,
        created_at: submitTime,
      },
      payload
    );

    analytics.identify(payload.email, traits, function () {
      analytics.track(
        "request_enterprise_demo",
        $.extend(
          {
            request_date: submitTime,
          },
          payload
        )
      );
    });

    for (var field in payload) {
      if (payload[field]) {
        fieldValues[relateiqFieldIds[field]] = [
          {
            raw: payload[field],
          },
        ];
      }
    }

    $.ajax({
      url: "https://mashaper-relateiq-v1.p.mashape.com/accounts",
      method: "POST",
      headers: {
        authorization:
          "Basic NTU2ZDcxYzdlNGIwMmM5ZTM3YjgxNzc1Ok9NbFNBVGM1QkFTOG1JbEtXZENMZFZ2Z3RqYQ==",
        "x-mashape-key": "mJUINHSWBYmshREqNlfTBKtbBHDZp1N7VKhjsnUIUo4f4r3pVj",
      },
      data: JSON.stringify({
        name: payload.email,
        fieldValues: fieldValues,
      }),
    }).always(function () {
      form.addClass("complete");
    });
  });

  // Docs page navigation
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

    $(".sidebar-toggle").click(function () {
      $(".page-navigation").addClass("sidebar-open");
      $(".docs-sidebar").addClass("sidebar-open");
    });
    $(".page-navigation > .close-sidebar").click(function () {
      $(".page-navigation").removeClass("sidebar-open");
    });
    $(".docs-sidebar > .close-sidebar").click(function () {
      $(".docs-sidebar").removeClass("sidebar-open");
    });

    $(".toc-sidebar-toggle").click(function () {
      $(".docs-toc").addClass("sidebar-open");
    });
    $(".docs-toc > .close-sidebar").click(function () {
      $(".docs-toc").removeClass("sidebar-open");
    });

    $(".docs-toc > .collapse-toc").click(function () {
      $(".docs-toc").addClass("collapsed");
      $(".page-content-container").addClass("toc-collapsed");
      setCookie("toc-collapsed", "true");
    });
    $(".docs-toc > .expand-toc").click(function () {
      $(".docs-toc").removeClass("collapsed");
      $(".page-content-container").removeClass("toc-collapsed");
      setCookie("toc-collapsed", "false");
    });
    if (getCookie("toc-collapsed") === "true") {
      $(".docs-toc").addClass("collapsed");
      $(".page-content-container").addClass("toc-collapsed");
    }

    $("#search-version-icon").click(function () {
      const searchVersion = $(".search-version-row");
      if (searchVersion.hasClass("visible")) {
        searchVersion.removeClass("visible");
      } else {
        searchVersion.addClass("visible");
      }
    });
  }

  // Analytics

  $('[href^="/install"]').each(function () {
    var $link = $(this);

    analytics.trackLink(this, "Clicked download", {
      section: $link.closest(".navbar").length ? "header" : "page",
      pathname: window.location.pathname,
      type: $link.hasClass("button") ? "button" : "link",
    });
  });

  analytics.track(
    "Viewed " + $.trim(document.title.split("|").shift()) + " page"
  );

  $(".plugin-plate-link").each(function () {
    analytics.trackLink(this, "Click on plugin", {
      plugin_type: $(this).closest(".plugin-plate").find("h3").text(),
    });
  });

  $("#documentation .page-navigation a").each(function () {
    analytics.trackLink(this, "Click documentation link", {
      documentation_name: $(this).text(),
    });
  });

  $(".community-plate a").each(function () {
    analytics.trackLink(this, "Click community link", {
      community_type: $.trim(
        $(this).closest(".community-plate").find("h4").text()
      ),
    });
  });

  analytics.trackLink($('a[href="#comparison"]')[0], "Clicked Why Kong");

  // Add Smooth scroll when link with attr clicked
  $('a[data-link="scroll"]').click(function () {
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
  $("a[data-filter]").click(function () {
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

  $window.resize(function () {
    if ($window.width() <= 1099) {
      mobileTable();
    }
  });

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
  $window.scroll(() => {
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
  navtabs.click(function () {
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

  $("#feedback-comment-button-back").click(function () {
    $(".feedback-options").css("visibility", "visible");
    $(".feedback-comment").css("visibility", "hidden");
  });

  $("#feedback-comment-button-submit").click(function () {
    $(".feedback-comment").css("visibility", "hidden");
    sendFeedback("no", $("#feedback-comment-text").val());
  });

  $(".feedback-options-button").click(function () {
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
   * Copy code snippet support
   *
   * By default copy code is enabled for all code blocks. If you want disable it for specific page use class 'no-copy-code' in Front Matter:
   * ---
   * class: no-copy-code
   * ---
   * Additionally, you can still enable it for specific code block using the Inline Attribute as can be seen on the following example:
   *
   * ```bash
   * $ curl -X GET http://kong:8001/basic-auths
   * ```
   * {: .copy-code-snippet data-copy-code="curl -X GET http://kong:8001/basic-auths" }
   *
   * where:
   * data-copy-code="{custom-code}" - (optional) can be used to specify {custom-code} to be copied (only single-line text is supported)
   *
   */
  const copyInput = $('<textarea id="copy-code-input"></textarea>');
  $("body").append(copyInput);

  $(".copy-code-snippet, pre > code").each(function (index, element) {
    function findSnippetElement() {
      const $code = $(element);
      let snippet = $code
        .parent("pre")
        .parent(".highlight")
        .parent(".highlighter-rouge");
      if (snippet.length > 0) {
        return snippet;
      }
      snippet = $code.parent("pre").parent(".highlight");
      if (snippet.length > 0) {
        return snippet;
      }
      snippet = $code.parent("pre");
      if (snippet.length > 0) {
        return snippet;
      }
      return $code;
    }

    const noCode = $("div.page.no-copy-code").length > 0;
    const snippet = findSnippetElement();

    if (!snippet.hasClass("copy-code-snippet") && noCode) {
      return;
    }

    snippet.addClass("copy-code-snippet");

    const action = $('<i class="copy-action fa fa-copy"></i>');
    action.click(function () {
      if ($("#copy-code-success-info").length > 0) {
        return;
      }

      copyInput.text(
        snippet.data("copy-code") ||
          snippet
            .find("code")
            .text()
            .replace(/^\s*\$\s*/gi, "")
      );
      copyInput.select();
      document.execCommand("copy");

      const successInfo = $(
        '<div id="copy-code-success-info">Copied to clipboard!</div>'
      );
      successInfo.css({
        top: action[0].getBoundingClientRect().top - action.height(),
        left: action[0].getBoundingClientRect().left + action.width() / 2,
        opacity: 1,
      });

      setTimeout(function () {
        successInfo.animate({ opacity: 0 }, function () {
          successInfo.remove();
        });
      }, 1000);
      $("body").append(successInfo);
    });
    snippet.append(action);
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
   * skip_read_time: true
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
    imageModal.find("i").click(closeModal);
    imageModal.find(".image-modal-backdrop").click(closeModal);

    $(".page-content > .content img:not(.no-image-expand)").each(function (
      index,
      img
    ) {
      const $img = $(img);

      img.style.cursor = "pointer";
      $img.click(function () {
        $(document.body).addClass("image-modal-no-scroll");
        imageModal.addClass("visible");
        imageModal.find("img").attr("src", $img.attr("src"));

        document.addEventListener("keydown", imageModalKeyDown);
      });
    });
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

  const scrollToTopButton = $("#scroll-to-top-button");

  function updateScrollToTopButttonVisibility() {
    if ($window.scrollTop() >= $window.height()) {
      scrollToTopButton.addClass("visible");
    } else {
      scrollToTopButton.removeClass("visible");
    }
  }

  scrollToTopButton.click(function () {
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
  editionSwitch.click(function () {
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

jQuery(document).ready(function () {
  var closed = localStorage.getItem("closebanner-survey");
  console.log(closed);
  var getUrl = window.location;
  var baseUrl =
    getUrl.protocol + "//" + getUrl.host + "/" + getUrl.pathname.split("/")[0];
  if (
    closed !== "closeme" &&
    window.location.href.indexOf("getting-started") === -1 &&
    window.location.href.indexOf("2.1.x") > -1 &&
    getUrl !== baseUrl
  ) {
    $("header.navbar").removeClass("closed");
    $("body").addClass("banner");
  } else {
    $("header.navbar").addClass("closed");
    $("body").removeClass("banner");
  }
});

var scrolling = false;
$(document).scroll(function () {
  scrolling = true;
});

setInterval(function () {
  if (scrolling) {
    scrolling = false;
    if ($(document).scrollTop() < 85) {
      $("header").removeClass("compress");
    } else {
      $("header").addClass("compress");
    }
  }
}, 10);

$(".closebanner").click(function () {
  $("header.navbar").addClass("closed");
  localStorage.setItem("closebanner-survey", "closeme");
});
