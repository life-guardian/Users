class Agencies {
  String? sId;
  String? name;
  String? representativeName;

  Agencies({this.sId, this.name, this.representativeName});

  Agencies.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    representativeName = json['representativeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['name'] = name;
    data['representativeName'] = representativeName;
    return data;
  }
}
