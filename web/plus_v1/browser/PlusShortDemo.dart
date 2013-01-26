import "dart:html";
import "package:api_client/plus_v1_api_browser.dart" as plusclient;
import "package:api_client/urlshortener_v1_api_browser.dart" as urlshortenerclient;

void main() {
  // use your own API Key from the API Console here
  var plus = new plusclient.Plus();
  plus.key = "AIzaSyDxnNu9Dm3eGxnDD72EF02IjRvR5v_eMPc";
  var shortener = new urlshortenerclient.Urlshortener();
  shortener.key = "AIzaSyDxnNu9Dm3eGxnDD72EF02IjRvR5v_eMPc";
  var container = query("#text");
  
  plus.activities.list("+FoldedSoft", "public", maxResults: 5)
    .then((data) {
      data.items.forEach((item) {
        shortener.url.insert(new urlshortenerclient.Url.fromJson({"longUrl": item.url}))
          .then((url) {
            container.appendHtml("<a href=\"${url.id}\">${url.id}</a> ${item.published} - ${item.title}<br>");
          })
          .catchError((e) {
            container.appendHtml("$e<br>");
            return true; 
          });
      });
    })
    .catchError((e) {
      container.appendHtml("$e<br>");
      return true; 
    });
}
