import 'dart:html';
import 'dart:convert';
import 'dart:async';
import "package:google_oauth2_client/google_oauth2_browser.dart" as oauth;
import "package:google_drive_v2_api/drive_v2_api_browser.dart" as drivelib;
import 'src/files.dart';

final DivElement output = querySelector("#output");
final ButtonElement loginBtn = querySelector("#login");
final InputElement fileId = querySelector("#fileId");
final ButtonElement insert = querySelector("#insert");
final ButtonElement list = querySelector("#list");
final SCOPES = [drivelib.Drive.DRIVE_FILE_SCOPE, drivelib.Drive.DRIVE_SCOPE];

final Map actions = {
  "get":_get,
  "delete":_delete,
  "patch":_patch,
  "trash":_trash,
  "untrash":_untrash,
  "update":_update,
  "touch":_touch,
  "copy":_copy
};

main() {
  
  HttpRequest.getString("client_secret.json").then((secretsFile){
    Map secrets = JSON.decode(secretsFile);
    window.localStorage["client_id"] = secrets["web"]["client_id"];
    loginBtn.disabled = false;
  });
  
  actions.forEach((k,v){
    querySelector("#$k").onClick.listen(v);
  });
  
  fileId.onInput.listen(_toggleBtns);
  
  fileId.onChange.listen(_toggleBtns);
  
  loginBtn.onClick.listen((e){
    _getToken().then((token){
      loginBtn.disabled = true;
      fileId.disabled = false;
      insert.disabled = false;
      list.disabled = false;
    });
  });
  
  insert.onClick.listen(_insert);
  list.onClick.listen(_list);
}

Future <oauth.Token> _getToken(){
  var completer = new Completer();
  var clientId = window.localStorage["client_id"];
  var auth = new oauth.GoogleOAuth2(clientId, SCOPES);

  if (!window.localStorage.containsKey('token')){
    auth.login().then((oauth.Token token) {
      window.localStorage["token"] = token.toJson();
      completer.complete(token);
    });
  } else {
    Map map = JSON.decode(window.localStorage["token"]);
    var type = map["type"];
    var data = map["data"];
    var expiry = new DateTime.fromMillisecondsSinceEpoch(map['expiry']);
    var token = new oauth.Token(type,data,expiry);
    var request = new HttpRequest();
    request.open("GET", "https://www.googleapis.com/oauth2/v1/tokeninfo?access_token=$data");
    request.onLoad.listen((e){
      if(request.status == 200) {
        var token = new oauth.Token(type,data,expiry);
        completer.complete(token);
      }else
      {
        auth.login().then((oauth.Token token) {
          window.localStorage["token"] = token.toJson();
          completer.complete(token);
        });
      }
    });
    try {
      request.send();
    } catch(e){
      auth.login().then((oauth.Token token) {
        window.localStorage["token"] = token.toJson();
        completer.complete(token);
      });  
    }
  }
  return completer.future;
}

void _toggleBtns(e){
  actions.forEach((k,v){
    ButtonElement e = querySelector("#$k");
    e.disabled = fileId.value.isEmpty;
  });
}

void _get(e) {
  _getToken().then((token){
    var _fileId = fileId.value;
    get_file(token, _fileId).then((file){
      fileId.value = file.id;
      output.text = file.toString();
      _toggleBtns(e);
    });
  });
}

void _insert(e) {
  _getToken().then((token){
    insert_file(token, "New File Example").then((file){
      fileId.value = file.id;
      output.text = file.toString();
      _toggleBtns(e);
    });
  });
}

void _delete(e) {
  _getToken().then((token){
    var _fileId = fileId.value;
    delete_file(token, _fileId, output).then((file){
      fileId.value = "";
      output.text = "Deleted File: $_fileId";
      _toggleBtns(e);
    });
  });
}

void _copy(e) {
  _getToken().then((token){
    var _fileId = fileId.value;
    copy_file(token, _fileId).then((file){
      fileId.value = file.id;
      output.text = file.toString();
      _toggleBtns(e);
    });
  });
}

void _list(e){
  _getToken().then((token){
    list_files(token, "mimeType = 'application/vnd.google-apps.document' AND trashed = false").then((fileList){
      output.innerHtml = '';
      fileId.value = '';
      fileList.items.forEach((drivelib.File file){
        output.appendHtml("<div><a target='_blank' href='${file.alternateLink}'>${file.title}</a>: ${file.id}</div>");
      });
      _toggleBtns(e);
    });
  });
}

void _patch(e) {
  _getToken().then((token){
    var _fileId = fileId.value;
    patch_file(token, _fileId, "New File Example2").then((file){
      fileId.value = file.id;
      output.text = file.toString();
      _toggleBtns(e);
    });
  });
}

void _touch(e) {
  _getToken().then((token){
    var _fileId = fileId.value;
    touch_file(token, _fileId).then((file){
      fileId.value = file.id;
      output.text = file.toString();
      _toggleBtns(e);
    });
  });
}

void _trash(e) {
  _getToken().then((token){
    var _fileId = fileId.value;
    trash_file(token, _fileId).then((file){
      fileId.value = file.id;
      output.text = file.toString();
      _toggleBtns(e);
    });
  });
}

void _untrash(e) {
  _getToken().then((token){
    var _fileId = fileId.value;
    untrash_file(token, _fileId).then((file){
      fileId.value = file.id;
      output.text = file.toString();
      _toggleBtns(e);
    });
  });
}

void _update(e) {
  _getToken().then((token){
    var _fileId = fileId.value;
    update_file(token, _fileId,"All Work and No Play Makes Jack a dull boy.").then((file){
      fileId.value = file.id;
      output.text = file.toString();
      _toggleBtns(e);
    });
  });
}