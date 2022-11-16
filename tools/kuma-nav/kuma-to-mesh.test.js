const k2m = require("./kuma-to-mesh");

test("runs", () => {
  const r = k2m(__dirname + "/fixtures/kuma.yml");
  console.log(r);
});
