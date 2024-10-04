/// code : 100
/// message : "Información listada correctamente"
/// status : true
/// data : {"notificationStatus":0,"version":"1.0.0-1","faq":[{"id":1,"name":"Url FAQ","url":"http://ganebo.inkuboads.co/faq","options":{"status":"active","createdAt":"2021-07-05T16:53:53.000Z","updatedAt":"2021-10-22T16:09:59.000Z"},"tag":"FAQ"},{"id":2,"name":"Centro de Ayuda","url":"http://ganebo.inkubo.co/help","options":{"status":"active","createdAt":"2021-07-05T16:53:53.000Z","updatedAt":"2021-08-09T20:40:48.000Z"},"tag":"help"},{"id":3,"name":"Terminos y condiciones","url":"http://ganebo.inkuboads.co/terms","options":{"status":"active","createdAt":"2021-07-05T16:53:53.000Z","updatedAt":"2021-08-09T20:40:35.000Z"},"tag":"TC"}]}

class Settingsuser {
  int? _code;
  String? _message;
  bool? _status;
  DataUS? _data;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  DataUS? get data => _data;

  Settingsuser({
      int? code, 
      String? message, 
      bool? status,
    DataUS? data}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
}

  Settingsuser.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? DataUS.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["code"] = _code;
    map["message"] = _message;
    map["status"] = _status;
    if (_data != null) {
      map["data"] = _data?.toJson();
    }
    return map;
  }

}

/// notificationStatus : 0
/// version : "1.0.0-1"
/// faq : [{"id":1,"name":"Url FAQ","url":"http://ganebo.inkuboads.co/faq","options":{"status":"active","createdAt":"2021-07-05T16:53:53.000Z","updatedAt":"2021-10-22T16:09:59.000Z"},"tag":"FAQ"},{"id":2,"name":"Centro de Ayuda","url":"http://ganebo.inkubo.co/help","options":{"status":"active","createdAt":"2021-07-05T16:53:53.000Z","updatedAt":"2021-08-09T20:40:48.000Z"},"tag":"help"},{"id":3,"name":"Terminos y condiciones","url":"http://ganebo.inkuboads.co/terms","options":{"status":"active","createdAt":"2021-07-05T16:53:53.000Z","updatedAt":"2021-08-09T20:40:35.000Z"},"tag":"TC"}]

class DataUS {
  int? _notificationStatus;
  String? _version;
  List<Faq>? _faq;

  int? get notificationStatus => _notificationStatus;
  String? get version => _version;
  List<Faq>? get faq => _faq;

  DataUS({
      int? notificationStatus, 
      String? version, 
      List<Faq>? faq}){
    _notificationStatus = notificationStatus;
    _version = version;
    _faq = faq;
}

  DataUS.fromJson(dynamic json) {
    _notificationStatus = json["notificationStatus"];
    _version = json["version"];
    if (json["faq"] != null) {
      _faq = [];
      json["faq"].forEach((v) {
        _faq?.add(Faq.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["notificationStatus"] = _notificationStatus;
    map["version"] = _version;
    if (_faq != null) {
      map["faq"] = _faq?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 1
/// name : "Url FAQ"
/// url : "http://ganebo.inkuboads.co/faq"
/// options : {"status":"active","createdAt":"2021-07-05T16:53:53.000Z","updatedAt":"2021-10-22T16:09:59.000Z"}
/// tag : "FAQ"

class Faq {
  int? _id;
  String? _name;
  String? _url;
  Options? _options;
  String? _tag;

  int? get id => _id;
  String? get name => _name;
  String? get url => _url;
  Options? get options => _options;
  String? get tag => _tag;

  Faq({
      int? id, 
      String? name, 
      String? url, 
      Options? options, 
      String? tag}){
    _id = id;
    _name = name;
    _url = url;
    _options = options;
    _tag = tag;
}

  Faq.fromJson(dynamic json) {
    _id = json["id"];
    _name = json["name"];
    _url = json["url"];
    _options = json["options"] != null ? Options.fromJson(json["options"]) : null;
    _tag = json["tag"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["name"] = _name;
    map["url"] = _url;
    if (_options != null) {
      map["options"] = _options?.toJson();
    }
    map["tag"] = _tag;
    return map;
  }

}

/// status : "active"
/// createdAt : "2021-07-05T16:53:53.000Z"
/// updatedAt : "2021-10-22T16:09:59.000Z"

class Options {
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  String? get status => _status;
  String? get createdAt => _createdAt;
  String? get updatedAt => _updatedAt;

  Options({
      String? status, 
      String? createdAt, 
      String? updatedAt}){
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
}

  Options.fromJson(dynamic json) {
    _status = json["status"];
    _createdAt = json["createdAt"];
    _updatedAt = json["updatedAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["status"] = _status;
    map["createdAt"] = _createdAt;
    map["updatedAt"] = _updatedAt;
    return map;
  }

}