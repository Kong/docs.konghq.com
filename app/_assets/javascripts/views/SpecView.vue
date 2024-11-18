<template>
  <EmptyState
    v-if="productError"
    is-error
    class="mt-6"
    :message="productError"
  />
  <template v-else>
    <div v-if="activeProductVersionId" class="app-container flex pb-0 product fixed-position">
      <div class="sidebar-wrapper">
        <Sidebar
          class="sidebar"
          :product="product"
          :active-product-version-id="activeProductVersionId"
          @operation-selected="onOperationSelected"
        />
      </div>

      <div class="spec-content">
        <KAlert
          show-icon
          v-if="pageI18n"
          class="deprecated-warning"
          :message=pageI18n.banner
        />
        <KAlert
          v-if="deprecatedProductVersion"
          appearance="warning"
          class="deprecated-warning"
          message="This product version is now deprecated. The endpoints will remain fully usable until this version is sunsetted."
        />

        <div class="swagger-ui has-sidebar breadcrumbs">
          <KBreadcrumbs :items="breadcrumbs" />
        </div>

        <Spec
          :product="product"
          :product-version-id="activeProductVersionId"
          :active-operation="activeOperation"
        />
      </div>
    </div>
  </template>
</template>

<script setup>
import { computed, onMounted, ref, watch, reactive } from 'vue'
import { sortByDate } from '~/javascripts/helpers/sortBy.js'
import { fetchAll } from '~/javascripts/helpers/fetchAll.js'
import getMessageFromError from '~/javascripts/helpers/getMessageFromError.js'
import ApiService from '~/javascripts/services/api.js'
import EmptyState from '../components/EmptyState.vue'
import Spec from '../components/Spec.vue'
import Sidebar from '../components/Sidebar.vue'

const product = ref(null);
const activeProductVersionId = ref(null);
const activeProductVersionName= ref(null);
const productIdParam = ref(window.oas.product.id);
const productVersionParam = ref(window.oas.version.id);
const pageI18n = ref(window.pageI18n);

const productsAPI = new ApiService().productsAPI;
const versionsAPI = new ApiService().versionsAPI;
const activeOperation = ref(null);
const state = reactive({ activeOperation });
const productError = ref(null);
const deprecatedProductVersion = ref(false);

const breadcrumbs = computed(() => {
  return [
    { key: 'product-catalog', to: '/api/', text: 'Catalog' },
    { key: 'api-product', title: product.value.name, text: product.value.name }
  ];
});

function onOperationSelected(event) {
  activeOperation.value = event;
}

onMounted(async () => {
  await fetchProduct();
  initActiveProductVersionId();
})

async function fetchProduct () {
  const id = productIdParam.value;

  try {
    const { data } = await productsAPI.getProduct({ productId: id })

    const productWithVersion = {
      ...data,
      versions: await fetchAll(meta => versionsAPI.listProductVersions({ ...meta, productId: id }))
    }

    product.value = productWithVersion;
  } catch (err) {
    console.error(err);
    productError.value = getMessageFromError(err);
  }
}

function initActiveProductVersionId () {
  if (!product.value) {
    return
  }

  const versions = product.value.versions
    .slice()
    .sort(sortByDate('created_at'))

  if (!versions) {
    return
  }

  const val = productVersionParam.value?.toLowerCase()
  if (val) {
    const newProductVersion = versions.find(
      (productVersion) => productVersion.id === val || productVersion.name?.toLowerCase() === val
    )

    if (newProductVersion) {
      activeProductVersionId.value = newProductVersion.id;
      deprecatedProductVersion.value = newProductVersion.deprecated;
    }
  }

  if (!activeProductVersionId.value) {
    activeProductVersionId.value = versions[0]?.id
  }
}
</script>

<style scoped>
.app-container {
  display: flex;
}

.app-container .breadcrumbs {
  position: relative;
  left: var(--spacing-xl);
  top: var(--spacing-xl);
}

.breadcrumbs :deep(.k-breadcrumbs .k-breadcrumbs-item .k-breadcrumb-divider) {
  line-height: 0;
}

.sidebar-wrapper {
  flex: 0 0 auto;
  position: sticky;
  height: calc(100vh - 60px);
  margin-top: 60px;
  top: 60px;
  border-right: 1px solid var(--section_colors-stroke);
}
.sidebar {
  height: 100%;
  overflow-y: auto;
}
.spec-content {
  flex: 1 1 auto;
  overflow: auto;
  margin-top: 60px;
}
.deprecated-warning.k-alert {
  border-radius: 0;
  position: sticky;
  top: 0;
  z-index: 1;
}
.product .deprecated-alert {
  padding: 14px;
  font-family: inherit;
  font-size: 1rem;
  border-radius: 4px;
  color: var(--KAlertWarningColor, var(--yellow-500, color(yellow-500)));
  border-color: var(--KAlertWarningBorder, var(--yellow-200, color(yellow-200)));
  background-color: var(--KAlertWarningBackground, var(--yellow-100, color(yellow-100)));
}

.product .container .breadcrumbs {
  position: relative;
  left: var(--spacing-xs)
}

.product .swagger-ui .version-pragma {
  display: none;
}

.product .header-anchor {
  position: relative;
}

.product .header-anchor svg {
  position: absolute;
  left: -1.5rem;
  bottom: 0;
}
</style>
