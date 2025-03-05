import { createApp } from 'vue'
import SpecView from '~/javascripts/views/SpecView.vue'
import Kongponents from '@kong/kongponents'
import '@kong/kongponents/dist/style.css'
import "@kong/spec-renderer-dev/dist/style.css";

window.addEventListener('DOMContentLoaded', (event) => {
  const app = document.getElementById('app');

  if (app.length !== 0) {
    const app = createApp(SpecView);

    app.use(Kongponents);
    app.mount('#app');
  }
});
