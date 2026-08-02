// ASHES OF BABEL: THE FRACTURE POINT
// Production narrative build
// Complete five-act production build

VAR debug_mode = false

VAR trust_cain = 0
VAR opening_inquiries = 0
VAR library_evidence_count = 0
VAR council_inspection_count = 0
VAR responsibility_count = 0

VAR knows_location = false
VAR understands_retained_moment = false
VAR heard_cains_method = false

VAR saw_library = false
VAR examined_books = false
VAR examined_dead = false
VAR examined_missile = false
VAR saw_missile = false
VAR saw_ningishzida_firing = false
VAR heard_order_defence = false
VAR cain_accepted_culpability = false
VAR confrontation_angle = "unresolved"

VAR inspected_enlil = false
VAR inspected_ninlil = false
VAR inspected_enki = false
VAR inspected_inanna = false

VAR blamed_enlil = false
VAR blamed_cain = false
VAR blamed_enki = false
VAR blamed_council = false
VAR blamed_system = false
VAR responsibility_complete = false
VAR assigned_enlil = false
VAR assigned_executors = false
VAR assigned_enki = false
VAR assigned_council = false
VAR assigned_system = false
VAR assigned_multiple = false

VAR judged_enki = "unresolved"
VAR judged_inanna = "unresolved"
VAR counterfactual_judgement = "unresolved"
VAR flourishing_response = "unresolved"
VAR asked_anunna_fate = false
VAR challenged_model = false
VAR challenged_causality = false
VAR counterfactual_seen = false

VAR interpretation = "unresolved"
VAR recognised_rigged_system = false
VAR replay_count = 0
VAR ending_state = "unresolved"

-> telemetry_opening

=== telemetry_opening ===
# scene:system_opening
# telemetry:opening
# mood:clinical
SYSTEM TIMESTAMP: LCS-9821.67.001
VR INSTANCE: 12 (Monitored - Overrides Available)
RULESET: Constrained (Physical Laws Present)
MEMORY INTEGRITY STATUS: 1.00
ENTROPY BALANCE: 0.44
NOVELTY INDEX: 0.57
TRIGGER STATUS: No Action

-> babel_attack

=== babel_attack ===
# scene:babel_attack
# image:babel_under_attack
# mood:catastrophic
# transition:hard_cut
They will tell you it was arrogance.

That the Tower was an insult. That the gods struck Babel down in wrath.

It was not punishment. It was containment.

The people of Babel had learned the mechanics of the word: the force by which thought became form. They were no longer merely reacting to the world the gods had made for them.

They were creating.

The sky shreds open.

Anunna war-fighters cut through the clouds, obsidian hulls black against the fire gathering below. Energy bombs fall in silver lines. Great halls do not collapse. They cease to exist.

The capital does not burn.

It bleeds.

Cain and Neba stand at the edge of the end as a lone fighter breaks formation.

A missile leaves its wing.

It crosses the city in a perfect arc and strikes the Tower's spine.

Stone convulses. The upper structure begins to fall.

Then-

# effect:freeze
Silence.

Flame hangs without heat. Smoke stops climbing. Shattered masonry waits between architecture and debris. Far below, a body is caught in the instant before annihilation.

Cain lowers his hands. He is the only thing in the dead city still moving.

# speaker:neba
NEBA: "So. This is what the end looks like."

# speaker:cain
CAIN: "Yes."

His eyes pass over the stillborn city and settle somewhere beyond it.

CAIN: "And now, we see why."

-> opening_inquiry

=== opening_inquiry ===
# scene:frozen_babel
# image:frozen_babel
# mood:suspended
{ debug_mode:
    [DEBUG: inquiries={opening_inquiries}, trust_cain={trust_cain}, location={knows_location}, retained={understands_retained_moment}, method={heard_cains_method}, missile={saw_missile}]
}

{ opening_inquiries >= 2:
    * [Let Cain show you what came before the impact.] -> library_transition
}

* {not knows_location} [Ask where they are.]
    ~ knows_location = true
    ~ opening_inquiries += 1
    # speaker:neba
    NEBA: "Where are we?"

    # speaker:cain
    CAIN: "Babel. At the end."

    NEBA: "This is not the city described in the records."

    CAIN: "No. It is the city the records were written to conceal."

    Neba looks down through the suspended smoke. What remains of the city is too deliberate, too vast, to fit inside the old story of frightened tribes and wounded gods.
    -> opening_inquiry

* {not understands_retained_moment} [Ask who stopped time.]
    ~ understands_retained_moment = true
    ~ opening_inquiries += 1
    # speaker:neba
    NEBA: "Who stopped this?"

    # speaker:cain
    CAIN: "No one stopped it. We are viewing a retained moment."

    NEBA: "A record?"

    CAIN: "More than a record. Less than the event itself."

    NEBA: "And you trust it?"

    CAIN: "I trust what it can show. Not every meaning imposed upon it."
    -> opening_inquiry

* {not heard_cains_method} [Ask why Cain brought her.]
    ~ heard_cains_method = true
    ~ opening_inquiries += 1
    ~ trust_cain += 1
    # speaker:neba
    NEBA: "Why did you bring me here?"

    # speaker:cain
    CAIN: "Because an explanation would let me choose what you understood."

    NEBA: "And this does not?"

    CAIN: "This lets the evidence accuse me before I speak."

    He does not ask her to trust him. That earns him more than asking would have.
    -> opening_inquiry

* {not saw_missile} [Remain silent and examine the destruction.]
    ~ saw_missile = true
    ~ opening_inquiries += 1
    Neba walks to the edge of the fractured platform.

    Fires hang motionless above the streets. A child's hand reaches from beneath a sheet of glass, fingers fixed around the wrist of someone the blast has already erased.

    Above them, the war-fighter has begun to climb away.

    The missile remains visible inside the Tower.

    Its hull bears an Anunna military signature.

    Cain watches Neba recognise it. He offers no softer interpretation.
    -> opening_inquiry

=== library_transition ===
# scene:impact_reversal
# image:frozen_library
# mood:uncanny
# transition:reverse
Cain raises one hand.

Reality convulses.

The Tower draws itself upward. Stone tears free of the air and locks into place. Fire narrows into the wound that made it. A figure below is assembled backward from ash, horror returning to a face that has not yet been killed.

