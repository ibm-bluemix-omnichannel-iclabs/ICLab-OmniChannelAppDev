var express = require('express');
var config = require('../config');
const request = require('request');

// Send a POST request to the token server URI with a grant type "authorization_code", clientId,
// and your redirect URI as form parameters.
// Send the clientId and secret as basic HTTP authentication credentials

module.exports = function () {
  var router = express.Router();
  router.get('/', function (req, res, next) {
    var requestUrl = config.tokenEndpoint;

    // Creating the post request to the token endpoint
    var formData = {
      grant_type: 'authorization_code',
      client_id: config.clientId,
      redirect_uri: config.redirectURL,
      code: req.query.code
    };

    request.post({url: requestUrl, formData: formData},
      function optionalCallback(err, httpResponse, body) {
        if (err || !body) {
          console.error('post request to /oauth/v3/token failed:', err);
          return next(err);
        }

        var parsedBody = JSON.parse(body);

        // Saving the data to the session
        parsedBody.isAuthorized = true;
        req.session.authData = parsedBody;

        // Redirecting back to the protected endpoint
        res.redirect('/protected');
      }).auth(config.clientId, config.secret);
  });
  return router;
};

