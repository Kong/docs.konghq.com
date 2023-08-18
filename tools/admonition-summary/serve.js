const http = require("http");

const finalhandler = require("finalhandler");
const serveStatic = require("serve-static");

const serve = serveStatic("./dist/site");

module.exports = function () {
  const server = http.createServer(function (req, res) {
    const done = finalhandler(req, res);
    serve(req, res, done);
  });

  console.log("Listening on http://localhost:8000");
  console.log("Press Ctrl-C to stop");
  server.listen(8000);
};

if (require.main == module) {
  module.exports();
}
