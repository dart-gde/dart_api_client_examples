// Run as 
// dart web/drive_v2/console/files/insert_folder_example.dart

import "dart:io";
import "dart:async";
import "dart:json" as JSON;
import "package:google_oauth2_client/google_oauth2_console.dart";
import "package:google_drive_v2_api/drive_v2_api_console.dart" as drivelib;
import "package:http/http.dart" as http;

void createPublicFolder(folderName, drivelib.Drive drive) {
  print("enter createPublicFolder");
  var body = {
    'title': folderName,
    'mimeType': "application/vnd.google-apps.folder"
  };

  drivelib.File file = new drivelib.File.fromJson(body);
  var request = drive.files.insert(file).then((drivelib.File newFile) {
        print("inserted: ${newFile.title} ${newFile.id}");

          var newPerms = new drivelib.Permission.fromJson({
            "value": "",
            "type": "anyone",
            "role": "reader"
          });

        drive.permissions.insert(newPerms, newFile.id).then((drivelib.Permission updatedPermission) {
          print("updatedPermission = ${updatedPermission.toJson()}");
          drive.files.get(newFile.id).then((drivelib.File fileWithLink) {
            print("public web url: ${fileWithLink.webViewLink}");
          });
        });
      });
}

void run(Map client_secrets) {
  String identifier = client_secrets["client_id"];
  String secret = client_secrets["client_secret"];
  //showAll();
  
  List scopes = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
  
  final auth = new OAuth2Console(identifier: identifier, secret: secret, scopes: scopes);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  createPublicFolder("public_folder", drive);
}

void main() {
  
  String path = "client_secrets.json";
  File secrets = new File(path);
  secrets.exists().then((bool exists){
    if(exists) {
      secrets.readAsString().then((String content){
        Map client_secret_installed = JSON.parse(content);
        Map client_secrets = client_secret_installed["installed"];
          run(client_secrets);
        });
      }
    });
    
}