# Running
Use the commands below to run the image from the [jig](https://github.com/osirrc2019/jig) directory, updating the corpus details as appropriate.

The following corpus are supported:
- `robust04`

## Prepare
The following `jig` command can be used to index `robust04`:
```
python run.py prepare \
  --repo osirrc2019/olddog \
  --collections robust04=/path/to/disk45=trectext
```

## Search
The following `jig` command can be used to perform a search over `robust04`.
```
python run.py search \
  --repo osirrc2019/olddog \
  --output $(pwd)/out \
  --qrels qrels/qrels.robust2004.txt \
  --topic topics/robust04.301-450.601-700.txt \
  --collection robust04 \
  --opts out_file_name="run.bm25.robust04"
```