The missile pulls out of the Tower.

It reforms from heat and shrapnel, slides backward between the pillars, and stops.

Waiting.

The ruins stretch into shelves. Broken walls become columns. Stairways curl upward and downward through an archive too large to belong inside the city they just saw.

Books burn without being consumed. Beneath the glass floor, scholars and labourers lie frozen across the lower levels.

Babel was not a tower.

It was a library.

~ saw_library = true

{ debug_mode:
    [DEBUG ACT I COMPLETE: inquiries={opening_inquiries}, trust_cain={trust_cain}, saw_missile={saw_missile}, saw_library={saw_library}]
}

-> act_one_checkpoint

=== act_one_checkpoint ===
# scene:act_one_checkpoint
END OF ACT I

-> act_two_opening

=== function can_confront_cain() ===
~ return library_evidence_count >= 2

=== act_two_opening ===
# scene:babel_library
# image:babel_library
# mood:revelation
# transition:slow_resolve
The silence of the archive settles around them.

Above the glass, books wait in the instant before erasure. Below it, the dead wait in the instant before becoming history.

The missile hangs between the pillars.

Cain does not explain any of it.

-> library_investigation

=== library_investigation ===
# scene:babel_library_investigation
# mood:investigative
{ debug_mode:
    [DEBUG: evidence={library_evidence_count}, books={examined_books}, dead={examined_dead}, missile={examined_missile}, trust_cain={trust_cain}]
}

{ can_confront_cain():
    * [Turn the evidence on Cain.] -> confront_cain
}

* {not examined_books} [Examine the books.]
    ~ examined_books = true
    ~ library_evidence_count += 1
    # image:babel_burning_books
    Neba moves between shelves that curve beyond sight.

    Pages have frozen halfway through burning. Ink gathers at the edges of diagrams as though knowledge itself has been caught trying to escape.

    She finds mathematics, astronomical observations, civic records, studies of language and mind. Not fragments copied without comprehension. Systems tested, corrected, and extended by many hands.

    # speaker:neba
    NEBA: "They were not building blindly."

    # speaker:cain
    CAIN: "No."

    NEBA: "They understood what they were doing."

    CAIN: "That was the danger."

    NEBA: "To whom?"

    Cain looks across the impossible archive.

    CAIN: "To anyone whose authority depended upon knowledge remaining a gift."

    ~ blamed_system = true
    -> library_investigation

* {not examined_dead} [Look beneath the glass.]
    ~ examined_dead = true
    ~ library_evidence_count += 1
    # image:babel_dead_beneath_glass
    The lower levels are crowded with scholars, labourers, scribes, and children. None carry weapons. One woman has thrown herself across a boy whose hand still grips a writing stylus.

    # speaker:neba
    NEBA: "This was not a military target."

    # speaker:cain
    CAIN: "No."

    NEBA: "Then it was extermination."

    CAIN: "It was called containment."
    -> dead_evidence_response

=== dead_evidence_response ===
* ["Containment is the language used when murder requires procedure."]
    ~ blamed_system = true
    ~ trust_cain += 1
    NEBA: "Containment is the language used when murder requires procedure."

    Cain receives the accusation without correcting its shape.
    -> library_investigation

* [Ask what threat they were believed to pose.]
    NEBA: "What threat were they believed to pose?"

    CAIN: "They were learning faster than expected. Organising beyond assigned boundaries. Creating without permission."

    NEBA: "That is not a threat."

    CAIN: "To a system built upon ownership, it is the only threat that matters."

    ~ blamed_system = true
    -> library_investigation

* [Say nothing.]
    Neba keeps her eyes on the woman and the boy.

    The word _containment_ dies between them.
    -> library_investigation

* {not examined_missile} [Examine the missile.]
    ~ examined_missile = true
    ~ saw_missile = true
    ~ library_evidence_count += 1
    # image:anunna_missile_suspended
    Its surface is smooth except where heat has begun to flower across the casing. Along its spine, an identification lattice pulses beneath the metal.

    Neba knows the signature.

    # speaker:neba
    NEBA: "This weapon is Anunna."

    # speaker:cain
    CAIN: "Yes."

    NEBA: "Not salvaged. Not copied. Military issue."

    CAIN: "Yes."

    She follows the missile's frozen path through the ruined chamber, beyond the shelves, toward the war-fighter climbing away from the city.

    Cain does not look up.
    -> library_investigation

=== confront_cain ===
# scene:cain_confrontation
# image:cain_in_frozen_library
# mood:accusation
Neba turns from the evidence.

* ["Who did this?"]
    ~ confrontation_angle = "collective"
    # speaker:neba
    NEBA: "Who did this?"

    # speaker:cain
    CAIN: "We did."

    NEBA: "Who is _we_?"

    CAIN: "The Anunna."
    -> cain_confession

* ["Who gave the order?"]
    ~ confrontation_angle = "command"
    ~ blamed_enlil = true
    # speaker:neba
    NEBA: "Who ordered the strike?"

    # speaker:cain
    CAIN: "Enlil."

    NEBA: "And the others obeyed?"

    CAIN: "Some agreed. Some objected. All allowed it to happen."

    NEBA: "Including you."
    -> cain_confession

* ["Where were you?"]
    ~ confrontation_angle = "executor"
    # speaker:neba
    NEBA: "Where were you?"

    Cain looks through the pillars toward the war-fighter suspended above the city.

    # speaker:cain
    CAIN: "There."

    NEBA: "You were flying escort?"

    CAIN: "No."
    -> cain_confession

* ["Did Enki know?"]
    ~ confrontation_angle = "enki"
    ~ blamed_enki = true
    # speaker:neba
    NEBA: "Did Enki know?"

    # speaker:cain
    CAIN: "He was in the room when the order was confirmed. He objected."

    NEBA: "That was not what I asked."

    CAIN: "No. It was not."

    NEBA: "Then why is Babel beneath us?"

    CAIN: "Because objection and intervention are not the same thing."

    NEBA: "And where were you?"
    -> cain_confession

=== cain_confession ===
# scene:ningishzida_confession
# image:ningishzida_fires_on_babel
# mood:betrayal
{ confrontation_angle != "executor":
    Cain raises one hand and points beyond her.
}

