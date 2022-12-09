import animejs from "animejs"

document.addEventListener("DOMContentLoaded", (event) => {
  const waves = document.querySelector('.waves.waves--type-1');

  if (waves !== null) {
    const strokeOffset = [animejs.setDashoffset, 0];
    const delayAmt = 100;
    const tl = animejs.timeline({
      easing: 'easeInOutSine',
      duration: 800,
      direction: 'normal'
    });
    // this is a FOUC prevention technique.
    // on load, set the `display` to `block` instead of `none`.
    waves.style.display = 'block';
    // trigger the timeline animations
    tl
    // animate path group 1
      .add({
        targets: '.waves-group-1 path',
        strokeDashoffset: strokeOffset,
        delay: (el, i) => i * delayAmt
      }, '+=300')
    // animate path group 2
      .add({
        targets: '.waves-group-2 path',
        strokeDashoffset: strokeOffset,
        delay: (el, i) => i * delayAmt
      }, '-=600')
    // animate path group 3
      .add({
        targets: '.waves-group-3 path',
        strokeDashoffset: strokeOffset,
        delay: (el, i) => i * delayAmt
      }, '-=600');
  }
});
