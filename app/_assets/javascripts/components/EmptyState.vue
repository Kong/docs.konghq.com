<template>
  <KEmptyState
    data-testid="empty-state-card"
    cta-is-hidden
    :is-error="isError"
  >
    <template
      v-if="!isError"
      #title
    >
      <slot name="title">
        {{ title }}
      </slot>
    </template>
    <template #message>
      <slot name="message">
        {{ displayMessage }}
      </slot>
    </template>
  </KEmptyState>
</template>

<script lang="ts">
import { defineComponent } from 'vue'

export default defineComponent({
  name: 'EmptyState',
  props: {
    isError: {
      type: Boolean,
      default: false
    },
    title: {
      type: String,
      default: ''
    },
    message: {
      type: String,
      default: ''
    }
  },
  computed: {
    displayMessage () {
      return this.isError
        ? 'Error ' + this.message
        : this.message
    }
  }
})
</script>

<style lang="scss">
// !important required because kemptystate has no theming options
.empty-state-wrapper {
  color: var(--text_colors-primary) !important;
  border-color: var(--section_colors-stroke) !important;
  background-color: var(--section_colors-hero) !important;

  .k-empty-state-message {
    color: var(--text_colors-primary) !important;
  }

  .k-empty-state-title-header {
    color: var(--text_colors-headings) !important;
  }

  svg {
    display: inline-block;
    margin: 0 auto;
  }
}
</style>
