import 'dart:chrome';

void main() {
  chrome.app.runtime.onLaunched.addListener((AppRuntimeLaunchData launchData) {
    chrome.app.window.create('dart_api_client_examples.html',
        new AppWindowCreateWindowOptions(width: 800, height: 600));
  });
}
