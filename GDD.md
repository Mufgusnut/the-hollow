# The Hollow (working title)

## Logline
After witch hunters murder the woman who raised you, you — her familiar, gifted human-level
intelligence by her dying charm — must gather the torn pages of her spellbook and hunt down
the hunters, while the town that once loved her only fears you now.

## Recommended Engine: Godot 4.x
- Free, open-source, no royalties or seat licenses — matters since scope here is large and open-ended.
- Native orthographic camera support makes a 3D-models-rendered-isometric look easy (better lighting/shadow than pure 2D, still reads as classic isometric).
- Input Map abstraction makes KB+mouse, point-and-click, and gamepad support coexist cleanly without separate code paths per device.
- GDScript is fast to iterate in for a solo/small-team narrative game; can drop to C# later for performance-critical systems if needed.
- Exports cleanly to Windows/Mac/Linux (and Steam) with no extra tooling.

---

## Tone & Setting
Low fantasy, rural/medieval. A witch's cottage on the edge of a small farming village, ringed
by forest, farmland, an old mill, a bog, and — deeper out — the witch hunters' waystation and
chapterhouse. Tone sits between *Stray* (small-creature-in-a-big-world intimacy) and *Undertale*
(moral texture in how NPCs react to you) — melancholy, warm in memory, sharpening into grief and
resolve.

---

## Narrative Structure

### Act 1 — The Hollow at Peace (tutorial)
Opens on the witch as the village has always known her: helping with her magic, delivering
remedies, asking nothing back. Small errands here (fetch herbs, tend the garden) double as
movement/interaction tutorials and establish the bond before anything goes wrong.

Then a plague moves through the village. A child dies. There's no real cause, but fear needs a
target, and the whispers land on her — lights in the woods, a shape at a window, a witch's curse
by any other name. The village warns her outright: stop using magic, or else. Unbeknownst to
her, it goes further than warnings — witch hunters are already in town, quietly paid for by
villagers pooling what they can afford, planning to kill her.

**This is where the player actually takes control for the first time.** A second child is
dying. The witch has brewed the last healing draught that can save them, but she doesn't dare
set foot in the village herself — not with what they're already saying about her. So she does
something she swore she wouldn't: lays a brilliance charm on her familiar, *temporarily*, just
enough wit to carry the draught to the square herself. She's explicit about the stakes: don't be
seen, don't be caught doing anything a small animal shouldn't be able to do, or suspicion lands
squarely back on her. She promises to lift the charm the moment the familiar is home safe.

This errand *is* the tutorial and the game's first real tension in one move: the player
experiences the village's suspicion firsthand, under a countdown of sorts (a dying child, a
temporary charm, hunters already circling), before the raid the player has no way to stop.

One night — presumably not long after — a witch-hunter clan raids the cottage. The player is
knocked aside, trapped, or hidden (a short chase/stealth sequence with no way to intervene) and
comes to afterward to find the cottage ransacked and the master dead. Whatever was meant to be
temporary about the charm doesn't get undone; the spellbook has been torn apart, its pages
scattered on the wind. *(The exact mechanical/narrative hinge — how "temporary" becomes
"permanent" the night she dies — is still to be nailed down; noting it here as open.)*

### Act 2 — Gathering the Wind (main body)
Open-ish exploration across the region's zones (see World Structure). Core loop: find tome pages
(→ new spells) → use the new ability to reach previously blocked areas or interact with the world/NPCs
in a new way → follow clues about who started the rumors and who leads the hunters → grow a small
network of townsfolk who remember the master's kindness, regardless of their instinctive reaction
to the player's species (see Familiar Bias below).

The rumor's origin resolves into a person, not a conspiracy — someone specific and human-scale
(fear, guilt, or self-interest), giving the player a mid-game gut-check before the larger revenge
target. Reputation building matters here: some villagers become informants or helpers; others
remain hostile no matter what.

### Act 3 — The Reckoning
Approach and infiltrate the witch hunters' chapterhouse. Encounters with hunter lieutenants
(each keyed to counter one of the player's early tools, forcing combined use of spells learned so
far). Final confrontation with the clan leader responsible for the master's death. Ending reflects
player choices made in Act 2 (how much of the town sided with you, whether the rumor-originator
was exposed/spared/left ambiguous).

---

## Playable Familiars

Choosing a familiar sets stats, traversal tools, and — critically — a **suspicion bias**: how
strongly and in what way ordinary humans instinctively react to seeing the creature. This is a
gameplay system (affects stealth/suspicion meters and dialogue availability), not just flavor.

| Familiar | Traversal niche | Combat/utility | Human bias |
|---|---|---|---|
| **Cat** | Jump/climb to ledges and rooftops; silent movement | Balanced, agile pounce attack; good night vision | Low baseline suspicion (common pet) but *witch-cat* superstition is strong — once identified as the witch's familiar specifically, hunted harder and faster than the others |
| **Crow** | Flight over gaps/obstacles; aerial scouting reveals nearby map/enemy layout | Can carry very light objects; weak in a straight fight | Treated as an omen of death/ill luck — high baseline suspicion from superstitious villagers, though a few unbothered NPCs (e.g., a herbalist, a child) exist as exceptions |
| **Snake** | Slither through grates/gaps/pipes no other familiar can use | Venomous bite = strong stealth takedown | Near-universal fear/panic reaction — can barely move in open crowds without triggering alarm; must live in shadows and undercrofts |
| **Rat** | Smallest gaps of all; gnaws through soft barriers (rope, thin wood); swims well | Weak combat; excels at not being noticed at all | Mostly ignored/invisible to townsfolk (vermin, beneath notice) — but if directly spotted up close, provokes a reflexive "kill it" swat rather than an organized alarm |

