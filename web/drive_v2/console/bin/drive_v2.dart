import "dart:async";
import "dart:io";
import "package:google_oauth2_client/google_oauth2_console.dart" as oauth;
import "package:google_drive_v2_api/drive_v2_api_console.dart" as drivelib;
import "package:google_drive_v2_api/drive_v2_api_client.dart" as driveclient show File,FileList;
import "package:crypto/crypto.dart" show CryptoUtils;

const _IDENTIFIER =
  "81884541313-k0ukbp0o5gcpj0g4ejct2u2q8givoinu.apps.googleusercontent.com";
const _SECRET = "YGYEl0GbO8oxPWL-HXarDlv4";
const _SCOPES = const ["https://www.googleapis.com/auth/drive","https://www.googleapis.com/auth/drive.file"];

final Map actions = {
 '-i':insert_file,
 '-insert':insert_file,
 '-g':get_file,
 '-get':get_file,
 '-c':copy_file,
 '-copy':copy_file,
 '-p':patch_file,
 '-patch':patch_file,
 '-t':touch_file,
 '-touch':touch_file,
 '-tu':trash_file,
 '-trash':trash_file,
 '-ut':untrash_file,
 '-untrash':untrash_file
};

void main(List args) {
  var auth = new oauth.OAuth2Console(identifier: _IDENTIFIER,
      secret: _SECRET,
      scopes: _SCOPES);

  //I'm sure there is a more elegant way to do this.
  if(args.length!=2) print(_getUsage());
  else {
    var option = args[0];
    var param = args[1];
    List scopes = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];
    final auth = new oauth.OAuth2Console(identifier: _IDENTIFIER, secret: _SECRET, scopes: scopes);
    var drive = new drivelib.Drive(auth);
    drive.makeAuthRequests = true;

    if (!['-l','-list','-u','-update','-d','-delete'].contains(option)) {  
      actions[option](drive,param).then((resultFile){
        print(resultFile);
      });
    } else if (['-l','-list'].contains(option)){
      list_files(drive, param).then((fileList){
        fileList.items.forEach((driveclient.File file){
          print("${file.title}: ${file.id}");
        });
      });
    } else if (['-u','-update'].contains(option)){
      update_file(drive, param, "All Work and No Play Makes Jack a Dull Boy").then((updatedFile){
        print(updatedFile);
      });
    } else if (['-d','-delete'].contains(option)) {
      delete_file(drive, param).then((_){});
    }
  }
}

String _getUsage() {
  return """
Operate on Google Drive Files:
-i, --insert <filename>: Insert <filename>.
-c, --copy <fileId>: Copy file.
-t, --touch <fileId>: Touch file.
-p, --patch <fileId>: Patch file.
-g, --get <fileId>: Get file.
-l, --list <query>: List files from <query> (example: "mimeType = 'application/vnd.google-apps.document' AND trashed = false").
-u, --update <fileId>: Update file with "All Work and No Play Makes Jack a Dull Boy".
-tu, --trash <fileId>: Trash file.
-ut, --untrash <fileId>: Untrash file.
-d, --delete <fileId>:  Ooooo be careful.  Can't be undone.
  """;
}

Future <driveclient.File> get_file(drivelib.Drive drive, String fileId) {
  var completer = new Completer();
  drive.files.get(fileId).then((driveclient.File rtrvdFile){
    completer.complete(rtrvdFile);
  });
  return completer.future;
}


Future <driveclient.File> insert_file(drivelib.Drive drive, String fileName) {
  var completer = new Completer();
  var body = {
              'title': fileName,
              'mimeType': "application/vnd.google-apps.document"
  };
  driveclient.File file = new driveclient.File.fromJson(body);
  drive.files.insert(file).then((driveclient.File newFile){
    completer.complete(newFile);
  });
  return completer.future;
}

Future <driveclient.File> copy_file(drivelib.Drive drive, String fileId) {
  var completer = new Completer();
  drive.files.get(fileId).then((driveclient.File rtrvdFile){
    drive.files.copy(rtrvdFile, fileId).then((driveclient.File copiedFile){
      completer.complete(copiedFile);
    });
  });
  return completer.future;
}

Future delete_file(drivelib.Drive drive, String fileId) {
  var completer = new Completer();
  drive.files.get(fileId).then((driveclient.File rtrvdFile){
    print("Ooooo be careful.  Can't be undone. ARE YOU SURE?  Type filename to delete forever or 'quit'");
    print("Filename: ${rtrvdFile.title}");
    var answer = stdin.readLineSync();
    if(answer == rtrvdFile.title){
      drive.files.delete(fileId).then((deletedFile){
        completer.complete();
      }); 
    }
  });
  
  return completer.future;
}

Future <driveclient.File> patch_file(drivelib.Drive drive, String fileId) {
  var completer = new Completer();
  var body = {
              'title': 'new file name',
              'mimeType': "application/vnd.google-apps.document"
  };
  driveclient.File file = new driveclient.File.fromJson(body);
  drive.files.patch(file, fileId).then((driveclient.File patchedFile){
    completer.complete(patchedFile);
  });
  return completer.future;
}

Future <driveclient.FileList> list_files(drivelib.Drive drive, String query){
  var completer = new Completer();
  drive.files.list(maxResults:10,q:query).then((driveclient.FileList fileList){
    completer.complete(fileList);
  });
  return completer.future;
}

Future <driveclient.File>  touch_file(drivelib.Drive drive, String fileId) {
  var completer = new Completer();
  drive.files.touch(fileId).then((driveclient.File touchedFile){
    completer.complete(touchedFile);
  });
  return completer.future;
}

Future <driveclient.File> trash_file(drivelib.Drive drive, String fileId) {
  var completer = new Completer();
  drive.files.trash(fileId).then((driveclient.File trashedFile){
    completer.complete(trashedFile);
  });
  
  return completer.future;
}

Future <driveclient.File> untrash_file(drivelib.Drive drive, String fileId) {
  var completer = new Completer();
  drive.files.untrash(fileId).then((driveclient.File untrashedFile){
    completer.complete(untrashedFile);
  });
  return completer.future;
}

Future <driveclient.File> update_file(drivelib.Drive drive, String fileId, String content){
  String base64content = CryptoUtils.bytesToBase64(content.codeUnits);
  var completer = new Completer();
  drive.files.get(fileId).then((driveclient.File rtrvdFile){
    drive.files.update(rtrvdFile, fileId, content:base64content).then((driveclient.File updatedFile){
      completer.complete(updatedFile);
    });
  });
  return completer.future;
}
