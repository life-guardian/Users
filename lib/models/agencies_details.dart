class AgenciesList {
  int? totalPages;
  int? currentPage;
  List<Agencies>? agencies;

  AgenciesList({this.totalPages, this.currentPage, this.agencies});

  AgenciesList.fromJson(Map<String, dynamic> json) {
    totalPages = json['totalPages'];
    currentPage = json['currentPage'];
    if (json['agencies'] != null) {
      agencies = <Agencies>[];
      json['agencies'].forEach((v) {
        agencies!.add(Agencies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalPages'] = totalPages;
    data['currentPage'] = currentPage;
    if (agencies != null) {
      data['agencies'] = agencies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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
