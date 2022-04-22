To start the presentation, install [marp-cli](https://github.com/marp-team/marp-cli/releases),
then run:

```
make present
```

Then open http://localhost:8080

A few make targets will take care of setting up necessary docker images and
running the examples:

```
make run-log
make run-csv-simple
make run-csv
make run-csv-lpeg
```
