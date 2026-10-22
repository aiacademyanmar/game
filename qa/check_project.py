import json
from pathlib import Path
root=Path(__file__).resolve().parent.parent
levels=json.loads((root/"data/lessons.json").read_text(encoding="utf-8"))
assert len(levels)==24
assert [x["id"] for x in levels]==list(range(1,25))
assert len({x["name_mm"] for x in levels})==24
assert all(x["world"]==(x["id"]-1)//4+1 for x in levels)
for x in levels:
  assert (root/x["image"][6:]).is_file(),x["id"]
  assert len(x["quiz_options"])==3 and x["quiz_options"][x["quiz_correct"]]==x["meaning_mm"]
assert len(list((root/"art").glob("level_*.svg")))==24
print("24 paccaya levels, 6 worlds, 24 SVG cards and quizzes validated (public no-audio edition)")
