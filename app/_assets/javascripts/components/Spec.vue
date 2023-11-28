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
      :active-operation="props.activeOperation"
      @clicked-view-spec="triggerViewSpecModal"
    />

    <ViewSpecModal
      :is-visible="viewSpecModalIsVisible"
      :spec-contents="specContents"
      :spec-name="specName"
      :download-callback="downloadSpecContents"
      @close="closeModal"
    />
  </div>
</template>

<script setup>
import { SpecDetails } from '@kong-ui-public/spec-renderer'
import { ref, onMounted, watch } from 'vue'
import ApiService from '~/javascripts/services/api.js'
import ViewSpecModal from '~/javascripts/components/ViewSpecModal.vue'
import jsyaml from 'js-yaml'

const props = defineProps({
  product: { type: Object },
  productVersionId: { type: String },
  activeOperation: { type: Object }
});

const loading = ref(true);
const spec = ref(null);
const viewSpecModalIsVisible = ref(false);
const specContents = ref('');
const specName = ref('');

const versionsAPI = new ApiService().versionsAPI;

onMounted(async () => {
  await fetchSpec();
});

watch(() => props.product, async () => {
  await fetchSpec();
})

async function fetchSpec() {
  if (!props.product) {
    return;
  }

  loading.value = true;

  return await versionsAPI.getProductVersionSpec({
    productId: props.product?.id,
    productVersionId: props.productVersionId
  }).then(async res => {
    const parsedSpec = jsyaml.load(res.data.content);

    spec.value = parsedSpec;
  }).catch(e => {
    console.log(e)
  }).finally(() => {
    loading.value = false;
  });
}

function closeModal () {
  viewSpecModalIsVisible.value = false;
}

function triggerViewSpecModal () {
  viewSpecModalIsVisible.value = true;
  specContents.value = getSpecContents();
}

function getSpecContents () {
  return JSON.stringify(spec.value, null, 2);
}

function downloadSpecContents (){
  let extension;
  let fileName = window.location.pathname.split('/').slice(1, -1).join('-');
  const content = specContents.value;
  const element = document.createElement('a');

  try {
    JSON.parse(content);
    extension = '.json';
  } catch (e) {
    extension = '.yaml';
  }

  element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(specContents.value));
  element.setAttribute('download', fileName + extension);
  element.style.display = 'none';
  document.body.appendChild(element);
  element.click();
  document.body.removeChild(element);
}
</script>

<style lang="scss">
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
  z-index: 10;
}
</style>
