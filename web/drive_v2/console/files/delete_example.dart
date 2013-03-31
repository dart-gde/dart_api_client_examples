// WARNING! DELETING BYPASSES THE TRASH AND CAN'T BE UNDONE

// Run as 
// dart web/drive_v2/console/files/delete_example.dart

import "dart:io";
import "dart:json" as JSON;
import "package:google_oauth2_client/google_oauth2_console.dart";
import "package:google_drive_v2_api/drive_v2_api_console.dart" as drivelib;

void run(Map client_secrets) {
  String identifier = client_secrets["client_id"];
  String secret = client_secrets["client_secret"];
  
  List scopes = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
  
  final auth = new OAuth2Console(identifier: identifier, secret: secret, scopes: scopes);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  String fileName = "Test New File 9pm";
  String mimeType = "application/vnd.google-apps.document";
  var body = {'title': fileName, 'mimeType': mimeType };

  drivelib.File file = new drivelib.File.fromJson(body);

  drive.files.insert(file).then((drivelib.File newFile){
    print("Created: ${newFile.title}: ${newFile.id}");
    String fileId = newFile.id;
    drive.files.delete(fileId).then((deletedFile){
      print("Deleted: $deletedFile");
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