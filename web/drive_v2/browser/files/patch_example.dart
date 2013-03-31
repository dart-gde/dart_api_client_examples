import "dart:html";
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "dart:json";

final SCOPES = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
final Element output = query("#output");

void patch_file(String clientId, String fileId, Map newMetaData) {
  var auth = new GoogleOAuth2(clientId, SCOPES);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  auth.login().then((token) {
    output.appendHtml("Got Token ${token.type} ${token.data}<br>");
    drivelib.File file = new drivelib.File.fromJson(newMetaData);
    drive.files.patch(file,fileId).then((drivelib.File patchedFile){
      output.appendHtml("<div>Changed File To: <a href='${patchedFile.alternateLink}'>${patchedFile.title}</a></div>");
    });
  }); 
}