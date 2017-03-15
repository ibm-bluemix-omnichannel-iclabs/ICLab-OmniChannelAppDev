var express = require('express');
var config = require('../config');
var base64url = require('base64url');
const request = require('request');

module.exports = function () {
  var router = express.Router();

  router.get('/', function (req, res) {
    // Getting the data from the session
    var authData = req.session.authData;

    if (authData && authData.isAuthorized) {
      //the user is authorized
      res.render('protected');
    } else {
      //unauthorized user
      var requestUrl = config.authorizationEndpoint + '?response_type=code&client_id=' + config.clientId +
        '&redirect_uri=' + config.redirectURL + '&scope=openid&state=123';
      res.redirect(requestUrl);
    }
  });

  // This endpoint is for the client to get the access and id token info
  router.get('/getAuthData', function (req, res) {
    //Get the user data from the session
    var authData = req.session.authData;
    var idTokenInfo = getTokenInfo(authData.id_token);
    var accessTokenInfo = getTokenInfo(authData.access_token);

    var userData = {
      'userName': idTokenInfo.name,
      'profilePicture': idTokenInfo.picture,
      'idTokenInfo': idTokenInfo,
      'accessTokenInfo': accessTokenInfo,
      'appId': config.pushAPPGUID,
      'clientSecret': config.pushClientSecret,
      'appRegion': config.appRegion
    };

    res.json(userData);
  });
  return router;
};

/**
 * This function will return the payload of the token
 * @param {string} token - the token to be parsed
 * @return {object} - the payload of the given token
 */
var getTokenInfo = function (token) {
  var tokenComponents = token.split('.');
  var decodedToken = base64url.decode(tokenComponents[1]); //[header , payload ,signature]
  return JSON.parse(decodedToken);
};
