class UserAltan {
  int? code;
  String? message;
  bool? status;
  DataAltan? data;

  UserAltan({this.code, this.message, this.status, this.data});

  UserAltan.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataAltan.fromJson(json['data']) : null;
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

class DataAltan {
  Item? item;

  DataAltan({this.item});

  DataAltan.fromJson(Map<String, dynamic> json) {
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
  int? id;
  String? points;
  String? megabits;
  String? remainingPoints;
  String? exchange;
  PointsUser? pointsUser;
  String? exchangeDay;
  double? daysTotal;
  String? remainingPointsConvert;

  Item(
      {this.id,
        this.points,
        this.megabits,
        this.remainingPoints,
        this.exchange,
        this.pointsUser,
        this.exchangeDay,
        this.daysTotal,
        this.remainingPointsConvert
      });

  Item.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    points = json['points'].toString() ?? "";
    megabits = json['megabits'].toString() ?? "";
    remainingPoints = json['remainingPoints'].toString() ?? "";
    remainingPointsConvert = json['remainingPointsConvert'].toString() ?? "0";
    exchange = json['exchange'];
    pointsUser = json['pointsUser'] != null
        ? new PointsUser.fromJson(json['pointsUser'])
        : null;
    exchangeDay = json['exchangeDay'].toString() ?? "";
    daysTotal = double.parse(json['daysTotal']) ;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['points'] = this.points;
    data['megabits'] = this.megabits;
    data['remainingPoints'] = this.remainingPoints;
    data['remainingPointsConvert'] = this.remainingPointsConvert;
    data['exchange'] = this.exchange;
    if (this.pointsUser != null) {
      data['pointsUser'] = this.pointsUser!.toJson();
    }
    data['exchangeDay'] = this.exchangeDay;
    data['daysTotal'] = this.daysTotal;
    return data;
  }
}

class PointsUser {
  String? result;
  String? phonePrefix;
  String? photoUrl;
  String? phoneNumber;
  String? fullname;
  String? points;

  PointsUser(
      {this.result,
        this.phonePrefix,
        this.photoUrl,
        this.phoneNumber,
        this.points,
        this.fullname});

  PointsUser.fromJson(Map<String, dynamic> json) {
    result = json['result'];
    phonePrefix = json['phonePrefix'];
    photoUrl = json['photoUrl'];
    phoneNumber = json['phoneNumber'];
    fullname = json['fullname'];
    points = json['points'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['result'] = this.result;
    data['phonePrefix'] = this.phonePrefix;
    data['photoUrl'] = this.photoUrl;
    data['phoneNumber'] = this.phoneNumber;
    data['fullname'] = this.fullname;
    data['points'] = this.points;
    return data;
  }
}