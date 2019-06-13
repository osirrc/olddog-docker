# Olddog OSIRRC Docker Image

[![Docker Build Status](https://img.shields.io/docker/cloud/build/osirrc2019/olddog.svg)](https://hub.docker.com/r/osirrc2019/olddog)

[**Chris Kamphuis**](https://github.com/chriskamphuis) and [**Arjen de Vries**](https://github.com/arjenpdevries)

This is the docker image for the [Olddog](https://github.com/chriskamphuis/olddog) project (based on work by M&uuml;hleisen et al.)  conforming to the [OSIRRC_jig](https://github.com/osirrc/jig/) for the [Open-Source IR Replicability Challenge (OSIRRC) at SIGIR 2019](https://osirrc.github.io/osirrc2019/).
This image is available on [Docker Hub](https://hub.docker.com/r/osirrc2019/olddog
) has been tested with the jig at commit [efc94e9](https://github.com/osirrc/jig/commit/efc94e90962ab7368bb8dacbbda341a3f3409157) (13/07/2019).

+ Supported test collections: `robust04`
+ Supported hooks: `init`, `index`, `search` 

## Quick Start

The following `jig` command can be used to index TREC disks 4/5 for `robust04`:

```
python run.py prepare \                                                         
  --repo osirrc2019/olddog \                                                       
  --collections robust04=/path/to/disk45=trectext
```

The following `jig` command can be used to perform a retrieval run on the collection with the `robust04` test collection.

```
python run.py search \
  --repo osirrc2019/olddog \
  --output $(pwd)/out \
  --qrels qrels/qrels.robust2004.txt \
  --topic topics/robust04.301-450.601-700.txt \
  --collection robust04 \
  --opts out_file_name="run.bm25.robust04"
```

## Retrieval Methods

The Anserini image supports the following retrieval models:

+ **BM25** (conjunctive variant): k1=0.9, b=0.4 (Robertson et al., 1995) 

## Expected Results

The following results should be able to be re-produced using the jig search command.

### robust04

MAP                                     | BM25      | 
:---------------------------------------|-----------|
[TREC 2004 Robust Track Topics](http://trec.nist.gov/data/robust/04.testset.gz)| 0.1771    |

P@5                                     | BM25      | 
:---------------------------------------|-----------|
[TREC 2004 Robust Track Topics](http://trec.nist.gov/data/robust/04.testset.gz)| 0.2578    |


## Implementation

The following is a quick breakdown of what happens in each of the scripts in the repo.

### Dockerfile

The `Dockerfile` installs dependencies (`python3`, `monetdb`, etc.), copies scripts to the root dir, and sets the working dir to `/work`

### init

The `init` [script](init) is a bash script (via the `#!/bin/bash` she-bang) that invokes `wget` to download an `anserini` JAR from Maven Central. Then it clones the `olddog` project from github, which then is build using maven.

### index
The `index` Python [script](index) (via the `#!/usr/bin/python3` she-bang) reads a JSON string (see [here](https://github.com/osirrc/jig#index)) containing at least one collection to index (including the name, path, and format).
The collection is indexed using Anserini (Yang et al., 2017) and placed in a directory, with the same name as the collection, in the working dir (i.e., `/work/robust04`).
After the Lucene index has been created, the olddog software uses this index to creates csv files from it that can be loaded in the monetdb (Boncz, 2002)  column store.
At this point, `jig` takes a snapshot and the indexed collections are persisted for the `search` hook.

### search
The `search` [script](search) reads a JSON string (see [here](https://github.com/osirrc/jig#search)) containing the collection name (to map back to the index directory from the `index` hook) and topic path, among other options.
A monetDB databse is created and the csv-files are loaded into the database.
The retrieval run is performed and output is placed in `/output` for the `jig` to evaluate using `trec_eval`.

## References
+ Hannes M&uuml;hleisen, Thaer Samar, Jimmy Lin, Arjen de Vries (2014) Old Dogs Are Great at New Tricks: Column Stores for IR Prototyping. _SIGIR_
+ Stephen E. Robertson, Steve Walker, Micheline Hancock-Beaulieu, Mike Gatford, and A. Payne. (1995) Okapi at TREC-4. _TREC_
+ Peilin Yang, Hui Fang, and Jimmy Lin (2017) Anserini: Enabling the Use of Lucene for Information Retrieval Research. _SIGIR_
+ Boncz Peter (2002) Monet: A Next-Generation DBMS Kernel For Query-Intensive Applications. _PhD Thesis_

## Reviews

+ Documentation reviewed at commit [xxxxx](xxxxx) (mm/dd/yyyy) by [xxxxx](xxxxx)

