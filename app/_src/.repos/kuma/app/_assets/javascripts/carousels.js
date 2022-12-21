import $ from "jquery";
window.jQuery = window.$ = $;

import 'slick-carousel'

$(function() {
  $('div[data-slick]').slick();
});
