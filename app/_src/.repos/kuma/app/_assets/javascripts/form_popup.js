import Form from '@/javascripts/form'

export default class FormPopUp {
  constructor() {
    this.elem = document.querySelector('.toast');

    if (this.elem !== null) {
      this.displayToast();
      this.addEventListeners();
      new Form(this.elem.querySelector('form'));
    }
  }

  displayToast() {
    setTimeout(() => {
      this.elem.classList.add('is-active');
    }, 3000);
  }

  addEventListeners() {
    this.elem
      .querySelector('.toast__close-button')
      .addEventListener('click', (event) => {
        this.elem.classList.remove('is-active');
      });
  }
}
