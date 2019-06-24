#!/bin/sh

echo Indexing collections
python3 run.py prepare \
  --repo osirrc2019/olddog \
  --collections robust04=/export/data/ir/robust04=trectext core18=/export/data/ir/WashingtonPost.v2/data=json

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

