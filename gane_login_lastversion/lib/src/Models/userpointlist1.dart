class Userpointlist1 {
  int? code;
  String? message;
  bool? status;
  DataLUP1? data;

  Userpointlist1({this.code, this.message, this.status, this.data});

  Userpointlist1.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataLUP1.fromJson(json['data']) : null;
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

class DataLUP1 {
  List<ItemsLUP1>? items;
  int? totalPages;

  DataLUP1({this.items, this.totalPages});

  DataLUP1.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ItemsLUP1>[];
      json['items'].forEach((v) {
        items!.add(new ItemsLUP1.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    return data;
  }
}

class ItemsLUP1 {
  int? id;
  int? points;
  int? categoryId;
  int? adsId;
  int? sequenceAdsId;
  int? notificationId;
  int? systemPlanAltanId;
  String? images;
  String? color;
  Options? options;
  String? title;

  ItemsLUP1(
      {this.id,
        this.points,
        this.categoryId,
        this.adsId,
        this.sequenceAdsId,
        this.notificationId,
        this.systemPlanAltanId,
        this.images,
        this.color,
        this.options,
        this.title});

  ItemsLUP1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    points = json['points']??0;
    categoryId = json['categoryId']??0;
    adsId = json['adsId']??0;
    sequenceAdsId = json['sequenceAdsId']??0;
    notificationId = json['notificationId']??0;
    systemPlanAltanId = json['systemPlanAltanId']??0;
    images = json['images']??"";
    color = json['color']??"";
    options =
    json['options'] != null ? new Options.fromJson(json['options']) : null;
    title = json['title']??"No-data";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['points'] = this.points;
    data['categoryId'] = this.categoryId;
    data['adsId'] = this.adsId;
    data['sequenceAdsId'] = this.sequenceAdsId;
    data['notificationId'] = this.notificationId;
    data['systemPlanAltanId'] = this.systemPlanAltanId;
    data['images'] = this.images;
    data['color'] = this.color;
    if (this.options != null) {
      data['options'] = this.options!.toJson();
    }
    data['title'] = this.title;
    return data;
  }
}

class Options {
  String? createdAt;

  Options({this.createdAt});

  Options.fromJson(Map<String, dynamic> json) {
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createdAt'] = this.createdAt;
    return data;
  }
}