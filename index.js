var path = require("path");
var fs = require("fs");
var ff = require("ff");
var clc = require("cli-color");
var common = require("../../src/common");
var root = common.paths.root; //save the root path function

var logger = new common.Formatter('addon-geoloc');

//called when addon is activated
exports.init = function () {
	logger.log("Initializing");

	exports.load();
};

exports.load = function () {
	logger.log("Loading");
}

exports.testapp = function (opts, next) {
	logger.log("TestApp Initializing");
}

