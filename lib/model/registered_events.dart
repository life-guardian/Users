class RegisteredEvents {
  String? eventId;
  String? eventName;
  String? eventDate;

  RegisteredEvents({this.eventId, this.eventName, this.eventDate});

  RegisteredEvents.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    eventName = json['eventName'];
    eventDate = json['eventDate'];
  }
}