The frozen war-fighter catches the firelight. Its departure vector begins at the missile hanging inside the library.

# speaker:cain
CAIN: "I fired it."

# speaker:neba
NEBA: "You?"

CAIN: "I was Ningishzida then. I received the order. I launched the missile."

~ saw_ningishzida_firing = true

Fifteen thousand years of shared battles, arguments, discoveries, and narrow survivals rearrange themselves around a fact he could have kept buried.

He has not changed.

Her understanding of him has.

* [Ask why.]
    ~ heard_order_defence = true
    NEBA: "Why?"

    CAIN: "Because I was ordered."

    NEBA: "That explains the sequence. It does not explain the choice."

    Cain's gaze drops to the people beneath the glass.

    CAIN: "At the time, I believed obedience was duty. I believed we were saving them from what they might become."

    NEBA: "And now?"

    CAIN: "Now I know belief did not make the dead less dead."
    -> confession_resolved

* [Name it as murder.]
    ~ blamed_cain = true
    ~ trust_cain += 1
    NEBA: "You murdered them."

    CAIN: "Yes."

    NEBA: "You do not get to hide inside _we_."

    CAIN: "No."
    -> confession_resolved

* [Name the order as illegitimate.]
    ~ blamed_cain = true
    ~ blamed_system = true
    NEBA: "You obeyed an order that had no legitimate authority."

    CAIN: "Enlil held command."

    NEBA: "Command is not legitimacy."

    CAIN: "I know that now."

    NEBA: "They needed you to know it then."
    -> confession_resolved

* [Ask whether he believed it was necessary.]
    ~ trust_cain += 1
    ~ blamed_system = true
    NEBA: "Did you believe the strike was necessary?"

    CAIN: "Yes."

    NEBA: "And now?"

    CAIN: "Now I know that certainty was part of the weapon."
    -> confession_resolved

* [Say nothing.]
    Neba looks at the bodies below the glass.

    Cain waits.

    He does not ask for forgiveness.
    -> confession_resolved

=== confession_resolved ===
~ cain_accepted_culpability = true

# speaker:cain
CAIN: "This was the E'den. Not a garden. A civilisation."

He gestures toward the archive: its impossible geometry, its disciplined beauty, the work of human minds building upon one another without permission.

CAIN: "This unity was what made Babel dangerous to Enlil. It was why humanity had to be divided, owned, and taught to remember achievement as sin."

# speaker:neba
NEBA: "And the fire?"

Cain looks past the dying library, toward the source of the order.

# speaker:cain
CAIN: "It originated elsewhere."

He extends his hand. The glass beneath them darkens until the dead disappear. Shelves bend into pillars. Burning pages become points of light circling a war-table.

# transition:world_fold
# image:nippur_council_chamber
The library folds into Nippur.

{ debug_mode:
    [DEBUG ACT II COMPLETE: evidence={library_evidence_count}, angle={confrontation_angle}, trust_cain={trust_cain}, blamed_cain={blamed_cain}, blamed_system={blamed_system}, executor_clue={saw_ningishzida_firing}, culpability={cain_accepted_culpability}]
}

-> act_two_checkpoint

=== act_two_checkpoint ===
# scene:act_two_checkpoint
END OF ACT II

-> act_three_opening

=== function can_assign_responsibility() ===
~ return council_inspection_count >= 2

=== function can_leave_council() ===
~ return council_inspection_count >= 2 && responsibility_complete

=== function has_executor_clue() ===
~ return saw_ningishzida_firing && cain_accepted_culpability

=== function has_intervention_clue() ===
~ return inspected_enki

=== function has_system_clue() ===
~ return blamed_system || interpretation == "external_constraint"

=== function has_convergence_clue() ===
~ return counterfactual_seen && (asked_anunna_fate || challenged_causality || challenged_model)

=== function can_question_binary() ===
~ return has_executor_clue() && has_intervention_clue() && has_system_clue() && has_convergence_clue()

=== act_three_opening ===
# scene:nippur_council_chamber
# image:nippur_war_table
# mood:foreboding
# transition:slow_resolve
A long wooden table resolves beneath the circling light.

Babel hangs above it in miniature: radiant, whole, and already surrounded by war-fighters.

Enlil stands at the head of the chamber. Ninlil rests one hand against his arm. Enki has risen from his seat. Inanna watches from the far side of the table, silent and still.

Neba stops beside Cain.

She has not seen Enki or Inanna in more than thirteen thousand years.

# speaker:cain
CAIN: "The Adamu fled their Anunna lords and gathered here. In less than half a shar, they built the city. Then they began the Tower."

His gaze remains on the room, not on Neba.

CAIN: "You will not like what follows. But without it, you would not exist."

# effect:memory_play
The retained moment begins to move.

-> council_scene

=== council_scene ===
# scene:council_order
# image:enki_opposes_enlil
# mood:confrontation
# speaker:enki
ENKI: "This is a mistake."

# speaker:enlil
ENLIL: "They are organising. Constructing. Laying foundations beyond what was permitted."

ENKI: "They are learning. Growing into something more than tools. You should be proud."

ENLIL: "Proud of their defiance? They were created for labour. Not for legacy."

The war-fighters descend through the image above them.

# speaker:enki
ENKI: "I gave them reason. I gave them language. They built something greater than we ever did, and that terrifies you."

# speaker:enlil
ENLIL: "You gave them that. They were meant to serve. Not to shape. Not to create."

Ninlil's fingers tighten on his arm. He looks at her hand. The anger in his face settles into certainty.

ENKI: "They built this city for themselves."

ENLIL: "It is because they are great that they must be broken."

# image:babel_above_war_table
Enki turns from the war-table. His fists close at his sides.

ENKI: "You would rather destroy them than admit they are more than you believe."

ENLIL: "They are precisely what I believed. If you had not given them choice--will--this would never have happened."

Silence gathers around the table.

Enki does not move.

Inanna watches him.

# speaker:enlil
ENLIL: "The order stands."

# effect:freeze
# image:frozen_council_fracture
The chamber stops.

The first detonation hangs above the war-table. Enlil's decree has become history. Ninlil's hand remains against his arm. Enki stands inside the last instant in which objection might still have become intervention.

