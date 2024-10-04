/// code : 100
/// message : "Información listada correctamente"
/// status : true
/// data : {"result":[{"id":201,"title":"prueba 1231251","description":"asfasf","typeClass":"unique","operation":0,"segmentationStatus":0,"ads":[{"id":258,"defaultLogo":0,"lgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/gamer/8644a56832c7743e169c94b2377436091e0ab564-1637340274899.png","adImages":"","vimeoUrl":"","pointsAds":"120","pointsuser":[],"formatValue":4,"gamerAds":[{"id":24,"header":"prueba jeugo papas ","description":"asdasdas","type":"IMAGE","gamer":12,"figure":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/b004b802cf7c8f95f61f05554bf300089510ecfb-1637340275486.png","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/8fba5320d06fde5056e156be2875584d98f82ab9-1637340275733.png"],"background":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/c3d0f8466728422117df0a7561dee51eaf8bf571-1637340276021.jpeg","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/36ea8125def06ada92afc64a058b691d435f5680-1637340276220.jpg"],"audio":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/8bd710e0c862df81c19844024af1a12d80e89b36-1637340276544.mp3","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/07cf116d4bada67ef201f3107662e618ebc2d9b3-1637340276850.mp3"],"typeGamer":"HOUSE","codeUrl":""}]}],"timeOperation":[{"id":2456,"hours":{"id":6},"day":{"id":8}}],"campaign":{"id":4,"statusTracking":{"name":"Pendiente"}},"statusTracking":{"name":"En curso"},"segmentation":{"id":619,"segmentationuser":[{"id":38292}]}},{"id":198,"title":"test backgroun juego","description":"asdasd","typeClass":"unique","operation":0,"segmentationStatus":0,"ads":[{"id":256,"defaultLogo":0,"lgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/gamer/b51078679e9eca4f9429aad5c0d3d529eb906f5c-1637337476174.jpeg","adImages":"","vimeoUrl":"","pointsAds":"120","pointsuser":[],"formatValue":4,"gamerAds":[{"id":22,"header":"prueba 2 juegos","description":"asdaasds","type":"IMAGE","gamer":12,"figure":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/c3bb3ed4b205689f9494d05d53fefa7bc61a9aaa-1637337476944.png","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/f9089b1696a2048ddc78ea1c86fbea1a1fb975c4-1637337477165.png"],"background":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/5024d1ef305d1de1c418d625a7d71f8cdfe4b81b-1637337477518.jpeg","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/d2318a9dfebad2dbca4949599285e618ce56c3f0-1637337477759.jpg","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/cf9a29f766eaee9092198877988bce20bc273c41-1637337477943.jpg"],"audio":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/270d684bf185ef80d63694ae4871b85fafca5f0e-1637337478343.mp3","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/c726cd72115952bef89b0b2d6b8287e4bc44fbb7-1637337478688.mp3"],"typeGamer":"HOUSE","codeUrl":""}]}],"timeOperation":[{"id":2441,"hours":{"id":6},"day":{"id":8}}],"campaign":{"id":60,"statusTracking":{"name":"Pendiente"}},"statusTracking":{"name":"En curso"},"segmentation":{"id":616,"segmentationuser":[{"id":37911}]}}],"courrentPage":0,"page":1}

class Gamelist {
  int? _code;
  String? _message;
  bool? _status;
  DataGL? _data;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  DataGL? get data => _data;

  Gamelist({
      int? code, 
      String? message, 
      bool? status,
    DataGL? data}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
}

