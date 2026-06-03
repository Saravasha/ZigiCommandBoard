const fs = require("fs-extra");
const path = require("path");

const projectRoot = path.resolve(__dirname, "..");

// Electron build output (source)
const electronBuild = path.join(projectRoot, "dist", "win-unpacked");

// Final standalone output (product)
const output = path.join(projectRoot, "..", "Zigi-Command-Board-Portable");

// Runtime scripts (source of truth)
const runtimeSrc = path.join(projectRoot, "runtime");
const runtimeDest = path.join(output, "runtime");

// Assets (if needed later)
const assetsSrc = path.join(projectRoot, "assets");
const assetsDest = path.join(output, "assets");

async function buildPackage() {
  console.log("🚀 Creating standalone bundle...");

  // 1. Clean output folder (idempotent build)
  await fs.remove(output);
  await fs.ensureDir(output);

  // 2. Copy Electron build (binary + resources)
  await fs.copy(electronBuild, output, {
    overwrite: true,
    errorOnExist: false,
  });

  // 3. Explicitly remove unwanted runtime if Electron ever injects it again
  await fs.remove(path.join(output, "resources", "runtime")).catch(() => {});

  // 4. Copy runtime scripts (your system layer)
  await fs.copy(runtimeSrc, runtimeDest, {
    overwrite: true,
    errorOnExist: false,
  });

  // 5. Copy assets (safe to include)
  await fs.copy(assetsSrc, assetsDest, {
    overwrite: true,
    errorOnExist: false,
  });

  console.log("✅ Standalone folder created at:");
  console.log(output);

  console.log("📦 Contents:");
  console.log(" - Electron binary");
  console.log(" - runtime scripts");
  console.log(" - assets");
}

buildPackage().catch((err) => {
  console.error("❌ Pack failed:", err);
  process.exit(1);
});
