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

### Prepare mode

Index TREC Robust04 and Core18 in the same container:

    python3 run.py prepare \
      --repo osirrc2019/olddog \
      --collections robust04=/export/data/ir/robust04=trectext core18=/export/data/ir/WashingtonPost.v2/data=json

_Note: this creates two separate databases - for IR experiments, this is probably the desired setting, but for real life application, it is probably not._

Index TREC disks 4/5 for `robust04`:

    python3 run.py prepare \
      --repo osirrc2019/olddog \
      --collections robust04=/export/data/ir/robust04=trectext

Index WAPO for `core18`:

     python3 run.py prepare \
       --repo osirrc2019/olddog \
       --collections core18=/export/data/ir/WashingtonPost.v2/data=json

_AFAIK, directories have to be group readable for `dockerfiles` for mounting the volumes to work successfully._

### Interact mode

The `jig` provides a separate _Interact_ mode, in our case not really necessary though.
Interactive mode is started as `python3 run.py interact --repo osirrc2019/olddog`, but you can also just start the container using `docker start`.

Interactive querying is then possible using `mclient`:

    docker exec -it $(docker ps - aql) mclient -d robust04

and/or

    docker exec -it $(docker ps - aql) mclient -d core18

depending on the collection indexed.

### Search mode

#### Robust04

_Conjuctive:_

    python3 run.py search \
      --repo osirrc2019/olddog \
      --output $(pwd)/out \
      --qrels qrels/qrels.robust04.txt \
      --topic topics/topics.robust04.txt \
      --collection robust04 \
      --opts out_file_name="robust04-conj" mode="conjunctive"

_Disjunctive:_

    python3 run.py search \
      --repo osirrc2019/olddog \
      --output $(pwd)/out \
      --qrels qrels/qrels.robust04.txt \
      --topic topics/topics.robust04.txt \
      --collection robust04 \
      --opts out_file_name="robust04-disj" mode="disjunctive"

#### CORE18

_Conjunctive:_

    python3 run.py search \
       --repo osirrc2019/olddog \
       --output $(pwd)/out \
       --qrels qrels/qrels.core18.txt \
       --topic topics/topics.core18.txt \
       --collection core18 \
       --opts out_file_name="core18-conj" mode="conjunctive"

_Disjunctive:_

    python3 run.py search \
       --repo osirrc2019/olddog \
       --output $(pwd)/out \
       --qrels qrels/qrels.core18.txt \
       --topic topics/topics.core18.txt \
       --collection core18 \
       --opts out_file_name="core18-disj" mode="disjunctive"

#### Other

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
