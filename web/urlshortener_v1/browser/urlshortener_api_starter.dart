import "dart:html";
import "package:google_urlshortener_v1_api/urlshortener_v1_api_browser.dart" as urlshortenerlib;
import "package:google_urlshortener_v1_api/urlshortener_v1_api_client.dart" as urlshortenerlib_client;
import "package:google_oauth2_client/google_oauth2_browser.dart";

var auth, urlshortener;

final CLIENT_ID = "796343192238.apps.googleusercontent.com";
final SCOPES = [urlshortenerlib.Urlshortener.URLSHORTENER_SCOPE];

void debugLog(String message) {
  querySelector("#debug-panel").text = "$message\n${querySelector("#debug-panel").text}";
}

void historyLog(String message) {
  querySelector("#history-panel").text = "$message\n${querySelector("#history-panel").text}";
}

void analyticsLog(String message) {
  querySelector("#analytics-panel").text = "$message\n${querySelector("#analytics-panel").text}";
}

String formatJson(String json) {
  json = json.replaceAll("\":", "\": ");
  json = json.replaceAll(",\"", ",\n\"");
  json = json.replaceAll("\": {", "\":\n{");
  return json;
}

void toggleInterface(token) {
  if (token == null) {
    debugLog("Logged out.");
    urlshortener.makeAuthRequests = false;
  } else {
    debugLog("Auth Success ${token.toString()}");
    urlshortener.makeAuthRequests = true;
  }
  querySelector("#panel-sign-in").style.display = (token == null) ? "block" : "none";
  querySelector("#panel-sign-out").style.display = (token == null) ? "none" : "block";
}

void main() {

  auth = new GoogleOAuth2(CLIENT_ID, SCOPES, tokenLoaded: toggleInterface);

  urlshortener = new urlshortenerlib.Urlshortener(auth);

  querySelector("#sign-in").onClick.listen((e) {
    debugLog("Attempting to log you in.");
    auth.login();
  });

  querySelector("#sign-out").onClick.listen((e) {
    debugLog("Signing you out.");
    auth.logout();
    toggleInterface(null);
  });

  querySelector("#shorten-button").onClick.listen((event) {
    var requestData = {"longUrl": (querySelector("#shorten-input") as InputElement).value};
    var url = new urlshortenerlib_client.Url.fromJson(requestData);
    urlshortener.url.insert(url)
      .then((urlshortenerlib_client.Url responseUrl) {
        debugLog("insert url successfully:\n${formatJson(responseUrl.toString())}");
        (querySelector('#shorten-link') as AnchorElement)
        ..href = responseUrl.id
        ..text = responseUrl.id;

        (querySelector('#expand-input') as InputElement).value = responseUrl.id;
        (querySelector('#analytics-input') as InputElement).value = responseUrl.id;
      })
      .catchError((e) {
        debugLog("Error insert url: $e");
      });
  });

  querySelector("#expand-button").onClick.listen((event) {
    var shortUrl = (querySelector("#shorten-link") as AnchorElement).href;
    urlshortener.url.get(shortUrl)
      .then((urlshortenerlib_client.Url responseUrl) {
        debugLog("get url successfully:\n${formatJson(responseUrl.toString())}");
        (querySelector('#expand-link') as AnchorElement)
        ..href = responseUrl.longUrl
        ..text = responseUrl.longUrl;
      })
      .catchError((e) {
        debugLog("Error get url: $e");
      });
  });

  querySelector("#analytics-button").onClick.listen((event) {
    urlshortener.url.list(projection: "FULL")
      .then((urlshortenerlib_client.UrlHistory responseUrlHistory) {
        analyticsLog("analytics successfully:\n${formatJson(responseUrlHistory.toString())}");
      })
      .catchError((e) {
        debugLog("Error analytics: $e");
      });
  });

  querySelector("#history-button").onClick.listen((event) {
    urlshortener.url.list()
      .then((urlshortenerlib_client.UrlHistory responseUrlHistory) {
        historyLog("list history:\n${formatJson(responseUrlHistory.toString())}");
      })
      .catchError((e) {
        debugLog("Error history: $e");
      });
  });

  querySelector("#clear-debug").onClick.listen((e) => querySelector("#debug-panel").text = "");

}