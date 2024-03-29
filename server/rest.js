var http = require("http");
var https = require("https");

/**
 * getJSON: REST get request returning JSON object(s)
 * @param options: http options object
 * @param callback: callback to pass the results JSON object(s) back
 */
exports.getJSON = function(options, onResult) {
    console.log("rest::getJSON");

    var prot = options.https ? https : http;
    var req = prot.request(options, function(res) {
        var output = '';
        console.log(options.host + options.path + ':' + res.statusCode);
        res.setEncoding('utf8');

        res.on('data', function (chunk) {
            output += chunk;
        });

        res.on('end', function() {
            var obj;
            try {
                obj = JSON.parse(output);
            } catch (e) {
                obj = e.toString();
            } finally {
                onResult(res.statusCode, obj);
            }
        });
    });

    req.on('error', function(err) {
        //res.send('error: ' + err.message);
    });

    req.end();
};
