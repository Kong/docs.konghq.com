const path = require('path')
const connect = require('connect')
const serveStatic = require('serve-static')

const buildUrls = require('./build-urls')
const createPDF = require('./create-pdf')
const listVersions = require('./list-versions')
const listPlugins = require('./list-plugins')

module.exports = async function (nav) {
  // Serve the static files
  connect()
    .use(serveStatic(path.join(__dirname, '..', 'dist')))
    .listen(3000, () => console.log('Server running on :3000'))

  if (process.env.KONG_DOC_VERSIONS) {
    return await printDocs(process.env.KONG_DOC_VERSIONS)
  }

  if (process.env.KONG_PLUGIN_NAME) {
    return await printPlugin(
      process.env.KONG_PLUGIN_NAME,
      process.env.KONG_PLUGIN_VERSION
    )
  }
}

async function printDocs (nav) {
  const versions = await listVersions(nav)

  for (const v of versions) {
    const title = `${v.type}-${v.version}`
    const urls = buildUrls(v)
    await createPDF(title, urls)
  }
}

async function printPlugin (plugin, version) {
  const urls = await listPlugins(plugin, version)
  let title = plugin
  if (version) {
    title = `${title}-${version}`
  }
  await createPDF(title, urls)
}

if (require.main === module) {
  module.exports().then(() => {
    process.exit(0)
  })
}
