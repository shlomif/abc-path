D := dest/abc-path
Dfiles := $(D)/abc-path-test.xhtml $(D)/qunit.css $(D)/qunit.js $(D)/require.js $(D)/jquery-latest.js

all: $(D)/abc-path.js lib/for-node/js/abc-path.js $(Dfiles)

edit:
	gvim -o abc-path.js abc-path-test.js ../Games-ABC_Path-Generator/lib/Games/ABC_Path/Generator.pm

test:
	NODE_PATH="`pwd`"/lib/for-node/js qunit-cli test-code.js
	# firefox abc-path-test.html

lib/for-node/js/abc-path.js: abc-path.ts abc-path-test.ts
	./node_modules/.bin/tsc --traceResolution --module commonjs --outDir lib/for-node/js --moduleResolution node *.ts

$(D)/abc-path.js: abc-path.ts abc-path-test.ts
	./node_modules/.bin/tsc --traceResolution --module amd --outDir $(D) --moduleResolution node *.ts

$(Dfiles): $(D)/%: %
	cp -f $< $@
