import "dart:html";
import "dart:json";
import "package:urlshortener_v1_api_client/urlshortener_v1_api_client.dart" as urlshortenerlib;
import "package:google_oauth2_client/google_oauth2_client.dart";

var auth, urlshortener;

final CLIENT_ID = "796343192238.apps.googleusercontent.com";
final SCOPES = [urlshortenerlib.Urlshortener.URLSHORTENER_SCOPE];

void debugLog(String message) {
  query("#debug-panel").text = "$message\n${query("#debug-panel").text}";
}

void historyLog(String message) {
  query("#history-panel").text = "$message\n${query("#history-panel").text}";
}

void analyticsLog(String message) {
  query("#analytics-panel").text = "$message\n${query("#analytics-panel").text}";
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
  } else {
    debugLog("Auth Success ${token.toString()}");
  }
  query("#panel-sign-in").style.display = (token == null) ? "block" : "none";
  query("#panel-sign-out").style.display = (token == null) ? "none" : "block";
}

void main() {

  auth = new OAuth2(CLIENT_ID, SCOPES, tokenLoaded: toggleInterface);

  urlshortener = new urlshortenerlib.Urlshortener(auth);

  query("#sign-in").on.click.add((e) {
    debugLog("Attempting to log you in.");
    auth.login();
  });

  query("#sign-out").on.click.add((e) {
    debugLog("Signing you out.");
    auth.logout();
    toggleInterface(null);
  });

  query("#shorten-button").on.click.add((event) {
    var requestData = {"longUrl": (query("#shorten-input") as InputElement).value};
    var url = new urlshortenerlib.Url.fromJson(requestData);
    urlshortener.url.insert(url)
      ..handleException((e) {
        debugLog("Error insert url: $e");
      })
      ..then((urlshortenerlib.Url responseUrl) {
        debugLog("insert url successfully:\n${formatJson(responseUrl.toString())}");
        (query('#shorten-link') as AnchorElement)
        ..href = responseUrl.id
        ..text = responseUrl.id;

        (query('#expand-input') as InputElement).value = responseUrl.id;
        (query('#analytics-input') as InputElement).value = responseUrl.id;
      });
  });

  query("#expand-button").on.click.add((event) {
    var shortUrl = (query("#shorten-link") as AnchorElement).href;
    urlshortener.url.get(shortUrl)
      ..handleException((e) {
        debugLog("Error get url: $e");
      })
      ..then((urlshortenerlib.Url responseUrl) {
        debugLog("get url successfully:\n${formatJson(responseUrl.toString())}");
        (query('#expand-link') as AnchorElement)
        ..href = responseUrl.longUrl
        ..text = responseUrl.longUrl;
      });
  });

  query("#analytics-button").on.click.add((event) {
    urlshortener.url.list(projection: "FULL")
    ..handleException((e) {
      debugLog("Error analytics: $e");
    })
    ..then((urlshortenerlib.UrlHistory responseUrlHistory) {
      analyticsLog("analytics successfully:\n${formatJson(responseUrlHistory.toString())}");
    });
  });

  query("#history-button").on.click.add((event) {
    urlshortener.url.list()
    ..handleException((e) {
      debugLog("Error history: $e");
    })
    ..then((urlshortenerlib.UrlHistory responseUrlHistory) {
      historyLog("list history:\n${formatJson(responseUrlHistory.toString())}");
    });
  });

  query("#clear-debug").on.click.add((e) => query("#debug-panel").text = "");

}