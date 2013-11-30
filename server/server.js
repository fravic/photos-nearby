var express = require('express');
var rest = require("./rest");

var app = express();
app.use(express.logger());

var API_URL_HOST = "api.500px.com";
var PHOTO_SEARCH_PATH = "/v1/photos/search";
var CATEGORIES = "Landscapes,City%20and%20Architecture";
var CONSUMER_KEY = process.env.CONSUMER_KEY;

app.get('/', function(req, res) {
    var lat = req.query.lat;
    var lng = req.query.lng;
    var radius = req.query.radius;

    if (!lat || !lng || !radius) {
        res.send(500, { error: 'Must specify lat, lng and radius!' });
    }

    var path = PHOTO_SEARCH_PATH;
    path += "?geo=" + lat + "," + lng + "," + radius;
    path += "&only=" + CATEGORIES;
    path += "&image_size=4";
    path += "&sort=rating";
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

                     if (statusCode != 500) {
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

var port = process.env.PORT || 8080;
app.listen(port, function() {
    console.log("Listening on " + port);
});