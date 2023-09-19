module.exports = async function (distro, steps) {
  const Dockerode = require("dockerode");
  const streams = require("memory-streams");
  const fs = require("fs");
  const yaml = require("js-yaml");

  const config = yaml.load(fs.readFileSync("./config/setup.yaml", "utf8"));

  const stdout = new streams.WritableStream();
  const stderr = new streams.WritableStream();

  const docker = new Dockerode({ socketPath: "/var/run/docker.sock" });

  let setup = config[distro].setup;
  if (!setup) {
    throw new Error(`No setup found for ${distro}`);
  }
  setup = setup.join(" && ");

  steps = steps.join(" && ").replace("\n", " && ");
  if (steps.trim().length == 0) {
    throw new Error(`Unable to fetch install instructions from docs for ${distro}`);
  }

  const asUser = `su tester -c 'cd ~ && ${steps} && kong version'`;

  const completeString = `${setup} && ${asUser}`;

  // Pull the image
  await new Promise((resolve, reject) => {
    docker.pull(
      config[distro].image,
      { platform: "linux/amd64" },
      (err, stream) => {
        if (err) {
          return reject(err);
        }

        docker.modem.followProgress(stream, onFinished, onProgress);

        function onFinished(err, output) {
          if (err) {
            return reject(err);
          }
          return resolve(output);
        }
        function onProgress(event) {}
      },
    );
  });

  return new Promise((resolve, reject) => {
    docker.run(
      config[distro].image,
      ["bash", "-c", completeString],
      [stdout, stderr],
      { Tty: false, HostConfig: { AutoRemove: true }, platform: "linux/amd64" },
      function (err, data, container) {
        if (err) {
          return reject(err);
        }
        const lines = stdout
          .toString()
          .split("\n")
          .filter((l) => l);
        const version = lines[lines.length - 1];
        return resolve({
          version,
          stdout: stdout.toString(),
          stderr: stderr.toString(),
          jobConfig: {
            image: config[distro].image,
            commands: completeString,
          },
        });
      },
    );
  });
};
