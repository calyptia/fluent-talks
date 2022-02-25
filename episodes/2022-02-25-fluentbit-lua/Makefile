cities.csv:
	wget https://pkgstore.datahub.io/core/world-cities/world-cities_csv/data/6cc66692f0e82b18216a48443b6b95da/world-cities_csv.csv
	mv world-cities_csv.csv cities.csv

run-csv-simple: build
	docker run --rm -ti --name fluent-talk -v$(PWD):/source fluent-talk /fluent-bit/bin/fluent-bit -i tail -p read_from_head=true -p exit_on_eof=true -p path=cities.csv -F lua -m '*' -p script=csv_simple.lua -p call=handler -o stdout

run-log: build
	docker run --rm -ti --name fluent-talk -v$(PWD):/source fluent-talk /fluent-bit/bin/fluent-bit -i cpu -F lua -m '*' -p script=log.lua -p call=handler -o null

run-csv: build
	docker run --rm -ti --name fluent-talk -v$(PWD):/source fluent-talk /fluent-bit/bin/fluent-bit -c csv.conf

run-csv-lpeg: build
	docker run --rm -ti --name fluent-talk -v$(PWD):/source fluent-talk /fluent-bit/bin/fluent-bit -c csv_lpeg.conf

build: cities.csv
	docker build -t fluent-talk .

present:
	marp -s .

.PHONY: build run-csv-simple run-log run-csv run-csv-lpeg present
