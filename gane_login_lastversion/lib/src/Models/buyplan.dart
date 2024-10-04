class BuyPlans {
  int? code;
  String? message;
  bool? status;
  DataBuyPlan? data;

  BuyPlans({this.code, this.message, this.status, this.data});

  BuyPlans.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataBuyPlan.fromJson(json['data']) : null;
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

class DataBuyPlan {
  Item? item;

  DataBuyPlan({this.item});

  DataBuyPlan.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item!.toJson();
    }
    return data;
  }
}

class Item {
  String? reference;
  String? order;
  String? expiresAt;
  String? fullname;

  Item({this.reference, this.order, this.expiresAt, this.fullname});

  Item.fromJson(Map<String, dynamic> json) {
    reference = json['reference'];
    order = json['order'];
    expiresAt = json['expires_at'].toString();
    fullname = json['fullname'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reference'] = this.reference;
    data['order'] = this.order;
    data['expires_at'] = this.expiresAt;
    data['fullname'] = this.fullname;
    return data;
  }
}