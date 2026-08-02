import { readFile, readdir, stat } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { IMAGE_ASSETS } from "../image-manifest.js";

const repositoryRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const inkPath = resolve(repositoryRoot, "src/ashes_of_babel_fracture_point.ink");
const storyPath = resolve(repositoryRoot, "story/story.json");
const imageDirectory = resolve(repositoryRoot, "assets/images");

const ink = await readFile(inkPath, "utf8");
const storyJson = (await readFile(storyPath, "utf8")).replace(/^\uFEFF/, "");
JSON.parse(storyJson);

const cueKeys = new Set([...ink.matchAll(/^\s*#\s*image:([^\s]+)\s*$/gm)].map((match) => match[1]));
const manifestKeys = new Set(Object.keys(IMAGE_ASSETS));
const webImageFiles = (await readdir(imageDirectory)).filter((name) => name.endsWith(".webp"));
const webImageKeys = new Set(webImageFiles.map((name) => name.replace(/\.webp$/, "")));

function difference(left, right) {
  return [...left].filter((item) => !right.has(item)).sort();
}

const failures = [];
const missingManifest = difference(cueKeys, manifestKeys);
const unusedManifest = difference(manifestKeys, cueKeys);
const missingFiles = difference(manifestKeys, webImageKeys);
const orphanedFiles = difference(webImageKeys, manifestKeys);

if (missingManifest.length) failures.push(`Ink cues missing from manifest: ${missingManifest.join(", ")}`);
if (unusedManifest.length) failures.push(`Manifest entries unused by Ink: ${unusedManifest.join(", ")}`);
if (missingFiles.length) failures.push(`Manifest assets missing on disk: ${missingFiles.join(", ")}`);
if (orphanedFiles.length) failures.push(`Web images without manifest entries: ${orphanedFiles.join(", ")}`);

for (const fileName of webImageFiles) {
  const details = await stat(resolve(imageDirectory, fileName));
  if (details.size === 0) failures.push(`Empty web image: ${fileName}`);
}

if (failures.length) {
  throw new Error(`Asset audit failed:\n- ${failures.join("\n- ")}`);
}

console.log(`Asset audit passed: ${cueKeys.size} Ink cues, manifest entries, and WebP files agree.`);
