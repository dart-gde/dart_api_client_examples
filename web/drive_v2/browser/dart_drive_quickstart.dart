import "dart:html";
import "dart:typed_data";
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import "package:google_drive_v2_api/drive_v2_api_client.dart" as client;
import "package:google_oauth2_client/google_oauth2_browser.dart";

final CLIENT_ID = "796343192238.apps.googleusercontent.com";
final SCOPES = [drivelib.Drive.DRIVE_FILE_SCOPE];

void main() {
  var auth = new GoogleOAuth2(CLIENT_ID, SCOPES);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  var filePicker = query("#filePicker");
  var loginButton = query("#login");
  var output = query("#text");

  void uploadFile(Event evt) {
    var file = (evt.target as InputElement).files[0];
    var reader = new FileReader();
    reader.readAsArrayBuffer(file);
    reader.onLoad.listen((Event e) {
      var contentType = file.type;
      if (contentType.isEmpty) {
        contentType = 'application/octet-stream';
      }

      var uintlist = new Uint8List.fromList(reader.result);
      var charcodes = new String.fromCharCodes(uintlist);
      var base64Data = window.btoa(charcodes);
      var newFile = new client.File.fromJson({"title": file.name, "mimeType": contentType});
      output.appendHtml("Uploading file...<br>");
      drive.files.insert(newFile, content: base64Data, contentType: contentType)
        .then((data) {
          output.appendHtml("Uploaded file with ID <a href=\"${data.alternateLink}\" target=\"_blank\">${data.id}</a><br>");
        })
        .catchError((e) {
          output.appendHtml("$e<br>");
          return true;
        });

    });
  }

  filePicker.onChange.listen(uploadFile);
  loginButton.onClick.listen((Event e) {
    auth.login().then((token) {
      output.appendHtml("Got Token ${token.type} ${token.data}<br>");
      filePicker.style.display = "block";
    });
  });
}