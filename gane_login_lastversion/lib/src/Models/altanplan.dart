class AltanPLane {
  int? code;
  String? message;
  bool? status;
  DataAP? data;

  AltanPLane({this.code, this.message, this.status, this.data});

  AltanPLane.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataAP.fromJson(json['data']) : null;
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

class DataAP {
  Plan? plan;

  DataAP({this.plan});

  DataAP.fromJson(Map<String, dynamic> json) {
    plan = json['plan'] != null ? new Plan.fromJson(json['plan']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.plan != null) {
      data['plan'] = this.plan!.toJson();
    }
    return data;
  }
}

class Plan {
  String? missingDay;
  String? totalGd;
  String? gbUsed;
  String? gbAvailable;
  String? days;
  String? sms;
  String? minute;
  String? gb;
  String? gb_red;
  String? gbConvert;
  String? gbRedConvert;
  String? smsConvert;
  String? minuteConvert;

  Plan({this.missingDay, this.totalGd, this.gbUsed, this.gbAvailable, this.days, this.sms, this.minute, this.gb, this.gb_red,this.gbConvert,
    this.gbRedConvert,
    this.smsConvert,
    this.minuteConvert});

  Plan.fromJson(Map<String, dynamic> json) {
    missingDay = json['missing_day']??"0";
    totalGd = json['total_gd']??"0";
    gbUsed = json['gb_used']??"0";
    gbAvailable = json['gb_available']??"0";
    days = json['days']??"0";
    sms = json['sms']??"0";
    minute = json['minute']??"0";
    gb = json['gb']??"0";
    gb_red = json['gb_red']??"0";
    gbConvert = json['gbConvert'];
    gbRedConvert = json['gbRedConvert'];
    smsConvert = json['smsConvert'];
    minuteConvert = json['minuteConvert'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['missing_day'] = this.missingDay;
    data['total_gd'] = this.totalGd;
    data['gb_used'] = this.gbUsed;
    data['gb_available'] = this.gbAvailable;
    data['days'] = this.days;
    data['sms'] = this.sms;
    data['minute'] = this.minute;
    data['gb'] = this.gb;
    data['gb_red'] = this.gb_red;
    data['gbConvert'] = this.gbConvert;
    data['gbRedConvert'] = this.gbRedConvert;
    data['smsConvert'] = this.smsConvert;
    data['minuteConvert'] = this.minuteConvert;
    return data;
  }
}