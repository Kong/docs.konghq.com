import { AnalyticsBrowser } from '@segment/analytics-next'

if (import.meta.env.VITE_JEKYLL_ENV === 'production') {
  window.analytics = AnalyticsBrowser.load({ writeKey: 'X7EZTdbdUKQ8M6x42SHHPWiEhjsfs1EQ' })
}
