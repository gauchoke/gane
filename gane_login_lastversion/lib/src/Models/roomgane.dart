/// code : 100
/// message : "Información listada correctamente"
/// status : true
/// data : {"result":[{"id":11,"title":"Dia del padre","description":"dias sad asda sdas dasdsa","class":"unique","formatAdverts":[{"id":150,"defaultLogo":1,"LgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/976ec53544586ed6a5e8e3c7b32f58ad6ac03d4c-1629737895982.png","AdImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/d0088181461a0c7ab7781f66598db0a10d7756bf-1630074707592.png","vimeoUrl":"","pointsFormat":500,"format":2}],"campaign":{"id":10,"ads":{"fullname":"Eric Solarte"}}},{"id":9,"title":"Dia del padre","description":"dias sad asda sdas dasdsa","class":"unique","formatAdverts":[{"id":152,"defaultLogo":1,"LgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/976ec53544586ed6a5e8e3c7b32f58ad6ac03d4c-1629737895982.png","AdImages":"","vimeoUrl":"https://player.vimeo.com/video/593348846","pointsFormat":500,"format":1}],"campaign":{"id":10,"ads":{"fullname":"Eric Solarte"}}},{"id":8,"title":"Dia del padre","description":"dias sad asda sdas dasdsa","class":"unique","formatAdverts":[{"id":151,"defaultLogo":1,"LgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/976ec53544586ed6a5e8e3c7b32f58ad6ac03d4c-1629737895982.png","AdImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/65e560f1c5ab631015ee732e4f3ca2f75b682aca-1630075179776.png","vimeoUrl":"","pointsFormat":500,"format":2}],"campaign":{"id":10,"ads":{"fullname":"Eric Solarte"}}}],"courrentPage":0,"page":1}

class Roomgane {
  int? _code;
  String? _message;
  bool? _status;
  DataSG? _data;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  DataSG? get data => _data;

  Roomgane({
      int? code, 
      String? message, 
      bool? status,
    DataSG? data}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
}

  Roomgane.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? DataSG.fromJson(json["data"]) : null;
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

/// result : [{"id":11,"title":"Dia del padre","description":"dias sad asda sdas dasdsa","class":"unique","formatAdverts":[{"id":150,"defaultLogo":1,"LgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/976ec53544586ed6a5e8e3c7b32f58ad6ac03d4c-1629737895982.png","AdImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/d0088181461a0c7ab7781f66598db0a10d7756bf-1630074707592.png","vimeoUrl":"","pointsFormat":500,"format":2}],"campaign":{"id":10,"ads":{"fullname":"Eric Solarte"}}},{"id":9,"title":"Dia del padre","description":"dias sad asda sdas dasdsa","class":"unique","formatAdverts":[{"id":152,"defaultLogo":1,"LgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/976ec53544586ed6a5e8e3c7b32f58ad6ac03d4c-1629737895982.png","AdImages":"","vimeoUrl":"https://player.vimeo.com/video/593348846","pointsFormat":500,"format":1}],"campaign":{"id":10,"ads":{"fullname":"Eric Solarte"}}},{"id":8,"title":"Dia del padre","description":"dias sad asda sdas dasdsa","class":"unique","formatAdverts":[{"id":151,"defaultLogo":1,"LgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/976ec53544586ed6a5e8e3c7b32f58ad6ac03d4c-1629737895982.png","AdImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/65e560f1c5ab631015ee732e4f3ca2f75b682aca-1630075179776.png","vimeoUrl":"","pointsFormat":500,"format":2}],"campaign":{"id":10,"ads":{"fullname":"Eric Solarte"}}}]
/// courrentPage : 0
/// page : 1

class DataSG {
  List<ResultGane>? _result;
  int? _courrentPage;
  int? _page;

  List<ResultGane>? get result => _result;
  int? get courrentPage => _courrentPage;
  int? get page => _page;

  DataSG({
      List<ResultGane>? result,
      int? courrentPage, 
      int? page}){
    _result = result;
    _courrentPage = courrentPage;
    _page = page;
}

