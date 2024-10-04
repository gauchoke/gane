class PlanesCompra {
  int? code;
  String? message;
  bool? status;
  DataPlanesCompra? data;

  PlanesCompra({this.code, this.message, this.status, this.data});

  PlanesCompra.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataPlanesCompra.fromJson(json['data']) : null;
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

class DataPlanesCompra {
  List<Items>? items;
  int? totalPages;
  int? offset;

  DataPlanesCompra({this.items, this.totalPages, this.offset});

  DataPlanesCompra.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(new Items.fromJson(v));
      });
    }
    totalPages = json['totalPages'];
    offset = json['offset'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items!.map((v) => v.toJson()).toList();
    }
    data['totalPages'] = this.totalPages;
    data['offset'] = this.offset;
    return data;
  }
}

class Items {
  int? id;
  String? name;
  String? description;
  String? planAltanId;
  int? price;
  String? photoUrl;
  String? url;
  int? megabits;
  Options? options;

  Items(
      {this.id,
        this.name,
        this.description,
        this.planAltanId,
        this.price,
        this.photoUrl,
        this.url,
        this.megabits,
        this.options});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    planAltanId = json['planAltanId'];
    price = json['price'];
    photoUrl = json['photoUrl'];
    url = json['url'];
    megabits = json['megabits'];
    options =
    json['options'] != null ? new Options.fromJson(json['options']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['planAltanId'] = this.planAltanId;
    data['price'] = this.price;
    data['photoUrl'] = this.photoUrl;
    data['url'] = this.url;
    data['megabits'] = this.megabits;
    if (this.options != null) {
      data['options'] = this.options!.toJson();
    }
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