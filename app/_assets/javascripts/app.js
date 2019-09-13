/* globals $, history, analytics */

'use strict'

$(function () {
  var NAV_HEIGHT = 56

  var $window = $(window)
  var $docs = $('#documentation')

  $('.navbar-toggle').on('click', function () {
    var $navbar = $($(this).data('target'))
    $navbar.slideToggle(150)
  })

  $('.scroll-to').on('click', function (e) {
    e.preventDefault()
    if ($(window).width() <= 1000) {
      var offset = NAV_HEIGHT + 40
    } else {
      var offset = NAV_HEIGHT
    }
    $('html, body').animate({
      scrollTop: $($(this).attr('href')).offset().top - offset // Header height
    }, 700)
  })

  // Change header download button color

  if (!$('body#enterprise').length) {
    var introSectionHeight = $('.section.intro-section').outerHeight() || 38
    var $downloadBtn = $('.navbar-nav').find('.button')

    $window.on('scroll', function () {
      var scrollTop = $(this).scrollTop()

      if (scrollTop > introSectionHeight) {
        $downloadBtn.removeClass('button-dark').addClass('button-primary')
      } else {
        $downloadBtn.removeClass('button-primary').addClass('button-dark')
      }
    })
  }

  // Hide banner on "I accept" and set cookie
  $('.cookie-policy-accept').on('click', function (e) {
    e.preventDefault()

    $('.cookie-policy-container').removeClass('showing')
    $('.page').removeClass('page-cookie-policy')
    setCookie('cookie-policy', 'agreed')
  })

  function getCookie (cname) {
    var name = cname + '='
    var ca = document.cookie.split(';')
    for (var i = 0; i < ca.length; i++) {
      var c = ca[i]
      while (c.charAt(0) === ' ') {
        c = c.substring(1)
      }
      if (c.indexOf(name) === 0) {
        return c.substring(name.length, c.length)
      }
    }
    return ''
  }

  function setCookie (cname, cvalue) {
    var CookieDate = new Date()
    CookieDate.setFullYear(CookieDate.getFullYear() + 1)
    document.cookie = cname + '=' + cvalue + '; expires=' + CookieDate.toGMTString() + ';path=/'
  }

  var isCookieSet = getCookie('cookie-policy')
  if (isCookieSet === '') {
    $('.cookie-policy-container').addClass('showing')
    $('.page').addClass('page-cookie-policy')
  }

  // Page section on contribute page

  $('.toggle-page-section').on('click', function (e) {
    e.preventDefault()
    var $link = $(this)

    $link.parent().next('.page-section').stop().slideToggle(300, function () {
      $link.toggleClass('active')
    })
  })

  // Tabs on download page

  var $tabs = $('.tab-list li')
  var $tabPanes = $('.tab-pane')

  $tabs.on('click', function (e, disableTracking) {
    e.preventDefault()

    var tabId = $(this).find('a').attr('href')

    $tabs.removeClass('active').filter(this).addClass('active')
    $tabPanes.removeClass('active').filter(tabId).addClass('active')

    if (history.pushState) {
      history.pushState(null, null, tabId)
    } else {
      window.location.hash = tabId
    }

    if (!disableTracking) {
      analytics.track('Choose installation method', {
        installationMethod: tabId.substr(1)
      })
    }
  })

  if (window.location.hash) {
    $tabs.find('a[href="' + window.location.hash + '"]').trigger('click', true)
  }

  // Subscribe form

  $('#subscription_form, #follow_up_subscription_form').on('submit', function (e) {
    e.preventDefault()

    var form = $(this)
    var email = form.find('[name="email"]').val()
    var time = new Date().toString()

    var traits = {
      email: email,
      environment: 'kong',
      newsletter_updates: true,
      created_at: time
    }

    form.find('.message').html('')
    form.find('[name="email"]').removeClass('error')
    if (!email || !isEmail(email)) {
      $(this).find('.error-message').html('The e-mail address entered is invalid.')
      form.find('[name="email"]').addClass('error')
      return false
    }

    form.addClass('loading')

    $.ajax({
      url: form.attr('action'),
      type: 'POST',
      async: false,
      data: form.serialize(),
      xhrFields: {
        withCredentials: true
      },
      success: function () {
        console.log('Success')
      }
    })

    var track = function () {
      analytics.track('request_newsletter_updates', {
        email: email,
        request_date: time
      })
    }

    analytics.identify(email, traits, track)

    form.find('[name="email"]').val()
    $(this).find('.success-message').text('Thank you for signing up!')
    return false
  })

  // set utm_ values from query parameter

  var getUrlParameter = function getUrlParameter (sParam) {
    var sPageURL = decodeURIComponent(window.location.search.substring(1))
    var sURLVariables = sPageURL.split('&')
    var sParameterName
    var i
    var x
    var status = false
    var urlParams = ['utm_source', 'utm_campaign', 'utm_medium', 'utm_content', 'utm_term']
    var paramValues = []
    for (i = 0; i < sURLVariables.length; i++) {
      sParameterName = sURLVariables[i].split('=')

      if ($.inArray(sParameterName[0], urlParams) >= 0) {
        setCookie(sParameterName[0], sParameterName[1], 30)
        paramValues.push(sParameterName[0])
        status = true
      }
    }

    if (status === true) {
      for (i = 0; i < urlParams.length; i++) {
        if ($.inArray(urlParams[i], paramValues) < 0) {
          setCookie(urlParams[i], ' ', 30)
        }
      }
    }

    for (x = 0; x < urlParams.length; x++) {
      if (getCookie(urlParams[x])) {
        $('input[name="' + urlParams[x] + '"]').val(getCookie(urlParams[x]))
      }
    }
  }

  getUrlParameter()

  // Check for email validation

  function isEmail (email) {
    var regex = /^([a-zA-Z0-9_.+-])+\@(([a-zA-Z0-9-])+\.)+([a-zA-Z0-9]{2,4})+$/
    return regex.test(email)
  }

  // Enterprise page demo request form

  $('.demo-request-form').on('submit', function (e) {
    e.preventDefault()

    var form = $(this)
    var data = form.serializeArray()
    var submitTime = new Date().toString()
    var payload = {}
    var fieldValues = {}
    var relateiqFieldIds = {
      title: 8,
      tell_us_more: 6,
      email: 7,
      phone: 9,
      deployment: 14,
      company: 10,
      name: 13,
      environment: 16
    }

    form.addClass('loading')

    for (var i = 0; i < data.length; i++) {
      payload[data[i].name] = data[i].value
    }

    payload.environment = 'kong'

    var traits = $.extend({
      enterprise: true,
      created_at: submitTime
    }, payload)

    analytics.identify(payload.email, traits, function () {
      analytics.track('request_enterprise_demo', $.extend({
        request_date: submitTime
      }, payload))
    })

    for (var field in payload) {
      if (payload[field]) {
        fieldValues[relateiqFieldIds[field]] = [{
          raw: payload[field]
        }]
      }
    }

    $.ajax({
      url: 'https://mashaper-relateiq-v1.p.mashape.com/accounts',
      method: 'POST',
      headers: {
        'authorization': 'Basic NTU2ZDcxYzdlNGIwMmM5ZTM3YjgxNzc1Ok9NbFNBVGM1QkFTOG1JbEtXZENMZFZ2Z3RqYQ==',
        'x-mashape-key': 'mJUINHSWBYmshREqNlfTBKtbBHDZp1N7VKhjsnUIUo4f4r3pVj'
      },
      data: JSON.stringify({
        name: payload.email,
        fieldValues: fieldValues
      })
    }).always(function () {
      form.addClass('complete')
    })
  })

  // Docs page navigation
  if ($docs.length) {
    var $nav = $docs.find('.page-navigation')
    var $navItems = $nav.find('a')
    var hash = window.location.hash

    var setNavItemActive = function () {
      $navItems.removeClass('active').filter(this).addClass('active')
    }

    if (hash) {
      $navItems.each(function () {
        if ($(this).attr('href').indexOf(hash) !== -1) {
          setNavItemActive.call(this)
        }
      })
    }

    $navItems.on('click', setNavItemActive)

    if ($(window).width() <= 800) {
      $('.sidebar-toggle').click(function () {
        $('.page-navigation').addClass('sidebar-open')
      })
      $('.page-navigation > .close-sidebar').click(function () {
        $('.page-navigation').removeClass('sidebar-open')
      })
    }
  }

  // Analytics

  $('[href^="/install"]').each(function () {
    var $link = $(this)

    analytics.trackLink(this, 'Clicked download', {
      section: $link.closest('.navbar').length ? 'header' : 'page',
      pathname: window.location.pathname,
      type: $link.hasClass('button') ? 'button' : 'link'
    })
  })

  analytics.track(
    'Viewed ' + $.trim(document.title.split('|').shift()) + ' page'
  )

  $('.plugin-plate-link').each(function () {
    analytics.trackLink(this, 'Click on plugin', {
      plugin_type: $(this).closest('.plugin-plate').find('h3').text()
    })
  })

  $('#documentation .page-navigation a').each(function () {
    analytics.trackLink(this, 'Click documentation link', {
      documentation_name: $(this).text()
    })
  })

  $('.community-plate a').each(function () {
    analytics.trackLink(this, 'Click community link', {
      community_type: $.trim($(this).closest('.community-plate').find('h4').text())
    })
  })

  analytics.trackLink($('a[href="#comparison"]')[0], 'Clicked Why Kong')

  // Add Smooth scroll when link with attr clicked
  $('a[data-link="scroll"]').click(function () {
    $('html, body').animate({
      scrollTop: $($.attr(this, 'href')).offset().top - NAV_HEIGHT // Add spacing on top after scroll
    }, 600) // Adjust scroll speed
    // Remove any active classes that may already be applied
    $('a[data-link="scroll"').removeClass('active')
    // Add active class sidebar a
    $(this).addClass('active')
    return false
  })

  // Smooth scroll if hash in URL
  if (window.location.hash) {
    if ($(window).width() <= 1000) {
      var offset = NAV_HEIGHT + 40
    } else {
      var offset = NAV_HEIGHT
    }
    $('html, body').scrollTop(0).show()
    $('html, body').animate({
      scrollTop: $(window.location.hash).offset().top - offset // Add spacing on top after scroll
    }, 600) // Adjust scroll speed
  }

  // Plugins filter
  $('a[data-filter]').click(function () {
    var target = $(this).data('filter')

    // Remove any active classes that may already be applied
    $('a[data-filter]').removeClass('active')
    // Add active class sidebar a
    $(this).addClass('active')

    // For all faded cards, replace href with data-href target
    $('.plugin-card.fadeOut').each(function () {
      var link = $(this).find('a')
      link.attr('href', $(link).attr('data-href'))
      link.removeAttr('data-href')
    })

    // Remove any fade states that may already be applied
    $('.plugin-card').removeClass('fadeOut')

    // If the target of the li is not all continue
    if (target !== 'all') {
      // Fade all cards that don't have matching filter
      $('.plugin-card').not('.' + target).addClass('fadeOut')
      // For each faded card, move href to data-href and remove href
      $('.plugin-card.fadeOut').each(function () {
        var link = $(this).find('a')
        link.attr('data-href', $(link).attr('href'))
        link.removeAttr('href')
      })
    }
  })

  // Responsive Tables
  if($window.width() <= 1099) {
    mobileTable()
  }

  $window.resize(function (){
    if($window.width() <= 1099) {
      mobileTable()
    }
  })

  function mobileTable () {
    $('table').each(function (index, value) {
      var headerCount = $(this).find('thead th').length

      for (i = 0; i <= headerCount; i++) {
        var headerLabel = $(this).find('thead th:nth-child(' + i + ')').text()

        $(this).find('tr td:not([colspan]):nth-child(' + i + ')').replaceWith(
          function () {
            return $('<td data-label="' + headerLabel + '">').append($(this).contents())
          })
      }
    })
  }
})
