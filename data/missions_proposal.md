# Photoboom Mission Catalog: Master List, Templates & Tagging Proposal

*Compiled 2026-07-15 from every hunt list in `~/Downloads/actual_photo_hunts` plus
`data/example_missions.txt`.*

## 1. What was extracted

[actual_missions.csv](actual_missions.csv) holds all **651 missions**, transcribed
faithfully (source, title, description, points). Sources:

| Source | Missions | Character |
|---|---|---|
| `boston_hrsfans_missions.txt` | 56 | Boston/Cambridge HRSFA hunt; geeky, no points |
| `hrsfa_hrsfans_2017.pdf` | 70 | HRSFA/NS 2017, Cambridge; points 1–500 |
| `hrsfa_photo_scavenger_hunt.xls` | 54 | HRSFA House Party 2008, Washington DC; bonus-tier points ("10/25") |
| `thomas_farewell_missions.txt` | 73 | SF farewell hunt (draft of the Memorial hunt) |
| `thoms_lotze_photohunt.pdf` | 75 | Thomas Lotze Memorial Photo Hunt, SF 2017-05-20 (final version) |
| `Flags Day Game 2015 - Master List.xlsx` | 96 | SF Flags Day 2015; raunchy, includes a Star Wars sub-pack and sticker/emoji prop missions |
| `Flags Day - List.pdf` | 96 | Earlier SF Flags Day edition (~2013); overlaps 2015 but distinct |
| `burning_man1+2.jpg` | 34 | Burning Man "No Spectators" SF hunt; experience-driven, Ten-Principles themed |
| `mission_hipster1+2.jpg` | 54 | "Mission Hipster Edition"; **already organized into themed categories** |
| `reigh_prompts.txt` | 43 | Two-person photo-prompt exchange; intimate/at-home prompts |
| `data/example_missions.txt` (repo) | 80 | 2020 remote/quarantine hunt — the source for the home-friendly pack |

Notably, three organizer conventions recur across almost every list and are worth
treating as **fixtures**: a 1-point *Test Photo* first, a big-points *Team Photo* last,
and points tiers that signal difficulty rather than strict value.

The Flags Day 2015 spreadsheet also has a per-mission metadata scheme (photo/video,
physical item, non-player involvement, team-member count, collaboration, difficulty,
year last used) — independent confirmation that a tagging system is the right model.

## 2. The proposed master list

[missions_master.csv](missions_master.csv) is the curated catalog: **310 missions**,
deduplicated across hunts, each with a canonical name, cleaned description, normalized
default points, and tags. Columns: `name, description, points, status, tags, notes`
(notes record variants, escalations, and provenance; status is the lifecycle stage —
`proposed`/`playtest`/`active`/`retired` — defined in the
[mission program plan](missions_plan.md)).

Curation rules applied:

- **Dedupe, best version wins.** E.g. *Bucket* appeared in 6 hunts at 2–70 pts; one
  canonical entry with the median difficulty. Variants that change the mission
  meaningfully (e.g. *Higher* → *Even Higher*) stay separate or are noted as
  escalations.
- **Points normalized** to the 2017-era scale: 10 easy find/pose, 20 moderate,
  30 requires nerve or stranger cooperation, 40–50 coordination or daring, 70 heroic,
  100 epic commitment (*Haircut*), Team Photo 100.
- **Softened, not censored:** legally-risky wording was toned down (e.g. *hello.jpg* is
  now "embarrassing but SFW") and flagged `mischief`; risqué missions are kept but
  tagged `risque` so they're opt-in.
- **Dropped:** a handful that aged badly on consent grounds (licking strangers,
  opposite-gender restroom raids, "bonus if albino"-style gawking) and pure property
  damage. *Same Sex Kiss* is kept with a note recommending a reworded modern version.
- **Berkeley pack is net-new** (no source hunt covered Berkeley) — 8 proposed missions
  generated from the city templates in §5, marked "Proposed new" in notes.

## 3. Tagging system

Flat, space-separated, kebab-case tags in one column — greppable, trivially stored,
and expressive enough. Tags are grouped into **facets**:

