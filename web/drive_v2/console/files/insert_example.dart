// Run as
// dart web/drive_v2/console/files/insert_example.dart

import "dart:io";
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

  String fileName = "Test New File";
  String mimeType = "application/vnd.google-apps.document";
  var body = {'title':fileName, 'mimeType':mimeType};
  client.File file = new client.File.fromJson(body);
  drive.files.insert(file).then((client.File newFile){
    print(newFile);
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