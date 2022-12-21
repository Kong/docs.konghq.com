export default class NavBar {
  constructor() {
    this.elem = document.querySelector('.theme-container');
    this.sidebarButton = this.elem.querySelector('.sidebar-button');
    this.touchStart = {};

    if (this.elem !== null) {
      this.addEventListeners();
    }
  }

  addEventListeners() {
    this.elem.addEventListener('touchstart', (event) => {
      this.touchStart = {
        x: event.changedTouches[0].clientX,
        y: event.changedTouches[0].clientY
      }
    });

    this.elem.addEventListener('touchstart', (event) => {
      const dx = event.changedTouches[0].clientX - this.touchStart.x;
      const dy = event.changedTouches[0].clientY - this.touchStart.y;

      if (Math.abs(dx) > Math.abs(dy) && Math.abs(dx) > 40) {
        if (dx > 0 && this.touchStart.x <= 80) {
          this.toggleSidebar(true)
        } else {
          this.toggleSidebar(false)
        }
      }
    });

    this.sidebarButton.addEventListener('click', (event) => {
      this.toggleSidebar();
    });
  }

  toggleSidebar(toggle) {
    this.elem.classList.toggle('sidebar-open', toggle);
  }
}
