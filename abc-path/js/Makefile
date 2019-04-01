all: abc-path.js

edit:
	gvim -o abc-path.js abc-path-test.js ../Games-ABC_Path-Generator/lib/Games/ABC_Path/Generator.pm

test:
	firefox abc-path-test.html

abc-path.js: abc-path.ts abc-path-test.ts
	./node_modules/.bin/tsc --traceResolution --module amd --moduleResolution node *.ts
