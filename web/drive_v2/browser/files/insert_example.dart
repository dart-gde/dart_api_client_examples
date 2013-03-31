import "dart:html";
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "dart:json";

final SCOPES = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
final Element output = query("#output");

void insert_file(String clientId, String fileName) {
  var auth = new GoogleOAuth2(clientId, SCOPES);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  auth.login().then((token) {
    output.appendHtml("Got Token ${token.type} ${token.data}<br>");
    
    var body = {
      'title': fileName,
      'mimeType': "application/vnd.google-apps.document"
    };
    
    drivelib.File file = new drivelib.File.fromJson(body);
    drive.files.insert(file).then((drivelib.File newFile){
      output.appendHtml("Created File:  <a target='_blank' href='${newFile.alternateLink}'>${newFile.title}</a>");
    });
  }); 
}

void insert_folder(String clientId, String folderName) {
  var auth = new GoogleOAuth2(clientId, SCOPES);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  
  var body = {
    'title': folderName,
    'mimeType': "application/vnd.google-apps.folder"
  };
  
  drivelib.File file = new drivelib.File.fromJson(body);
  drive.files.insert(file).then((drivelib.File newFolder){
    output.appendHtml("<div>Inserted: <a target='_blank' href='${newFolder.alternateLink}'>${newFolder.title}</a></div>");
    var newPerms = new drivelib.Permission.fromJson({
      "value": "",
      "type": "anyone",
      "role": "reader"
    });
    
    drive.permissions.insert(newPerms, newFolder.id).then((drivelib.Permission updatedPermission) {
      output.appendHtml("updatedPermission = ${updatedPermission.toJson()}");
      drive.files.get(newFolder.id).then((drivelib.File fileWithLink) {
        output.appendHtml("<div>public web url: <a href='${fileWithLink.webViewLink}'>${fileWithLink.webViewLink}</a></div>");
      });
    });
  });
}