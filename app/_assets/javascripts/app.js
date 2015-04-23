$(function () {
  $('.navbar-toggle').on('click', function () {
    var $navbar = $($(this).data('target'));
    $navbar.slideToggle(150);
  });

  // Page section on contribute page

  $('.toggle-page-section').on('click', function (e) {
    e.preventDefault();
    var $link = $(this);

    $link.parent().next('.page-section').stop().slideToggle(300, function () {
      $link.toggleClass('active');
    });
  });

  // Tabs on download page

  var $tabs = $('.tab-list li');
  var $tabPanes = $('.tab-pane');

  $tabs.on('click', function (e, disableTracking) {
    e.preventDefault();

    var tabId = $(this).find('a').attr('href');

    $tabs.removeClass('active').filter(this).addClass('active');
    $tabPanes.removeClass('active').filter(tabId).addClass('active');

    if (history.pushState) {
      history.pushState(null, null, tabId);
    } else {
      location.hash = tabId;
    }

    if (!disableTracking) {
      analytics.track('Choose installation method', {
        installationMethod: tabId.substr(1)
      });
    }
  });

  if (location.hash) {
    $tabs.find('a[href="' + location.hash + '"]').trigger('click', true);
  }

  // Subscribe form on homepage

  Parse.initialize("ZFqEMoCQSm0K4piYYdstraJDOl0a80tJB7R0tR49", "SdqL88SikiiftwBjEGfRb4SmbghTIycZ2kfy7Jb0");

  $('.subscribe-form').on('submit', function (e) {
    e.preventDefault();

    var $form = $(this);
    var data = $form.serializeArray();
    var Subscription = Parse.Object.extend('Subscription');
    var subscription = new Subscription();
    var payload = {};

    for (var i = 0; i < data.length; i++) {
      payload[data[i].name] = data[i].value;
    }

    analytics.identify($.extend({
      environment: 'kong',
      userId: payload.email
    }, payload));

    subscription.save(payload, {
      success: function () {
        $form.fadeOut(300, function () {
          $('.success-message').fadeIn(300);
        });
      },
      error: function () {
        $form.fadeOut(300, function () {
          $('.error-message').fadeIn(300);
        });
      }
    });
  });

  // Analytics
  $('[href^="/download"]').each(function () {
    var $link = $(this);

    analytics.trackLink(this, 'Clicked download', {
      section: $link.closest('.navbar').length ? 'header' : 'page',
      pathname: location.pathname,
      type: $link.hasClass('button') ? 'button' : 'link'
    });
  });
});
