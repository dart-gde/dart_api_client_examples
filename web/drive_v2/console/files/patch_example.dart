// Run as 
// dart web/drive_v2/console/files/patch_example.dart


import "dart:io";
import "dart:async";
import "dart:json" as JSON;
import "package:google_oauth2_client/google_oauth2_console.dart";
import "package:google_drive_v2_api/drive_v2_api_console.dart" as drivelib;
import "package:http/http.dart" as http;

void patchFile(String fileId, Map newMetaData, drivelib.Drive drive, Function callback) {
  
  drivelib.File file = new drivelib.File.fromJson(newMetaData);
  
  drive.files.patch(file,fileId).then((drivelib.File patchedFile){
    Function.apply(callback,[patchedFile]);
  });
  
}

void onPatchFile(drivelib.File file) {
  print(file);
}

void run(Map client_secrets) {
  String identifier = client_secrets["client_id"];
  String secret = client_secrets["client_secret"];
  
  List scopes = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
  
  final auth = new OAuth2Console(identifier: identifier, secret: secret, scopes: scopes);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  Map newMetaData = {
                     "title":"Just Changed Title Again2"
  };
  patchFile("180oQjByG0c2U2vxD1ujyIyJ0fLu7yEQ-kXIHavCbLBo", newMetaData, drive, onPatchFile);
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