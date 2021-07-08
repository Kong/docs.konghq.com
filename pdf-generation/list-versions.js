const fg = require('fast-glob')
module.exports = async function (path) {
  path = path || '*'
  const lookup = {
    ce: 'gateway-oss',
    deck: 'deck',
    ee: 'enterprise',
    gsg: 'getting-started-guide',
    kic: 'kubernetes-ingress-controller',
    konnect: 'konnect',
    mesh: 'mesh'
  }
  let files = await fg(`../app/_data/docs_nav_${path}.yml`)
  files = files
    .map((f) => {
      if (f.includes('docs_nav_contributing')) {
        return
      }
      const item = { path: f }
      const info = f.replace('../app/_data/docs_nav_', '').replace(/\.yml$/, '')

      // Special case Konnect Platform
      if (info === 'konnect_platform') {
        item.type = 'konnect-platform'
        item.version = ''
      } else {
        const x = info.split('_')
        item.type = lookup[x[0]]
        item.version = x[1]
      }
      return item
    })
    .filter((n) => n)

  if (!files.length) {
    throw new Error(`No matching version found for '${path}'`)
  }

  return files
}
