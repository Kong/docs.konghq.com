window.addEventListener('scroll',
  function () {
    var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
    if (w <= 800 && $(window).scrollTop() < 8) {
      $('.content').toggleClass('scrolled', false);
      $('.content-header').toggleClass('scrolled', false);
      $('.content-version').show(250);
    } else {
      $('.content').toggleClass('scrolled', true);
      $('.content-header').toggleClass('scrolled', true);
      $('.content-version').hide(250);
    }
  }
);
