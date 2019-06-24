#!/bin/sh
pushd /export/data/ir/jig

echo Robust04 \(conjunctive\)
python3 run.py search \
  --repo osirrc2019/olddog \
  --output $(pwd)/out \
  --qrels qrels/qrels.robust04.txt \
  --topic topics/topics.robust04.txt \
  --collection robust04 \
  --opts out_file_name="robust04-conj" mode="conjunctive"

echo Robust04 \(disjunctive\)
python3 run.py search \
  --repo osirrc2019/olddog \
  --output $(pwd)/out \
  --qrels qrels/qrels.robust04.txt \
  --topic topics/topics.robust04.txt \
  --collection robust04 \
  --opts out_file_name="robust04-disj" mode="disjunctive"

echo Core18 \(conjunctive\)
python3 run.py search \
   --repo osirrc2019/olddog \
   --output $(pwd)/out \
   --qrels qrels/qrels.core18.txt \
   --topic topics/topics.core18.txt \
   --collection core18 \
   --opts out_file_name="core18-conj" mode="conjunctive"

echo Core18 \(disjunctive\)
python3 run.py search \
   --repo osirrc2019/olddog \
   --output $(pwd)/out \
   --qrels qrels/qrels.core18.txt \
   --topic topics/topics.core18.txt \
   --collection core18 \
   --opts out_file_name="core18-disj" mode="disjunctive"

popd