Inanna is smiling.

Not with approval. With recognition.

-> council_fracture_intro

=== council_fracture_intro ===
# scene:frozen_council
# mood:suspended
# speaker:cain
CAIN: "This is where it happened."

# speaker:neba
NEBA: "The order?"

CAIN: "The fracture. A moment where history could have split."

NEBA: "Then why did it not?"

Cain looks from Enki's closed hand to Inanna's smile.

CAIN: "That is what I brought you to judge."

-> council_inspection

=== council_inspection ===
# scene:frozen_council_inspection
# mood:investigative
{ debug_mode:
    [DEBUG: inspections={council_inspection_count}, Enlil={inspected_enlil}, Ninlil={inspected_ninlil}, Enki={inspected_enki}, Inanna={inspected_inanna}, Enki_judgement={judged_enki}, Inanna_judgement={judged_inanna}]
}

{ can_assign_responsibility():
    + [Ask the question the room was designed to avoid.] -> responsibility_assignment
}

* {not inspected_enlil} [Inspect Enlil at the head of the table.]
    ~ inspected_enlil = true
    ~ council_inspection_count += 1
    # image:enlil_frozen_at_war_table
    Enlil's hand hovers above the projection. There is no hesitation in his face. Only the composure of a man who has mistaken control for survival.

    # speaker:neba
    NEBA: "He believed authority made him correct."

    # speaker:cain
    CAIN: "He believed survival required control."

    NEBA: "Whose survival?"

    CAIN: "His order's."

    ~ blamed_enlil = true
    -> council_inspection

* {not inspected_ninlil} [Inspect Ninlil's hand on Enlil's arm.]
    ~ inspected_ninlil = true
    ~ council_inspection_count += 1
    # image:ninlil_silent_gesture
    Her fingers rest against him in a gesture that refuses to declare itself.

    It might be restraint.

    It might be reassurance.

    It might be consent.

    # speaker:neba
    NEBA: "She never speaks."

    # speaker:cain
    CAIN: "No."

    NEBA: "Do you know what she wanted?"

    CAIN: "No."

    NEBA: "Then silence protects her from judgement."

    CAIN: "And prevented her from changing anything."
    -> council_inspection

