import "dart:html";
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "dart:json";

final SCOPES = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
final Element output = query("#output");

void update_file(String clientId, String fileId, String content) {
  
  String base64content = window.btoa(content);
  
  output.appendHtml(base64content);
  
  var auth = new GoogleOAuth2(clientId, SCOPES);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  auth.login().then((token) {
    output.appendHtml("Got Token ${token.type} ${token.data}<br>");
    
    drive.files.get(fileId).then((drivelib.File rtrvdFile){
      drive.files.update(rtrvdFile, fileId, content:base64content).then((drivelib.File updatedFile){
        output.appendHtml("<div>Updated File: <a target='_blank' href='${updatedFile.alternateLink}'>${updatedFile.title}</a></div>");
      });
      //
    });
  });
  
}