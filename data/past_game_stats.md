# What the Recovered Photos Say

*2026-07-15. Recovered from `~/Downloads/past_game_photos/` after the loss of the game
database. Raw output: [mission_stats.csv](mission_stats.csv). Feeds §3 of
[missions_plan.md](missions_plan.md) — and corrects it.*

*Reproduce: `python3 data/extract_past_stats.py` (rebuilds `mission_stats.csv` from the
photo folders) then `python3 data/analyze_past_stats.py` (the findings below). Stdlib
only, no dependencies. Re-run if more photo archives surface.*

## Method

938 exported photos across 5 games. Every filename follows one convention:

```
bernsteinbears_71_fort_20200703213835_612.jpeg
└── team ──────┘ │  └mission┘ └timestamp──┘ └id┘
                codenum
```

That gives team, mission, and submission time per photo — enough for **completion
rate** (teams with ≥1 photo for a mission ÷ teams in the game). Four of the five games
join by codenum to mission lists already extracted in
[actual_missions.csv](actual_missions.csv), supplying the denominator: *missions
offered but never attempted*, which turn out to be the most informative rows. The join
validated at 100% / 99.6% / 98.4% / 100%, so the codenum mapping is trustworthy.

**Result: 301 mission-runs recovered**, 82 of the 310 catalog missions now have at
least one run of real data.

| Game | Date | Setting | Teams | Missions | Photos | Window |
|---|---|---|---|---|---|---|
| game_1 | 2017-05-20 | SF (Thomas Lotze Memorial) | 7 | 72/75 attempted | 279 | 2.8h (+11 late uploads) |
| game_2 | 2017-10-21 | Cambridge (HRSFA/NS) | 5 | 70/70 attempted | 281 | 2.8h |
| game_3 | 2020-07-03 | Remote (Quarantine Hunt) | 5 | 67/80 attempted | 193 | 2.3h |
| game_5 | 2023-12-17 | Remote, 2-person prompt exchange | 2 | 38/43 attempted | 50 | 0.8h |
| game_rmi | 2023-04-20 | Corporate Earth Day (RMI) | 4 | 33/? attempted | 135 | 2.0h |

### Caveats, stated plainly

- **No accept/reject data.** These are exported files; presumably accepted, but that's
  an assumption. No reject rate, no bonus data, no favorites. (§3.1 of the plan.)
- **game_rmi's numbers are upward-biased** and not comparable to the others: with no
  surviving mission list, only *attempted* missions are visible, so its "0 never
  completed / 100% median" is selection bias, not excellence.
- **game_5 excluded** from aggregates: 2 "teams" (individuals) make completion rates
  0/50/100% by construction.
- Aggregates below use the 258 runs from games with ≥4 teams.
- **`example_missions.txt` is a draft, not the shipped list**: all three teams that
  attempted game_3 #45 submitted "And Another Little Llama"; the archived list says
  "Pokemon". Filenames won. Worth knowing that the repo's example list ≠ what ran.

---

## Finding 1: Points do not predict difficulty. They predict priority.

This is the headline, and it **refutes the calibration bands I proposed** in the plan's
§3.5.

| Points | Runs | Median completion | Band I proposed | Reality |
|---:|---:|---:|:---|:---|
| 1 | 3 | 100% | — | Test Photo |
| 10 | 114 | **58%** | 70–95% | **below** |
| 20 | 69 | 60% | 50–80% | in band |
| 30 | 23 | 57% | 30–60% | in band |
| 50 | 3 | **100%** | 15–40% | **way above** |
| 70 | 5 | **100%** | 5–20% | **way above** |
| 100 | 6 | **83%** | <10% | **way above** |
| 500 | 2 | 90% | — | Team Photo |

**correlation(points, completion) = +0.15** across 225 runs — essentially none, and
*positive* where I predicted strongly negative.

The mechanism is obvious in hindsight: points are an incentive, and teams triage. The
70- and 100-pointers (Flight, Hats, Bucket, Team Photo) are the *headline* missions —
everyone does them precisely because they're worth a lot. Meanwhile the 10-point
missions are the ones teams walk past. High points don't mark "hard", they mark
"do this one", and organizers already price the must-dos high.

**So the §3.5 rule was backwards.** Points aren't a difficulty prediction to be
calibrated against completion; they're a *steering* mechanism. The revised rule
(now in the plan): judge a mission against **its own tier's baseline**, and read
under-performance at low points as "not worth the walk" — a pricing decision, not a
quality verdict.

## Finding 2: Tags predict difficulty — better than points do

Median completion by catalog tag (113 matched runs):

