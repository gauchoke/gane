class Verifyphone1 {
  int? code;
  String? message;
  bool? status;
  DataVerifyphone1? data;

  Verifyphone1({this.code, this.message, this.status, this.data});

  Verifyphone1.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataVerifyphone1.fromJson(json['data']) : null;
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

class DataVerifyphone1 {
  String? userExist;
  String? phoneNumber;
  String? phonePrefix;

  DataVerifyphone1({this.userExist, this.phoneNumber, this.phonePrefix});

  DataVerifyphone1.fromJson(Map<String, dynamic> json) {
    userExist = json['userExist'];
    phoneNumber = json['phoneNumber'];
    phonePrefix = json['phonePrefix'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userExist'] = this.userExist;
    data['phoneNumber'] = this.phoneNumber;
    data['phonePrefix'] = this.phonePrefix;
    return data;
  }
}