Design intent: no familiar is strictly better, each biases the player toward a different route
through the same region (rooftops vs. sewers vs. shadows vs. open ignorable ground) and a
different flavor of the suspicion metagame. More familiars are meant to be added later using the
same two-axis template (traversal niche + human bias).

---

## Magic & Progression

The master's spellbook was torn to pieces and scattered. Individual **tome pages** are found as
exploration/quest rewards throughout Act 2; each page permanently unlocks one spell. This is the
game's main progression currency — a soft metroidvania gate (new spell → new route/interaction),
not a stat grind.

1. **Telekinesis** *(starting spell, taught in Act 1 before the raid)* — move small-ish objects
   out of the way. Opens paths blocked by things too big for a small animal to push/climb past
   (a fallen branch, a barrel, a shutter).
2. **Veil** *(illusion/disguise)* — briefly appear harmless or throw your voice/silhouette
   elsewhere; lowers suspicion or creates a distraction.
3. **Mending** *(restoration)* — repair broken bridges/objects; minor self-heal; also a story
   beat, since it lets the player fix things the hunters broke.
4. **Kindling** *(small fire)* — light dark areas/torches, burn through vines or webs, signal
   allies.
5. **Warding** *(barrier)* — block a projectile or attack, shove back an enemy.
6. **Beastspeech** *(communicate with animals)* — get hints from local wildlife, recruit small
   animal allies as scouts or distractions.
7. **True Sight** *(late spell)* — reveal hidden magical traps, invisible ink/marks left by the
   hunters, and other clue layers.
8. **Master's Echo** *(capstone, tied to the finale)* — a channeled burst of the master's own
   power, gated behind the final story beat rather than found as a page.

Each spell is deliberately dual-purpose: a traversal key *and* a stealth/combat tool, so finding
pages keeps paying off in both exploration and encounters retroactively.

---

## World Structure
- **The Hollow (cottage ruins)** — hub/home base and safe respawn point.
- **The Village** — social hub; reputation and suspicion play out here most directly.
- **Farmland & Old Mill** — early exploration zone, Act 1 tutorial errands revisited with new eyes.
- **The Bog** — reclusive herbalist NPC, optional lore/ally, Snake-friendly terrain.
- **Under-village (sewers/cellars)** — Rat-friendly route, shortcuts and hidden stashes.
- **Witch Hunters' Waystation** — Act 2 midpoint area, first real combat encounters.
- **The Chapterhouse** — Act 3 final area.

## Suspicion / Reputation System
Two tracked values per region: **Suspicion** (how alert humans/hunters currently are to your
species being around) and **Standing** (long-term goodwill from individual NPCs, earned by
helping them, echoing what the master used to do). Familiar bias sets your suspicion floor/ceiling
and how fast it decays; Standing gates who will talk, hide you, or help in Act 3.

---

## Camera, Controls & Input
- **Camera:** third-person overhead/isometric, fixed-angle with smooth follow (not full free
  rotation, to keep the isometric read consistent).
- **Keyboard + mouse:** WASD movement with mouse-look/interact, *or* click-to-move navigation
  (click ground to path there, click an object/enemy to interact or target a spell) — both bound
  simultaneously, not a mode toggle, so players can mix them fluidly.
- **Spell casting:** hotbar (keys 1–8), mouse click to target/direction where relevant.
- **Controller:** first-class, likely the best-feeling option for this camera style — left stick
  move, camera follows automatically (right stick nudges/resets it), face buttons for
  interact/dodge/spell-hotbar-page, triggers for targeting and cast.

## Combat Philosophy
The player is a small animal — sustained direct combat should feel risky, not heroic. Lean on
stealth, environmental hazards, traps, luring, and precision sneak-attacks over slugging matches.
Beastspeech-recruited animal allies and spells like Warding/Kindling exist to give the player
options besides a straight fight, especially against armored hunters.

---

## Suggested Build Order (once we move to implementation)
1. Godot project scaffold: scenes folder structure, Input Map (KB/mouse + gamepad bound together),
   base Familiar character controller (movement only).
2. Isometric camera rig + click-to-move navigation alongside WASD.
3. One familiar (Cat) fully playable with movement, jump/climb traversal, and idle/attack anims
   (placeholder art fine).
4. Telekinesis spell + one blocked-path puzzle prop, to prove the "spell unlocks route" loop end
   to end.
5. Minimal suspicion meter + one NPC reaction state, to prove the bias system before building all
   four familiars against it.

This document is meant to be a living reference — update it as design decisions change rather
than treating it as fixed once written.
