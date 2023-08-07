window.addEventListener('scroll',
  function () {
    var w = window.innerWidth || document.documentElement.clientWidth || document.body.clientWidth;
    if (w <= 480 && $(window).scrollTop() < 8) {
      $('.page-header-product-version').show(250);
      $('.page-header-doc').toggleClass('scrolled', false);
      $('.page--header-background-doc').toggleClass('scrolled', false);
    } else {
      $('.page-header-product-version').hide(250);
      $('.page-header-doc').toggleClass('scrolled', true);
      $('.page--header-background-doc').toggleClass('scrolled', true);
    }
  }
);
