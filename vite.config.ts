import { defineConfig, loadEnv } from 'vite';
import RubyPlugin from 'vite-plugin-ruby';
import inject from '@rollup/plugin-inject';
import vue from '@vitejs/plugin-vue';
import dns from 'dns';

function mutateCookieAttributes(proxy) {
  proxy.on('proxyRes', function (proxyRes, req, res) {
    if (proxyRes.headers['set-cookie']) {
      proxyRes.headers['set-cookie'] = proxyRes.headers['set-cookie'].map(h => {
        return h.replace(/Domain=.*;/, 'Domain=localhost; Secure;');
      });
    }
  });
}

// 🧯 Fixes failing smoke test: fallbacks if VITE_PORTAL_API_URL is unset
function setHostHeader(proxy) {
  const rawUrl = process.env.VITE_PORTAL_API_URL || 'http://localhost:3000'; // fallback added here
  let host;

  try {
    host = new URL(rawUrl).hostname;
  } catch (e) {
    console.warn('⚠️ Invalid VITE_PORTAL_API_URL. Using localhost as fallback.');
    host = 'localhost'; // fallback to prevent crash
  }

  proxy.on('proxyReq', function (proxyRes) {
    proxyRes.setHeader('host', host);
  });
}

export default ({ command, mode }) => {
  process.env = { ...process.env, ...loadEnv(mode, process.cwd()) };

  // Sets VITE_INDEX_API_URL which is templated in index.html
  process.env.VITE_INDEX_API_URL =
    command === 'serve' ? '/' : process.env.VITE_PORTAL_API_URL;

  // Defaults locale to en
  process.env.VITE_LOCALE = process.env.VITE_LOCALE || 'en';

  // 🧯 Fixes failing smoke test: define default if not set
  let portalApiUrl = process.env.VITE_PORTAL_API_URL || 'http://localhost:3000'; // fallback added
  if (!portalApiUrl.endsWith('/')) {
    portalApiUrl += '/';
  }

  const subdomainR = new RegExp(/http:\/\/(.*)localhost/);
  if (subdomainR.test(portalApiUrl)) {
    portalApiUrl = 'http://localhost' + portalApiUrl.replace(subdomainR, '');
  }

  // Prevents 127.0.0.1 rewrite in local dev
  dns.setDefaultResultOrder('verbatim');

  return defineConfig({
    define: {
      'process.env.development': JSON.stringify('development'),
      'process.env.production': JSON.stringify('production')
    },
    build: {
      commonjsOptions: {
        include: [/@kong\/kongponents/, /node_modules/]
      },
      rollupOptions: {
        external: ['shiki/onig.wasm']
      }
    },
    plugins: [
      inject({
        $: 'jquery',
        jQuery: 'jquery'
      }),
      RubyPlugin(),
      vue()
    ],
    server: {
      cors: { origin: 'http://localhost:8888' },
      proxy: {
        '^/api': {
          changeOrigin: true,
          target: portalApiUrl,
          configure: (proxy, options) => {
            mutateCookieAttributes(proxy);
            setHostHeader(proxy);
          }
        }
      }
    }
  });
};