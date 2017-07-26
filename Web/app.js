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
const passport = require("passport");
const WebAppStrategy = require("bluemix-appid").WebAppStrategy;
const userAttributeManager = require("bluemix-appid").UserAttributeManager;
const app = express();
const helmet = require("helmet");
const express_enforces_ssl = require("express-enforces-ssl");
const cfEnv = require("cfenv");

// ADD APPID PARAMS


if (cfEnv.getAppEnv().isLocal) {
   console.error('This sample should not work locally, please push the sample to Bluemix.');
   process.exit(1);
}

// Security configuration
app.use(helmet());
app.use(helmet.noCache());
app.enable("trust proxy");
app.use(express_enforces_ssl());

// Setup express application to use express-session middleware
// Must be configured with proper session storage for production
// environments. See https://github.com/expressjs/session for
// additional documentation
app.use(session({
  secret: "123456",
  resave: true,
  saveUninitialized: true,
    proxy: true,
    cookie: {
        httpOnly: true,
        secure: true
    }
}));

app.set('view engine', 'ejs');

// Use static resources from /samples directory
app.use(express.static("views"));

// Configure express application to use passportjs
app.use(passport.initialize());
app.use(passport.session());

passport.use(new WebAppStrategy());

// Initialize the user attribute Manager
userAttributeManager.init();



//Generate the main html page
app.get('/',function(req,res){
    res.sendfile(__dirname + '/views/index.html');
});




// ADD APPID URLS


var port = process.env.PORT || 3000;
app.listen(port, function(){
  console.log("Listening on http://localhost:" + port);
});
