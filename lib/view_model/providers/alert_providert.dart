// Registered Events Provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_app/model/alerts.dart';

// Nearby Alerts Provider
class AlertsNotifier extends StateNotifier<List<Alerts>> {
  AlertsNotifier({required Ref ref}) : super([]);

  void addList(List<Alerts> events) {
    state = events;
  }

  void clearData() {
    state = [];
  }
}

final alertsProvider =
    StateNotifierProvider<AlertsNotifier, List<Alerts>>((ref) {
  return AlertsNotifier(ref: ref);
});
