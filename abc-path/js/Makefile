D := dest/abc-path
Dfiles := $(D)/abc-path-test.xhtml $(D)/qunit.css $(D)/qunit.js $(D)/require.js $(D)/jquery-latest.js
TSC := ./node_modules/.bin/tsc
TS_SOURCES := abc-path.ts abc-path-test.ts

all: $(D)/abc-path.js lib/for-node/js/abc-path.js $(Dfiles)

benchmark: all
	NODE_PATH="`pwd`"/lib/for-node/js time node lib/for-node/js/benchmark.js

edit:
	gvim -o $(TS_SOURCES) ../Games-ABC_Path-Generator/lib/Games/ABC_Path/Generator.pm

test: all
	NODE_PATH="`pwd`"/lib/for-node/js ./node_modules/.bin/qunit-cli test-code.js
	# firefox abc-path-test.html

lib/for-node/js/abc-path.js: $(TS_SOURCES) $(TSC)
	$(TSC) --module commonjs --outDir lib/for-node/js --moduleResolution node *.ts

$(D)/abc-path.js: $(TS_SOURCES) $(TSC)
	$(TSC) --module amd --outDir $(D) --moduleResolution node *.ts

$(Dfiles): $(D)/%: %
	cp -f $< $@

$(TSC):
	npm install
