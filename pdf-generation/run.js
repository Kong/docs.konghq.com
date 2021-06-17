const path = require('path')
const connect = require('connect')
const serveStatic = require('serve-static')

const buildUrls = require('./build-urls')
const createPDF = require('./create-pdf')
const listVersions = require('./list-versions')

module.exports = async function (nav) {
  // Serve the static files
  connect()
    .use(serveStatic(path.join(__dirname, '..', 'dist')))
    .listen(3000, () => console.log('Server running on :3000'))

  // Generate the PDFs
  const generatedPdfs = []
  const versions = await listVersions(nav)

  for (const v of versions) {
    const title = `${v.type}-${v.version}`
    const urls = buildUrls(v)
    await createPDF(title, urls)
    generatedPdfs.push(title)
  }

  return generatedPdfs
}

if (require.main === module) {
  module.exports(process.env.KONG_DOC_VERSIONS).then(() => {
    process.exit(0)
  })
}
