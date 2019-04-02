all: dest/abc-path/abc-path.js lib/for-node/js/abc-path.js dest/abc-path/abc-path-test.xhtml

edit:
	gvim -o abc-path.js abc-path-test.js ../Games-ABC_Path-Generator/lib/Games/ABC_Path/Generator.pm

test:
	NODE_PATH="`pwd`"/lib/for-node/js qunit-cli test-code.js
	# firefox abc-path-test.html

lib/for-node/js/abc-path.js: abc-path.ts abc-path-test.ts
	./node_modules/.bin/tsc --traceResolution --module commonjs --outDir lib/for-node/js --moduleResolution node *.ts

dest/abc-path/abc-path.js: abc-path.ts abc-path-test.ts
	./node_modules/.bin/tsc --traceResolution --module amd --outDir dest/abc-path --moduleResolution node *.ts

dest/abc-path/abc-path-test.xhtml: abc-path-test.xhtml
	cp -f $< $@
