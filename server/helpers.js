var gm = require("gm");
var fs = require('fs');

exports.setupPublicDirs = function() {
    fs.mkdir('./public/images', 0777, function(error) {
        if (error && error.errno === 34) {
            fs.mkdir('./public', 0777, function(error) {
                fs.mkdir('./public/images');
            });
        }
    });
}

exports.fetchAndResizeImageForId = function(id, url, width, callback) {
    var path = 'images/' + id + '.jpg';
    console.log("Resizing " + url + " to " + path);

    gm(url).resize(width).write('./public/' + path, function(err) {
        if (err) {
            console.log(err);
            callback(null);
        } else {
            callback(path);
        }
    });
}
