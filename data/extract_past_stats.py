#!/usr/bin/env python3
"""Recover per-mission completion stats from exported photo filenames.

Filename convention (all 938 photos conform):
    {team}_{codenum}_{missionslug}_{YYYYMMDDHHMMSS}_{photoid}.{ext}

Mission identity: the filename slug is authoritative for missions that were
attempted (it is what the running game actually called mission N). The archived
mission list supplies names for missions nobody attempted -- the rows that carry
the most information, and the only way to get a real denominator.
"""
import csv
import os
import re
from collections import defaultdict
from datetime import datetime

PHOTOS = os.path.expanduser("~/Downloads/past_game_photos")
REPO = "/Users/tlotze/Dropbox/projects/photoboom"

FNAME = re.compile(
    r"^(?P<team>[a-z0-9]+)_(?P<codenum>\d+)_(?P<slug>[a-z0-9]*)_"
    r"(?P<ts>\d{14})_(?P<photoid>\d+)\.(jpeg|jpg|png|gif)$"
)

GAMES = {
    "game_1": ("Thomas Lotze Memorial Photo Hunt", "2017-05-20", "SF"),
    "game_2": ("HRSFA/NS Scavenger Hunt 2017", "2017-10-21", "Cambridge"),
    "game_3": ("Quarantine Hunt 2020", "2020-07-03", "remote"),
    "game_5": ("Prompt Exchange 2023", "2023-12-17", "remote/2-person"),
    "game_rmi": ("Earth Day Hunt (RMI) 2023", "2023-04-20", "corporate"),
}


def norm(s):
    return re.sub(r"[^a-z0-9]", "", s.lower())


def load_from_actual_csv(source):
    with open(f"{REPO}/data/actual_missions.csv") as fh:
        return [r["title"] for r in csv.DictReader(fh) if r["source"] == source]


def load_example_missions():
    out = []
    for line in open(f"{REPO}/data/example_missions.txt"):
        line = line.strip()
        if not line:
            continue
        m = re.match(r"^\d+\s+(.*)$", line)
        out.append((m.group(1) if m else line).split(":", 1)[0])
    return out


def load_reigh_prompts():
    out = []
    for line in open(os.path.expanduser("~/Downloads/actual_photo_hunts/reigh_prompts.txt")):
        line = line.strip()
        if line:
            out.append(line.split(":", 1)[0])
    return out


MISSION_LISTS = {
    "game_1": load_from_actual_csv("thoms_lotze_photohunt.pdf"),
    "game_2": load_from_actual_csv("hrsfa_hrsfans_2017.pdf"),
    "game_3": load_example_missions(),
    "game_5": load_reigh_prompts(),
    "game_rmi": None,
}

# ------------------------------------------------------------------- parse files
photos = []
for game in sorted(os.listdir(PHOTOS)):
    gdir = os.path.join(PHOTOS, game)
    if not os.path.isdir(gdir):
        continue
    for fn in os.listdir(gdir):
        if fn == ".DS_Store":
            continue
        m = FNAME.match(fn)
        if m:
            photos.append({
                "game": game, "team": m.group("team"),
                "codenum": int(m.group("codenum")), "slug": m.group("slug"),
                "ts": datetime.strptime(m.group("ts"), "%Y%m%d%H%M%S"),
            })

# ------------------------------------------------------------------ per-game work
rows, summaries, discrepancies = [], [], []

