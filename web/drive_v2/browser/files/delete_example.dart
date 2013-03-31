import "dart:html";
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "dart:json";

final SCOPES = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
final Element output = query("#output");

void delete_file(String clientId, String fileId) {
  var auth = new GoogleOAuth2(clientId, SCOPES);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  auth.login().then((token) {
    output.appendHtml("Got Token ${token.type} ${token.data}<br/>");
    
    drive.files.get(fileId).then((drivelib.File rtrvdFile){
      drive.files.copy(rtrvdFile, fileId).then((drivelib.File copiedFile){
        output.appendHtml("<div id='file'>Copied File:  <a target='_blank' href='${copiedFile.alternateLink}'>${copiedFile.title}</a><button id='delete'>delete</button></div>");

        ButtonElement delete = query("#delete");
        delete.onClick.listen((e){
          output.appendHtml("<div id='warning'><span style='color:red;'>WARNING: This can't be undone.  Are you sure?</span><button id='yes'>Yes</button><button id='no'>No</button></div>");
          ButtonElement yes = query("#yes");
          ButtonElement no = query("#no");
          DivElement warning = query("#warning");
          DivElement fileDiv = query("#file");
          
          yes.onClick.listen((e){
            drive.files.delete(copiedFile.id).then((deletedFile){
              output.appendHtml("Deleted file: ${deletedFile}");
            });
          });        
          no.onClick.listen((e){
            warning.remove();
          });
        });       
      });
    });    
  }); 
}