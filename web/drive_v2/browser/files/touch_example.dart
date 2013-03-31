import "dart:html";
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "dart:json";

final SCOPES = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
final Element output = query("#output");

void touch_file(String clientId, String fileId) {
  var auth = new GoogleOAuth2(clientId, SCOPES);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  auth.login().then((token) {
    output.appendHtml("Got Token ${token.type} ${token.data}<br>");
    
    drive.files.touch(fileId).then((drivelib.File touchedFile){
      output.appendHtml("<div>Touched File: <a target='_blank' href='${touchedFile.alternateLink}'>${touchedFile.title}</a>  Last Modified: ${touchedFile.modifiedDate}</div>");
    });
  }); 
}