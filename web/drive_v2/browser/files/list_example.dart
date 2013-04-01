// See https://developers.google.com/drive/search-parameters for more information on queries.

import "dart:html";
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "dart:json";

final SCOPES = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
final Element output = query("#output");

void list_files(String clientId, String query) {
  var auth = new GoogleOAuth2(clientId, SCOPES);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  auth.login().then((token) {
    output.appendHtml("Got Token ${token.type} ${token.data}<br>");
    
    drive.files.list(maxResults:10,q:query).then((drivelib.FileList fileList){
      fileList.items.forEach((drivelib.File file){
        output.appendHtml("<div><a target='_blank' href='${file.alternateLink}'>${file.title}</a></div>");
      });
    });
  }); 
}