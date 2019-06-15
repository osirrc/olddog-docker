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

_TODO: move database load to this stage!_

### Search

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

### SEE ALSO

[README](README.md)
