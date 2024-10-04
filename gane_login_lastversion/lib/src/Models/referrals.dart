class ReferralData {
  int? code;
  String? message;
  bool? status;
  DataReferral? data;

  ReferralData({this.code, this.message, this.status, this.data});

  ReferralData.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataReferral.fromJson(json['data']) : null;
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

class DataReferral {
  Information? information;

  DataReferral({this.information});

  DataReferral.fromJson(Map<String, dynamic> json) {
    information = json['information'] != null
        ? new Information.fromJson(json['information'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.information != null) {
      data['information'] = this.information!.toJson();
    }
    return data;
  }
}

class Information {
  int? id;
  double? pointsUser;
  double? pointsFriend;
  String? codeReferrals;
  String? userId;
  String? pointsWin;
  String? effectiveShares;
  String? textShares;
  String? title;
  String? description;

  Information(
      {this.id,
        this.pointsUser,
        this.pointsFriend,
        this.codeReferrals,
        this.userId,
        this.pointsWin,
        this.effectiveShares,
        this.textShares,
        this.title,
        this.description
      });

  Information.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pointsUser = json['pointsUser'].toDouble();
    pointsFriend = json['pointsFriend'].toDouble();
    codeReferrals = json['codeReferrals'];
    userId = json['userId'];
    pointsWin = json['pointsWin'];
    effectiveShares = json['effectiveShares'];
    textShares = json['textShares'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pointsUser'] = this.pointsUser;
    data['pointsFriend'] = this.pointsFriend;
    data['codeReferrals'] = this.codeReferrals;
    data['userId'] = this.userId;
    data['pointsWin'] = this.pointsWin;
    data['effectiveShares'] = this.effectiveShares;
    data['textShares'] = this.textShares;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}