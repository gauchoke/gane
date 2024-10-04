class PlansAltanDetails1 {
  int? code;
  String? message;
  bool? status;
  DataPlansAltanDetails1? data;

  PlansAltanDetails1({this.code, this.message, this.status, this.data});

  PlansAltanDetails1.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataPlansAltanDetails1.fromJson(json['data']) : null;
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

class DataPlansAltanDetails1 {
  List<Plans1>? plans;

  DataPlansAltanDetails1({this.plans});

  DataPlansAltanDetails1.fromJson(Map<String, dynamic> json) {
    if (json['plans'] != null) {
      plans = <Plans1>[];
      json['plans'].forEach((v) {
        plans!.add(new Plans1.fromJson(v));
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

class Plans1 {
  String? offeringId;
  String? name;
  String? expireDate;
  String? createdDate;
  String? color;
  DetailPlan? detailPlan;
  DetailPlan? balanceRecharge;

  Plans1(
      {this.offeringId,
        this.name,
        this.expireDate,
        this.createdDate,
        this.color,
        this.detailPlan,
        this.balanceRecharge});

  Plans1.fromJson(Map<String, dynamic> json) {
    offeringId = json['offeringId']??"0";
    name = json['name']??"-";
    expireDate = json['expireDate']??"1970-01-01";
    createdDate = json['createdDate']??"1970-01-01";
    color = json['color']??"#00000000";
    detailPlan = json['detailPlan'] != null
        ? new DetailPlan.fromJson(json['detailPlan'])
        : null;
    balanceRecharge = json['balanceRecharge'] != null
        ? new DetailPlan.fromJson(json['balanceRecharge'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['offeringId'] = this.offeringId;
    data['name'] = this.name;
    data['expireDate'] = this.expireDate;
    data['createdDate'] = this.createdDate;
    data['color'] = this.color;
    if (this.detailPlan != null) {
      data['detailPlan'] = this.detailPlan!.toJson();
    }
    if (this.balanceRecharge != null) {
      data['balanceRecharge'] = this.balanceRecharge!.toJson();
    }
    return data;
  }
}

class DetailPlan {
  Sms1? sms;
  Sms1? minute;
  Sms1? gbFull;
  Sms1? velRed;

  DetailPlan({this.sms, this.minute, this.gbFull, this.velRed});

  DetailPlan.fromJson(Map<String, dynamic> json) {
    sms = json['sms'] != null ? new Sms1.fromJson(json['sms']) : Sms1(value: "0",name: "-");
    minute = json['minute'] != null ? new Sms1.fromJson(json['minute']) : Sms1(value: "0",name: "-");
    gbFull = json['gbFull'] != null ? new Sms1.fromJson(json['gbFull']) : Sms1(value: "0",name: "-");
    velRed = json['velRed'] != null ? new Sms1.fromJson(json['velRed']) : Sms1(value: "0",name: "-");
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sms != null) {
      data['sms'] = this.sms!.toJson();
    }
    if (this.minute != null) {
      data['minute'] = this.minute!.toJson();
    }
    if (this.gbFull != null) {
      data['gbFull'] = this.gbFull!.toJson();
    }
    if (this.velRed != null) {
      data['velRed'] = this.velRed!.toJson();
    }
    return data;
  }
}

class Sms1 {
  String? name;
  String? value;

  Sms1({this.name, this.value});

  Sms1.fromJson(Map<String, dynamic> json) {
    name = json['name']??"-";
    value = json['value']??"0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}