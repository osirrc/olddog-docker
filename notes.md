# Quick Start

Instructions for evaluating TREC8 using OldDog on the OSIRRC 2019 `jig`.

## Preliminaries

Create repository under `/export/data` to avoid SELinux volume mount problems when running docker commands.

    mkdir -p /export/data/ir
    cd /export/data/ir

Install `trec_eval`:

    git clone https://github.com/usnistgov/trec_eval.git && make -C trec_eval
    cd trec_eval/
    sudo make install
 
Install the `jig`:

    git clone git@github.com:osirrc/jig.git
    cd jig
    pip3 install -r requirements.txt --user

Ugly setup, `jig` expects `trec_eval/trec_eval` to be the evaluation program executable...

    mkdir trec_eval
    ln -s /usr/local/bin/trec_eval trec_eval

Build the OldDog docker image (locally):

    git clone git@github.com:osirrc2019/olddog-docker.git
    docker build -t osirrc2019/olddog .

### Prepare

Index TREC disks 4/5 for `robust04`:

    python3 run.py prepare \
      --repo osirrc2019/olddog \
      --collections robust04=/vol/practica/IR/robust04=trectext

Index WAPO for `core18`:

     python3 run.py prepare \
       --repo osirrc2019/wapodog \
       --collections core18=/export/data/ir/WashingtonPost.arjen=json

### Interact

The `jig` provides a separate _Interact_ mode, which is not strictly necessary to use a prepared image.


     docker exec -it thirsty_payne mclient -d robust04

### Search

Running a Robust04 retrieval experiment:

    python3 run.py search \
      --repo osirrc2019/olddog \
      --output $(pwd)/out \
      --qrels qrels/qrels.robust04.txt \
      --topic topics/topics.robust04.txt \
      --collection robust04 \
      --opts out_file_name="robust04" mode="disjunctive"

Running a TREC7 retrieval experiment:

    python3 run.py search \
      --repo osirrc2019/olddog \
      --output $(pwd)/out \
      --qrels qrels/qrels.trec7.adhoc.parts1-5 \
      --topic topics/topics.351-400.txt \
      --collection robust04 \
      --opts out_file_name="trec7"

Running a TREC8 retrieval experiment:

    python3 run.py search \
      --repo osirrc2019/olddog \
      --output $(pwd)/out \
      --qrels qrels/qrels.trec8.adhoc.parts1-5 \
      --topic topics/topics.401-450.txt \
      --collection robust04 \
      --opts out_file_name="trec8"

Running a CORE18 retrieval experiment:

    python3 run.py search \
       --repo osirrc2019/wapodog \
       --output $(pwd)/out \
       --qrels qrels/qrels.core18.txt \
       --topic topics/topics.core18.txt \
       --collection core18 \
       --opts out_file_name="core18-conj" mode="conjunctive"

    python3 run.py search \
       --repo osirrc2019/wapodog \
       --output $(pwd)/out \
       --qrels qrels/qrels.core18.txt \
       --topic topics/topics.core18.txt \
       --collection core18 \
       --opts out_file_name="core18-disj" mode="disjunctive"

### SEE ALSO

[README](README.md)
