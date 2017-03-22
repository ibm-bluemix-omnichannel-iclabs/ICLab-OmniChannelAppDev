BMDService - Web Final App
===================================================


This is a completed Web app.

Before starting the Web app building open bluemix and do the following,

1. Create a [Bluemix Push service](https://console.stage1.ng.bluemix.net/docs/services/mobilepush/index.html) and configure the service
2. Create a [Bluemix  AppId service](https://console.stage1.ng.bluemix.net/docs/services/appid/index.html#gettingstarted) and enable FaceBook and Google Login


Please follow the steps to run the app,

1. Open `manifest.yml` file. Change the `host` and `name` to your website name.

2. Open the `Config.js` file and add your credentials

```
  oauthServerUrl: 'Get it from your APPID Service ',
  clientId: 'Get it from your APPID Service ',
  tenantId: 'Get it from your APPID Service ',
  secret: 'Get it from your APPID Service ',

```

3. Go to [Firebase](https://console.firebase.google.com/) and create an app and get `Legacy Server key` and `Sender ID` from `CLOUD MESSAGING` section.

4. Open the `views/manifest.json` file and add values for `name` and `gcm_sender_id`.

5.  Open the `views/protected.ejs` file and add values for ,

```
var initParams = {
     "appGUID":"97ea15df-0ca1-4ff0-8c54-fb46259204f8",
     "appRegion":".stage1-dev.ng.bluemix.net",
     "clientSecret":"a6e5635d-88b8-4cbd-bc00-58f1be61d6c6"
   }

   var userId = "kg"
```

Inside teh `registerPush` method .

5. Go the root folder `Web` in your terminal.

6. Run the `CLI` command - `cf api api.stage1.ng.bluemix.net` ,

7. Login to bluemix from CLI using `cf login`. Select your `Organization` and `Space`.

8. Do the `cf push`. This will host your app in Bluemix.

9. After App is started open - `https://yourwebsitename.stage1.mybluemix.net`.

>Note : Load your website with <bold>HTTPS</bold>.
