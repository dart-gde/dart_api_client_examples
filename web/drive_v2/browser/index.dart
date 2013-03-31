import 'dart:html';
import 'dart:json';
import 'files/get_example.dart';
import 'files/copy_example.dart';
import 'files/delete_example.dart';
import 'files/insert_example.dart';
import 'files/list_example.dart';
import 'files/patch_example.dart';
import 'files/touch_example.dart';
import 'files/trash_example.dart';
import 'files/untrash_example.dart';
import 'files/update_example.dart';

final ButtonElement login = query("#login");

main() {
  
  HttpRequest.getString("/client_secrets.json").then((secretsFile){
    
    Map secrets = parse(secretsFile);
    window.localStorage["client_id"] = secrets["web"]["client_id"];
    login.disabled = false;
    
  });
  
  login.onClick.listen((e){
    
    var clientId = window.localStorage["client_id"];
    
    //Uncomment one method call below for the one you want to demo:
    
    get_file(clientId, "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4");
    //copy_file(clientId, "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4");
    //delete_file(clientId, "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4");
    //insert_file(clientId, "New File Example");
    //insert_folder(clientId, "New Folder Example");
    //list_files(clientId, "mimeType = 'application/vnd.google-apps.document'");
    //patch_file(clientId, "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4", {'title':'Dart Drive Example New Title'});
    //touch_file(clientId, "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4");
    //trash_file(clientId, "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4");
    //untrash_file(clientId, "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4");
    //update_file(clientId, "1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4", "All work and no play makes Jack a dull boy");
    
  });
  
}