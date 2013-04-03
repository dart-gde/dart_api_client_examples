var authtokendiv = document.getElementById('auth_token');
var login = document.getElementById("login");
var demo = document.getElementById("demo");

function onGetAuthToken(auth_token) {
	if (auth_token && auth_token!="") {
		demo.style.display = "";
		authtokendiv.innerText = auth_token;
		console.log("OAUTH",authtokendiv.innerText);
	}
}

function startOAuth() {
	chrome.experimental.identity.getAuthToken({ 'interactive': true }, onGetAuthToken);
		
	//onGetAuthToken("abcdef12345");
	
	
}

function init() {

	login.onclick = startOAuth;
}

window.onload = init;