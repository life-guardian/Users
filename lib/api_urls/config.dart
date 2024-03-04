// var baseUrl = 'https://lifeguardian.cyclic.app';
var baseUrl = 'https://lifeguardianapi.pratikjpatil.me';

// global variables
double? universalLat, universaLng;

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
var agenciesDataurl = '$baseUrl/api/search/agencies/?searchText=';
var agencyDetailsUrl = '$baseUrl/api/search/agencydetails/';

var googleMapsApiKey = 'AIzaSyCSpvganhtdZCMngmIVVuGFxr_tE533K4s';
