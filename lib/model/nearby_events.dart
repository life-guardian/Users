class NearbyEvents {
  String? eventId;
  String? eventName;
  String? agencyName;
  String? eventDate;

  NearbyEvents({this.eventId, this.eventName, this.agencyName, this.eventDate});

  NearbyEvents.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    eventName = json['eventName'];
    agencyName = json['agencyName'];
    eventDate = json['eventDate'];
  }
}