| Harder | | Easier | |
|---|---:|---|---:|
| `reflective` | **10%** | `meta` | 100% |
| `home-ok` | 40% | `pose` | 86% |
| `interact` | 43% | `multi-member` | 86% |
| `non-player` | 43% | `sporty` | 86% |
| `wholesome` | 43% | `all-team` | 86% |
| `make`, `perform` | 57% | `family` | 80% |
| `find` | 60% | `geeky`, `silly` | 80% |
| `science` | 60% | `wordplay` | 76% |

The spread is real and intuitive: **missions needing a stranger's cooperation run at
roughly half the completion of missions a team can do by itself.** `interact` and
`non-player` at 43% vs `pose` at 86% is the single most useful predictive fact
recovered.

This validates the tag system as more than organization — it's the difficulty model.
The builder's balance panel (§1.1 Step 3) should predict a mission's completion from
its tags, not its points.

## Finding 3: List density looks like it caps completion

| Game | Offered | Hours | Missions/hour | Median completion |
|---|---:|---:|---:|---:|
| game_rmi | 33* | 2.0 | 16.5* | 100%* |
| game_2 | 70 | 2.8 | 25.0 | 80% |
| game_1 | 75 | 2.8 | 26.8 | 57% |
| game_3 | 80 | 2.3 | **34.8** | **40%** |

\* biased upward, see caveats.

Directionally monotonic, but this is n=3 comparable games and game_1 vs game_2 (26.8
vs 25.0/hour → 57% vs 80%) shows density isn't the only factor — travel distance and
list character matter too. **Treat as a hypothesis worth testing, not a law.** The
suggestive read: past ~25 missions/hour, teams start ignoring the list rather than
racing it. The plan's default (50 missions / 3 hours ≈ 17/hour) sits in the
comfortable zone, which is now empirically supported rather than guessed.

## Finding 4: The introspective missions flopped — genre mismatch

16 missions were never completed by anyone. **13 of them are game_3**, and they
cluster hard:

> Memories · We Don't Talk · Precious · Stealing Is Wrong · Prom · It Lives Again! ·
> Beach · Vermicelli · Hurricane · Team · Legacy · Not Appearing In This Film ·
> Rotini Raphael

Most of these are the *personal/introspective* genre — "something you loved as a
child", "something given to you by someone you don't talk to any more", "your favorite
thing in your house". That genre is exactly what `reigh_prompts.txt` (the 2-person
prompt exchange) is built from, and it works beautifully **there** — a slow, intimate,
2-person game. Transplanted into a competitive 5-team quarantine hunt, it died: nobody
wants to do emotional inventory against a clock while their team races.

The lesson isn't "these are bad missions." It's that **mission quality is contextual**,
and the catalog needs to encode the context. Concretely: `reflective` is now a tag
(14 catalog missions), belonging in family/prompt-exchange packs and never in a
competitive draw.

The tag immediately paid for itself as a measurement: `reflective` missions run at
**10% median completion — the lowest of any tag in the catalog**, less than a quarter
of the next-hardest (`home-ok`, 40%) and a fifth of `interact`. The genre mismatch is
not a soft judgment; it's the strongest signal in the dataset.

Note both *Memories* and *We Don't Talk* had been dropped from the catalog during
curation. They're now restored and tagged `reflective` rather than retired — the
Finding-4 lesson applied to itself: **re-home before you retire.**

The other 3 never-completed (game_1: Playful, The Fuzz, My Shot) are ordinary
misses — a t-shirt nobody owned, cops nobody found, a nerf gun nobody had.

## Finding 5: Odds and ends

- **Openers vs closers**: Team Photo went up at minute 1 in game_3 (remote teams start
  together); the last missions attempted in game_2 were *In The Billiard Room*,
  *We Don't Burn The Clock*, *Sanyo*, *Pax Romana* — location-locked finds, i.e. the
  ones you do when you happen to walk past them. Consistent with teams routing
  opportunistically rather than working the list in order.
- **70 of 258 runs (27%) hit 100% completion** — a lot of the catalog is "everyone
  gets this". Fine for scoring rhythm; suspicious in bulk.
- **game_2 is the healthiest hunt on record**: 70/70 missions attempted, 0 never done,
  80% median completion, 30 missions completed by every team.

---

## What changes in the plan

1. **§3.5 rewritten**: points are steering, not difficulty. Judge against tier
   baselines; the tier baselines from Finding 1 become the reference table.
2. **§1.2 gains a sizing rule** grounded in Finding 3: default ~17 missions/hour,
   warn above ~25.
3. **Difficulty prediction moves to tags** (Finding 2): the builder's balance panel
   forecasts completion from tags and flags `interact`/`non-player`-heavy draws.
4. **New `reflective` tag** (Finding 4), excluded from competitive draws.
5. The evaluation loop worked before it was even built — on the plan itself. That's
   the argument for §3.2: **the next hunt should produce favorites and reject data**,
   because completion rate alone would never have told us *why* the introspective
   missions died.