  Gamelist.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? DataGL.fromJson(json["data"]) : null;
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

/// result : [{"id":201,"title":"prueba 1231251","description":"asfasf","typeClass":"unique","operation":0,"segmentationStatus":0,"ads":[{"id":258,"defaultLogo":0,"lgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/gamer/8644a56832c7743e169c94b2377436091e0ab564-1637340274899.png","adImages":"","vimeoUrl":"","pointsAds":"120","pointsuser":[],"formatValue":4,"gamerAds":[{"id":24,"header":"prueba jeugo papas ","description":"asdasdas","type":"IMAGE","gamer":12,"figure":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/b004b802cf7c8f95f61f05554bf300089510ecfb-1637340275486.png","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/8fba5320d06fde5056e156be2875584d98f82ab9-1637340275733.png"],"background":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/c3d0f8466728422117df0a7561dee51eaf8bf571-1637340276021.jpeg","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/36ea8125def06ada92afc64a058b691d435f5680-1637340276220.jpg"],"audio":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/8bd710e0c862df81c19844024af1a12d80e89b36-1637340276544.mp3","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/07cf116d4bada67ef201f3107662e618ebc2d9b3-1637340276850.mp3"],"typeGamer":"HOUSE","codeUrl":""}]}],"timeOperation":[{"id":2456,"hours":{"id":6},"day":{"id":8}}],"campaign":{"id":4,"statusTracking":{"name":"Pendiente"}},"statusTracking":{"name":"En curso"},"segmentation":{"id":619,"segmentationuser":[{"id":38292}]}},{"id":198,"title":"test backgroun juego","description":"asdasd","typeClass":"unique","operation":0,"segmentationStatus":0,"ads":[{"id":256,"defaultLogo":0,"lgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/gamer/b51078679e9eca4f9429aad5c0d3d529eb906f5c-1637337476174.jpeg","adImages":"","vimeoUrl":"","pointsAds":"120","pointsuser":[],"formatValue":4,"gamerAds":[{"id":22,"header":"prueba 2 juegos","description":"asdaasds","type":"IMAGE","gamer":12,"figure":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/c3bb3ed4b205689f9494d05d53fefa7bc61a9aaa-1637337476944.png","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/f9089b1696a2048ddc78ea1c86fbea1a1fb975c4-1637337477165.png"],"background":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/5024d1ef305d1de1c418d625a7d71f8cdfe4b81b-1637337477518.jpeg","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/d2318a9dfebad2dbca4949599285e618ce56c3f0-1637337477759.jpg","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/cf9a29f766eaee9092198877988bce20bc273c41-1637337477943.jpg"],"audio":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/270d684bf185ef80d63694ae4871b85fafca5f0e-1637337478343.mp3","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/c726cd72115952bef89b0b2d6b8287e4bc44fbb7-1637337478688.mp3"],"typeGamer":"HOUSE","codeUrl":""}]}],"timeOperation":[{"id":2441,"hours":{"id":6},"day":{"id":8}}],"campaign":{"id":60,"statusTracking":{"name":"Pendiente"}},"statusTracking":{"name":"En curso"},"segmentation":{"id":616,"segmentationuser":[{"id":37911}]}}]
/// courrentPage : 0
/// page : 1

class DataGL {
  List<ResultGL>? _result;
  int? _courrentPage;
  int? _page;

  List<ResultGL>? get result => _result;
  int? get courrentPage => _courrentPage;
  int? get page => _page;

  DataGL({
      List<ResultGL>? result,
      int? courrentPage, 
      int? page}){
    _result = result;
    _courrentPage = courrentPage;
    _page = page;
}

