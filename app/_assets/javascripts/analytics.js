import { AnalyticsBrowser } from '@segment/analytics-next'

window.analytics = new AnalyticsBrowser();

analytics
  .load({ writeKey: 'X7EZTdbdUKQ8M6x42SHHPWiEhjsfs1EQ' })
  .catch(function(error) { console.log(error) });
