import 'package:flutter_dotenv/flutter_dotenv.dart';

var baseUrl = dotenv.get("BASE_URL");

// global variables
// double? universalLat, universaLng;

// sending data to server
var registerurl = '$baseUrl/api/user/register';
var loginUrl = '$baseUrl/api/user/login';
var logoutUrl = '$baseUrl/api/user/logout';
var registerEventUrl = '$baseUrl/api/event/register';
var putDeviceLocationUrl = '$baseUrl/api/userlocation/updatelastlocation';
var rescueMeUrl = '$baseUrl/api/userrescue/user/rescueme';
var stopRescueMeUrl = '$baseUrl/api/userrescue/user/stoprescueme';
var isRescueMeAlreadyClickedUrl =
    '$baseUrl/api/userrescue/user/isrescuemeongoing';

// receiving data from server
var alertUrl = '$baseUrl/api/alert/showreceived';
var nearbyEventsUrl = '$baseUrl/api/event/nearbyevents';
var eventDetailsUrl = '$baseUrl/api/event/eventdetails';
var userRegeteredEventsUrl = '$baseUrl/api/event/registeredevents';
var agenciesDataurl = '$baseUrl/api/search/agencies/?searchText=';
var agencyDetailsUrl = '$baseUrl/api/search/agencydetails';

var googleMapsApiKey = 'AIzaSyCSpvganhtdZCMngmIVVuGFxr_tE533K4s';
