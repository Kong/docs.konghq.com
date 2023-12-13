import { createApp } from 'vue';
import SearchApp from '~/javascripts/views/SearchApp/Index.vue';
import InstantSearch from 'vue-instantsearch/vue3/es';

const app = createApp(SearchApp);
app.use(InstantSearch);
app.mount('#search-app');
