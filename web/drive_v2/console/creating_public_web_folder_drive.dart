import "dart:io";
import "dart:async";
import "dart:json" as JSON;
import "package:google_oauth2_client/google_oauth2_console.dart";
import "package:api_client/drive_v2_api_console.dart" as driveclient;
import "package:http/http.dart" as http;

createPublicFolder(folderName, driveclient.Drive drive) {
  print("enter createPublicFolder");
  var body = {
    'title': folderName,
    'mimeType': "application/vnd.google-apps.folder"
  };

  driveclient.File file = new driveclient.File.fromJson(body);
  var request = drive.files.insert(file).then((driveclient.File newFile) {
        print("inserted: ${newFile.title} ${newFile.id}");

          var newPerms = new driveclient.Permission.fromJson({
            "value": "",
            "type": "anyone",
            "role": "reader"
          });

        drive.permissions.insert(newPerms, newFile.id).then((driveclient.Permission updatedPermission) {
          print("updatedPermission = ${updatedPermission.toJson()}");
          drive.files.get(newFile.id).then((driveclient.File fileWithLink) {
            print("public web url: ${fileWithLink.webViewLink}");
          });
        });
      });
}

void main() {
  showAll();
  String identifier = "299615367852-n0kfup30mfj5emlclfgud9g76itapvk9.apps.googleusercontent.com";
  String secret = "8ini0niNxsDN0y42ye_UNubw";
  List scopes = [driveclient.Drive.DRIVE_FILE_SCOPE, driveclient.Drive.DRIVE_SCOPE];
  print(scopes);
  final auth = new OAuth2Console(identifier: identifier, secret: secret, scopes: scopes);
  var drive = new driveclient.Drive(auth);
  drive.makeAuthRequests = true;
  createPublicFolder("public_folder", drive);
}