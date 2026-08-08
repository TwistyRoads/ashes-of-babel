import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import { Story } from "../vendor/ink.mjs";
import { ACT_LABELS } from "../image-manifest.js";
import { collectStoryBeats } from "../story-engine.js";

const storyContent = (await readFile(new URL("../story/story.json", import.meta.url), "utf8")).replace(/^\uFEFF/, "");
const normaliseChoice = (text) => text.trim().replace(/^"(.*)"$/, "$1");

class Route {
  constructor() {
    this.story = new Story(storyContent);
    this.meta = {};
    this.text = "";
    this.result = null;
    this.advance();
  }

  advance() {
    this.result = collectStoryBeats(this.story, this.meta);
    this.meta = this.result.persistentMeta;
    this.text += this.result.beats.flatMap((beat) => beat.lines.map((line) => line.text)).join("\n");
    return this.result;
  }

  choices() {
    return this.story.currentChoices.map((choice) => normaliseChoice(choice.text));
  }

  choose(label) {
    const choice = this.story.currentChoices.find((candidate) => normaliseChoice(candidate.text) === label);
    assert.ok(choice, `Missing choice "${label}". Available: ${this.choices().join(" | ")}`);
    this.story.ChooseChoiceIndex(choice.index);
    return this.advance();
  }
}

function reachLibrary(route) {
  route.choose("Ask where they are.");
  route.choose("Ask who stopped time.");
  route.choose("Let Cain show you what came before the impact.");
}

function passCain(route, firstEvidence = "Examine the books.", secondEvidence = "Examine the missile.") {
  reachLibrary(route);
  route.choose(firstEvidence);
  route.choose(secondEvidence);
  route.choose("Turn the evidence on Cain.");
  route.choose("Who did this?");
  route.choose("Name the order as illegitimate.");
}

function inspect(route, label, judgement = null) {
  route.choose(label);
  if (judgement) route.choose(judgement);
}

function reachCollapse(route, {
  inspectEnki = false,
  responsibility = "Enlil, who issued the order.",
  flourishing = "Call this the path that should have happened."
} = {}) {
  passCain(route);

  if (inspectEnki) {
    inspect(route, "Inspect Enki's unfinished objection.", "Ask whether Enki had a viable alternative.");
    inspect(route, "Inspect Enlil at the head of the table.");
  } else {
    inspect(route, "Inspect Enlil at the head of the table.");
    inspect(route, "Inspect Ninlil's hand on Enlil's arm.");
  }

  route.choose("Ask the question the room was designed to avoid.");
  route.choose(responsibility);
  route.choose("Say that this is the whole answer.");
  route.choose("See what could have happened.");
  route.choose("Withhold judgement and watch.");
  route.choose(flourishing);
}

function finish(route, collapseChoice, endingChoice) {
  route.choose(collapseChoice);
  route.choose(endingChoice);
  if (route.choices().includes("End the retained moment.")) route.choose("End the retained moment.");
  assert.equal(route.story.currentChoices.length, 0, "Ending route did not terminate.");
  return route.story.variablesState.ending_state;
}

assert.deepEqual(
  ["system_opening", "act_one_checkpoint", "act_two_checkpoint", "act_three_checkpoint", "act_four_checkpoint"].filter((scene) => !ACT_LABELS[scene]),
  [],
  "Opening or act-checkpoint scenes are missing presentation labels."
);

// Library evidence must remain independent: Books -> Missile is valid, and Dead remains available afterward.
{
  const route = new Route();
  reachLibrary(route);
  route.choose("Examine the books.");
  assert.ok(route.choices().includes("Examine the missile."), "Missile evidence disappeared after examining books.");
  route.choose("Examine the missile.");
  assert.ok(route.choices().includes("Look beneath the glass."), "Dead evidence disappeared after Books -> Missile.");
  assert.ok(route.choices().includes("Turn the evidence on Cain."), "Two independent evidence items did not unlock confrontation.");
}

