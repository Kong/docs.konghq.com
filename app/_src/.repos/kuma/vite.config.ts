import { resolve } from 'path'
import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import WindiCSS from 'vite-plugin-windicss'

export default defineConfig({
  plugins: [
    RubyPlugin(),
    WindiCSS({
      root: __dirname,
      configFiles: [resolve(__dirname, 'windi.config.ts')],
      scan: {
        dirs: [
          'app/_layouts', 'app/_includes', 'app/_posts', 'app/_assets', 'app/community', 'app/cookie-policy',
          'app/docs', 'app/enterprise', 'app/install', 'app/policies', 'app/privacy', 'app/resources',
          'app/servicemeshcon', 'terms', 'app/use-cases'
        ],
      },
    }),
  ],
  css: {
    preprocessorOptions: {
      scss: { additionalData: ["@import '@/styles/custom/config/variables', '@/styles/vuepress-core/config', '@/styles/custom/config/fonts', '@/styles/custom/config/mixins', '@/styles/custom/base/forms';"] },
    },
  },
})
