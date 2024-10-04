class colonList {
  int? code;
  String? message;
  bool? status;
  DatacolonList? data;

  colonList({this.code, this.message, this.status, this.data});

  colonList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DatacolonList.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class DatacolonList {
  List<Colonies>? colonies;

  DatacolonList({this.colonies});

  DatacolonList.fromJson(Map<String, dynamic> json) {
    if (json['colonies'] != null) {
      colonies = <Colonies>[];
      json['colonies'].forEach((v) {
        colonies!.add(new Colonies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.colonies != null) {
      data['colonies'] = this.colonies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Colonies {
  String? name;
  String? zipCode;

  Colonies({this.name, this.zipCode});

  Colonies.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    zipCode = json['zipCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['zipCode'] = this.zipCode;
    return data;
  }
}