import axios from 'axios'
import { ajax } from 'jquery'

export default class Form {
  constructor(form) {
    if (form) {
      this.elem = form;
    } else {
      this.elem = document.querySelector('.form-wrapper form');
    }

    if (this.elem !== null) {
      this.setupInputs();
      this.addEventListeners();
    }
  }

  addEventListeners() {
    this.elem.addEventListener('submit', (event) => {
      const formData = new FormData(this.elem);
      event.preventDefault();

      ajax({
        url: formData.get('pardot-link'),
        type: this.elem.method || 'GET',
        dataType: 'jsonp',
        crossDomain: true,

        data: $(this.elem).serialize(),
        xhrFields: {
          withCredentials: true
        },
        beforeSend: () => {
          this.elem.querySelector('.submit_text').classList.add('is-hidden');
          this.elem.querySelector('.btn').classList.add('is-sending');
          this.elem.querySelector('.spinner').classList.remove('hidden');
        },
        success: (data, textStatus) => {
          this.elem
            .parentNode
            .querySelector('.form-success')
            .classList.remove('hidden')
        },
        error: (data, textStatus) => {
          this.elem
            .parentNode
            .querySelector('.form-error')
            .classList.remove('hidden');
        },
        complete: (data, textStatus) => {
          this.elem.remove();
        }
      })
    });
  }

  setupInputs() {
    const queryString = window.location.search;
    const params = new URLSearchParams(queryString);

    this.elem.querySelector("input[name='utm_content']").value = params.get('utm_content');
    this.elem.querySelector("input[name='utm_medium']").value = params.get('utm_medium');
    this.elem.querySelector("input[name='utm_source']").value = params.get('utm_source');
    this.elem.querySelector("input[name='utm_campaign']").value = params.get('utm_campaign');
    this.elem.querySelector("input[name='utm_term']").value = params.get('utm_term');
    this.elem.querySelector("input[name='utm_ad_group']").value = params.get('utm_ad_group');
  }
}
