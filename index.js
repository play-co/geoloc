var path = require("path");
var fs = require("fs");
var ff = require("ff");
var clc = require("cli-color");

//called when addon is activated
exports.init = function (common) {
	var logger = new common.Formatter('geoloc');

	//logger.log("Initializing");

	exports.load(common);
};

exports.load = function (common) {
	var logger = new common.Formatter('geoloc');

	//logger.log("Loading");
}

exports.testapp = function (common, opts, next) {
	var logger = new common.Formatter('geoloc');

	//logger.log("TestApp Initializing");
}

