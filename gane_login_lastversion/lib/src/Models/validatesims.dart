class ValidatesSimsCard {
  int? code;
  String? message;
  bool? status;
  DataValidatesSimsCard? data;

  ValidatesSimsCard({this.code, this.message, this.status, this.data});

  ValidatesSimsCard.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataValidatesSimsCard.fromJson(json['data']) : null;
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

class DataValidatesSimsCard {
  String? sim;

  DataValidatesSimsCard({this.sim});

  DataValidatesSimsCard.fromJson(Map<String, dynamic> json) {
    sim = json['sim'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sim'] = this.sim;
    return data;
  }
}