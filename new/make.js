var util = require('util');
var fs = require('fs');

var compiler = require('../compiler');
var js_generator = require('../compiler-js');
var srcfile = process.argv[2];

var runtime = fs.readFileSync('runtime.js', 'utf-8');

var src = fs.readFileSync(srcfile, 'utf-8');
util.puts(runtime);
util.puts(compiler.compile(src, js_generator()));