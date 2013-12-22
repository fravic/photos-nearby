var gm = require("gm");
var fs = require('fs');

var AWS = require('aws-sdk');
var s3 = new AWS.S3();

var AWS_BUCKET_NAME = "photos-nearby";
var AWS_PHOTO_BASE_URL = "https://s3-us-west-1.amazonaws.com/photos-nearby/";

exports.setupPublicDirs = function() {
    fs.mkdir('./public/images', 0777, function(error) {
        if (error && error.errno === 34) {
            fs.mkdir('./public', 0777, function(error) {
                fs.mkdir('./public/images');
            });
        }
    });
}

exports.fetchAndResizeImageForId = function(id, url, width, isLocal, callback) {
    var path = 'images/' + id + '.jpg';
    var resized;

    console.log("Resizing " + url + " to " + path);

    resized = gm(url).resize(width)

    if (isLocal) {
        resized.write('./public/' + path, function(err) {
            if (err) {
                console.log(err);
                callback(null);
            } else {
                callback(path);
            }
        });
    } else {
        resized.stream(function(err, stdout, stderr) {
            if (err) {
                console.log("Error streaming resized image", err);
                callback(null);
                return;
            }

            var buf = new Buffer("");
            stdout.on('data', function(data) {
                buf = Buffer.concat([buf, data]);
            })
            stdout.on('end', function(data) {
                var data = {
                    Bucket: AWS_BUCKET_NAME,
                    Key: id + ".jpg",
                    Body: buf,
                    ContentType: "image/jpeg",
                    ACL: "public-read"
                };
                s3.client.putObject(data, function(err, res) {
                    if (err) {
                        console.log("Error writing to S3", err);
                        callback(null);
                    } else {
                        callback(AWS_PHOTO_BASE_URL + id + ".jpg");
                    }
                });
            });
        });
    }
}
