import 'dart:chrome';
import 'dart:html';
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import "package:google_oauth2_client/google_oauth2_browser.dart";
import "dart:json";
import "dart:async";

final DivElement authTokenElement = query("#auth_token");
final DivElement output = query("#output");
final ButtonElement getButton = query("#get");
final ButtonElement insertButton = query("#insert");
final ButtonElement listButton = query("#list");
final ButtonElement updateButton = query("#update");

void main() {

    getButton.onClick.listen((e){
      
      handleOAuth().then((drive){
        String fileId = "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4";
        drive.files.get(fileId).then((drivelib.File rtrvdFile){
          output.innerHtml = stringify(rtrvdFile);
        });
      });
    });
    
    insertButton.onClick.listen((e){
      handleOAuth().then((drive){
        var body = {
                    'title': "Dart, Drive and Chrome Example",
                    'mimeType': "application/vnd.google-apps.document"
        };
        drivelib.File file = new drivelib.File.fromJson(body);
        drive.files.insert(file).then((drivelib.File newFile){
          output.innerHtml = "Created: ${newFile.title}: ${newFile.id}";
        });
      });
    });
    
    listButton.onClick.listen((e){
      handleOAuth().then((drive){
        var query = "mimeType = 'application/vnd.google-apps.document'";
        output.innerHtml = "<h2>Results from query: $query </h2>";
        drive.files.list(maxResults:10,q:query).then((drivelib.FileList fileList){
          fileList.items.forEach((drivelib.File file){
            output.appendHtml("<div>${file.title}: ${file.id}<br/></div>");
          });
        });
      });
    });
    
    updateButton.onClick.listen((e){
      handleOAuth().then((drive){
        var content = "All work and no play makes Jack a dull boy.";
        String base64content = window.btoa(content);
        String fileId = "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4";
        drive.files.get(fileId).then((drivelib.File rtrvdFile){
          drive.files.update(rtrvdFile, fileId, content:base64content).then((drivelib.File updatedFile){
            output.innerHtml = "Updated file: ${updatedFile.title}: ${updatedFile.id}";
          });
        });
      });
    });
}

Future<drivelib.Drive> handleOAuth() {
  var auth_token = authTokenElement.text;
  var completer = new Completer();
  
  var auth = new SimpleOAuth2(auth_token);
  var drive = new drivelib.Drive(auth);
  drive.makeAuthRequests = true;
  completer.complete(drive);
  
  return completer.future;
}