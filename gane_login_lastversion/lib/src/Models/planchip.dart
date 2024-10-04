class ChipPlans {
  int? code;
  String? message;
  bool? status;
  DataChipPlans? data;

  ChipPlans({this.code, this.message, this.status, this.data});

  ChipPlans.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataChipPlans.fromJson(json['data']) : null;
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

class DataChipPlans {
  PlanhipPlans? plan;

  DataChipPlans({this.plan});

  DataChipPlans.fromJson(Map<String, dynamic> json) {
    plan = json['plan'] != null ? new PlanhipPlans.fromJson(json['plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.plan != null) {
      data['plan'] = this.plan!.toJson();
    }
    return data;
  }
}

class PlanhipPlans {
  int? id;
  String? name;
  double? price;
  String? photoUrl;

  PlanhipPlans({this.id, this.name, this.price, this.photoUrl});

  PlanhipPlans.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price']!.toDouble() ?? 0.0;
    photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['photoUrl'] = this.photoUrl;
    return data;
  }
}