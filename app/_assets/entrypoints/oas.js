import App from '~/javascripts/components/App.vue'
import { createApp } from 'vue'
import Kongponents from '@kong/kongponents'

window.addEventListener("DOMContentLoaded", (event) => {
  const app = document.getElementById('app');

  if (app.length !== 0) {
    const app = createApp(App);

    app.use(Kongponents);
    app.mount('#app');
  }
});
