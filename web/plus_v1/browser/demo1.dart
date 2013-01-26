import "dart:html";
import "package:api_client/plus_v1_api_browser.dart" as plusclient;

void main() {
  // use your own API Key from the API Console here
  var plus = new plusclient.Plus();
  plus.key = "AIzaSyDxnNu9Dm3eGxnDD72EF02IjRvR5v_eMPc";
  var container = query("#text");

  plus.activities.list("+FoldedSoft", "public", maxResults: 10)
    .then((plusclient.ActivityFeed data) {
      data.items.forEach((item) {
        container.appendHtml("<a href=\"${item.url}\">${item.published}</a> - ${item.title}<br>");
      });
    })
    .catchError((e) {
      container.appendHtml("$e<br>");
      return true;
    });
}
