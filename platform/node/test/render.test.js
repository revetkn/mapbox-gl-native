'use strict';

var suite = require('mapbox-gl-test-suite').render;
var suiteImplementation = require('./suite_implementation');

var tests;

if (process.argv[1] === __filename && process.argv.length > 2) {
    tests = process.argv.slice(2);
}

suite.run('native', {tests: tests}, suiteImplementation);