// All four required Library route families remain valid.
for (const evidencePath of [
  ["Examine the books.", "Look beneath the glass."],
  ["Examine the books.", "Examine the missile."],
  ["Look beneath the glass.", "Examine the missile."]
]) {
  const route = new Route();
  reachLibrary(route);
  for (const evidence of evidencePath) {
    route.choose(evidence);
    if (evidence === "Look beneath the glass.") route.choose("Say nothing.");
  }
  assert.ok(route.choices().includes("Turn the evidence on Cain."), `${evidencePath.join(" -> ")} did not unlock confrontation.`);
}

{
  const route = new Route();
  reachLibrary(route);
  route.choose("Examine the books.");
  route.choose("Look beneath the glass.");
  route.choose("Say nothing.");
  route.choose("Examine the missile.");
  assert.ok(route.choices().includes("Turn the evidence on Cain."), "Books -> Dead -> Missile did not preserve confrontation.");
}

// Each ending category remains reachable through a coherent route.
{
  const route = new Route();
  reachCollapse(route);
  assert.equal(finish(route, "Conclude that saving Babel destroyed the universe.", "Accept that Enki's intervention led to catastrophe."), "consequence_and_memory");
}

{
  const route = new Route();
  reachCollapse(route);
  assert.ok(!route.choices().includes("Neither branch is the real choice."), "False-binary deduction appeared without all clue classes.");
  assert.equal(finish(route, "Challenge the claim: sequence is not causation.", "Refuse to call sequence a cause."), "epistemic_restraint");
  assert.ok(route.text.includes("refuses to disappear under examination"), "Epistemic coda did not use replay-neutral wording.");
  assert.ok(!route.text.includes("projection is examined again"), "First-pass epistemic coda still implies replay.");
}

{
  const route = new Route();
  reachCollapse(route, { responsibility: "The Council, which made atrocity procedural." });
  assert.equal(finish(route, "Accept only that every available choice carried consequence.", "Return judgement to the system that made Babel expendable."), "governance_failure");
}

{
  const route = new Route();
  reachCollapse(route);
  assert.equal(finish(route, "Conclude that Babel had to fall for Neba to exist.", "Reject existence as a justification."), "existential_cost");
}

{
  const route = new Route();
  reachCollapse(route, { inspectEnki: true, flourishing: "Ask what became of the Anunna." });
  route.choose("Suspect that something rejected the deviation.");
  assert.ok(route.choices().includes("Neither branch is the real choice."), "False-binary deduction did not unlock with all clue classes.");
  route.choose("Neither branch is the real choice.");
  assert.equal(route.story.variablesState.ending_state, "rigged_reality");
  assert.equal(route.story.currentChoices.length, 0, "Rigged-reality route did not terminate.");
}

// Causal catastrophe is no longer offered after the player establishes a causal or model limit.
{
  const route = new Route();
  reachCollapse(route);
  route.choose("Challenge the claim: sequence is not causation.");
  assert.ok(!route.choices().includes("Accept that Enki's intervention led to catastrophe."), "Contradictory causal conclusion remained eligible.");
  assert.ok(route.choices().includes("Carry only the knowledge that no choice was harmless."), "Non-causal consequence ending was lost.");
}

// Replay restores the Council and collapse images immediately at both re-entry points.
{
  const route = new Route();
  reachCollapse(route);
  route.choose("Challenge the claim: sequence is not causation.");
  route.choose("Refuse to call sequence a cause.");
  const councilReturn = route.choose("Return to the fracture.");
  assert.equal(councilReturn.beats.at(-1).image, "frozen_council_fracture");

  route.choose("Ask the question the room was designed to avoid.");
  route.choose("Say that this is the whole answer.");
  route.choose("See what could have happened.");
  const collapseReturn = route.choose("Return to the moment of collapse.");
  assert.equal(collapseReturn.beats.at(-1).image, "new_universe_ignition");
}

console.log("Narrative regressions passed: Library routes, five endings, coda, replay images, coherence, and false-binary gating.");
