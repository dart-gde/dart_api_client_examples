Examples using http://pub.dartlang.org/packages/google_drive_v2_api from Dart console to interface the Drive SDK.

Before running these examples, make sure you:
* Complete step 1 of https://developers.google.com/drive/quickstart-python.  Setup a Client ID for installed applications.
* Download credentials.json from [Api Console](https://code.google.com/apis/console) into project root.

Run these using commandline.  The following shows an example for files/get_example.dart.
* Run get_example.dart from commandline in project root:

```
$ dart web/drive_v2/console/files/get_example.dart
```

* The console will output:

```
Client needs your authorization for scopes [https://www.googleapis.com/auth/drive.file, https://www.googleapis.com/auth/drive]
In a web browser, go to (You'll see a long url here.  Copy and paste it into browser.)
Then click "Allow access".

Waiting for your authorization...
```

* Navigate to url from output and click "Allow access".
* The console will output (make sure you supply your own fileId in get_example.dart):

```
{"thumbnailLink":"https://docs.google.com/feeds/vt?gd=true&id=1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4&v=2&s=AMedNnoAAAAAURaezJn6DXhjh25DS9GktFMtf3Y8VqSD&sz=s220","alternateLink":"https://docs.google.com/document/d/1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4/edit","lastViewedByMeDate":"2013-02-09T16:40:32.484Z","selfLink":"https://www.googleapis.com/drive/v2/files/1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4","quotaBytesUsed":"0","userPermission":{"type":"user","etag":"\"ky-gmqaUUYN8wxoFPgMc9ZipjMk/LVBDXG0ZNXsNYHmo79xHoMlEqAU\"","kind":"drive#permission","selfLink":"https://www.googleapis.com/drive/v2/files/1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4/permissions/me","id":"me","role":"owner"},"id":"1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4","shared":false,"exportLinks":{},"writersCanShare":true,"etag":"\"ky-gmqaUUYN8wxoFPgMc9ZipjMk/MTM2MDM4MTczMjYwNA\"","modifiedByMeDate":"2013-02-09T03:48:52.604Z","mimeType":"application/vnd.google-apps.document","title":"Dart Drive Example","parents":[{"kind":"drive#parentReference","parentLink":"https://www.googleapis.com/drive/v2/files/0AH15YrNkj-ZxUk9PVA","selfLink":"https://www.googleapis.com/drive/v2/files/1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4/parents/0AH15YrNkj-ZxUk9PVA","id":"0AH15YrNkj-ZxUk9PVA","isRoot":true}],"lastModifyingUserName":"Damon Douglas","createdDate":"2013-02-09T03:45:38.169Z","iconLink":"https://ssl.gstatic.com/docs/doclist/images/icon_11_document_list.png","kind":"drive#file","labels":{"starred":false,"viewed":true,"trashed":false,"hidden":false,"restricted":false},"modifiedDate":"2013-02-09T03:48:52.604Z","editable":true,"ownerNames":["Damon Douglas"],"embedLink":"https://docs.google.com/document/d/1z13pdHxgJAxZfTcA3zTuegwE5SYpfH3VWaQLAOl-Rc4/preview"}
```

See [mimeTypes](http://stackoverflow.com/questions/11412497/what-are-the-google-apps-mime-types-in-google-docs-and-google-drive) for a list of Google Drive mimeTypes.