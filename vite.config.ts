import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import inject from '@rollup/plugin-inject';

export default defineConfig({
  plugins: [
    inject({
      $: 'jquery',
      jQuery: 'jquery',
    }),
    RubyPlugin(),
  ]
})
