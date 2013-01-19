import "dart:html";
import "dart:json";
import "package:plus_v1moments_api_client/plus_v1moments_api_client.dart" as historylib;
import "package:plus_v1_api_client/plus_v1_api_client.dart" as pluslib;
import "package:google_oauth2_client/google_oauth2_client.dart";

var auth, plus, history;

final CLIENT_ID = "796343192238.apps.googleusercontent.com";
final SCOPES = [pluslib.Plus.PLUS_ME_SCOPE, historylib.Plus.PLUS_MOMENTS_WRITE_SCOPE];

final Map sampleActivities = 
  {
    "AddActivity":{
      "type":"http://schemas.google.com/AddActivity",
      "target":{
        "url":"https://developers.google.com/+/plugins/snippet/examples/thing"
      }
    },
    "BuyActivity":{
      "type":"http://schemas.google.com/BuyActivity",
      "target":{
        "url":"https://developers.google.com/+/plugins/snippet/examples/a-book"
      }
    },
    "CheckInActivity":{
      "type":"http://schemas.google.com/CheckInActivity",
      "target":{
        "url":"https://developers.google.com/+/plugins/snippet/examples/place"
      }
    },
    "CommentActivity":{
      "type":"http://schemas.google.com/CommentActivity",
      "target":{
        "url":"https://developers.google.com/+/plugins/snippet/examples/blog-entry"
      },
      "result":{
        "type":"http://schema.org/Comment",
        "url":"https://developers.google.com/+/plugins/snippet/examples/blog-entry#comment-1",
        "name":"This is amazing!",
        "text":"I can not wait to use it on my site :)"
      }
    },
    "CreateActivity":{
      "type":"http://schemas.google.com/CreateActivity",
      "target":{
        "url":"https://developers.google.com/+/plugins/snippet/examples/photo"
      }
    },
    "ListenActivity":{
      "type":"http://schemas.google.com/ListenActivity",
      "target":{
        "url":"https://developers.google.com/+/plugins/snippet/examples/song"
      }
    },
    "ReserveActivity":{
      "type":"http://schemas.google.com/ReserveActivity",
      "target":{
        "url":"https://developers.google.com/+/plugins/snippet/examples/restaurant"
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
        "url":"https://developers.google.com/+/plugins/snippet/examples/widget"
      },
      "result":{
        "type":"http://schema.org/Review",
        "name":"A Humble Review of Widget",
        "url":"https://developers.google.com/+/plugins/snippet/examples/review",
        "text":"It is amazingly effective at whatever it is that it is supposed to do.",
        "reviewRating": {
          "type": "http://schema.org/Rating",
          "ratingValue":"100",
          "bestRating":"100",
          "worstRating":"0"
        }
      }
    },
    "ViewActivity":{
      "type":"http://schemas.google.com/ViewActivity",
      "target":{
        "url":"https://developers.google.com/+/plugins/snippet/examples/video"
      }
    }
  };

void debugLog(String message) {
  query("#debug-panel").text = "$message\n${query("#debug-panel").text}";
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
  query("#panel-communicate-moments").style.display = (token == null) ? "none" : "block";;
}

void createButtons() {
  final mainDiv = query("#sample-moment-buttons");
  sampleActivities.forEach((name, body) {
    var buttonHtml = "<button class='write-sample' data-moment='${JSON.stringify(body)}'>$name</button>";
    mainDiv.appendHtml(buttonHtml);
  });
  debugLog("Loaded sample activities");
}

void writeMoment(String momentString) {
  var json;
  try {
    json = JSON.parse(momentString);
  } on JSONParseException {
    debugLog("Invalid JSON Input");
    return;
  }
  debugLog("Trying to write Moment:\n${formatJson(momentString)}");
  var moment = new historylib.Moment.fromJson(json);
  history.makeAuthRequests = true;
  history.moments.insert(moment, "me", "vault", debug: true)
    ..handleException((e) {
      debugLog("Error writing moment: $e");
      return true;
    })
    ..then((historylib.Moment response) {
      debugLog("Moment written successfully:\n${formatJson(response.toString())}");
    });
}

void main() {
  createButtons();
  
  auth = new OAuth2(CLIENT_ID, SCOPES, tokenLoaded: toggleInterface);
  
  plus = new pluslib.Plus(auth);
  history = new historylib.Plus(auth);

  query("#sign-in").on.click.add((e) {
    debugLog("Attempting to log you in.");
    auth.login();
  });
  
  query("#sign-out").on.click.add((e) {
    debugLog("Signing you out.");
    auth.logout();
    toggleInterface(null);
  });
  
  query("#clear-debug").on.click.add((e) => query("#debug-panel").text = "");
  query("#get-me").on.click.add((e) {
    debugLog("Attempting to get your profile");
    plus.makeAuthRequests = true;
    plus.people.get("me", optParams: {"fields": "displayName,id,image,url"})
      .then((pluslib.Person p) {
        debugLog("Got your profile:\n${formatJson(p.toString())}");
      });
  });
  
  queryAll(".write-sample").forEach((button) {
    button.on.click.add((e) => writeMoment(button.dataAttributes["moment"]));
  });
  
  query("#custom-json-submit").on.click.add((e) => writeMoment(query("#custom-json").text));
}
