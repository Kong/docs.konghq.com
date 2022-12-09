import animejs from "animejs"

function inView(el) {
  const elementHeight = el.clientHeight;
  const windowHeight = window.innerHeight;
  const scrollY = window.scrollY || window.pageYOffset;
  const scrollPosition = scrollY + windowHeight;
  const elementPosition = el.getBoundingClientRect().top + scrollY + elementHeight;

  return scrollPosition > elementPosition ? true : false;
}

document.addEventListener('DOMContentLoaded', (event) => {
  let hasAnimated = false;

  function animate() {
    const waves = document.querySelector('.waves.waves--type-2');

    if (waves !== null) {
      const rightGroup = '.wave-group--1 path, .wave-group--2 path, .wave-group--5 path';
      const leftGroup = '.wave-group--3 path, .wave-group--4 path, .wave-group--6 path';
      const strokeOffset = [animejs.setDashoffset, 0];
      const targetWidth = 820;
      const delay = 100;

      const tl = animejs.timeline({
        easing: 'cubicBezier(.66,.3,0,.94)',
        duration: 800,
        direction: 'normal'
      });

      // only run this function at certain widths...
      if (window.innerWidth >= targetWidth) {
        // and only run if the element is in view, and hasn't already animated
        if (inView(waves) && !hasAnimated) {
          hasAnimated = true;

          // right line group
          tl
            .add({
              targets: waves,
              opacity: 1
            })
            .add({
              targets: rightGroup,
              strokeDashoffset: strokeOffset,
              delay: (el, i) => i * delay
            }, '-=800')
            .add({
              targets: leftGroup,
              strokeDashoffset: strokeOffset,
              delay: (el, i) => i * delay
            }, '-=1200')
        }
      }
    }
  }

  window.addEventListener('scroll', animate);
});
