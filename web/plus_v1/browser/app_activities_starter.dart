import "dart:html";
import "dart:convert";
import "package:google_plus_v1_api/plus_v1_api_browser.dart" as pluslib;
import "package:google_plus_v1_api/plus_v1_api_client.dart" as pluslib_client;
import "package:google_oauth2_client/google_oauth2_browser.dart" as oauth;

oauth.GoogleOAuth2 auth;
pluslib.Plus plus;

final CLIENT_ID = "895718515639.apps.googleusercontent.com";
final SCOPES = [pluslib.Plus.PLUS_LOGIN_SCOPE];
final ACTIONS = [
  "http://schemas.google.com/AddActivity",
  "http://schemas.google.com/BuyActivity",
  "http://schemas.google.com/CheckInActivity",
  "http://schemas.google.com/CommentActivity",
  "http://schemas.google.com/CreateActivity",
  "http://schemas.google.com/DiscoverActivity",
  "http://schemas.google.com/ListenActivity",
  "http://schemas.google.com/ReserveActivity",
  "http://schemas.google.com/ReviewActivity",
  "http://schemas.google.com/WantActivity"
 ];

final Map sampleActivities = {
  "AddActivity":{
    "type":"http://schemas.google.com/AddActivity",
    "target":{
      "url":"https://developers.google.com/+/web/snippet/examples/thing"
    }
  },
  "BuyActivity":{
    "type":"http://schemas.google.com/BuyActivity",
    "target":{
      "url":"https://developers.google.com/+/web/snippet/examples/a-book"
    }
  },
  "CheckInActivity":{
    "type":"http://schemas.google.com/CheckInActivity",
    "target":{
      "url":"https://developers.google.com/+/web/snippet/examples/place"
    }
  },
  "CommentActivity":{
    "type":"http://schemas.google.com/CommentActivity",
    "target":{
      "url":"https://developers.google.com/+/web/snippet/examples/blog-entry"
    },
    "result":{
      "type":"http://schema.org/Comment",
      "url":"https://developers.google.com/+/web/snippet/examples/blog-entry#comment-1",
      "name":"This is amazing!",
      "text":"I can not wait to use it on my site :)"
    }
  },
  "CreateActivity":{
    "type":"http://schemas.google.com/CreateActivity",
    "target":{
      "url":"https://developers.google.com/+/web/snippet/examples/photo"
    }
  },
  "DiscoverActivity":{
    "type": "http://schemas.google.com/DiscoverActivity",
    "target": {
      "url": "https://developers.google.com/+/web/snippet/examples/thing"
    }
  },
  "ListenActivity":{
    "type":"http://schemas.google.com/ListenActivity",
    "target":{
      "url":"https://developers.google.com/+/web/snippet/examples/song"
    }
  },
  "ReserveActivity":{
    "type":"http://schemas.google.com/ReserveActivity",
    "target":{
      "url":"https://developers.google.com/+/web/snippet/examples/restaurant"
    },
    "result":{
      "type":"http://schemas.google.com/Reservation",
      "startDate":"2012-06-28T19:00:00-08:00",
      "attendeeCount":"3"
    }
  },
  "ReviewActivity":{
    "type":"http://schemas.google.com/ReviewActivity",
    "target":{
      "url":"https://developers.google.com/+/web/snippet/examples/widget"
    },
    "result":{
      "type":"http://schema.org/Review",
      "name":"A Humble Review of Widget",
      "url":"https://developers.google.com/+/web/snippet/examples/review",
      "text":"It is amazingly effective at whatever it is that it is supposed to do.",
      "reviewRating":[{
        "type": "http://schema.org/Rating",
        "ratingValue":"100",
        "bestRating":"100",
        "worstRating":"0"
      }]
    }
  },
  "WantActivity":{
    "type":"http://schemas.google.com/WantActivity",
    "target":{
      "url":"https://developers.google.com/+/web/snippet/examples/a-book"
    }
  }
};

void debugLog(String message) {
  querySelector("#debug-panel").text = "$message\n${querySelector("#debug-panel").text}";
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
  querySelector("#panel-sign-in").style.display = (token == null) ? "block" : "none";
  querySelector("#panel-sign-out").style.display = (token == null) ? "none" : "block";
  querySelector("#panel-communicate-moments").style.display = (token == null) ? "none" : "block";;
}

void createButtons() {
  final mainDiv = querySelector("#sample-moment-buttons");
  sampleActivities.forEach((name, body) {
    var buttonHtml = "<button class='write-sample' data-moment='${JSON.encode(body)}'>$name</button>";
    mainDiv.appendHtml(buttonHtml);
  });
  debugLog("Loaded sample activities");
}

void writeMoment(String momentString) {
  var json;

  try {
    json = JSON.parse(momentString);
  } on FormatException {
    debugLog("Invalid JSON Input");
    return;
  }
  debugLog("Trying to write Moment:\n${formatJson(momentString)}");
  var moment = new pluslib_client.Moment.fromJson(json);
  plus.makeAuthRequests = true;
  plus.moments.insert(moment, "me", "vault", debug: true)
    .then((pluslib_client.Moment response) {
      debugLog("Moment written successfully:\n${formatJson(response.toString())}");
    })
    .catchError((e) {
      debugLog("Error writing moment: $e");
      return true;
    });
}

void main() {
  createButtons();

  auth = new oauth.GoogleOAuth2(CLIENT_ID, SCOPES, request_visible_actions: ACTIONS, tokenLoaded: toggleInterface);

  plus = new pluslib.Plus(auth);

  querySelector("#sign-in").onClick.listen((_) {
    debugLog("Attempting to log you in.");
    auth.login();
  });

  querySelector("#sign-out").onClick.listen((_) {
    debugLog("Signing you out.");
    auth.logout();
    toggleInterface(null);
  });

  querySelector("#clear-debug").onClick.listen((_) => querySelector("#debug-panel").text = "");

  querySelector("#get-me").onClick.listen((_) {
    debugLog("Attempting to get your profile");
    plus.makeAuthRequests = true;
    plus.people.get("me", optParams: {"fields": "displayName,id,image,url"})
      .then((pluslib_client.Person p) => debugLog("Got your profile:\n${formatJson(p.toString())}"))
      .catchError((error) => debugLog("Error getting profile: $error"));
  });

  querySelectorAll(".write-sample").forEach((button) {
    button.onClick.listen((_) => writeMoment(button.dataset["moment"]));
  });

  querySelector("#custom-json-submit").onClick.listen((_) => writeMoment(querySelector("#custom-json").text));
}
