# Quick Start

Instructions for running OldDog on the OSIRRC 2019 `jig`.

+ Supported test collections: `robust04`
+ Supported hooks: `init`, `index`, `search`. `interactive`

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

Build the docker image locally:

    git clone git@github.com:osirrc2019/olddog-docker.git
    docker build -t osirrc2019/olddog .

### Prepare

The following `jig` command can be used to index TREC disks 4/5 for `robust04`:

    python3 run.py prepare \
      --repo osirrc2019/olddog \
      --collections robust04=/vol/practica/IR/robust04=trectext

_TODO: move database load to this stage!_

### Search

The following `jig` command can be used to perform a retrieval run on the collection with the `robust04` test collection.

    python3 run.py search \
      --repo osirrc2019/olddog \
      --output $(pwd)/out \
      --qrels qrels/qrels.robust2004.txt \
      --topic topics/robust04.401-450.txt \
      --collection robust04 \
      --opts out_file_name="run.bm25.trec8"

### SEE ALSO

[README](README.md)