  DataGL.fromJson(dynamic json) {
    if (json["result"] != null) {
      _result = [];
      json["result"].forEach((v) {
        _result?.add(ResultGL.fromJson(v));
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

/// id : 201
/// title : "prueba 1231251"
/// description : "asfasf"
/// typeClass : "unique"
/// operation : 0
/// segmentationStatus : 0
/// ads : [{"id":258,"defaultLogo":0,"lgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/gamer/8644a56832c7743e169c94b2377436091e0ab564-1637340274899.png","adImages":"","vimeoUrl":"","pointsAds":"120","pointsuser":[],"formatValue":4,"gamerAds":[{"id":24,"header":"prueba jeugo papas ","description":"asdasdas","type":"IMAGE","gamer":12,"figure":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/b004b802cf7c8f95f61f05554bf300089510ecfb-1637340275486.png","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/8fba5320d06fde5056e156be2875584d98f82ab9-1637340275733.png"],"background":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/c3d0f8466728422117df0a7561dee51eaf8bf571-1637340276021.jpeg","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/36ea8125def06ada92afc64a058b691d435f5680-1637340276220.jpg"],"audio":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/8bd710e0c862df81c19844024af1a12d80e89b36-1637340276544.mp3","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/07cf116d4bada67ef201f3107662e618ebc2d9b3-1637340276850.mp3"],"typeGamer":"HOUSE","codeUrl":""}]}]
/// timeOperation : [{"id":2456,"hours":{"id":6},"day":{"id":8}}]
/// campaign : {"id":4,"statusTracking":{"name":"Pendiente"}}
/// statusTracking : {"name":"En curso"}
/// segmentation : {"id":619,"segmentationuser":[{"id":38292}]}

class ResultGL {
  int? _id;
  String? _title;
  String? _description;
  String? _pointsAdditional;
  String? _typeClass;
  int? _operation;
  int? _segmentationStatus;
  List<Ads>? _ads;
  List<TimeOperation>? _timeOperation;
  Campaign? _campaign;
  StatusTracking? _statusTracking;
  Segmentation? _segmentation;

  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  String? get pointsAdditional => _pointsAdditional;
  String? get typeClass => _typeClass;
  int? get operation => _operation;
  int? get segmentationStatus => _segmentationStatus;
  List<Ads>? get ads => _ads;
  List<TimeOperation>? get timeOperation => _timeOperation;
  Campaign? get campaign => _campaign;
  StatusTracking? get statusTracking => _statusTracking;
  Segmentation? get segmentation => _segmentation;

  ResultGL({
      int? id, 
      String? title, 
      String? description,
      String? pointsAdditional,
      String? typeClass, 
      int? operation, 
      int? segmentationStatus, 
      List<Ads>? ads, 
      List<TimeOperation>? timeOperation, 
      Campaign? campaign, 
      StatusTracking? statusTracking, 
      Segmentation? segmentation}){
    _id = id;
    _title = title;
    _description = description;
    _pointsAdditional = pointsAdditional;
    _typeClass = typeClass;
    _operation = operation;
    _segmentationStatus = segmentationStatus;
    _ads = ads;
    _timeOperation = timeOperation;
    _campaign = campaign;
    _statusTracking = statusTracking;
    _segmentation = segmentation;
}

  ResultGL.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    _description = json["description"];
    _pointsAdditional = json["pointsAdditional"];
    _typeClass = json["typeClass"];
    _operation = json["operation"];
    _segmentationStatus = json["segmentationStatus"];
    if (json["ads"] != null) {
      _ads = [];
      json["ads"].forEach((v) {
        _ads?.add(Ads.fromJson(v));
      });
    }
    if (json["timeOperation"] != null) {
      _timeOperation = [];
      json["timeOperation"].forEach((v) {
        _timeOperation?.add(TimeOperation.fromJson(v));
      });
    }
    _campaign = json["campaign"] != null ? Campaign.fromJson(json["campaign"]) : null;
    _statusTracking = json["statusTracking"] != null ? StatusTracking.fromJson(json["statusTracking"]) : null;
    _segmentation = json["segmentation"] != null ? Segmentation.fromJson(json["segmentation"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    map["description"] = _description;
    map["pointsAdditional"] = _pointsAdditional;
    map["typeClass"] = _typeClass;
    map["operation"] = _operation;
    map["segmentationStatus"] = _segmentationStatus;
    if (_ads != null) {
      map["ads"] = _ads?.map((v) => v.toJson()).toList();
    }
    if (_timeOperation != null) {
      map["timeOperation"] = _timeOperation?.map((v) => v.toJson()).toList();
    }
    if (_campaign != null) {
      map["campaign"] = _campaign?.toJson();
    }
    if (_statusTracking != null) {
      map["statusTracking"] = _statusTracking?.toJson();
    }
    if (_segmentation != null) {
      map["segmentation"] = _segmentation?.toJson();
    }
    return map;
  }

}

/// id : 619
/// segmentationuser : [{"id":38292}]

class Segmentation {
  int? _id;
  List<Segmentationuser>? _segmentationuser;

  int? get id => _id;
  List<Segmentationuser>? get segmentationuser => _segmentationuser;

  Segmentation({
      int? id, 
      List<Segmentationuser>? segmentationuser}){
    _id = id;
    _segmentationuser = segmentationuser;
}

  Segmentation.fromJson(dynamic json) {
    _id = json["id"];
    if (json["segmentationuser"] != null) {
      _segmentationuser = [];
      json["segmentationuser"].forEach((v) {
        _segmentationuser?.add(Segmentationuser.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    if (_segmentationuser != null) {
      map["segmentationuser"] = _segmentationuser?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 38292

class Segmentationuser {
  int? _id;

  int? get id => _id;

  Segmentationuser({
      int? id}){
    _id = id;
}

  Segmentationuser.fromJson(dynamic json) {
    _id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    return map;
  }

}

/// name : "En curso"

class StatusTracking {
  String? _name;

  String? get name => _name;

  StatusTracking({
      String? name}){
    _name = name;
}

  StatusTracking.fromJson(dynamic json) {
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    return map;
  }

}

/// id : 4
/// statusTracking : {"name":"Pendiente"}

class Campaign {
  int? _id;
  StatusTracking? _statusTracking;

  int? get id => _id;
  StatusTracking? get statusTracking => _statusTracking;

  Campaign({
      int? id, 
      StatusTracking? statusTracking}){
    _id = id;
    _statusTracking = statusTracking;
}

  Campaign.fromJson(dynamic json) {
    _id = json["id"];
    _statusTracking = json["statusTracking"] != null ? StatusTracking.fromJson(json["statusTracking"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    if (_statusTracking != null) {
      map["statusTracking"] = _statusTracking?.toJson();
    }
    return map;
  }

}

/// name : "Pendiente"

class StatusTrackinggg {
  String? _name;

  String? get name => _name;

  StatusTrackinggg({
      String? name}){
    _name = name;
}

  StatusTrackinggg.fromJson(dynamic json) {
    _name = json["name"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["name"] = _name;
    return map;
  }

}

/// id : 2456
/// hours : {"id":6}
/// day : {"id":8}

class TimeOperation {
  int? _id;
  Hours? _hours;
  Day? _day;

  int? get id => _id;
  Hours? get hours => _hours;
  Day? get day => _day;

  TimeOperation({
      int? id, 
      Hours? hours, 
      Day? day}){
    _id = id;
    _hours = hours;
    _day = day;
}

  TimeOperation.fromJson(dynamic json) {
    _id = json["id"];
    _hours = json["hours"] != null ? Hours.fromJson(json["hours"]) : null;
    _day = json["day"] != null ? Day.fromJson(json["day"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    if (_hours != null) {
      map["hours"] = _hours?.toJson();
    }
    if (_day != null) {
      map["day"] = _day?.toJson();
    }
    return map;
  }

}

/// id : 8

class Day {
  int? _id;

  int? get id => _id;

  Day({
      int? id}){
    _id = id;
}

  Day.fromJson(dynamic json) {
    _id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    return map;
  }

}

/// id : 6

class Hours {
  int? _id;

  int? get id => _id;

  Hours({
      int? id}){
    _id = id;
}

  Hours.fromJson(dynamic json) {
    _id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    return map;
  }

}

/// id : 258
/// defaultLogo : 0
/// lgImages : "https://dev-kubo.s3-us-west-2.amazonaws.com/gn/gamer/8644a56832c7743e169c94b2377436091e0ab564-1637340274899.png"
/// adImages : ""
/// vimeoUrl : ""
/// pointsAds : "120"
/// pointsuser : []
/// formatValue : 4
/// gamerAds : [{"id":24,"header":"prueba jeugo papas ","description":"asdasdas","type":"IMAGE","gamer":12,"figure":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/b004b802cf7c8f95f61f05554bf300089510ecfb-1637340275486.png","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/8fba5320d06fde5056e156be2875584d98f82ab9-1637340275733.png"],"background":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/c3d0f8466728422117df0a7561dee51eaf8bf571-1637340276021.jpeg","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/36ea8125def06ada92afc64a058b691d435f5680-1637340276220.jpg"],"audio":["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/8bd710e0c862df81c19844024af1a12d80e89b36-1637340276544.mp3","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/07cf116d4bada67ef201f3107662e618ebc2d9b3-1637340276850.mp3"],"typeGamer":"HOUSE","codeUrl":""}]

class Ads {
  int? _id;
  int? _defaultLogo;
  String? _lgImages;
  String? _adImages;
  String? _vimeoUrl;
  String? _pointsAds;
  String? _url;
  List<dynamic>? _pointsuser;
  int? _formatValue;
  List<GamerAds>? _gamerAds;
  String? _brand;

  int? get id => _id;
  int? get defaultLogo => _defaultLogo;
  String? get lgImages => _lgImages;
  String? get adImages => _adImages;
  String? get vimeoUrl => _vimeoUrl;
  String? get pointsAds => _pointsAds;
  String? get url => _url;
  List<dynamic>? get pointsuser => _pointsuser;
  int? get formatValue => _formatValue;
  List<GamerAds>? get gamerAds => _gamerAds;
  String? get brand => _brand;

  Ads({
      int? id, 
      int? defaultLogo, 
      String? lgImages, 
      String? adImages, 
      String? vimeoUrl, 
      String? pointsAds,
      String? url,
      List<dynamic>? pointsuser, 
      int? formatValue, 
      List<GamerAds>? gamerAds,
    String? brand,
  }){
    _id = id;
    _defaultLogo = defaultLogo;
    _lgImages = lgImages;
    _adImages = adImages;
    _vimeoUrl = vimeoUrl;
    _pointsAds = pointsAds;
    _url = url;
    //_pointsuser = pointsuser;
    _formatValue = formatValue;
    _gamerAds = gamerAds;
    _brand = brand;
}

  Ads.fromJson(dynamic json) {
    _id = json["id"];
    _defaultLogo = json["defaultLogo"];
    _lgImages = json["lgImages"];
    _adImages = json["adImages"];
    _vimeoUrl = json["vimeoUrl"];
    _pointsAds = json["pointsAds"];
    _url = json["url"];
    _brand = json["brand"];
    /*if (json["pointsuser"] != null) {
      _pointsuser = [];
      json["pointsuser"].forEach((v) {
        _pointsuser?.add(dynamic.fromJson(v));
      });
    }*/
    _formatValue = json["formatValue"];
    if (json["gamerAds"] != null) {
      _gamerAds = [];
      json["gamerAds"].forEach((v) {
        _gamerAds?.add(GamerAds.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["defaultLogo"] = _defaultLogo;
    map["lgImages"] = _lgImages;
    map["adImages"] = _adImages;
    map["vimeoUrl"] = _vimeoUrl;
    map["pointsAds"] = _pointsAds;
    map["url"] = _url;
    map["brand"] = _brand;
    /*if (_pointsuser != null) {
      map["pointsuser"] = _pointsuser?.map((v) => v.toJson()).toList();
    }*/
    map["formatValue"] = _formatValue;
    if (_gamerAds != null) {
      map["gamerAds"] = _gamerAds?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : 24
/// header : "prueba jeugo papas "
/// description : "asdasdas"
/// type : "IMAGE"
/// gamer : 12
/// figure : ["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/b004b802cf7c8f95f61f05554bf300089510ecfb-1637340275486.png","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/figure/8fba5320d06fde5056e156be2875584d98f82ab9-1637340275733.png"]
/// background : ["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/c3d0f8466728422117df0a7561dee51eaf8bf571-1637340276021.jpeg","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/background/36ea8125def06ada92afc64a058b691d435f5680-1637340276220.jpg"]
/// audio : ["https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/8bd710e0c862df81c19844024af1a12d80e89b36-1637340276544.mp3","https://dev-kubo.s3-us-west-2.amazonaws.com/gn/audio/07cf116d4bada67ef201f3107662e618ebc2d9b3-1637340276850.mp3"]
/// typeGamer : "HOUSE"
/// codeUrl : ""

class GamerAds {
  int? _id;
  String? _header;
  String? _description;
  String? _type;
  int? _gamer;
  List<String>? _figure;
  List<String>? _background;
  List<String>? _audio;
  String? _typeGamer;
  String? _codeUrl;

  int? get id => _id;
  String? get header => _header;
  String? get description => _description;
  String? get type => _type;
  int? get gamer => _gamer;
  List<String>? get figure => _figure;
  List<String>? get background => _background;
  List<String>? get audio => _audio;
  String? get typeGamer => _typeGamer;
  String? get codeUrl => _codeUrl;

  GamerAds({
      int? id, 
      String? header, 
      String? description, 
      String? type, 
      int? gamer, 
      List<String>? figure, 
      List<String>? background, 
      List<String>? audio, 
      String? typeGamer, 
      String? codeUrl}){
    _id = id;
    _header = header;
    _description = description;
    _type = type;
    _gamer = gamer;
    _figure = figure;
    _background = background;
    _audio = audio;
    _typeGamer = typeGamer;
    _codeUrl = codeUrl;
}

  GamerAds.fromJson(dynamic json) {
    _id = json["id"];
    _header = json["header"];
    _description = json["description"];
    _type = json["type"];
    _gamer = json["gamer"];
    _figure = json["figure"] != null ? json["figure"].cast<String>() : [];
    _background = json["background"] != null ? json["background"].cast<String>() : [];
    _audio = json["audio"] != null ? json["audio"].cast<String>() : [];
    _typeGamer = json["typeGamer"];
    _codeUrl = json["codeUrl"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["header"] = _header;
    map["description"] = _description;
    map["type"] = _type;
    map["gamer"] = _gamer;
    map["figure"] = _figure;
    map["background"] = _background;
    map["audio"] = _audio;
    map["typeGamer"] = _typeGamer;
    map["codeUrl"] = _codeUrl;
    return map;
  }

}