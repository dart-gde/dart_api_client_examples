// Run as 
// dart web/drive_v2/console/files/copy_example.dart

import "dart:io";
import "dart:async";
import "dart:json" as JSON;
import "package:google_oauth2_client/google_oauth2_console.dart";
import "package:google_drive_v2_api/drive_v2_api_console.dart" as drivelib;
import "package:http/http.dart" as http;

void copyFile(String fileId, drivelib.Drive drive, Function callback) {
  
  var request = drive.files.get(fileId).then((drivelib.File rtrvdFile) {
    drive.files.copy(rtrvdFile, fileId).then((drivelib.File copiedFile){
      Function.apply(callback,[copiedFile]);  
    });
  });
  
}

void onCopyFile(drivelib.File file) {
  print(file);
}

void run(Map client_secrets) {
  String identifier = client_secrets["client_id"];
  String secret = client_secrets["client_secret"];
  
  List scopes = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
  
  final auth = new OAuth2Console(identifier: identifier, secret: secret, scopes: scopes);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  copyFile("1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4", drive, onCopyFile);
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