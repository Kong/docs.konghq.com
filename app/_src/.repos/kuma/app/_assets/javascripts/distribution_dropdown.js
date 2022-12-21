export default class DistributionDropdown {
  constructor() {
    this.elem = document.querySelector('.distribution-dropdown');

    if (this.elem !== null) {
      this.addEventListeners();
    }
  }

  addEventListeners() {
    this.elem.addEventListener('mouseover', (event) => {
      this.elem.querySelector('.distribution-icon').classList.add('rotated');
      this.elem.querySelector('.options-list').classList.remove('hidden');
    });

    this.elem.addEventListener('mouseleave', (event) => {
      this.elem.querySelector('.distribution-icon').classList.remove('rotated');
      this.elem.querySelector('.options-list').classList.add('hidden');
    });
  }
}