### Spice (exactly one per mission — the content rating)
| Tag | Meaning |
|---|---|
| `family` | Fine for kids to do and see |
| `standard` | Adult-flavored humor, nothing explicit |
| `cheeky` | Mild innuendo, social nerve, gray-zone shenanigans |
| `risque` | PDA, underwear, sex-shop props — adults opting in |

### Warning flags (orthogonal to spice)
`mischief` (shopkeeper-annoying / legally gray — needs organizer sign-off),
`daring` (physical risk: heights, fire, water).

### Theme
`geeky` `science` `sporty` `arty` `musical` `foodie` `silly` `wholesome` `spooky`
`wordplay` `burner` `reflective`

`reflective` (introspective/personal prompts) is a **context** tag, not a flavor: these
missions are the heart of prompt-exchange games and reliably die in competitive races —
13 of the 16 never-completed missions on record were this genre in the wrong game.
See [past_game_stats.md](past_game_stats.md), Finding 4.

### People required
`all-team` `multi-member` `other-team` `non-player` `stranger-help` `animal` `baby`
(default = any one team member)

### Setting
`urban` `store` `bar` `landmark` `home-ok` (playable indoors/remote)
(default = anywhere)

### City
`sf` `boston` `berkeley` `dc` — always paired with `landmark` or a local reference.

### Logistics
`video` `multi-photo` `bring-back` `points-per-unit` `honoree` (guest-of-honor slot)
`meta` (Test Photo, Team Photo, Suggestion Box, Create Your Own)

### Action kind (for balancing a hunt)
`find` `pose` `make` `perform` `interact` `wear` `eat`

A good 60-mission hunt mixes kinds: roughly ⅓ finds (solo-scannable while walking),
⅓ poses/makes (creative), ⅓ interactions (the memorable ones).

## 4. Theme packs = saved tag queries

A "pack" is just a query over the master list, then trimmed to size by hand:

| Pack | Query | Sample missions |
|---|---|---|
| **Standard** | `NOT risque AND NOT mischief AND NOT (city tags)` | Flight, Head in Bucket, Lookalike, Parkour, Gummi Diorama, Team Photo |
| **Families** | `family AND NOT daring AND NOT bar` | Puppies, Milk and Cookies, Pillow Fort, Yoda, Good Stick, Silly Face |
| **Risque** | `risque OR (cheeky AND spice-adjacent picks)` | Forbidden Love, Granny Panties, Magic Wand, Underwear Party, Sharpie Tattoo |
| **Geeky** | `geeky` | MtG Avatar, Hogwarts Colors, Live Long And Prosper, Waldo, Portal, Locutus |
| **Science** | `science` | Hexagon, Anomaly, Napkin Math, Semaphore, Resonance, Sorting Algorithm, Eureka |
| **Sporty** | `sporty` | Parkour, Three-Legged Race, Tug of War, Human Pyramid, DDR, Juggler |
| **Non-players** | `non-player OR other-team OR stranger-help` | Piggyback, Dream, Lookalike, Photobomb, Tourist Exchange, Dance Party |
| **San Francisco** | `sf` | Sutro Pose, Frank Chu, Dolores Pyramid, Clarion Zombies, Borderlands, Fog Bridge |
| **Boston** | `boston` | Harvard Gate, Lampoon Ibis, Brattle Gold, Noch's, Ducklings, Citgo Sign |
| **Berkeley** | `berkeley` | Campanile Pose, Sather Gate Serenade, Moe's Stack, Indian Rock Summit, Big C |
| **Remote/home** | `home-ok` | Fridge Archaeology, Where's the Beach, TP Mummy, Compact, Virtual Background |
| **Prompt exchange** | `reflective` (2-player, non-competitive) | Memories, Precious, Youth Approved, Good Stick, Dream, Handwritten |
| **Burner** | `burner` | MOOP Patrol, Art Car, Radical Expression, Found-Art Collab, Mythical Creature |
| **Seasonal** | `seasonal-winter` / `seasonal-fall` | Santa's Lap, Snow Angels / Pumpkin King, Leaf Pile |

