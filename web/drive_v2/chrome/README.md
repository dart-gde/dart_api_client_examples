Example using http://pub.dartlang.org/packages/google_drive_v2_api from Dart to interface the Drive SDK in a Chrome Packaged App context.

Before running this example, make sure you:

* Create a client ID for an installed Chrome Application:
1 - Install this `chrome` folder as an unpacked extension [as described](http://developer.chrome.com/extensions/getstarted.html).  Copy the app ID as shown in chrome://extensions/.
2 - Create a new Project in the [Google API Console](https://code.google.com/apis/console).
3 - Turn on the Drive API service.
4 - Under API Access click the blue "Create an OAuth 2.0 client ID"
5 - Provide a name for your project and leave everything else blank.
6 - Select Installed Application for Application Type.
7 - Select Chrome Application for Installed application type.
8 - Provide the app ID from step 1 above for the Application ID.
9 - Replace `YOUR CLIENT ID` in the OAuth section of the manifest with your Client ID.
10 - In the console run `dart build.dart --full` in the chrome folder.


See [mimeTypes](http://stackoverflow.com/questions/11412497/what-are-the-google-apps-mime-types-in-google-docs-and-google-drive) for a list of Google Drive mimeTypes.

