var express = require('express');
var engines = require('consolidate');
var path = require('path');
var logger = require('morgan');
var bodyParser = require('body-parser');
var app = express();
var session = require('express-session');
var protected = require('./routes/protected')(false);
var oauthCallback= require('./routes/oauth-callback')(false);

app.use(session({
  secret: 'BMDService',
  resave: false,
  saveUninitialized: true
}));

// Setup the view engine
app.set('views', path.join(__dirname, 'public'));
app.engine('html', engines.mustache);
app.set('view engine', 'html');

app.use(logger('dev'));
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.static(path.join(__dirname, 'node_modules/jquery.json-viewer/json-viewer')));
app.use('/', express.static(path.join(__dirname, 'public')));
app.use('/protected',protected);
app.use('/oauth-callback',oauthCallback);

// Catch the 404 error and forward it to the error handler
app.use(function(req, res, next) {
  var err = new Error('Not Found');
  err.status = 404;
  next(err);
});

// Development error handler
// This will print the stack trace
if (app.get('env') === 'development') {
  app.use(function(err, req, res, next) {
    res.status(err.status || 500);
    var errorUrl = '/error.html?errorMessage=' + err.message + '&errorStatus=' + err.status || 500 + '&errorStack=' + err.stack;
    res.redirect(errorUrl);
  });
}

// Production error handler
// No stack traces leaked to the user
app.use(function(err, req, res, next) {
  res.status(err.status || 500);
  var errorUrl = '/error.html?errorMessage=' + err.message;
  res.redirect(errorUrl);
});

module.exports = app;
