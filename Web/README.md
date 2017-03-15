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
  authorizationEndpoint: 'Get it from your APPID Service ',
  tokenEndpoint: 'Get it from your APPID Service ',
  clientId: 'Get it from your APPID Service ',
  secret: 'Get it from your APPID Service ',
  redirectURL: 'https://yourwebsiteName.stage1.mybluemix.net/oauth-callback',
  appRegion: "Service region - like .stage1.ng.bluemix.net",
  pushAPPGUID: "Push service App Guid",
  pushClientSecret: "Push service Client Secret"
```

3. Go to [Firebase](https://console.firebase.google.com/) and create an app and get `Legacy Server key` and `Sender ID` from `CLOUD MESSAGING` section.

4. Open the `public/manifest.json` file and add values for `name` and `gcm_sender_id`.

5. Go tho the root folder `Web_starter` in your terminal.

6. Run the `CLI` command - `cf api api.stage1.ng.bluemix.net` ,

7. Login to bluemix from CLI using `cf login`. Select your `Organization` and `Space`.

8. Do the `cf push`. This will host your app in Bluemix. 

9. After App is started open - `https://yourwebsitename.stage1.mybluemix.net`. 

>Note : Load your website with <bold>HTTPS</bold>.