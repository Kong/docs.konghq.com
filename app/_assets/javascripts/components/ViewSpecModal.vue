<template>
  <div class="view-spec-modal">
    <KModal
      :close-on-backdrop-click="true"
      :visible="visible"
      hide-close-icon
      title="View Spec"
      @canceled="closeModal"
    >
      <template #title>
        <span class="color-text_colors-primary">View Spec</span>
      </template>

      <span>
        <code>
          <!--
            eslint-disable vue/no-mutating-props
            specContents is from props and not to be changed. The no-mutating-props
            rule does not take into account that even though textarea is an editable element,
            ours is disabled meaning no mutation
          -->
          <textarea
            id="spec-area"
            :value="specContents"
            disabled
          />
        </code>
      </span>

      <template #footer-actions>
        <KClipboardProvider v-slot="{ copyToClipboard }">
          <KButton
            class="copy"
            appearance="primary"
            data-testid="copy-btn"
            @click="copySpec(copyToClipboard)"
          >
           Copy
          </KButton>
        </KClipboardProvider>
        <KButton
          class="ml-2"
          appearance="secondary"
          data-testid="download-btn"
          type="submit"
          @click="downloadCallback"
        >
          Download
        </KButton>
        <KButton
          data-testid="close-btn"
          class="close"
          style="margin-left: auto;"
          appearance="secondary"
          @click="closeModal"
        >
          Close
        </KButton>
      </template>
    </KModal>
  </div>
</template>

<script setup>
import useToaster from '../composables/useToaster.js'

const props = defineProps({
  specName: {
    type: String,
    default: ''
  },
  specContents: {
    type: String,
    default: ''
  },
  visible: {
    type: Boolean,
    default: false
  },
  downloadCallback: {
    type: Function,
    required: true
  }
})

const emit = defineEmits(['close'])

const { notify } = useToaster()

const closeModal = () => {
  emit('close')
}

const copySpec = (executeCopy) => {
  if (!executeCopy(props.specContents)) {
    notify({
      appearance: 'danger',
      message: 'Failed to copy id to clipboard'
    })
  }

  notify({
    message: 'Copied to clipboard'
  })
}
</script>

<style lang="scss" scoped>
#spec-area {
  width: 100%;
  height: 300px;
  overflow: scroll;
  white-space: pre;
  color: var(--text_colors-primary);
  background-color: var(--kui-color-background-neutral-weakest, #f9fafb);
  margin: 0;
  padding: var(--spacing-md);
  font-size: var(--type-xs);
  font-family: var(--font-family-mono);
  border-width: 0;
  box-shadow: none;
}
code {
  background: none;
}

.view-spec-modal :deep(.modal-footer .footer-actions) {
  width: 100% !important;
  margin-left: 0 !important;
}
</style>