for game, (gname, gdate, gwhere) in GAMES.items():
    gp = [p for p in photos if p["game"] == game]
    if not gp:
        continue
    teams = sorted({p["team"] for p in gp})
    titles = MISSION_LISTS[game]

    by_mission = defaultdict(set)
    slugs = defaultdict(set)
    for p in gp:
        by_mission[p["codenum"]].add(p["team"])
        slugs[p["codenum"]].add(p["slug"])

    # Game window = the day of the bulk of submissions; later uploads are stragglers.
    day = max({p["ts"].date() for p in gp}, key=lambda d: sum(1 for p in gp if p["ts"].date() == d))
    on_day = [p for p in gp if p["ts"].date() == day]
    start = min(p["ts"] for p in on_day)
    end = max(p["ts"] for p in on_day)
    late = len(gp) - len(on_day)

    n_offered = len(titles) if titles else max(by_mission)

    for codenum in range(1, n_offered + 1):
        completers = by_mission.get(codenum, set())
        listed = titles[codenum - 1] if titles and codenum <= len(titles) else ""
        slug = sorted(slugs[codenum])[0] if slugs.get(codenum) else ""

        if slug:  # attempted: filename wins
            if listed and not norm(listed).startswith(slug[:12]):
                discrepancies.append(f"{game} #{codenum}: ran '{slug}', archived list says '{listed}'")
                name, src = slug, "filename"
            else:
                name, src = (listed or slug), ("list" if listed else "filename")
        else:  # never attempted: only the list knows it existed
            name, src = listed, "list"
        if not name:
            continue

        times = sorted((p["ts"] - start).total_seconds() / 60
                       for p in on_day if p["codenum"] == codenum)
        rows.append({
            "game": game, "game_name": gname, "date": gdate,
            "codenum": codenum, "mission": name, "name_source": src,
            "teams_total": len(teams), "teams_completed": len(completers),
            "completion_pct": round(100 * len(completers) / len(teams)),
            "photos": sum(1 for p in gp if p["codenum"] == codenum),
            "median_min_from_start": f"{times[len(times)//2]:.0f}" if times else "",
        })

    summaries.append({
        "game": game, "name": gname, "date": gdate, "where": gwhere,
        "teams": len(teams), "offered": n_offered if titles else None,
        "attempted": len(by_mission), "photos": len(gp), "late": late,
        "hours": (end - start).total_seconds() / 3600, "team_names": teams,
    })

rows.sort(key=lambda r: (r["game"], r["codenum"]))
with open(f"{REPO}/data/mission_stats.csv", "w", newline="") as fh:
    w = csv.DictWriter(fh, fieldnames=list(rows[0].keys()))
    w.writeheader()
    w.writerows(rows)

# ------------------------------------------- join to catalog (exact normalized name)
catalog = {norm(r["name"]): r["name"] for r in csv.DictReader(open(f"{REPO}/data/missions_master.csv"))}
matched = defaultdict(list)
for r in rows:
    key = norm(r["mission"])
    if key in catalog:
        matched[catalog[key]].append(r)

print("=" * 72)
for s in summaries:
    off = s["offered"] or "?"
    print(f"{s['game']:9s} {s['date']} {s['where']:15s} {s['teams']} teams  "
          f"{s['attempted']}/{off} attempted  {s['photos']:3d} photos  "
          f"{s['hours']:.1f}h" + (f"  (+{s['late']} late)" if s["late"] else ""))
    print(f"          teams: {', '.join(s['team_names'])}")

print(f"\n{len(rows)} mission-runs written -> data/mission_stats.csv")
print(f"catalog join: {len(matched)}/{len(catalog)} catalog missions have >=1 run "
      f"({sum(len(v) for v in matched.values())} runs matched)")

if discrepancies:
    print("\nList-vs-reality discrepancies (filename won):")
    for d in discrepancies:
        print("  " + d)

known = [r for r in rows if r["teams_total"] >= 4]
print(f"\n--- Across games with >=4 teams ({len(known)} runs) ---")
never = [r for r in known if r["teams_completed"] == 0]
print(f"never completed by anyone: {len(never)}")
for r in sorted(never, key=lambda r: r["game"]):
    print(f"    {r['game']} #{r['codenum']:2d} {r['mission']}")
print("\nhardest attempted (>0, lowest completion):")
for r in sorted([r for r in known if r["teams_completed"] > 0],
                key=lambda r: r["completion_pct"])[:12]:
    print(f"    {r['completion_pct']:3d}%  {r['game']} #{r['codenum']:2d} {r['mission']}")
print("\nuniversal (100% completion):")
uni = [r for r in known if r["completion_pct"] == 100]
print(f"    {len(uni)} of {len(known)} runs")
