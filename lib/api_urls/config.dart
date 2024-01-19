var baseUrl = 'https://lifeguardian.cyclic.app';

// global variables
double? universalLat, universaLng;
String? globalToken;

// sending data to server
var registerurl = '$baseUrl/api/user/register';
var loginUrl = '$baseUrl/api/user/login';
var logoutUrl = '$baseUrl/api/user/logout';
var registerEventUrl = '$baseUrl/api/event/register';

// receiving data from server
var alertUrl = '$baseUrl/api/alert/showreceived/$universalLat/$universaLng';
var nearbyEventsUrl =
    '$baseUrl/api/event/nearbyevents/$universalLat/$universaLng';
var eventDetailsUrl = '$baseUrl/api/event/eventdetails/';
var userRegeteredEventsUrl = '$baseUrl/api/event/registeredevents';
var agenciesDataurl =
    '$baseUrl/api/search/agencies/?searchText=';

var googleMapsApiKey = 'AIzaSyCSpvganhtdZCMngmIVVuGFxr_tE533K4s';
