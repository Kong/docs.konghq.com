<template>
  <aside>
    <KSkeleton v-if="isLoading" />
    <div v-else class="px-5 py-6 sidebar-content">
      <header class="mb-3">
        <h2>{{ props.product.title }}</h2>
        <KSelect
          appearance="select"
          class="version-select-dropdown"
          width="100%"
          data-testid="version-select-dropdown"
          :enable-filtering="false"
          :items="versionSelectItems"
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
import { ref, onMounted } from 'vue'
import { SpecOperationsList } from '@kong-ui-public/spec-renderer'
import ApiService from '~/javascripts/services/api.js'

const props = defineProps({
  product: { type: Object, required: true },
  activeProductVersionId: { type: String, required: true }
});

const emit = defineEmits(['operationSelected']);
const versionSelectItems = ref([]);
const isLoading = ref(true);
const operations = ref(null);
const versionsAPI = new ApiService().versionsAPI;

onMounted(async () => {
  const operationsResponse = await fetchOperations();
  operations.value = operationsResponse;

  updateVersionSelectItems();
});

function updateVersionSelectItems () {
  versionSelectItems.value = props.product.versions
    .slice()
    .sort((a, b) => new Date(a.created_at).getTime() - new Date(b.created_at).getTime())
    .map((productVersion) => ({
      value: productVersion.id,
      label: `${productVersion.name}${productVersion.deprecated ? ' (Deprecated)' : ''}`,
      selected: productVersion.id === props.activeProductVersionId
    })) || []
}

async function fetchOperations () {
  const productId = props.product.id;
  isLoading.value = true;

  try {
    const res = await versionsAPI.getProductVersionSpecOperations({
      productId,
      versionId: props.activeProductVersionId
    });

    return res.data.operations?.map(operation => ({
      ...operation,
      operationId: operation.operation_id
    }));
  } catch (err) {
    console.error(err);
  } finally {
    isLoading.value = false;
  }
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
