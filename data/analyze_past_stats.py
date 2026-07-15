#!/usr/bin/env python3
"""Analyze recovered completion data: points calibration + tag signal."""
import csv
import os
import re
import statistics as st
from collections import defaultdict

REPO = "/Users/tlotze/Dropbox/projects/photoboom"


def norm(s):
    return re.sub(r"[^a-z0-9]", "", s.lower())


# points per (game, codenum) from the archived lists
points = {}


def from_actual(source, game):
    with open(f"{REPO}/data/actual_missions.csv") as fh:
        for i, r in enumerate([r for r in csv.DictReader(fh) if r["source"] == source], 1):
            if r["points"].isdigit():
                points[(game, i)] = int(r["points"])


from_actual("thoms_lotze_photohunt.pdf", "game_1")
from_actual("hrsfa_hrsfans_2017.pdf", "game_2")
for i, line in enumerate([l.strip() for l in open(f"{REPO}/data/example_missions.txt") if l.strip()], 1):
    m = re.match(r"^(\d+)\s", line)
    if m:
        points[("game_3", i)] = int(m.group(1))

catalog = {norm(r["name"]): r for r in csv.DictReader(open(f"{REPO}/data/missions_master.csv"))}
runs = list(csv.DictReader(open(f"{REPO}/data/mission_stats.csv")))
runs = [r for r in runs if int(r["teams_total"]) >= 4]  # 2-team game too noisy

# ------------------------------------------------- 1. points calibration
print("=" * 74)
print("POINTS CALIBRATION: does the price predict completion?")
print("=" * 74)
by_pts = defaultdict(list)
for r in runs:
    p = points.get((r["game"], int(r["codenum"])))
    if p:
        by_pts[p].append(int(r["completion_pct"]))

print(f"{'points':>7} {'runs':>5} {'median':>7} {'mean':>6}  {'proposed band':>14}  verdict")
BANDS = {10: (70, 95), 20: (50, 80), 30: (30, 60), 50: (15, 40), 70: (5, 20), 100: (0, 10)}
for p in sorted(by_pts):
    v = by_pts[p]
    med, mean = st.median(v), st.mean(v)
    band = BANDS.get(p)
    if band:
        verdict = "in band" if band[0] <= med <= band[1] else ("ABOVE" if med > band[1] else "BELOW")
        bs = f"{band[0]}-{band[1]}%"
    else:
        verdict, bs = "", "-"
    print(f"{p:>7} {len(v):>5} {med:>6.0f}% {mean:>5.0f}%  {bs:>14}  {verdict}")

allp = [(points[(r['game'], int(r['codenum']))], int(r["completion_pct"]))
        for r in runs if (r['game'], int(r['codenum'])) in points]
n = len(allp)
mx, my = st.mean([a[0] for a in allp]), st.mean([a[1] for a in allp])
cov = sum((a - mx) * (b - my) for a, b in allp) / n
corr = cov / (st.pstdev([a[0] for a in allp]) * st.pstdev([b[1] for b in allp]))
print(f"\ncorrelation(points, completion) = {corr:+.2f} over {n} runs")

# ------------------------------------------------- 2. tag signal
print("\n" + "=" * 74)
print("TAG SIGNAL: median completion by catalog tag (matched runs only)")
print("=" * 74)
by_tag = defaultdict(list)
matched = 0
for r in runs:
    c = catalog.get(norm(r["mission"]))
    if not c:
        continue
    matched += 1
    for t in c["tags"].split():
        by_tag[t].append(int(r["completion_pct"]))

print(f"(matched {matched} runs to catalog)\n")
print(f"{'tag':<16} {'runs':>5} {'median':>7}")
for t, v in sorted(by_tag.items(), key=lambda x: -st.median(x[1])):
    if len(v) >= 4:
        print(f"{t:<16} {len(v):>5} {st.median(v):>6.0f}%")

# ------------------------------------------------- 3. per-game difficulty
print("\n" + "=" * 74)
print("PER-GAME: how much of the list did teams actually get?")
print("=" * 74)
for g in ["game_1", "game_2", "game_3", "game_rmi"]:
    gr = [r for r in runs if r["game"] == g]
    if not gr:
        continue
    comp = [int(r["completion_pct"]) for r in gr]
    zero = sum(1 for c in comp if c == 0)
    full = sum(1 for c in comp if c == 100)
    print(f"{g:9s} {len(gr):3d} missions | median completion {st.median(comp):3.0f}% | "
          f"{zero:2d} never done | {full:2d} done by all")

# ------------------------------------------------- 4. never-completed detail
print("\n" + "=" * 74)
print("NEVER COMPLETED (candidates for retire/rewrite/reprice)")
print("=" * 74)
for r in runs:
    if int(r["teams_completed"]) == 0:
        p = points.get((r["game"], int(r["codenum"])), "?")
        print(f"  {r['game']:8s} #{r['codenum']:>2} {r['mission']:<28} {p:>4} pts")

# ------------------------------------------------- 5. timing
print("\n" + "=" * 74)
print("TIMING: median minutes from first submission")
print("=" * 74)
tm = sorted([(int(r["median_min_from_start"]), r) for r in runs if r["median_min_from_start"]],
            key=lambda x: x[0])
print("earliest-attempted (the openers):")
for m, r in tm[:5]:
    print(f"  {m:>3} min  {r['game']:8s} {r['mission']}")
print("latest-attempted (the closers):")
for m, r in tm[-5:]:
    print(f"  {m:>3} min  {r['game']:8s} {r['mission']}")

# ------------------------------------------------- 6. list density vs completion
print("\n" + "=" * 74)
print("LIST DENSITY: were teams given more list than time?")
print("=" * 74)
HOURS = {"game_1": 2.8, "game_2": 2.8, "game_3": 2.3, "game_rmi": 2.0}
print(f"{'game':9s} {'offered':>7} {'hours':>6} {'per hour':>9} {'median completion':>18}")
for g, h in HOURS.items():
    gr = [r for r in runs if r["game"] == g]
    if not gr:
        continue
    med = st.median([int(r["completion_pct"]) for r in gr])
    print(f"{g:9s} {len(gr):>7} {h:>6.1f} {len(gr)/h:>9.1f} {med:>17.0f}%")
