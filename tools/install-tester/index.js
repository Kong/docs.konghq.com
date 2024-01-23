if (!process.env.BASE_URL) {
  process.env.BASE_URL = "http://localhost:8888";
}

// Parse a format like [2.6.x/rhel/oss/yum-repository](linux/amd64) into
// individual conditions
if (process.env.ONLY) {
  let only = process.env.ONLY.replace("[", "")
    .replace("]", "")
    .replace(")", "");
  [only, arch] = only.split("(");
  const [version, distro, package, method] = only.split("/");
  process.env.VERSION = version;
  process.env.DISTRO = distro;
  process.env.PACKAGE = package;
  process.env.METHOD = method;
  process.env.ARCH = arch;
}

const conditions = {
  version: (process.env.VERSION || "").split(",").filter((v) => v),
  distro: (process.env.DISTRO || "").split(",").filter((v) => v),
  method: (process.env.METHOD || "").split(",").filter((v) => v),
  package: (process.env.PACKAGE || "").split(",").filter((v) => v),
  arch: process.env.ARCH,
};

const debug = require("debug")("install-tester");
const yaml = require("js-yaml");
const fs = require("fs");
if (!fs.existsSync("./output")) {
  fs.mkdirSync("./output");
}

const { extractV2, extractV3 } = require("./instruction-extractor");
const run = require("./execute-in-docker");

let allStderr = "";

const expectedFailures = yaml.load(
  fs.readFileSync("./config/expected-failures.yaml", "utf8"),
);

(async function () {
  debug("Starting Install Tester");
  const config = loadConfig();
  for (let job of config) {
    for (let distro of job.distros) {
      for (let arch of job.arch) {
        let installOptions;
        if (job.version.slice(0, 2) === "2.") {
          installOptions = await extractV2(job.version, distro);
        } else {
          installOptions = await extractV3(job.version, distro);
        }
        for (let installOption of installOptions) {
          await runSingleJob(distro, job, arch, installOption, conditions);
        }
      }
    }
  }

  if (allStderr.length) {
    console.log("STDERR OUTPUT:\n" + allStderr);
  }
})();

async function runSingleJob2(distro, job, arch, installOption, conditions) {
  console.log(arch);
  console.log(installOption);
}

async function runSingleJob(distro, job, arch, installOption, conditions) {
  const marker = `${installOption.package}@${job.version} via ${installOption.type}`;
  const ref = `${job.version}/${distro}/${
    installOption.package
  }/${installOption.type.replace(/\w+\-repository/, "repository")}`;
  const summary = `[${ref}](${arch})`;

  debug(`====== START ${marker}  ======`);

  if (
    (skip = shouldSkip(
      conditions,
      job,
      distro,
      arch,
      installOption,
      ref,
      summary,
    ))
  ) {
    if (!process.env.IGNORE_SKIPS) {
      console.log(skip);
    }
    return;
  }

  if (expectedFailures[ref]) {
    console.log(
      `🤔 ${summary} Expected failure: ${expectedFailures[ref]}. Not executing.`,
    );
    if (process.env.EXPECTED_FAILURES_EXIT_CODE && process.exitCode === 0) {
      process.exitCode = process.env.EXPECTED_FAILURES_EXIT_CODE;
    }
    return;
  }

  const expected = job.outputs[installOption.package];
  debug(`Expecting: ${expected}`);

  try {
    const { jobConfig, version, stdout, stderr } = await run(
      distro,
      installOption.blocks,
      arch,
    );
    debug(`Got: ${version}`);

    // Create a file to re-run the command in one + debug
    fs.writeFileSync(
      `./output/${job.version}-${distro}-${installOption.package}-${installOption.type}.txt`,
      `docker run --platform ${arch} -it ${
        jobConfig.image
      } bash -c "${jobConfig.commands
        .replace(/"/g, '\\"')
        .replace(
          /\$/g,
          "\\$",
        )}; sleep 100000"\n\nSTDOUT:\n${stdout}\n\nSTDERR:\n${stderr}`,
    );

    if (expected !== version) {
      console.log(`❌ ${summary} Expected: ${expected}, Got: ${version}`);
      process.exitCode = 1;

      allStderr += `\n\n---------------------------------------\n❌ ${summary}\n---------------------------------------\n${stderr}`;

      if (!process.env.CONTINUE_ON_ERROR) {
        console.log(allStderr);
        process.exit(1);
      }
    } else {
      console.log(`✅ ${summary}`);
    }
  } catch (e) {
    console.log(`⚠️ ${summary} ${e.message}`);
    if (!process.env.CONTINUE_ON_ERROR) {
      process.exit(1);
    }
  }

  debug(`====== END ${marker} ======`);
}

function shouldSkip(
  conditions,
  job,
  distro,
  arch,
  installOption,
  ref,
  summary,
) {
  if (job.skip.includes(ref)) {
    return `⌛ ${summary} skipped | Explicitly marked as skipped in jobs.yaml`;
  }

  if (conditions.arch && conditions.arch != arch) {
    return `⌛ ${summary} skipped | Arch ${arch} not equal to '${conditions.arch}'`;
  }

  if (conditions.version.length && !conditions.version.includes(job.version)) {
    return `⌛ ${summary} skipped | Version ${
      job.version
    } not in [${conditions.version.join(", ")}]`;
  }

  if (conditions.distro.length && !conditions.distro.includes(distro)) {
    return `⌛ ${summary} skipped | Distro ${distro} not in [${conditions.distro.join(
      ", ",
    )}]`;
  }

  let genericType = installOption.type;
  if (["yum-repository", "apt-repository"].includes(genericType)) {
    genericType = "repository";
  }

  if (conditions.method.length && !conditions.method.includes(genericType)) {
    return `⌛ ${summary} skipped | Install method ${genericType} not in [${conditions.method.join(
      ", ",
    )}]`;
  }

  if (
    conditions.package.length &&
    !conditions.package.includes(installOption.package)
  ) {
    return `⌛ ${summary} skipped | Package ${
      installOption.package
    } not in [${conditions.package.join(", ")}]`;
  }

  if (!job.match.package.includes(installOption.package)) {
    return `⌛ ${summary} skipped | Package ${
      installOption.package
    } not in job config [${job.match.package.join(", ")}]`;
  }

  return false;
}

function loadConfig() {
  // Load kong_versions file to get the list of versions to test
  const allVersions = yaml.load(
    fs.readFileSync(__dirname + "/../../app/_data/kong_versions.yml", "utf8"),
  );

  const gatewayVersions = allVersions.filter((v) => v.edition === "gateway");

  const jobConfig = yaml.load(fs.readFileSync("./config/jobs.yaml", "utf8"));

  const jobs = [];
  for (const v of gatewayVersions) {
    for (let j of jobConfig) {
      if (new RegExp(j.match.version).test(v.release)) {
        let oss = null;
        let enterprise = null;

        if (j.match.package.includes("oss")) {
          oss = j.outputs.oss.replace("{{ version }}", v["ce-version"]);
        }

        if (j.match.package.includes("enterprise")) {
          enterprise = j.outputs.enterprise.replace(
            "{{ version }}",
            v["ee-version"],
          );
        }

        outputs = {
          enterprise,
          oss,
        };

        jobs.push({
          version: v.release,
          match: j.match,
          distros: j.distros,
          arch: j.arch,
          skip: j.skip || [],
          outputs,
        });
      }
    }
  }

  return jobs;
}
