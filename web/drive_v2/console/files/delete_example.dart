// WARNING! DELETING BYPASSES THE TRASH AND CAN'T BE UNDONE

// Run as 
// dart web/drive_v2/console/files/delete_example.dart

import "dart:io";
import "dart:async";
import "dart:json" as JSON;
import "package:google_oauth2_client/google_oauth2_console.dart";
import "package:google_drive_v2_api/drive_v2_api_console.dart" as drivelib;
import "package:http/http.dart" as http;

void deleteFile(String fileId, drivelib.Drive drive, Function callback) {
  var request = drive.files.get(fileId).then((drivelib.File rtrvdFile) {
    
    drive.files.delete(fileId).then((f){
      print(f);
    });
    
  });
}

void onDeleteFile(drivelib.File file) {
  print("Deleted: ${file.id}");
}

void insertFile(String fileName, String mimeType, drivelib.Drive drive, Function callback) {
  
  var body = {
              'title': fileName,
              'mimeType': mimeType
  };

  drivelib.File file = new drivelib.File.fromJson(body);
  
  var request = drive.files.insert(file).then((drivelib.File newFile) {
    Function.apply(callback,[newFile, drive]);  
  });
    
}

void onInsertFile(drivelib.File file, drivelib.Drive drive) {
  print("Created: ${file.id}");
  String fileId = file.id;
  deleteFile(fileId, drive, onDeleteFile);
}

void run(Map client_secrets) {
  String identifier = client_secrets["client_id"];
  String secret = client_secrets["client_secret"];
  
  List scopes = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
  
  final auth = new OAuth2Console(identifier: identifier, secret: secret, scopes: scopes);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  insertFile("Test New File", "application/vnd.google-apps.document", drive, onInsertFile);
  
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




