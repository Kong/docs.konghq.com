import { AnalyticsBrowser } from '@segment/analytics-next'

if (import.meta.env.PROD) {
  window.analytics = AnalyticsBrowser.load({ writeKey: 'X7EZTdbdUKQ8M6x42SHHPWiEhjsfs1EQ' })
}
