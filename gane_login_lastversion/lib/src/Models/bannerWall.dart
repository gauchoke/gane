class BannerWallet {
  int? code;
  String? message;
  bool? status;
  DataW? data;

  BannerWallet({this.code, this.message, this.status, this.data});

  BannerWallet.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataW.fromJson(json['data']) : null;
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

class DataW {
  ItemW? item;

  DataW({this.item});

  DataW.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? new ItemW.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    return data;
  }
}

class ItemW {
  int? id;
  String? photoUrl;
  String? sms;
  String? whatsapp;
  Options? options;
  String? callingCode;

  ItemW(
      {this.id,
        this.photoUrl,
        this.sms,
        this.whatsapp,
        this.options,
        this.callingCode});

  ItemW.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    photoUrl = json['photoUrl'];
    sms = json['sms'];
    whatsapp = json['whatsapp'];
    options =
    json['options'] != null ? new Options.fromJson(json['options']) : null;
    callingCode = json['callingCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['photoUrl'] = this.photoUrl;
    data['sms'] = this.sms;
    data['whatsapp'] = this.whatsapp;
    if (this.options != null) {
      data['options'] = this.options!.toJson();
    }
    data['callingCode'] = this.callingCode;
    return data;
  }
}

class Options {
  String? status;
  String? createdAt;
  String? updatedAt;

  Options({this.status, this.createdAt, this.updatedAt});

  Options.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}