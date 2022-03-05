const fs = require("fs");
const os = require("os");
const path = require("path");
const process = require("process");
const child_process = require("child_process");

const configPath = path.resolve(os.homedir(), ".Playdate", "config");
const configText = fs.readFileSync(configPath, "utf8");
const configLines = configText.split("\n");

let sdkRoot = null;
for (const line of configLines) {
  const components = line.split("\t");
  if (components[0] == "SDKRoot") {
    sdkRoot = components[1];
  }
}

if (sdkRoot == null) {
  throw new Error("No SDK Root");
}

const simulatorPath = path.resolve(sdkRoot, "bin", "Playdate Simulator.app");
const outputPath = process.argv[2];

child_process.spawn("/usr/bin/open", ["-a", simulatorPath, outputPath]);
