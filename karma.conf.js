'use strict';

module.exports = function (karma) {
	karma.set({
		browserify: {
			debug: true,
			extensions: ['.coffee']
		},

		browsers: ['Chrome'],

		files: ['tests/**/*.coffee'],

		frameworks: ['browserify', 'mocha', 'chai'],

		preprocessors: {
 			'tests/**/*.coffee': ['browserify']
		},

		reporters: ['dots']
	});
};