Assembly recipe for a new hunt: start with the 4 `meta` fixtures → pull ~50 from the
target pack → check the kind mix (§3) → add 3–5 `honoree`/site-specific one-offs from
templates → sanity-check spice against the audience.

## 5. Mission templates

Parameterized generators — the patterns that produced the best one-off missions in the
source hunts. Slots in `{braces}`:

**Place & community**
1. **Landmark pose** — "Team member posing with {LANDMARK}." (Sutro, Campanile, Ibis)
2. **Tiny landmark** — "A tiny model of {LANDMARK}, constructed by team members."
3. **Miniature bring-back** — "Bring back a miniature and accurate {LANDMARK}."
4. **Local business + themed action** — "All team members inside {SHOP}, {DOING ITS THING}."
   (Borderlands/reading, comic store/superhero poses, Noisebridge/hacking)
5. **Local legend** — "Photo with {LOCAL CELEBRITY}." (Frank Chu)
6. **Checkpoint challenge** — "Get to {SPOT}; do {ACTION} there." (Mission Hipster's 200-pt mains)
7. **High-score task** — one absurd, probably-impossible 100-pointer. (Flag on Sutro Tower)

**Guest of honor** (farewells, birthdays, memorials)
8. "Team photo with {HONOREE}, not at the start location."
9. "Something {HONOREE} would like." (Bribery)
10. "Non-players spelling out '{HONOREE}' with their bodies."
11. "Any non-player with a '{LETTER}' in their name, holding a paper with their name."

**Wordplay & sets**
12. **Word × medium** — "'{WORD}' written in {food | game pieces | human bodies}" (per-letter points).
13. **Like-a** — "Something that is like a {ANIMAL}, but not a {ANIMAL}."
14. **Eye of the** — "The eye of the {tiger | hurricane | needle}."
15. **Pair-pun** — matched 10-pointers: All Your Base/Bass, Yoga/Yoda, Ice/Ash, Wyld/Myld.
16. **Country of origin** — "Anything that visibly came from {COUNTRY}."

**Structure & scoring**
17. **Escalation pair** — same mission, bigger number: Higher (5 stories) → Even Higher (20);
    5 watches → 10 watches; bucket → bucket of ice water.
18. **Points-per-unit** — condiment packets, letters spelled, teams photobombed.
19. **Comparative** — "Most/longest/biggest {X}" judged at the finish. (2008 hunt)
20. **Before/after** — haircut, clothes swap, shirt swap with a stranger (multi-photo).
21. **Franchise sub-pack** — 10–15 missions skinned to {FRANCHISE} for a themed crowd
    (the 2015 Star Wars pack: *Tie Fighters*, *That's No Moon*…); works family-safe or risque.
22. **Prop packet** — hand each team {STICKERS/EMOJI/PROPS} at the start; missions consume them.
23. **Principles skin** — map missions onto {COMMUNITY}'s values, one per principle
    (the Burning Man hunt did all Ten Principles).
24. **Create Your Own** — blank slots; teams pitch, organizer prices on the spot.
25. **Suggestion Box** — "List three missions for the next hunt" — feeds this catalog.

## 6. Fit with the photoboom schema

`missions(game_id, codenum, name, description, points)` stays untouched — games keep
owning concrete missions. The catalog sits upstream:

- **Now:** `missions_master.csv` is the versioned catalog, reviewed by diff.
- **Next:** `catalog_missions` + `taggings` seeded from that CSV;
  `missions.catalog_mission_id` + `edited_from_catalog` for provenance. A pack is a
  saved tag query.
- **Then:** the web builder pre-seeds a game's missions from a pack and lets the
  organizer customize before launch — see [missions_plan.md](missions_plan.md) §1 for
  the flow and §5 for the phasing. Photo tagging for *player* photos can reuse this
  same vocabulary to auto-build "best of" albums per theme.

*Continued in [missions_plan.md](missions_plan.md): the full operating plan for hunt
creation, catalog growth, and evaluation-driven iteration.*
