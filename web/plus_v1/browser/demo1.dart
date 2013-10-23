import "dart:html";
import "package:google_plus_v1_api/plus_v1_api_browser.dart" as pluslib;
import "package:google_plus_v1_api/plus_v1_api_client.dart" as pluslib_client;

void main() {
  // use your own API Key from the API Console here
  var plus = new pluslib.Plus();
  plus.key = "AIzaSyDxnNu9Dm3eGxnDD72EF02IjRvR5v_eMPc";
  var container = querySelector("#text");

  plus.activities.list("+FoldedSoft", "public", maxResults: 10)
    .then((pluslib_client.ActivityFeed data) {
      data.items.forEach((item) {
        container.appendHtml("<a href=\"${item.url}\">${item.published}</a> - ${item.title}<br>");
      });
    })
    .catchError((e) {
      container.appendHtml("$e<br>");
      return true;
    });
}
