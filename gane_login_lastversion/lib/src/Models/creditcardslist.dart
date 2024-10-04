class TCList {
  int? code;
  String? message;
  bool? status;
  DataTCList? data;

  TCList({this.code, this.message, this.status, this.data});

  TCList.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataTCList.fromJson(json['data']) : null;
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

class DataTCList {
  List<ItemsTCList>? items;
  int? totalPages;
  int? offset;

  DataTCList({this.items, this.totalPages, this.offset});

  DataTCList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = <ItemsTCList>[];
      json['items'].forEach((v) {
        items!.add(new ItemsTCList.fromJson(v));
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

class ItemsTCList {
  int? id;
  String? cardHolder;
  String? cardNumber;
  String? franchise;
  bool? selected;

  ItemsTCList({this.id, this.cardHolder, this.cardNumber, this.franchise, this.selected});

  ItemsTCList.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardHolder = json['cardHolder'];
    cardNumber = json['cardNumber'];
    franchise = json['franchise'];
    selected = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cardHolder'] = this.cardHolder;
    data['cardNumber'] = this.cardNumber;
    data['franchise'] = this.franchise;
    return data;
  }
}