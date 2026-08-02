import { readFile } from "node:fs/promises";
import { dirname, resolve } from "node:path";
import { fileURLToPath } from "node:url";
import { Story } from "../vendor/ink.mjs";
import { collectStoryBeats } from "../story-engine.js";

const repositoryRoot = resolve(dirname(fileURLToPath(import.meta.url)), "..");
const storyContent = (await readFile(resolve(repositoryRoot, "story/story.json"), "utf8")).replace(/^\uFEFF/, "");

const openingStory = new Story(storyContent);
const opening = collectStoryBeats(openingStory);

if (opening.beats.length < 3) {
  throw new Error(`Expected opening telemetry and two visual beats; received ${opening.beats.length}.`);
}

if (opening.beats[0].telemetry !== "opening") {
  throw new Error("Opening telemetry was not isolated as its own visual beat.");
}

if (opening.beats[1].image !== "babel_under_attack") {
  throw new Error("Babel's attack image did not form the first illustrated beat.");
}

if (opening.beats.at(-1).image !== "frozen_babel" || opening.beats.at(-1).choices.length === 0) {
  throw new Error("The opening inquiry did not retain the frozen Babel image and choices.");
}

const routeStory = new Story(storyContent);
let passages = 0;
let choices = 0;
let completeText = "";

while (passages < 500) {
  while (routeStory.canContinue) {
    completeText += routeStory.Continue();
  }

  passages += 1;
  if (routeStory.currentChoices.length === 0) break;

  routeStory.ChooseChoiceIndex(0);
  choices += 1;
}

if (passages >= 500) throw new Error("Smoke route exceeded the passage safety limit.");
if (routeStory.currentChoices.length !== 0 || routeStory.canContinue) throw new Error("Smoke route did not terminate.");
if (!completeText.includes("The fracture opens in 2012.")) throw new Error("Smoke route missed the closing title card.");

console.log(`Story smoke test passed: ${passages} passages, ${choices} choices, clean termination.`);
