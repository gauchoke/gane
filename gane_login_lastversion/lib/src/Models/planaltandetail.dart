class PlansAltanDetails {
  int? code;
  String? message;
  bool? status;
  DataPlansAltanDetails? data;

  PlansAltanDetails({this.code, this.message, this.status, this.data});

  PlansAltanDetails.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataPlansAltanDetails.fromJson(json['data']) : null;
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

class DataPlansAltanDetails {
  List<Plans>? plans;

  DataPlansAltanDetails({this.plans});

  DataPlansAltanDetails.fromJson(Map<String, dynamic> json) {
    if (json['plans'] != null) {
      plans = <Plans>[];
      json['plans'].forEach((v) {
        plans!.add(new Plans.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Plans {
  String? offeringId;
  String? name;
  String? min;
  String? sms;
  String? gb;
  String? gbRed;
  String? expireDate;
  String? color;

  String? gbConvert;
  String? gbRedConvert;
  String? smsConvert;
  String? minuteConvert;

  Plans(
      {this.offeringId,
        this.name,
        this.min,
        this.sms,
        this.gb,
        this.gbRed,
        this.expireDate,
        this.color,
        this.gbConvert,
        this.gbRedConvert,
        this.smsConvert,
        this.minuteConvert
      });

  Plans.fromJson(Map<String, dynamic> json) {
    offeringId = json['offeringId'];
    name = json['name'];
    min = json['min'];
    sms = json['sms'];
    gb = json['gb'];
    gbRed = json['gbRed'];
    expireDate = json['expireDate'];
    color = json['color'];
    gbConvert = json['gbConvert'];
    gbRedConvert = json['gbRedConvert'];
    smsConvert = json['smsConvert'];
    minuteConvert = json['minuteConvert'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offeringId'] = this.offeringId;
    data['name'] = this.name;
    data['min'] = this.min;
    data['sms'] = this.sms;
    data['gb'] = this.gb;
    data['gbRed'] = this.gbRed;
    data['expireDate'] = this.expireDate;
    data['color'] = this.color;
    data['gbConvert'] = this.gbConvert;
    data['gbRedConvert'] = this.gbRedConvert;
    data['smsConvert'] = this.smsConvert;
    data['minuteConvert'] = this.minuteConvert;
    return data;
  }
}