class OperationDetails {
  String? eventId;
  String? eventName;
  String? eventDescription;
  String? eventDate;
  String? agencyName;
  List<double>? eventLocation;

  OperationDetails(
      {this.eventId,
      this.eventName,
      this.eventDescription,
      this.eventDate,
      this.agencyName,
      this.eventLocation});

  OperationDetails.fromJson(Map<String, dynamic> json) {
    eventId = json['eventId'];
    eventName = json['eventName'];
    eventDescription = json['eventDescription'];
    eventDate = json['eventDate'];
    agencyName = json['agencyName'];
    eventLocation = json['eventLocation'].cast<double>();
  }
}
