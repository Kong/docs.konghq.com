export default class HomeTabs {
  constructor() {
    this.elem = document.querySelector('.k-tabs');

    if (this.elem !== null) {
      this.addEventListeners();
    }
  }

  addEventListeners() {
    this.elem.querySelectorAll('li.tab-item').forEach((item) => {
      item.addEventListener('click', this.selectTab.bind(this));
    });
  }

  selectTab(event) {
    const selectedTab = event.currentTarget;

    this.elem.querySelectorAll('.tab-item').forEach((item) => {
      item.classList.remove('active');
    });

    selectedTab.classList.add('active');

    this.elem.querySelectorAll('.tab-container').forEach((item) => {
      item.classList.add('hidden');
    });

    const panelId = selectedTab.getAttribute('aria-controls');
    this.elem.querySelector(`.tab-container[id=${panelId}]`)
      .classList.remove('hidden');
  }
}
