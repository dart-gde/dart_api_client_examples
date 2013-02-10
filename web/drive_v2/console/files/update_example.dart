// Run as 
// dart web/drive_v2/console/files/update_example.dart

import "dart:io";
import "dart:async";
import "dart:json" as JSON;
import "package:google_oauth2_client/google_oauth2_console.dart";
import "package:google_drive_v2_api/drive_v2_api_console.dart" as drivelib;
import "package:http/http.dart" as http;
import "dart:crypto";

void updateFile(String fileId, String base64content, drivelib.Drive drive, Function callback) {
  
  var request = drive.files.get(fileId).then((drivelib.File rtrvdFile){
    drive.files.update(rtrvdFile, fileId, content:base64content).then((drivelib.File updatedFile){
      Function.apply(callback,[updatedFile]);
    });
  });
    
}

void onUpdateFile(drivelib.File file) {
  print(file);
}

void run(Map client_secrets) {
  String identifier = client_secrets["client_id"];
  String secret = client_secrets["client_secret"];
  
  List scopes = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
  
  final auth = new OAuth2Console(identifier: identifier, secret: secret, scopes: scopes);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  String content = "All work and no play makes Jack a dull boy";
  
  ListOutputStream los = new ListOutputStream();
  los.writeString(content);
  String base64content = CryptoUtils.bytesToBase64(los.read());
  
  updateFile("180oQjByG0c2U2vxD1ujyIyJ0fLu7yEQ-kXIHavCbLBo", base64content, drive, onUpdateFile);
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

