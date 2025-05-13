<template>
  <div v-if="tableOfContents" class="sidebar-mobile">
    <button
      type="button"
      @click="openSlideoutToc"
    >
      <MenuIcon />
    </button>
  </div>

  <div>
    <KSlideout
      v-if="!loading && tableOfContents"
      :title="parsedDocument?.name || 'Table of Contents'"
      :visible="slideoutTocVisible"
      @close="hideSlideout"
    >
      <SpecRendererToc
        v-if="slideoutTocVisible"
        navigation-type="hash"
        :base-path="basePath"
        :table-of-contents="tableOfContents"
        :control-address-bar="true"
        :current-path="currentPathTOC"
        @item-selected="itemSelected"
      />
    </KSlideout>

    <KSkeleton v-if="loading" type="spinner" class="spinner"/>

    <div v-if="!loading" class="app-container">
      <aside class="sidebar">
        <KSelect
          :items="versions"
          @selected="onVersionSelect"
          class="mt-2"
        />

        <SpecRendererToc
          v-if="!loading && tableOfContents && !slideoutTocVisible"
          navigation-type="hash"
          :base-path="basePath"
          :table-of-contents="tableOfContents"
          :control-address-bar="true"
          :current-path="currentPathTOC"
          @item-selected="itemSelected"
        />
      </aside>

      <div class="spec-content">
        <div class="breadcrumbs">
          <KBreadcrumbs :items="breadcrumbs" />
        </div>

        <KAlert
          show-icon
          v-if="pageI18n"
          class="deprecated-warning"
          :message=pageI18n.banner
        />

        <SpecDocument
          v-if="!loading && parsedDocument"
          :document="parsedDocument"
          navigation-type="hash"
          :base-path="basePath"
          :control-address-bar="true"
          @content-scrolled="onDocumentScroll"
          :current-path="currentPathDOC"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { onBeforeMount, ref, watch, computed } from 'vue';
import { SpecDocument, SpecRendererToc, parseSpecDocument,  parsedDocument, tableOfContents } from '@kong/spec-renderer';
import ApiService from '../services/api.js';
import { KSkeleton, KSelect, KSlideout } from '@kong/kongponents';
import { MenuIcon } from '@kong/icons'
import '@kong/kongponents/dist/style.css';

const loading = ref(true);
const versionsAPI = new ApiService().versionsAPI;
const productId = ref(window.oas.product.id);
const productVersionId = ref(window.oas.version.id);
const specText = ref('');
const currentPathTOC = ref(window.location.hash.substring(1));
const currentPathDOC = ref(window.location.hash.substring(1));
const basePath = window.location.pathname;
const slideoutTocVisible = ref(false)
const pageI18n = ref(window.pageI18n);

const versions = window.versions.map((v) => {
  return { ...v, selected: v.id === productVersionId.value };
});

const breadcrumbs = computed(() => {
  return [
    { key: 'product-catalog', to: '/api/', text: 'Catalog' },
  ];
});

onBeforeMount(async () =>  {
  await fetchSpec();
})

watch((specText), async (newSpecText, oldSpecText) => {
  await parseSpecDocument(newSpecText, {
    traceParsing: false,
    specUrl: null,
    withCredentials: false,
  })
})

async function fetchSpec() {
  let response = await versionsAPI.getProductVersionSpec({
    productId: productId.value,
    productVersionId: productVersionId.value,
  }).catch(e => {
    console.log(e)
  }).finally(() => {
    loading.value = false;
  });
  specText.value = response.data.content
}

const onDocumentScroll = (path) => {
  currentPathTOC.value = path
  // we need to re-calculate initiallyExpanded property based on the new path
  window.history.pushState({}, '', basePath + path)
}

const itemSelected = (id) => {
  currentPathTOC.value = id;
  currentPathDOC.value = id;

  slideoutTocVisible.value = false;
}

const onVersionSelect = (version) => {
  let path = version.value;
  if (window.location.hash !== '') {
    path += window.location.hash;
  }
  window.location.href = path;
  return;
}

const hideSlideout = () => {
  slideoutTocVisible.value = false
}

const openSlideoutToc = async () => {
  slideoutTocVisible.value = true
}
</script>

<style scoped>
.app-container {
  display: flex;
  gap: 40px;
  padding: 0 40px;
}

.spec-content {
  display: flex;
  flex-direction: column;
  width: 100%;
  margin-top: 160px;
}

.sidebar {
  display: none;
  position: sticky;
  left: 0;
  top: 160px;
  flex-direction: column;
  gap: 12px;
  width: 256px;
  flex-shrink: 0;
  height: 100vh;

  @media (min-width: 768px) {
    display: flex;
  }
}

.sidebar-mobile {
  display: flex;
  position: sticky;
  top: 135px;

  @media (min-width: 768px) {
    display: none;
  }
}

.breadcrumbs {
  display: flex;
}

.spinner {
  display: flex;
  justify-content: center;
  align-items: center;
  margin-left: auto;
  margin-right: auto;
  min-height: 208px;
}

.deprecated-warning.k-alert {
  border-radius: 0;
  position: sticky;
  top: 0;
  z-index: 1;
}
:deep(.input) {
  height: auto !important;
  margin-bottom: unset !important;
}

:deep(summary) {
  background-color: inherit !important;
}

:deep(details[open] summary:before) {
  content: none;
}

:deep(details summary:before) {
  content: none;
}

:deep(.table-of-contents) {
  height: 100%;
}
</style>