  DataSG.fromJson(dynamic json) {
    if (json["result"] != null) {
      _result = [];
      json["result"].forEach((v) {
        _result?.add(ResultGane.fromJson(v));
      });
    }
    _courrentPage = json["courrentPage"];
    _page = json["page"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_result != null) {
      map["result"] = _result?.map((v) => v.toJson()).toList();
    }
    map["courrentPage"] = _courrentPage;
    map["page"] = _page;
    return map;
  }

}

/// id : 11
/// title : "Dia del padre"
/// description : "dias sad asda sdas dasdsa"
/// class : "unique"
/// formatAdverts : [{"id":150,"defaultLogo":1,"LgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/976ec53544586ed6a5e8e3c7b32f58ad6ac03d4c-1629737895982.png","AdImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/d0088181461a0c7ab7781f66598db0a10d7756bf-1630074707592.png","vimeoUrl":"","pointsFormat":500,"format":2}]
/// campaign : {"id":10,"ads":{"fullname":"Eric Solarte"}}

class ResultGane {
  int? _id;
  String? _title;
  String? _description;
  List<FormatAdverts>? _formatAdverts;
  Campaign? _campaign;

  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  List<FormatAdverts>? get formatAdverts => _formatAdverts;
  Campaign? get campaign => _campaign;

  ResultGane({
      int? id, 
      String? title, 
      String? description, 
      List<FormatAdverts>? formatAdverts,
      Campaign? campaign}){
    _id = id;
    _title = title;
    _description = description;
    _formatAdverts = formatAdverts;
    _campaign = campaign;
}

  ResultGane.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    _description = json["description"];
    if (json["formatAdverts"] != null) {
      _formatAdverts = [];
      json["formatAdverts"].forEach((v) {
        _formatAdverts?.add(FormatAdverts.fromJson(v));
      });
    }
    _campaign = json["campaign"] != null ? Campaign.fromJson(json["campaign"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    map["description"] = _description;
    if (_formatAdverts != null) {
      map["formatAdverts"] = _formatAdverts?.map((v) => v.toJson()).toList();
    }
    if (_campaign != null) {
      map["campaign"] = _campaign?.toJson();
    }
    return map;
  }

}

/// id : 10
/// ads : {"fullname":"Eric Solarte"}

class Campaign {
  int? _id;
  Ads? _ads;

  int? get id => _id;
  Ads? get ads => _ads;

  Campaign({
      int? id, 
      Ads? ads}){
    _id = id;
    _ads = ads;
}

  Campaign.fromJson(dynamic json) {
    _id = json["id"];
    _ads = json["ads"] != null ? Ads.fromJson(json["ads"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    if (_ads != null) {
      map["ads"] = _ads?.toJson();
    }
    return map;
  }

}

/// fullname : "Eric Solarte"

class Ads {
  String? _fullname;

  String? get fullname => _fullname;

  Ads({
      String? fullname}){
    _fullname = fullname;
}

  Ads.fromJson(dynamic json) {
    _fullname = json["fullname"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["fullname"] = _fullname;
    return map;
  }

}

/// id : 150
/// defaultLogo : 1
/// LgImages : "https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/976ec53544586ed6a5e8e3c7b32f58ad6ac03d4c-1629737895982.png"
/// AdImages : "https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/d0088181461a0c7ab7781f66598db0a10d7756bf-1630074707592.png"
/// vimeoUrl : ""
/// pointsFormat : 500
/// format : 2

class FormatAdverts {
  int? _id;
  int? _defaultLogo;
  String? _lgImages;
  String? _adImages;
  String? _vimeoUrl;
  String? _pointsFormat;
  String? _timeVisible;
  int? _format;

  int? get id => _id;
  int? get defaultLogo => _defaultLogo;
  String? get lgImages => _lgImages;
  String? get adImages => _adImages;
  String? get vimeoUrl => _vimeoUrl;
  String? get pointsFormat => _pointsFormat;
  String? get timeVisible => _timeVisible;
  int? get format => _format;

  FormatAdverts({
      int? id, 
      int? defaultLogo, 
      String? lgImages, 
      String? adImages, 
      String? vimeoUrl,
      String? pointsFormat,
      String? timeVisible,
      int? format}){
    _id = id;
    _defaultLogo = defaultLogo;
    _lgImages = lgImages;
    _adImages = adImages;
    _vimeoUrl = vimeoUrl;
    _pointsFormat = pointsFormat;
    _timeVisible = timeVisible;
    _format = format;
}

  FormatAdverts.fromJson(dynamic json) {
    _id = json["id"];
    _defaultLogo = json["defaultLogo"];
    _lgImages = json["LgImages"];
    _adImages = json["AdImages"];
    _vimeoUrl = json["vimeoUrl"];
    _pointsFormat = json["pointsFormat"];
    _timeVisible = json["timeVisible"];
    _format = json["format"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["defaultLogo"] = _defaultLogo;
    map["LgImages"] = _lgImages;
    map["AdImages"] = _adImages;
    map["vimeoUrl"] = _vimeoUrl;
    map["pointsFormat"] = _pointsFormat;
    map["timeVisible"] = _timeVisible;
    map["format"] = _format;
    return map;
  }

}