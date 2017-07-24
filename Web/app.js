/*
 Copyright 2017 IBM Corp.
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 http://www.apache.org/licenses/LICENSE-2.0
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

const express = require("express");
const session = require("express-session");
const log4js = require("log4js");
const passport = require("passport");
const WebAppStrategy = require("bluemix-appid").WebAppStrategy;
//const config = require("config");

const app = express();

var cfEnv = require("cfenv");
var AppIDCredentials, bluemixAppRoute;
try {
	AppIDCredentials = cfEnv.getAppEnv().services.AdvancedMobileAccess[0].credentials;
	bluemixAppRoute = cfEnv.getAppEnv().url;
	console.log('AppIDCredentials = ' + JSON.stringify(AppIDCredentials));
	console.log('bluemixAppRoute = ' + JSON.stringify(bluemixAppRoute));
} catch(err) {
	throw ('This sample should not work locally, please push the sample to Bluemix.');
}

var config = {};
config.oauthServerUrl = 'https://appid-oauth.stage1.ng.bluemix.net/oauth/v3/57eb09df-7a85-4782-b16c-8f704b7bec6f';
config.clientId = '67f11442-7cde-4e7e-a6b3-e533b64a5be8';
config.tenantId = '57eb09df-7a85-4782-b16c-8f704b7bec6f';
config.secret = 'MDdhNDhmYTYtYTlmNi00NmY2LThjNDUtYmRjMzE2NDM2MmM4';
config.bluemixAppRoute = bluemixAppRoute;

var path = require('path');

const LOGIN_URL = "/ibm/bluemix/appid/login";
const CALLBACK_URL = "/ibm/bluemix/appid/callback";

// Setup express application to use express-session middleware
// Must be configured with proper session storage for production
// environments. See https://github.com/expressjs/session for
// additional documentation
app.use(session({
  secret: "123456",
  resave: true,
  saveUninitialized: true
}));

app.set('view engine', 'ejs');

// Use static resources from /samples directory
app.use(express.static("views"));

// Configure express application to use passportjs
app.use(passport.initialize());
app.use(passport.session());

passport.use(new WebAppStrategy({
	tenantId: config.tenantId,
	clientId: config.clientId,
	secret: config.secret,
	oauthServerUrl: config.oauthServerUrl,
	redirectUri: config.bluemixAppRoute + CALLBACK_URL
}));


// Configure passportjs with user serialization/deserialization. This is required
// for authenticated session persistence accross HTTP requests. See passportjs docs
// for additional information http://passportjs.org/docs
passport.serializeUser(function(user, cb) {
  cb(null, user);
});

passport.deserializeUser(function(obj, cb) {
  cb(null, obj);
});

// Explicit login endpoint. Will always redirect browser to login widget due to {forceLogin: true}.
// If forceLogin is set to false redirect to login widget will not occur of already authenticated users.
app.get(LOGIN_URL, passport.authenticate(WebAppStrategy.STRATEGY_NAME, {
  forceLogin: true
}));

// Callback to finish the authorization process. Will retrieve access and identity tokens/
// from AppID service and redirect to either (in below order)
// 1. the original URL of the request that triggered authentication, as persisted in HTTP session under WebAppStrategy.ORIGINAL_URL key.
// 2. successRedirect as specified in passport.authenticate(name, {successRedirect: "...."}) invocation
// 3. application root ("/")
app.get(CALLBACK_URL, passport.authenticate(WebAppStrategy.STRATEGY_NAME));


//Generat the main html page
app.get('/',function(req,res){
	res.sendfile(__dirname + '/views/index.html');
});

// Protected area. If current user is not authenticated - redirect to the login widget will be returned.
// In case user is authenticated - a page with current user information will be returned.
app.get("/protected", passport.authenticate(WebAppStrategy.STRATEGY_NAME), function(req, res){

	//return the protected page with user info
	res.render('protected',{name: req.user.name , picture:req.user.picture});
});

app.get("/token", function(req, res){

	//return the token data
	res.render('token',{tokens: JSON.stringify(req.session[WebAppStrategy.AUTH_CONTEXT])});
});

var port = process.env.PORT || 1234;
app.listen(port, function(){
  console.log("Listening on http://localhost:" + port);
});
