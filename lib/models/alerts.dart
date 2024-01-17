class Alerts {
  String? alertName;
  List<double>? alertLocation;
  String? alertForDate;
  String? alertSeverity;
  String? agencyName;
  String? locality;

  Alerts(
      {this.alertName,
      this.alertLocation,
      this.alertForDate,
      this.alertSeverity,
      this.agencyName});

  Alerts.fromJson(Map<String, dynamic> json) {
    alertName = json['alertName'];
    alertLocation = json['alertLocation'].cast<double>();
    alertForDate = json['alertForDate'];
    alertSeverity = json['alertSeverity'];
    agencyName = json['agencyName'];
  }
}