* {not inspected_enki} [Inspect Enki's unfinished objection.] -> inspect_enki

* {not inspected_inanna} [Inspect Inanna's smile.] -> inspect_inanna

=== inspect_enki ===
~ inspected_enki = true
~ council_inspection_count += 1
# image:enki_at_the_fracture
Enki stands apart from the others.

His anger is real. His objection is recorded.

So is his failure to prevent the strike.

# speaker:neba
NEBA: "He spoke against it."

# speaker:cain
CAIN: "Yes."

# speaker:neba
NEBA: "But Babel still burned."

# speaker:cain
CAIN: "Yes."

* [Conclude that speaking was not enough.]
    ~ judged_enki = "complicit"
    ~ blamed_enki = true
    NEBA: "An objection that changes nothing can become part of the ritual that permits the act."

    CAIN: "That conclusion took him a long time."
    -> council_inspection

* [Ask whether Enki had a viable alternative.]
    ~ judged_enki = "constrained"
    NEBA: "What could he have done? Kill his brother?"

    Cain looks at the open space beside Enki's frozen hand.

    CAIN: "Yes."
    -> council_inspection

* [Preserve the meaning of his refusal.]
    ~ judged_enki = "resistant"
    NEBA: "He refused to make the decision unanimous."

    CAIN: "That mattered."

    NEBA: "Did it save anyone?"

    CAIN: "No."
    -> council_inspection

=== inspect_inanna ===
~ inspected_inanna = true
~ council_inspection_count += 1
# image:inanna_smiles_at_fracture
Inanna's smile does not belong to the destruction above the table.

It belongs to the choice Enki has not made.

# speaker:neba
NEBA: "She knew another path was possible."

# speaker:cain
CAIN: "She saw the fracture."

NEBA: "Then why did she wait?"

CAIN: "She was waiting to learn whether Enki would act."

* [Call her waiting complicity.]
    ~ judged_inanna = "complicit"
    NEBA: "She recognised the choice and still left Babel beneath the missile."

    CAIN: "Yes."
    -> council_inspection

* [Call her waiting preparation.]
    ~ judged_inanna = "prepared"
    NEBA: "She was ready to move if he broke the pattern."

    CAIN: "Before anyone else in the room."
    -> council_inspection

* [Call her waiting dangerous.]
    ~ judged_inanna = "dangerous"
    NEBA: "She did not need to know the outcome. Only that the rules could break."

    Cain studies Inanna's frozen smile.

    CAIN: "That has always made her dangerous."
    -> council_inspection

=== responsibility_assignment ===
# scene:assigning_responsibility
# image:figures_around_frozen_babel
# mood:judgement
# speaker:cain
{ responsibility_count == 0:
    CAIN: "Who destroyed Babel?"
- else:
    CAIN: "Who else owns the fire?"
}

{ debug_mode:
    [DEBUG: responsibility_count={responsibility_count}, Enlil={assigned_enlil}, executors={assigned_executors}, Enki={assigned_enki}, Council={assigned_council}, system={assigned_system}, multiple={assigned_multiple}]
}

* {not assigned_enlil} [Enlil, who issued the order.]
    ~ assigned_enlil = true
    ~ responsibility_count += 1
    ~ blamed_enlil = true
    # speaker:neba
    NEBA: "Enlil. Without his order, the strike does not occur."

    # speaker:cain
    CAIN: "Then responsibility belongs to the highest authority?"

    NEBA: "Primary responsibility does."
    -> responsibility_assignment

* {not assigned_executors} [Ningishzida and the pilots, who executed it.]
    ~ assigned_executors = true
    ~ responsibility_count += 1
    ~ blamed_cain = true
    # speaker:neba
    NEBA: "An order cannot launch itself. Ningishzida and the pilots made Enlil's intention physical."

    # speaker:cain
    CAIN: "Yes."
    -> responsibility_assignment

* {not assigned_enki} [Enki, who objected but did not intervene.]
    ~ assigned_enki = true
    ~ responsibility_count += 1
    ~ blamed_enki = true
    # speaker:neba
    NEBA: "Enki understood the crime and still allowed the mechanism to continue."

    # speaker:cain
    CAIN: "He believed opposition preserved his innocence."

    NEBA: "It preserved the record of his opposition."
    -> responsibility_assignment

* {not assigned_council} [The Council, which made atrocity procedural.]
    ~ assigned_council = true
    ~ responsibility_count += 1
    ~ blamed_council = true
    # speaker:neba
    NEBA: "The room destroyed Babel before the missile did."

    # speaker:cain
    CAIN: "How?"

    NEBA: "Everyone was given a role narrow enough to deny ownership of the whole."
    -> responsibility_assignment

* {not assigned_system} [The Anunna system that treated the Adamu as property.]
    ~ assigned_system = true
    ~ responsibility_count += 1
    ~ blamed_system = true
    # speaker:neba
    NEBA: "They were classified as tools. Once that was accepted, extermination became asset control."

    # speaker:cain
    CAIN: "And no one needed to call it murder."

    NEBA: "Only enforcement."
    -> responsibility_assignment

* {not assigned_multiple} [Reject the premise that one answer can be sufficient.]
    ~ assigned_multiple = true
    ~ assigned_enlil = true
    ~ assigned_executors = true
    ~ assigned_enki = true
    ~ assigned_council = true
    ~ assigned_system = true
    ~ responsibility_count = 5
    ~ blamed_enlil = true
    ~ blamed_cain = true
    ~ blamed_enki = true
    ~ blamed_council = true
    ~ blamed_system = true
    # speaker:neba
    NEBA: "Enlil authorised it. Ningishzida executed it. Enki failed to prevent it. The Council normalised it. The system made it thinkable."

    # speaker:cain
    CAIN: "Which matters most?"

    NEBA: "The point is that removing any one layer might have stopped it."
    -> responsibility_assignment

+ {responsibility_count >= 1} [Say that this is the whole answer.]
    ~ responsibility_complete = true
    -> responsibility_convergence

=== responsibility_convergence ===
# scene:council_fracture_offer
# image:cain_beside_frozen_enki
# mood:threshold
Cain looks at the room Neba has judged: command, obedience, objection, silence, and the machinery that kept each part separate from the consequence.

{ responsibility_count == 1:
    # speaker:cain
    CAIN: "You have given the fire one owner."

    # speaker:neba
    NEBA: "One owner is enough to condemn. It may not be enough to explain."
- else:
    # speaker:cain
    CAIN: "Then Babel was not destroyed by a single choice."

    # speaker:neba
    NEBA: "No. It was destroyed by choices arranged so that each could pretend it was not the whole."
}

# speaker:cain
CAIN: "This history happened. I was there. I participated."

He turns toward Enki, frozen between dissent and action.

CAIN: "But sometimes a fracture reveals something larger moving behind the choice."

# speaker:neba
NEBA: "What would have happened if Enki had acted?"

# speaker:cain
CAIN: "Do you want to see?"

+ [See what could have happened.]
    NEBA: "Yes."

    The chamber draws a breath it did not take in history.
    -> act_three_checkpoint

=== act_three_checkpoint ===
# scene:act_three_checkpoint
{ debug_mode:
    [DEBUG ACT III COMPLETE: inspections={council_inspection_count}, responsibility_layers={responsibility_count}, complete={responsibility_complete}, blamed_enlil={blamed_enlil}, blamed_cain={blamed_cain}, blamed_enki={blamed_enki}, blamed_council={blamed_council}, blamed_system={blamed_system}]
}

END OF ACT III

-> act_four_opening

=== act_four_opening ===
# scene:counterfactual_council
# image:nippur_council_repeating
# mood:inevitable
# transition:memory_restart
{ replay_count > 0:
    -> counterfactual_replay
}

The chamber draws a breath it did not take in history.

The retained moment releases.

Enki's objection begins again. Enlil answers him with the same cold certainty. Ninlil's fingers close around her husband's arm. Above the table, the war-fighters descend toward Babel.

For several heartbeats, the repetition is exact enough to feel like imprisonment.

# speaker:enki
ENKI: "You would rather destroy them than admit they are more than you believe."

# speaker:enlil
ENLIL: "They are precisely what I believed. If you had not given them choice--will--this would never have happened."

Silence enters the room.

In history, Enki allowed it to remain silence.

This time, he moves.

-> enki_breaks_pattern

=== enki_breaks_pattern ===
# scene:enki_kills_enlil
# image:enki_dagger_strike
# mood:rupture
# effect:dagger_flash
A dagger crosses the open space before Neba sees Enki throw it.

It enters Enlil's chest.

The Lord of Command looks down at the blade as though authority itself has betrayed him. Ninlil catches his arm too late. His weight pulls free of her hand, and he falls beside the world he had ordered destroyed.

Ninlil lunges.

Inanna is already moving.

# image:inanna_restrains_ninlil
She strikes Ninlil in mid-step and drives her against the floor, one knee across her ribs, one hand locked around her wrist. Golden hair tears loose around a smile that is fierce, breathless, and utterly unsurprised.

# speaker:inanna
INANNA: "I hope you have a plan."

* [Condemn Enki's action.]
    ~ counterfactual_judgement = "condemned"
    # speaker:neba
    NEBA: "He answered murder with murder."

    # speaker:cain
    CAIN: "Yes."

    NEBA: "Then this is not salvation."

    CAIN: "Not yet."
    -> strike_recalled

* [Accept it as necessary.]
    ~ counterfactual_judgement = "necessary"
    # speaker:neba
    NEBA: "He stopped the strike."

    # speaker:cain
    CAIN: "Yes."

    NEBA: "Then he made the choice he should have made."

    CAIN: "Watch."
    -> strike_recalled

* [Withhold judgement and watch.]
    ~ counterfactual_judgement = "withheld"
    Neba says nothing.

    The difference between an execution and an intervention will not be settled while the missile is still in the air.
    -> strike_recalled

=== strike_recalled ===
# scene:strike_recalled
# image:war_fighters_withdraw_from_babel
# mood:release
# effect:missile_recall
Enki is already at the war-table. His hands move across the controls while Enlil's blood reaches the hem of his robe.

One by one, the war-fighters break formation.

The missile retracts into Ningishzida's fighter. Bombing vectors collapse. The black ships climb away from the city whose people will never know how narrowly they survived.

# speaker:enki
ENKI: "We shift to the Abzu. We mine what we need. When Nibiru returns, we leave."

Inanna tightens her hold on Ninlil and laughs--not because a man is dead, but because a rule has proved breakable.

# speaker:inanna
INANNA: "Then let us not waste the second chance."

The council chamber folds around the city above the table.

-> babel_flourishes

=== babel_flourishes ===
# scene:babel_survives
# image:babel_ascendant
# mood:wonder
# transition:time_lapse
Babel lives.

The Tower rises beyond the height at which the missile once found it. Roads extend from the city in luminous threads. Settlements become towns; towns become centres of learning, exchange, and argument.

The Adamu do not wait for knowledge to descend from the sky. They test it. Correct it. Teach it to one another. Ships pass over the city without lowering weapons, and children grow old beneath buildings their parents were never permitted to imagine.

The branch does not resemble mercy granted by the Anunna.

It resembles humanity continuing after they withdrew their claim.

* [Call this the path that should have happened.]
    ~ flourishing_response = "rightful_path"
    # speaker:neba
    NEBA: "This was the path denied to them."

    # speaker:cain
    CAIN: "It was a path."

    NEBA: "You still will not call it the correct one."

    CAIN: "Because we have not reached its consequence."
    -> counterfactual_fracture

* [Challenge the outcome as too clean.]
    ~ flourishing_response = "model_challenge"
    ~ challenged_model = true
    # speaker:neba
    NEBA: "This is a constructed projection."

    # speaker:cain
    CAIN: "Yes."

    NEBA: "Then it contains assumptions."

    CAIN: "All probable futures do."

    NEBA: "Including the assumption that one changed choice leaves everything else obediently in place."

    CAIN: "Especially that one."
    -> counterfactual_fracture

* [Ask what became of the Anunna.]
    ~ flourishing_response = "anunna_fate"
    ~ asked_anunna_fate = true
    # speaker:neba
    NEBA: "What became of your people?"

    # speaker:cain
    CAIN: "They withdrew to the Abzu. They waited for Nibiru. Then they left Earth."

    NEBA: "And the Adamu?"

    CAIN: "They continued."
    -> counterfactual_fracture

=== counterfactual_fracture ===
# scene:counterfactual_fracture
# image:babel_reality_fraying
# mood:uncanny
At the edge of Babel's golden skyline, the light bends.

At first it might be heat. Then a tower doubles against itself. A road ends in the middle of open air. The horizon trembles like fabric pulled too tight across a frame.

# speaker:neba
NEBA: "What is happening?"

# speaker:cain
CAIN: "Watch closely."

NEBA: "Did you know this would happen?"

CAIN: "I knew the projection reached a collapse. I do not know why."

The honesty leaves her nothing easy to reject.

~ counterfactual_seen = true

# effect:reality_unthread
# image:babel_unthreads_into_data
The world breaks.

Babel's towers stretch into lattices of light. Roads, bodies, fields, and oceans flatten into indexed fragments and stream toward an aperture too small to contain them. Earth follows. The stars lose depth. History ceases to be memory and becomes a sequence of references dissolving into a neutral void.

Cain and Neba are no longer standing in the city.

They are no longer standing anywhere.

Dark structures pulse at the edge of perception--reserved potential waiting outside the reality that called it into form. Then even those recede.

Nothing remains.

# scene:new_universe
# image:singularity_before_creation
# mood:cosmic
# transition:blackout
A single point ruptures the silence.

# effect:big_bang
# image:new_universe_ignition
Energy floods into distance. Matter begins its long accumulation. Time, erased with everything else, starts again.

Cain watches the newborn universe unfold.

# speaker:cain
CAIN: "Now you understand."

-> collapse_interpretation

=== collapse_interpretation ===
# scene:new_universe_interpretation
# mood:judgement
* [Conclude that saving Babel destroyed the universe.]
    ~ interpretation = "counterfactual_catastrophe"
    # speaker:neba
    NEBA: "Enki saved the city and destroyed everything beyond it."

    # speaker:cain
    CAIN: "That is what the projection shows."

    NEBA: "You do not believe it?"

    CAIN: "I believe the sequence. I do not know the mechanism."
    -> act_four_checkpoint

* [Challenge the claim: sequence is not causation.]
    ~ interpretation = "epistemic_caution"
    ~ challenged_causality = true
    ~ trust_cain += 1
    # speaker:neba
    NEBA: "The collapse followed the divergence. That does not establish that the divergence caused it."

    Cain studies her.

    # speaker:cain
    CAIN: "No. It does not."

    NEBA: "You brought me here to resist the explanation you wanted me to accept."

    CAIN: "I brought you here because I could no longer trust my own."
    -> act_four_checkpoint

* [Suspect that something rejected the deviation.]
    ~ interpretation = "external_constraint"
    ~ blamed_system = true
    # speaker:neba
    NEBA: "This reality tolerated Babel's destruction, but not its survival."

    # speaker:cain
    CAIN: "That is one possibility."

    NEBA: "Then the reset may not have been punishment. It may have been enforcement."

    CAIN: "Or correction."

    NEBA: "Those are the same word spoken by different authorities."
    -> act_four_checkpoint

* [Challenge the counterfactual itself.]
    ~ interpretation = "model_limit"
    ~ challenged_model = true
    # speaker:neba
    NEBA: "You changed one decision and held everything else constant."

    # speaker:cain
    CAIN: "Yes."

    NEBA: "History does not behave that way."

    CAIN: "No."

    NEBA: "Then this was not what would have happened. It was what might have followed from one isolated change."

    CAIN: "That distinction matters."
    -> act_four_checkpoint

* [Conclude that Babel had to fall for Neba to exist.]
    ~ interpretation = "personal_cost"
    # speaker:neba
    NEBA: "If Babel survives, the future that created me does not."

    # speaker:cain
    CAIN: "No."

    NEBA: "Then my existence rests upon their deaths."

    CAIN: "So does mine."

    NEBA: "That does not make the deaths necessary."

    CAIN: "No."
    -> act_four_checkpoint

* [Accept only that every available choice carried consequence.]
    ~ interpretation = "governance"
    # speaker:neba
    NEBA: "I understand that there was no harmless branch."

    # speaker:cain
    CAIN: "There rarely is."

    NEBA: "But harm does not make all choices equal."

    CAIN: "No. It makes judgement necessary."
    -> act_four_checkpoint

=== act_four_checkpoint ===
# scene:act_four_checkpoint
{ debug_mode:
    [DEBUG ACT IV COMPLETE: Enki_action={counterfactual_judgement}, flourishing={flourishing_response}, Anunna_fate={asked_anunna_fate}, model_challenge={challenged_model}, causality_challenge={challenged_causality}, interpretation={interpretation}, counterfactual={counterfactual_seen}]
}

// Act V follows directly. Keep this divert explicit: this knot is not terminal.
-> act_five_opening

=== counterfactual_replay ===
# scene:counterfactual_replay
# image:babel_branch_replayed
# mood:analytical
# transition:accelerated_memory
The chamber releases again.

This time the retained possibility does not ask Neba to mistake repetition for discovery. History moves around the evidence she has returned to test.

Enki's dagger crosses the room. Inanna catches Ninlil. The strike is recalled.

Babel rises.

The Anunna withdraw to the Abzu, wait for Nibiru, and leave Earth. At the edge of the human city, light begins to bend. The world unthreads. A universe ends, and another ignites in its place.

~ counterfactual_seen = true

-> replay_examination

=== replay_examination ===
# scene:counterfactual_replay_examination
# mood:investigative
{ debug_mode:
    [DEBUG REPLAY: count={replay_count}, Anunna_fate={asked_anunna_fate}, model_challenge={challenged_model}, causality_challenge={challenged_causality}, interpretation={interpretation}]
}

* {not asked_anunna_fate} [Hold the Anunna departure against the collapse.]
    ~ asked_anunna_fate = true
    ~ flourishing_response = "anunna_fate"
    # speaker:neba
    NEBA: "The world does not begin to fail when Babel survives. It begins after the Anunna prepare to leave it."

    # speaker:cain
    CAIN: "That is the sequence."

    NEBA: "Not yet the cause."

    CAIN: "No."
    -> replay_examination

* {not challenged_model} [Examine what the projection held constant.]
    ~ challenged_model = true
    ~ flourishing_response = "model_challenge"
    # speaker:neba
    NEBA: "The projection changed Enki's act and treated the rest of history as obedient."

    # speaker:cain
    CAIN: "Until history ceased to be history at all."

    NEBA: "Then its failure may expose the model, not the world."

    CAIN: "It may."
    -> replay_examination

* [Return to the moment of collapse.]
    The newborn universe expands through the dark once more.
    -> collapse_interpretation

=== act_five_opening ===
# scene:new_universe_threshold
# image:new_universe_before_neba
# mood:revelation
# transition:slow_resolve
The newborn universe expands between them.

Hydrogen gathers. Gravity begins its patient work. The first stars wait inside laws neither Cain nor Neba can see, but both have learned to distrust.

# speaker:cain
CAIN: "Now you understand."

# speaker:neba
NEBA: "I understand what you showed me. That is not the same thing."

-> final_interpretation

=== final_interpretation ===
# scene:final_interpretation
# mood:judgement
{ debug_mode:
    [DEBUG ACT V GATE: binary={can_question_binary()}, executor={has_executor_clue()}, intervention={has_intervention_clue()}, system={has_system_clue()}, convergence={has_convergence_clue()}, trust={trust_cain}, replay={replay_count}]
}

* {can_question_binary()} [Neither branch is the real choice.]
    -> unseen_constraint_deduction

* [Accept that Enki's intervention led to catastrophe.]
    ~ ending_state = "consequence_and_memory"
    # ending:consequence_and_memory
    # speaker:neba
    NEBA: "Enki prevented one atrocity and opened a path to something larger."

    # speaker:cain
    CAIN: "That is one reading."

    NEBA: "Not yours."

    CAIN: "I asked you to judge the evidence, not inherit my conclusion."
    -> incomplete_conclusion

* {challenged_causality} [Refuse to call sequence a cause.]
    ~ ending_state = "epistemic_restraint"
    # ending:epistemic_restraint
    # speaker:neba
    NEBA: "The collapse followed the intervention. The projection still cannot tell us why."

    # speaker:cain
    CAIN: "Then uncertainty is the honest answer."

    NEBA: "The honest answer for now."
    -> incomplete_conclusion

* {challenged_model} [Conclude that the projection failed before reality did.]
    ~ ending_state = "epistemic_restraint"
    # ending:epistemic_restraint
    # speaker:neba
    NEBA: "A model that changes one choice and preserves every dependent assumption is not another history."

    # speaker:cain
    CAIN: "No."

    NEBA: "Then I will not confuse its collapse with proof."
    -> incomplete_conclusion

* {blamed_system || blamed_council} [Return judgement to the system that made Babel expendable.]
    ~ ending_state = "governance_failure"
    # ending:governance_failure
    # speaker:neba
    NEBA: "Whatever followed, Babel died first because authority divided one crime among enough hands to make it feel procedural."

    # speaker:cain
    CAIN: "And knowing the consequence does not alter that judgement."

    NEBA: "It sharpens it."
    -> incomplete_conclusion

* {interpretation == "personal_cost"} [Reject existence as a justification.]
    ~ ending_state = "existential_cost"
    # ending:existential_cost
    # speaker:neba
    NEBA: "Our lives may depend upon Babel's destruction. That does not make its destruction necessary."

    # speaker:cain
    CAIN: "No."

    NEBA: "Then consequence cannot travel backward and become permission."
    -> incomplete_conclusion

* [Carry only the knowledge that no choice was harmless.]
    ~ ending_state = "consequence_and_memory"
    # ending:consequence_and_memory
    # speaker:neba
    NEBA: "There was no branch without consequence."

    # speaker:cain
    CAIN: "There never is."

    NEBA: "That does not make the consequences equal."
    -> incomplete_conclusion

=== unseen_constraint_deduction ===
# scene:unseen_constraint_deduction
# image:two_histories_one_boundary
# mood:revelation
# effect:branches_overlay
~ recognised_rigged_system = true
~ ending_state = "rigged_reality"
# ending:rigged_reality

# speaker:neba
NEBA: "No. You offered me Enlil alive or Enlil dead. Babel destroyed or Babel free."

The two histories form around them.

In one, the missile enters the Tower.

In the other, Babel rises beyond it.

Then both images begin to disappear.

NEBA: "But Babel is erased in both."

# speaker:cain
CAIN: "By different events."

NEBA: "Events so different they should not converge. In one history the Anunna enforce control. In the other they relinquish it and leave. The surface causes oppose each other. The boundary does not."

Cain says nothing.

Around them, the histories continue to vanish until only their shared edge remains: an absence neither branch can cross.

NEBA: "The branch can change everything we can see until it reaches something it is not permitted to change."

# speaker:cain
CAIN: "Or something the reality cannot survive changing."

NEBA: "You still do not know which."

CAIN: "No."

NEBA: "What imposes it?"

CAIN: "I don't know."

NEBA: "What is it protecting?"

CAIN: "I don't know."

Neba looks past the newborn stars, toward whatever may exist beyond the limits that gave those stars permission to form.

NEBA: "Then the game is rigged."

CAIN: "The choices were real."

NEBA: "Inside a boundary we cannot see."

The first light of the new universe becomes dawn.

-> savannah_coda

=== incomplete_conclusion ===
# scene:incomplete_conclusion
# image:cain_and_neba_before_new_stars
# mood:unresolved
Cain watches the answer settle without pretending it has become complete.

# speaker:cain
CAIN: "The retained moment is still open."

# speaker:neba
NEBA: "You think I missed something."

CAIN: "I think there are questions neither of us has finished asking."

* [Return to the fracture.]
    ~ replay_count += 1
    # effect:reverse_creation
    # transition:memory_rewind
    Stars contract into darkness. The newborn universe narrows to a point, and the point tears open into Enlil's frozen chamber.
    -> council_inspection

* [End the retained moment.]
    # transition:memory_release
    NEBA: "Then we carry the unanswered part with us."

    The new universe softens into morning light.
    -> savannah_coda

=== savannah_coda ===
# scene:savannah_porch
# image:savannah_porch_dawn
# mood:quiet_unease
# transition:identity_resolve
The first light of dawn touches the savannah in violet and ember.

Neba draws breath.

Cool air tastes of earth. Her fingers rest against the arm of a chair on a vast wooden porch. The retained moment recedes behind her eyes, leaving its scale inside a human body.

Here, she is Elena.

Across from her, Cain sits with the practised stillness of a man who has worn patience across many lives. Here, he is Johannes.

For a while, neither of them speaks.

{ recognised_rigged_system:
    # speaker:elena
    ELENA: "This was not only Babel."

    # speaker:johannes
    JOHANNES: "No."

    ELENA: "You have seen the same boundary before."

    Johannes looks beyond the porch, across grass silvered by the last of night.

    JOHANNES: "Not just here. Not just with humans. Every time it happens, the Anunna are fading into obscurity."

    ELENA: "Then their disappearance is what the boundary prevents."

    JOHANNES: "I did not say that."

    ELENA: "No. It could be the forbidden outcome. Or a precursor. Or only the last thing we can see before something deeper moves."

    Johannes meets her eyes.

    JOHANNES: "A pattern. Nothing more certain than that."
- else:
    # speaker:elena
    { ending_state == "epistemic_restraint":
        ELENA: "The last part still proves less than it appears to."

        # speaker:johannes
        JOHANNES: "It also refuses to disappear when the projection is examined again."

        ELENA: "Persistence is not explanation."

        JOHANNES: "No. But it is a reason to keep looking."
    - else:
        { ending_state == "governance_failure":
            ELENA: "Whatever the collapse was, it does not get to make Babel's destruction reasonable."

            # speaker:johannes
            JOHANNES: "No consequence can absolve the people who chose the fire."
        - else:
            { ending_state == "existential_cost":
                ELENA: "I exist because one history survived and another did not."

                # speaker:johannes
                JOHANNES: "So do I."

                ELENA: "That is a fact. Not a defence."
            - else:
                ELENA: "I saw choices with consequences large enough to hide every clean answer."

                # speaker:johannes
                JOHANNES: "Clean answers are usually the first thing power manufactures."
            }
        }
    }

    # speaker:elena
    ELENA: "You still think there was something beyond the choice."

    # speaker:johannes
    JOHANNES: "I think there is a pattern I cannot explain."
}

{ blamed_cain:
    # speaker:elena
    ELENA: "Understanding why you showed me does not absolve Ningishzida."

    # speaker:johannes
    JOHANNES: "No."

    { trust_cain > 0:
        ELENA: "But confession matters. Not enough to erase the dead. Enough that I believe you are no longer hiding behind the order."

        JOHANNES: "I am not."
    - else:
        ELENA: "You do not get trust merely because you finally told the truth."

        JOHANNES: "I know."
    }
}

The wind moves through the grass. Somewhere beyond the porch, an unseen bird calls into the warming air.

# speaker:elena
ELENA: "What happens now?"

# speaker:johannes
Johannes squints at the rising sun.

JOHANNES: "Next year, in 2012, the wheel spins again."

The wind stirs. The sun climbs. For Elena, the world has never felt so still.

-> closing_telemetry

=== closing_telemetry ===
# scene:system_closing
# telemetry:closing
# mood:clinical
SYSTEM TIMESTAMP: LCS-9821.88.019
VR INSTANCE: 12 (Monitored - Critical Overrides Pending)
RULESET: Constrained (Physical Laws Present, Fracture Points Emerging)
MEMORY INTEGRITY STATUS: 0.91
ENTROPY BALANCE: 0.68
NOVELTY INDEX: 0.92
TRIGGER STATUS: Flagged

# scene:unseen_war_card
# image:harvest_knights_unseen_war
# transition:title_card
HARVEST KNIGHTS

UNSEEN WAR

The fracture opens in 2012.

{ debug_mode:
    [DEBUG STORY COMPLETE: ending={ending_state}, rigged={recognised_rigged_system}, trust={trust_cain}, replay={replay_count}]
}

-> END
