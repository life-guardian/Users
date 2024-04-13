import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:user_app/helper/constants/api_keys.dart';
import 'package:user_app/model/alerts.dart';

class AlertsApi {
  Future<List<Alerts>> getNearByAlerts({
    required String token,
    required double latitude,
    required double longitude,
  }) async {
    var response = await http.get(
      Uri.parse("$alertUrl/$latitude/$longitude"),
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer $token'
      },
    );

    List<Alerts> data = [];
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      for (var jsonData in jsonResponse) {
        data.add(Alerts.fromJson(jsonData));
      }
    }

    await getEventsLocality(data: data).then((alertListWithLocalities) {
      data = alertListWithLocalities;
    });

    return data;
  }

  Future<List<Alerts>> getEventsLocality({required List<Alerts> data}) async {
    List<List<double>> coordinates = [];

    for (var event in data) {
      coordinates.add(event.alertLocation!);
    }

    List<String> localities = [];

    for (List<double> coordinate in coordinates) {
      try {
        List<Placemark> placemarks =
            await placemarkFromCoordinates(coordinate[1], coordinate[0]);
        Placemark placemark = placemarks[0];
        String? locality = placemark.locality;
        localities.add(locality!);
      } catch (error) {
        debugPrint("Error fetching locality for coordinates: $coordinate");
        localities.add("Unknown");
      }
    }

    for (int i = 0; i < data.length; i++) {
      data[i].locality = localities[i];
    }

    return data;
  }
}
