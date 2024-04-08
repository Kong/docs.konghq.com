<template>
  <ais-instant-search
    :search-client="searchClient"
    index-name="konghq"
    :routing="routing"
    :future="{ preserveSharedStateOnUnmount: true }"
  >
    <ais-configure
      :hits-per-page.camel="12"
      :attributes-to-snippet.camel="['content:15', 'description:15']"
      ruleContexts='landing'
      v-bind="searchParameters"
    />
    <header class="header" id="header">
      <ais-search-box
        placeholder="Search the docs..."
        :autofocus=true
        :show-loading-indicator=true
      />
    </header>

    <main class="search-container">
      <div class="search-container-wrapper">
        <section class="search-container-filters">
          <div class="search-container-header">
            <h2>Filters</h2>

            <ais-clear-refinements data-layout="desktop">
              <template #resetLabel>
                <div class="clear-filters">
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="10"
                    height="10"
                    viewBox="0 0 11 11"
                  >
                    <g fill="none" fill-rule="evenodd" opacity=".4">
                      <path d="M0 0h11v11H0z" />
                      <path
                        fill="#000"
                        fill-rule="nonzero"
                        d="M8.26 2.75a3.896 3.896 0 1 0 1.102 3.262l.007-.056a.49.49 0 0 1 .485-.456c.253 0 .451.206.437.457 0 0 .012-.109-.006.061a4.813 4.813 0 1 1-1.348-3.887v-.987a.458.458 0 1 1 .917.002v2.062a.459.459 0 0 1-.459.459H7.334a.458.458 0 1 1-.002-.917h.928z"
                      />
                    </g>
                  </svg>
                  Clear filters
                </div>
              </template>
            </ais-clear-refinements>
          </div>

          <div class="search-container-body">
            <ais-panel>
              <template #header> Products </template>

              <template #default>
                <ais-refinement-list
                  attribute="product"
                  :sort-by="['name']"
                />
              </template>
            </ais-panel>

            <ais-panel>
              <template #header> Versions </template>

              <template #default>
                <ais-refinement-list
                  attribute="version"
                  :sort-by="['name:desc']"
                  show-more
                />
              </template>
            </ais-panel>
          </div>
        </section>

        <footer class="search-container-filters-footer" data-layout="mobile">
          <ais-clear-refinements
            class="search-container-filters-footer-button-wrapper"
            @click="closeFilters"
          />

          <ais-stats class="search-container-filters-footer-button-wrapper">
            <template #default="{ nbHits }">
              <button class="button button-primary" @click="closeFilters">
                See results
              </button>
            </template>
          </ais-stats>
        </footer>
      </div>

      <section class="search-container-results">

        <KAlert
          show-icon
          v-if="pageI18n"
          class="missing-translation-banner"
          :message=pageI18n.banner
        />

        <ais-hits :class-names="{ 'ais-Hits-item': 'card default' }" >
          <template #item="{ item }">
            <article class="hit">

              <div class="hit-info-container">
                <a :href="item.url" target="_blank">
                   <p class="hit-category">
                      {{ item.hierarchy.lvl0 }}
                    </p>
                  <div class="hit-title">
                    <ais-highlight attribute="hierarchy.lvl1" :hit="item" />
                    <ais-highlight attribute="hierarchy.lvl2" :hit="item" :class-names="{ 'ais-Highlight': 'ais-Highlight-lvl2'}"/>
                    <ais-highlight attribute="hierarchy.lvl3" :hit="item" :class-names="{ 'ais-Highlight': 'ais-Highlight-lvl3'}"/>
                  </div>
                  <p class="hit-description">
                    <ais-snippet attribute="content" :hit="item" />
                    <ais-snippet v-if="item.description" attribute="description" :hit="item" />
                  </p>

                  <p class="hit-version">
                  <span class="hit-em">{{ item.version }}</span>
                  </p>
                </a>
              </div>
            </article>
          </template>
        </ais-hits>

        <no-results />

        <footer class="search-container-footer">
          <ais-pagination
            :padding="2"
            :show-first="false"
            :show-last="false"
            />
        </footer>
      </section>
    </main>

    <aside data-layout="mobile">
      <button class="filters-button" @click="openFilters">
        <svg xmlns="http://www.w3.org/2000/svg" viewbox="0 0 16 14">
          <path
              d="M15 1H1l5.6 6.3v4.37L9.4 13V7.3z"
              stroke="#fff"
              stroke-width="1.29"
              fill="none"
              fill-rule="evenodd"
              stroke-linecap="round"
              stroke-linejoin="round"
              />
        </svg>

        Filters
      </button>
    </aside>

  </ais-instant-search>
</template>

<script>
import { ref } from 'vue'
import {
  AisInstantSearch,
  AisClearRefinements,
  AisRefinementList,
  AisConfigure,
  AisSearchBox,
  AisHits,
  AisPagination,
} from 'vue-instantsearch/vue3/es';

import { KAlert } from '@kong/kongponents'
import '@kong/kongponents/dist/style.css'

import algoliasearch from 'algoliasearch/lite';
import NoResults from './NoResults.vue';
import { routing } from './routing.js';

import 'instantsearch.css/themes/reset.css';
import './Theme.css';
import './App.css';
import './App.mobile.css';

export default {
  components: {
    AisInstantSearch,
    AisClearRefinements,
    AisRefinementList,
    AisConfigure,
    AisSearchBox,
    AisHits,
    AisPagination,
    NoResults,
    KAlert
  },
  setup() {
    const pageI18n = ref(window.pageI18n)
    return {
      pageI18n
    }
  },
  data() {
    return {
      searchClient: algoliasearch(
        '05Y6TLHNFZ',
        '80483bfe28d9fd036a11a6f6a06454f8',
      ),
      routing,
      searchParameters: {
        optionalFilters: ['version:latest<score=1>', 'product:Kong Gateway<score=3>', 'product:Kong Konnect<score=2>', 'product:Kong Mesh<score=1>']
      }
    };
  },
  created() {
    this.onKeyUp = (event) => {
      if (event.key !== 'Escape') {
        return;
      }
      this.closeFilters();
    };

    this.onClick = (event) => {
      if (event.target !== this.header) {
        return;
      }

      this.closeFilters();
    };
  },
  mounted() {
    this.resultsContainer = document.querySelector('.search-container-results');
    this.header = document.querySelector('#header');

    this.$nextTick(function () {
      window.addEventListener('keydown', event => {
        if(event.metaKey && event.key === 'k') {
          this.$el.querySelector('input').focus();
          event.preventDefault();
        }
      })
    })
  },
  methods: {
    openFilters() {
      document.body.classList.add('filtering');
      window.scrollTo(0, 0);
      window.addEventListener('keyup', this.onKeyUp);
      window.addEventListener('click', this.onClick);
    },
    closeFilters() {
      document.body.classList.remove('filtering');
      this.resultsContainer.scrollIntoView();
      window.removeEventListener('keyup', this.onKeyUp);
      window.removeEventListener('click', this.onClick);
    }
  },
};
</script>

<style scoped>
.missing-translation-banner {
  background-color: #f2f6fe !important;
  border-left: solid 3px #3972d5;
  color: inherit !important;
  margin-bottom: 1em;
  padding: 15px;
  border-radius: 2px;
}

.missing-translation-banner :deep(.alert-icon-container) {
  color: #3972d5;
}
</style>
