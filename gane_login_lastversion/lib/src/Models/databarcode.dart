class BarCodeData {
  int? code;
  String? message;
  bool? status;
  DataBarCodeData? data;

  BarCodeData({this.code, this.message, this.status, this.data});

  BarCodeData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataBarCodeData.fromJson(json['data']) : null;
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

class DataBarCodeData {
  Sim? sim;

  DataBarCodeData({this.sim});

  DataBarCodeData.fromJson(Map<String, dynamic> json) {
    sim = json['sim'] != null ? new Sim.fromJson(json['sim']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sim != null) {
      data['sim'] = this.sim!.toJson();
    }
    return data;
  }
}

class Sim {
  String? mSISDN;
  String? iCC;
  String? pIN;

  Sim({this.mSISDN, this.iCC, this.pIN});

  Sim.fromJson(Map<String, dynamic> json) {
    mSISDN = json['MSISDN'];
    iCC = json['ICC'];
    pIN = json['PIN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['MSISDN'] = this.mSISDN;
    data['ICC'] = this.iCC;
    data['PIN'] = this.pIN;
    return data;
  }
}