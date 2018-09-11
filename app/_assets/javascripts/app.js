/* globals $, history, analytics */

'use strict'

$(function () {
  var $window = $(window)
  var $docs = $('#documentation')

  $('.navbar-toggle').on('click', function () {
    var $navbar = $($(this).data('target'))
    $navbar.slideToggle(150)
  })

  $('.scroll-to').on('click', function (e) {
    e.preventDefault()

    $('html, body').animate({
      scrollTop: $($(this).attr('href')).offset().top - 107 // Header height
    }, 700)
  })

  // Change header download button color

  if (!$('body#enterprise').length) {
    var introSectionHeight = $('.section.intro-section').outerHeight() || 50
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

  $('.subscribe-form').on('submit', function (e) {
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

    form.addClass('loading')

    var track = function () {
      form.addClass('complete')

      analytics.track('request_newsletter_updates', {
        email: email,
        request_date: time
      })
    }

    analytics.identify(email, traits, track)
  })

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
      scrollTop: $($.attr(this, 'href')).offset().top - 220 // Add spacing on top after scroll
    }, 600) // Adjust scroll speed
    // Remove any active classes that may already be applied
    $('a[data-link="scroll"').removeClass('active')
    // Add active class sidebar a
    $(this).addClass('active')
    return false
  })

  // Smooth scroll if hash in URL
  if (window.location.hash) {
    $('html, body').scrollTop(0).show()
    $('html, body').animate({
      scrollTop: $(window.location.hash).offset().top - 220 // Add spacing on top after scroll
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

  $(window).scroll(function () {
    var sticky = $('.site-header')
    var scroll = $(window).scrollTop()

    if (scroll >= 50) {
      sticky.addClass('fixed-top')
      $('.page').addClass('page-header-fixed')
    } else {
      sticky.removeClass('fixed-top')
      $('.page').removeClass('page-header-fixed')
    }
  })
})
