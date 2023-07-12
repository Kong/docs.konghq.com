<template>
  <div class=" spec mt-6 api-documentation">
    <div v-if="loading" class="spec-loading-container">
      <div>
        <KIcon
          icon="spinner"
          size="96"
          color="var(--steel-300)"
        />
      </div>
    </div>

    <SpecDetails
      v-else-if="spec"
      class="w-100"
      :document="spec"
      :activeOperation="props.activeOperation"
    />
  </div>
</template>

<script setup>
import { SpecDetails } from '@kong-ui-public/spec-renderer'
import { ref, onMounted } from 'vue'
import ApiService from '~/javascripts/services/api.js'
import jsyaml from 'js-yaml'

const props = defineProps({
  product: { type: Object, required: true },
  productVersionId: { type: String },
  activeOperation: { type: Object }
});

const loading = ref(false);
const spec = ref(null);
const versionsAPI = new ApiService().versionsAPI;

onMounted(async () => {
  const specResponse = await fetchSpec();
  spec.value = specResponse;
});

async function fetchSpec(version) {
  loading.value = true;

  return await versionsAPI.getProductVersionSpec({
    productId: props.product.id,
    versionId: props.productVersionId
  }).then(async res => {
    const parsedSpec = jsyaml.load(res.data.content);

    return parsedSpec;
  }).catch(e => {
    return e.response;
  }).finally(() => {
    loading.value = false;
  });
}
</script>

<style lang="scss">
.spec {
  .swagger-ui .version-pragma {
    display: none;
  }

  .header-anchor {
    position: relative;

    svg {
      position: absolute;
      left: -1.5rem;
      bottom: 0;
    }
  }
}

.spec-loading-container {
  align-items: center;
  background-color: #fff;
  display: flex;
  height: 50%;
  justify-content: center;
  left: 0;
  position: absolute;
  top: 60px;
  width: 100%;
  z-index: 10000;
}

.spec.api-documentation .breadcrumbs {
  margin-left: 0;
}
</style>
