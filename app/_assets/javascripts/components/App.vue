<template>
  <div class="app-container flex pb-0 product fixed-position">
    <div class="sidebar-wrapper">
      <Sidebar
        class="sidebar"
        :product="product"
        :activeProductVersionId="versionId"
        @operation-selected="onOperationSelected"
        />
    </div>

    <div class="spec-content">
      <Spec
        :product="product"
        :productVersionId="versionId"
        :activeOperation="activeOperation"
        />
    </div>
  </div>
</template>

<script setup>
  import Spec from './Spec.vue'
  import Sidebar from './Sidebar.vue'
  import { ref, reactive } from 'vue'

  const product = window.oas.product;
  const versionId = window.oas.version.id;
  const activeOperation = ref(null);
  const state = reactive({ activeOperation });

  function onOperationSelected(event) {
    activeOperation.value = event;
  }
</script>

<style scoped>
.app-container {
  display: flex;
}

.sidebar-wrapper {
  flex: 0 0 auto;
  position: sticky;
  height: calc(100vh - 60px);
  top: 60px;
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
</style>
