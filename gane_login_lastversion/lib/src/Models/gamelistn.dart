class GamelistN {
  int? code;
  String? message;
  bool? status;
  DataGLN? data;

  GamelistN({this.code, this.message, this.status, this.data});

  GamelistN.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataGLN.fromJson(json['data']) : null;
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

class DataGLN {
  Items? items;

  DataGLN({this.items});

  DataGLN.fromJson(Map<String, dynamic> json) {
    items = json['items'] != null ? new Items.fromJson(json['items']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.toJson();
    }
    return data;
  }
}

class Items {
  List<ItemsN>? items;
  Paging? paging;

  Items({this.items, this.paging});

  Items.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ItemsN>[];
      json['items'].forEach((v) {
        items!.add(new ItemsN.fromJson(v));
      });
    }
    paging =
    json['paging'] != null ? new Paging.fromJson(json['paging']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    if (this.paging != null) {
      data['paging'] = this.paging!.toJson();
    }
    return data;
  }
}

class ItemsN {
  String? id;
  String? promotionType;
  String? title;
  String? internalRef;
  String? description;
  String? status;
  String? timezone;
  String? startDate;
  String? endDate;
  String? defaultLanguage;
  String? created;
  OrganizingBrand? organizingBrand;

  ItemsN(
      {this.id,
        this.promotionType,
        this.title,
        this.internalRef,
        this.description,
        this.status,
        this.timezone,
        this.startDate,
        this.endDate,
        this.defaultLanguage,
        this.created,
        this.organizingBrand});

  ItemsN.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    promotionType = json['promotion_type'];
    title = json['title'];
    internalRef = json['internal_ref'];
    description = json['description'];
    status = json['status'];
    timezone = json['timezone'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    defaultLanguage = json['default_language'];
    created = json['created'];
    organizingBrand = json['organizing_brand'] != null
        ? new OrganizingBrand.fromJson(json['organizing_brand'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['promotion_type'] = this.promotionType;
    data['title'] = this.title;
    data['internal_ref'] = this.internalRef;
    data['description'] = this.description;
    data['status'] = this.status;
    data['timezone'] = this.timezone;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['default_language'] = this.defaultLanguage;
    data['created'] = this.created;
    if (this.organizingBrand != null) {
      data['organizing_brand'] = this.organizingBrand!.toJson();
    }
    return data;
  }
}

class OrganizingBrand {
  String? id;
  String? name;

  OrganizingBrand({this.id, this.name});

  OrganizingBrand.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class Paging {
  int? itemsPage;

  Paging({this.itemsPage});

  Paging.fromJson(Map<String, dynamic> json) {
    itemsPage = json['items_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['items_page'] = this.itemsPage;
    return data;
  }
}