import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";

const stylesheet = await readFile(new URL("../style.css", import.meta.url), "utf8");

assert.match(
  stylesheet,
  /\.app\s*\{[\s\S]*?height:\s*100dvh;[\s\S]*?min-height:\s*0;/,
  "The desktop grid must have a definite viewport height."
);

assert.match(
  stylesheet,
  /\.story-text\s*\{[\s\S]*?align-self:\s*stretch;[\s\S]*?overflow-y:\s*auto;/,
  "The story text must stretch into its grid row and own vertical scrolling."
);

assert.match(
  stylesheet,
  /@media\s*\(max-width:\s*900px\)[\s\S]*?\.app\s*\{[\s\S]*?height:\s*auto;[\s\S]*?min-height:\s*100dvh;/,
  "The mobile layout must return to natural document height."
);

console.log("Layout contract passed: fixed desktop viewport, scrollable story pane, flowing mobile document.");
