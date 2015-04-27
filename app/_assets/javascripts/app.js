$(function () {
  $('.navbar-toggle').on('click', function () {
    var $navbar = $($(this).data('target'));
    $navbar.slideToggle(150);
  });

  $('.scroll-to').on('click', function (e) {
    e.preventDefault();

    $('html, body').animate({
      scrollTop: $($(this).attr('href')).offset().top - 70 // Header height
    }, 700);
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

  // Subscribe form

  $('.subscribe-form').on('submit', function (e) {
    e.preventDefault();

    var $form = $(this);
    var email = $form.find('[name="email"]').val();
    var submitTime = new Date().getTime();

    analytics.track('request_newsletter_updates', {
      email: email,
      request_date: submitTime
    });

    analytics.identify(email, {
      email: email,
      environment: 'kong',
      newsletter_updates: true,
      created_at: submitTime
    }, function () {
      $form.fadeOut(300, function () {
        $('.success-message').fadeIn(300);
      });
    });
  });

  // Enterprise page demo request form

  $('.demo-request-form').on('submit', function (e) {
    e.preventDefault();

    var $form = $(this);
    var data = $form.serializeArray();
    var submitTime = new Date().getTime();

    var payload = {};

    for (var i = 0; i < data.length; i++) {
      payload[data[i].name] = data[i].value;
    }

    analytics.track('request_enterprise_demo', $.extend({
      request_date: submitTime
    }, payload));

    analytics.identify(payload.email, $.extend({
      environment: 'kong',
      enterprise: true,
      created_at: submitTime
    }, payload), function () {
      $form.fadeOut(300, function () {
        $('.success-message').fadeIn(300);
      });
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

  analytics.track(
      'Viewed ' + $.trim(document.title.split('|').shift()) + ' page'
  );
});
