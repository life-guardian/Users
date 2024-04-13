import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:user_app/helper/constants/api_keys.dart';
import 'package:user_app/model/nearby_events.dart';
import 'package:user_app/model/registered_events.dart';

class ProgramsAndEventsApi {

  Future<List<NearbyEvents>> getNearByEventsData({
    required String token,
    required double latitude,
    required double longitude,
  }) async {
    var response = await http.get(
      Uri.parse("$nearbyEventsUrl/$latitude/$longitude"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
    );

    List<NearbyEvents> data = [];

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      for (var jsonData in jsonResponse) {
        data.add(NearbyEvents.fromJson(jsonData));
      }
    }

    return data;
  }

  Future<List<RegisteredEvents>> getRegisteredEventsData({
    required String token,
  }) async {
    var response = await http.get(
      Uri.parse(userRegeteredEventsUrl),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
    );

    List<RegisteredEvents> data = [];

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);

      for (var jsonData in jsonResponse) {
        data.add(RegisteredEvents.fromJson(jsonData));
      }
    }

    return data;
  }
}
