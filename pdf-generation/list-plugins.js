const fg = require('fast-glob')

module.exports = async function (plugin, version) {
  plugin = plugin || '*'
  version = version || 'index'
  let files = await fg(`../app/_hub/kong-inc/${plugin}/${version}.md`)
  files = files.map((f) => {
    return f.replace('../app/_hub/', '/hub/').replace(/\.md$/, '.html')
  })

  // Prefix with URL
  files = files.map((f) => {
    return `http://localhost:3000${f}`
  })

  return files
}
