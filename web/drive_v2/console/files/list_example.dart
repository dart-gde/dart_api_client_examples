// Run as
// dart web/drive_v2/console/files/list_example.dart

// See https://developers.google.com/drive/search-parameters for more information on queries.

import "dart:io";
import "dart:async";
import "dart:json" as JSON;
import "package:google_oauth2_client/google_oauth2_console.dart";
import "package:google_drive_v2_api/drive_v2_api_console.dart" as drivelib;
import "package:google_drive_v2_api/drive_v2_api_client.dart" as client;

void run(Map client_secrets) {
  String identifier = client_secrets["client_id"];
  String secret = client_secrets["client_secret"];
  List scopes = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
  final auth = new OAuth2Console(identifier: identifier, secret: secret, scopes: scopes);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  String query = "mimeType = 'application/vnd.google-apps.document'";
  drive.files.list(maxResults:10,q:query).then((client.FileList fileList){
    fileList.items.forEach((client.File file){
      print("${file.title}: ${file.id}");
    });
  });
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