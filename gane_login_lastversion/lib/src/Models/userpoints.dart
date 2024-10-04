class Userpoints {
  int? code;
  String? message;
  bool? status;
  DataPU? data;

  Userpoints({this.code, this.message, this.status, this.data});

  Userpoints.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataPU.fromJson(json['data']) : null;
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

class DataPU {
  String? result;
  String? phonePrefix;
  String? photoUrl;
  String? phoneNumber;
  String? fullname;

  DataPU(
      {this.result,
        this.phonePrefix,
        this.photoUrl,
        this.phoneNumber,
        this.fullname});

  DataPU.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    phonePrefix = json['phonePrefix'];
    photoUrl = json['photoUrl'];
    phoneNumber = json['phoneNumber'];
    fullname = json['fullname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['phonePrefix'] = this.phonePrefix;
    data['photoUrl'] = this.photoUrl;
    data['phoneNumber'] = this.phoneNumber;
    data['fullname'] = this.fullname;
    return data;
  }
}