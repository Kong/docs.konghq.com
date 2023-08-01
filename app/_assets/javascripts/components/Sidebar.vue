<template>
  <aside>
    <KSkeleton v-if="isLoading" />
    <div v-else class="px-5 py-6 content">
      <header class="mb-3">
        <h2>{{ props.product?.name }}</h2>
        <KSelect
          appearance="select"
          class="version-select-dropdown"
          width="100%"
          data-testid="version-select-dropdown"
          :enable-filtering="false"
          :items="versionSelectItems"
          @selected="onSelectedVersion"
        />
      </header>
      <section>
        <SpecOperationsList
          v-if="operations"
          :operations="operations"
          width="100%"
          class="operations-list"
          @selected="emit('operationSelected', $event)"
        />
      </section>
    </div>
  </aside>
</template>

<script setup>
import { ref, onMounted, watch } from 'vue'
import { SpecOperationsList } from '@kong-ui-public/spec-renderer'
import ApiService from '~/javascripts/services/api.js'

const props = defineProps({
  product: { type: Object },
  activeProductVersionId: { type: String }
});

const versionSelectItems = ref([])
const isLoading = ref(true);
const operations = ref(null);
const versionsAPI = new ApiService().versionsAPI;

const emit = defineEmits(['operationSelected']);

onMounted(async () => {
  await fetchOperations();

  updateVersionSelectItems();
});

watch([
  () => props.product,
  () => props.activeProductVersionId
], async () => {
  await fetchOperations();
  updateVersionSelectItems();
})

function updateVersionSelectItems () {
  versionSelectItems.value = props.product?.versions
    .slice()
    .sort((a, b) => new Date(a.created_at).getTime() - new Date(b.created_at).getTime())
    .map((productVersion) => ({
      value: productVersion.id,
      label: `${productVersion.name}${productVersion.deprecated ? ' (Deprecated)' : ''}`,
      selected: productVersion.id === props.activeProductVersionId
    })) || []
}

async function fetchOperations () {
  if (!props.product) {
    return;
  }
  const productId = props.product?.id;
  isLoading.value = true;

  try {
    const res = await versionsAPI.getProductVersionSpecOperations({
      productId,
      versionId: props.activeProductVersionId
    });

    operations.value = res.data.operations?.map(operation => ({
      ...operation,
      operationId: operation.operation_id
    }));
  } catch (err) {
    console.error(err);
  } finally {
    isLoading.value = false;
  }
}

function onSelectedVersion (event) {
  const version = props.product.versions.find((productVersion) => productVersion.id === event.value);
  if (!version) {
    return;
  }
  const currentPath = window.location.pathname;
  let newPathname = currentPath.split('/').slice(0, -2).concat(version.name).join('/').concat('/')
  window.location.pathname = newPathname;
}
</script>

<style scoped>
  aside {
    width: 100%;
    max-width: 260px;
  }
  .title {
    font-weight: 500;
    font-size: 20px;
    display: block;
  }
  aside {
    width: 100%;
    max-width: 260px;
  }
  .title {
    font-weight: 500;
    font-size: 20px;
    display: block;
  }
  .operations-list :deep(button) {
    height: 60px;
    line-height: 24px;
  }
  .version-select-dropdown :deep(.k-input) {
    margin-bottom: inherit;
  }
  h2 {
    margin-top: auto;
  }
</style>
