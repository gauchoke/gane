class AccessToken {
  late int code;
  late String message;
  late bool status;
  late DataA data;

  AccessToken({required this.code, required this.message, required this.status, required this.data});

  AccessToken.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = (json['data'] != null ? new DataA.fromJson(json['data']) : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['message'] = this.message;
    data['status'] = this.status;
    data['data'] = this.data.toJson();
    return data;
  }
}

class DataA {
  late String accessToken;

  DataA({required this.accessToken});

  DataA.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    return data;
  }
}