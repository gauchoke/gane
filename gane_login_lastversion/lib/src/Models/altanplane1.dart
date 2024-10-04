class AltanPLane1 {
  int? code;
  String? message;
  bool? status;
  DataAP1? data;

  AltanPLane1({this.code, this.message, this.status, this.data});

  AltanPLane1.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataAP1.fromJson(json['data']) : null;
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

class DataAP1 {
  Sms? sms;
  Sms? minute;
  Sms? gbFull;
  Sms? velRed;
  List<Plans11>? plans;

  DataAP1({this.sms, this.minute, this.gbFull, this.velRed, this.plans});

  DataAP1.fromJson(Map<String, dynamic> json) {
    sms = json['sms'] != null ? new Sms.fromJson(json['sms']) : Sms(name: "-",value: "0");
    minute = json['minute'] != null ? new Sms.fromJson(json['minute']) : Sms(name: "-",value: "0");
    gbFull = json['gbFull'] != null ? new Sms.fromJson(json['gbFull']) : Sms(name: "-",value: "0");
    velRed = json['velRed'] != null ? new Sms.fromJson(json['velRed']) : Sms(name: "-",value: "0");
    plans = <Plans11>[];
    if (json['plans'] != null) {

      json['plans'].forEach((v) {
        plans!.add(new Plans11.fromJson(v));
      });
    }
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
    if (this.plans != null) {
      data['plans'] = this.plans!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sms {
  String? name;
  String? value;

  Sms({this.name, this.value});

  Sms.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "0";
    value = json['value'] ?? "0";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['value'] = this.value;
    return data;
  }
}


class Plans11 {
  String? offeringId;
  String? name;
  String? expireDate;
  String? createdDate;
  String? color;
  DetailPlan? detailPlan;
  DetailPlan? balanceRecharge;

  Plans11(
      {this.offeringId,
        this.name,
        this.expireDate,
        this.createdDate,
        this.color,
        this.detailPlan,
        this.balanceRecharge});

  Plans11.fromJson(Map<String, dynamic> json) {
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
  Sms? sms;
  Sms? minute;
  Sms? gbFull;
  Sms? velRed;

  DetailPlan({this.sms, this.minute, this.gbFull, this.velRed});

  DetailPlan.fromJson(Map<String, dynamic> json) {
    sms = json['sms'] != null ? new Sms.fromJson(json['sms']) : Sms(value: "0",name: "-");
    minute = json['minute'] != null ? new Sms.fromJson(json['minute']) : Sms(value: "0",name: "-");
    gbFull = json['gbFull'] != null ? new Sms.fromJson(json['gbFull']) : Sms(value: "0",name: "-");
    velRed = json['velRed'] != null ? new Sms.fromJson(json['velRed']) : Sms(value: "0",name: "-");
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