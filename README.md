# OSIRRC Docker Image for OldDog

[![Docker Build Status](https://img.shields.io/docker/cloud/build/osirrc2019/olddog.svg)](https://hub.docker.com/r/osirrc2019/olddog)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.3255060.svg)](https://doi.org/10.5281/zenodo.3255060)

[**Chris Kamphuis**](https://github.com/chriskamphuis) and [**Arjen de Vries**](https://github.com/arjenpdevries)

This is the docker image for the [OldDog](https://github.com/chriskamphuis/olddog) project (based on work by M&uuml;hleisen et al.)  conforming to the [OSIRRC jig](https://github.com/osirrc/jig/) for the [Open-Source IR Replicability Challenge (OSIRRC) at SIGIR 2019](https://osirrc.github.io/osirrc2019/).
This image is available on [Docker Hub](https://hub.docker.com/r/osirrc2019/olddog
) has been tested with the jig at commit [e51fe7a](https://github.com/osirrc/jig/commit/e51fe7aa8e128052244ed666e4b955a127441f9b) (06/25/2019).

+ Supported test collections: `robust04`, `core18`
+ Supported hooks: `init`, `index`, `search`, `interact`

## Quick Start

The following `jig` command can be used to index TREC disks 4/5 for `robust04`:

```
python run.py prepare \
  --repo osirrc2019/olddog \
  --tag v1.0.0 \
  --collections robust04=/path/to/disk45=trectext
```

The following `jig` command can be used to perform a retrieval run on the collection with the `robust04` test collection.

```
python run.py search \
  --repo osirrc2019/olddog \
  --tag v1.0.0 \
  --output $(pwd)/out \
  --qrels qrels/qrels.robust04.txt \
  --topic topics/topics.robust04.txt \
  --collection robust04 \
  --opts out_file_name="run.bm25.robust04"
```

The `--opts` argument can be extended by adding `mode='disjunctive'` for disjunctive query processing.

The following `jig` command can be used to start an interactive session:

```
python run.py interact \
  --repo osirrc2019/olddog \
  --tag v1.0.0 \
```  

## Retrieval Methods

The OldDog image supports the following retrieval models:

+ **BM25** (optionally conjunctive variant): k1=1.25, b=0.75 (Robertson et al., 1995) 

## Expected Results

The following results should be able to be re-produced using the jig search command.

### robust04

MAP                                     | conjunctive BM25 | disjunctive BM25 | 
:---------------------------------------|------------------|------------------|
[TREC 2004 Robust Track Topics](http://trec.nist.gov/data/robust/04.testset.gz)| 0.1736   | 0.2434    |

P@30                                    | conjunctive BM25 | disjunctive BM25 | 
:---------------------------------------|------------------|------------------|
[TREC 2004 Robust Track Topics](http://trec.nist.gov/data/robust/04.testset.gz)| 0.2526   | 0.2985    |

### core18

MAP                                     | conjunctive BM25 | disjunctive BM25 | 
:---------------------------------------|------------------|------------------|
[TREC 2018 Common Core Track Topics](https://trec.nist.gov/data/core/topics2018.txt)|  0.1802  |  0.2381  |

P@30                                    | conjunctive BM25 | disjunctive BM25 | 
:---------------------------------------|------------------|------------------|
[TREC 2018 Common Core Track Topics](https://trec.nist.gov/data/core/topics2018.txt)|  0.3167  | 0.3313   |


## Implementation

The following is a quick breakdown of what happens in each of the scripts in the repo.

### Dockerfile

The `Dockerfile` installs dependencies (`python3`, `monetdb`, etc.), copies scripts to the root dir, and sets the working dir to `/work`

### init

The `init` [script](init) is a bash script (via the `#!/bin/bash` she-bang) that invokes `wget` to download an `anserini` JAR from Maven Central. Then it downloads the `OldDog` project from github, which then is build using maven.

### index
The `index` Python [script](index) (via the `#!/usr/bin/python3` she-bang) reads a JSON string (see [here](https://github.com/osirrc/jig#index)) containing at least one collection to index (including the name, path, and format).
The collection is indexed using Anserini (Yang et al., 2017) and placed in a directory, with the same name as the collection, in the working dir (i.e., `/work/robust04`).
After the Lucene index has been created, the OldDog software uses this index to creates csv files from it that can be loaded in the monetdb (Boncz, 2002)  column store.
A monetDB databse is created and the csv-files are loaded into the database.
It is possible to index muliple collection using one container.
This is followed by removing the Lucene index so commiting the image takes less time.
At this point, `jig` takes a snapshot and the indexed collections are persisted for the `search` hook.

### search
The `search` [script](search) reads a JSON string (see [here](https://github.com/osirrc/jig#search)) containing the collection name (to map back to the index directory from the `index` hook) and topic path, among other options.
The retrieval run is performed and output is placed in `/output` for the `jig` to evaluate using `trec_eval`.

### interact
The `interact` [script](interact) starts the monetdb deamon. After this deamon has been started it is possible to open `mclient` to issue SQL queries. The following command can be used to open `mclient`:
```
docker exec -it $(docker ps -aql) mclient -d robust04
```

## Notes
- re:v0.1.0
We can not guarantee that version v0.1.0 still works. This version cloned the OldDog github repository. New versions download a released version and should keep working.

## References
+ Hannes M&uuml;hleisen, Thaer Samar, Jimmy Lin, Arjen de Vries (2014) Old Dogs Are Great at New Tricks: Column Stores for IR Prototyping. _SIGIR_
+ Stephen E. Robertson, Steve Walker, Micheline Hancock-Beaulieu, Mike Gatford, and A. Payne. (1995) Okapi at TREC-4. _TREC_
+ Peilin Yang, Hui Fang, and Jimmy Lin (2017) Anserini: Enabling the Use of Lucene for Information Retrieval Research. _SIGIR_
+ Peter Boncz (2002) Monet: A Next-Generation DBMS Kernel For Query-Intensive Applications. _PhD Thesis_

## Reviews

+ Documentation reviewed at commit [`d3a9750`](https://github.com/osirrc/olddog-docker/commit/d3a9750e74f815c12fe66dbd3e81e598b99ef9e5) (2019-06-13) by [Jimmy Lin](https://github.com/lintool/)
+ Documentation reviewed at commit [`dd53191`](https://github.com/osirrc/olddog-docker/commit/9275f8b72b518fc3ae35906ce1d7059e6dd53191) (2019-06-17) by [Ryan Clancy](https://github.com/r-clancy/).
