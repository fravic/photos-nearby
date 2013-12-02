var express = require('express');
var rest = require("./rest");
var helpers = require("./helpers");

var app = express();
app.use(express.logger());
app.use(express.static(__dirname + '/public'));
helpers.setupPublicDirs()

var API_URL_HOST = "api.500px.com";
var PHOTO_SEARCH_PATH = "/v1/photos/search";
var PHOTO_DATA_PATH = "/v1/photos";
var CATEGORIES = "Landscapes,City%20and%20Architecture";
var CONSUMER_KEY = process.env.CONSUMER_KEY;
var PAGE_SIZE = 20;
var IMAGE_SIZE = 4;
var IMAGE_WIDTH = 400;

var imagesById = {};

// Returns the photo list for a given coordinate
app.get('/', function(req, res) {
    var lat = req.query.lat;
    var lng = req.query.lng;
    var radius = req.query.radius;
    var page = req.query.page;

    if (!lat || !lng || !radius) {
        res.send(500, { error: 'Must specify lat, lng and radius!' });
    }

    var path = PHOTO_SEARCH_PATH;
    path += "?geo=" + lat + "," + lng + "," + radius;
    path += "&only=" + CATEGORIES;
    path += "&image_size=" + IMAGE_SIZE;
    path += "&sort=rating";
    path += "&rpp=" + PAGE_SIZE;
    path += "&page=" + page;
    path += "&consumer_key=" + CONSUMER_KEY;
    
    var options = {
        host: API_URL_HOST,
        https: true,
        path: path,
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    };

    rest.getJSON(options,
                 function(statusCode, result) {
                     res.statusCode = statusCode;

                     if (statusCode == 200) {
                         var photoList = [];
                         result.photos.forEach(function(p) {
                             var photo = {};
                             var properties = ["id", "name", "width", "height", "image_url", "latitude", "longitude"];
                             properties.forEach(function(prop) {
                                 photo[prop] = p[prop];
                             });
                             photoList.push(photo);
                         });
                         res.send(JSON.stringify(photoList));
                     } else {
                         res.send({apiError: result});
                     }

                 });
});

// Returns additional secondary data for a list of photos
app.get('/data', function(req, res) {
    var photoIds = req.query.photos;

    if (!photoIds) {
        res.send(500, { error: 'Must provide a list of photos!' });
        return false;
    }
    photoIds = photoIds.split(",");
    photoIds = photoIds.filter(function(pid) {
        return !isNaN(parseFloat(pid)) && isFinite(pid); // isNumeric
    });
    var photos = [];

    res.statusCode = 200;

    // TODO: Should add a timeout here
    photoIds.forEach(function(pid) {
        if (!pid) {
            return true
        }

        var path = PHOTO_DATA_PATH;
        path += "/" + pid;
        path += "?consumer_key=" + CONSUMER_KEY;

        var options = {
            host: API_URL_HOST,
            https: true,
            path: path,
            method: 'GET',
            headers: {
                'Content-Type': 'application/json'
            }
        };
        rest.getJSON(options,
                     function(statusCode, result) {
                         if (res.statusCode != 200) {
                             // Should have already send response by this point
                             return false;
                         }

                         res.statusCode = statusCode;

                         if (statusCode == 200) {
                             var photo = {};
                             var properties = ["id", "focal_length", "iso", "shutter_speed", "aperture", "taken_at"];
                             properties.forEach(function(prop) {
                                 photo[prop] = result.photo[prop];
                             });
                             photos.push(photo);

                             if (photos.length == photoIds.length) {
                                 res.send(JSON.stringify(photos));
                             }
                         } else {
                             res.send({apiError: result});
                         }
                     });
    });
});

// Returns the resized image url for a photo
app.get('/image', function(req, res) {
    var id = req.query.photoId;
    var url = req.query.url;

    function returnImage(error) {
        res.send({url: imagesById[id]});
    }
    if (!imagesById[id]) {
        helpers.fetchAndResizeImageForId(id, url, IMAGE_WIDTH, function(path) {
            if (!path) {
                res.statusCode = 500;
                res.send({apiError: "Could not resize image"});
            } else {
                imagesById[id] = path;
                returnImage();
            }
        });
    } else {
        returnImage();
    }
});

var port = process.env.PORT || 8080;
app.listen(port, function() {
    console.log("Listening on " + port);
});
