import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:user_app/models/nearby_events.dart';
import 'package:user_app/models/registered_events.dart';

// Nearby Events Provider

class NearbyEventsNotifier extends StateNotifier<List<NearbyEvents>> {
  NearbyEventsNotifier({required Ref ref}) : super([]);

  void addList(List<NearbyEvents> events) {
    state = events;
  }

  void clearData(){
    state=[];
  }
}

final nearbyEventsProvider =
    StateNotifierProvider<NearbyEventsNotifier, List<NearbyEvents>>((ref) {
  return NearbyEventsNotifier(ref: ref);
});



// Registered Events Provider

class RegisteredEventsNotifier extends StateNotifier<List<RegisteredEvents>> {
  RegisteredEventsNotifier({required Ref ref}) : super([]);

  void addList(List<RegisteredEvents> events) {
    state = events;
  }
  void clearData(){
    state=[];
  }
}

final registeredEventsProvider =
    StateNotifierProvider<RegisteredEventsNotifier, List<RegisteredEvents>>((ref) {
  return RegisteredEventsNotifier(ref: ref);
});

