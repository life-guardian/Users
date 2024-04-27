import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

final profileImageProvider = StateProvider<XFile?>((ref) => null);

final greetingProvider = StateProvider<String>((ref) => getGreetingMessage());

final isNearbyEventsLoading = StateProvider<bool>((ref) => true);

String getGreetingMessage() {
  final now = DateTime.now();
  final hour = now.hour;

  if (hour < 12) {
    return 'Good Morning';
  } else if (hour < 17) {
    return 'Good Afternoon';
  } else {
    return 'Good Evening';
  }
}
