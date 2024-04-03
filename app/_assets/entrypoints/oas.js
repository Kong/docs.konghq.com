import { createApp } from 'vue'
import SpecView from '~/javascripts/views/SpecView.vue'
import Kongponents from '@kong/kongponents'
import '@kong/kongponents/dist/style.css'
import '@kong-ui-public/spec-renderer/dist/style.css'

window.addEventListener('DOMContentLoaded', (event) => {
  const app = document.getElementById('app');

  if (app.length !== 0) {
    const app = createApp(SpecView);

    app.use(Kongponents);
    app.mount('#app');
  }
});
