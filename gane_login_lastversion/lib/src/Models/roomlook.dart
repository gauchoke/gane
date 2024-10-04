/// code : 100
/// message : "Información listada correctamente"
/// status : true
/// data : {"result":[{"id":63,"title":"anuncio 35","description":"Prueba 35","typeClass":"sequence","operation":0,"sizeAds":"standard","ads":[{"id":120,"defaultLogo":1,"lgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","adImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","vimeoUrl":"","pointsAds":"10","timeVisible":"10","pointsAdsuser":[],"questionAds":[{"id":22,"question":"Te gusta la gaseosa?","answersAds":[{"id":50,"answers":"Falso"},{"id":51,"answers":"Verdadero"}],"type":2},{"id":23,"question":"Cual es tu comida favorita?","answersAds":[{"id":52,"answers":""}],"type":1},{"id":24,"question":"Color favorito?","answersAds":[{"id":53,"answers":"Azul"},{"id":54,"answers":"Rojo"},{"id":55,"answers":"Amarillo"}],"type":3}],"formatValue":3}],"timeOperation":[{"id":1017,"hours":{"id":6},"day":{"id":8}}],"campaign":{"id":27}}],"courrentPage":0,"page":3}

class Roomlook {
  //int? _code;
  int? code;
  String? _message;
  bool? _status;
  DataSL? _data;

  //int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  DataSL? get data => _data;

  Roomlook({
    //int? code,
    this.code,
    String? message,
    bool? status,
    DataSL? data}){
    //_code = code;
    _message = message;
    _status = status;
    _data = data;
  }

  Roomlook.fromJson(dynamic json) {
    //_code = json["code"];
    code = int.tryParse(json["code"]?.toString() ?? '');
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? DataSL.fromJson(json["data"]) : null;
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    //map["code"] = _code;
    map["code"] = code;
    map["message"] = _message;
    map["status"] = _status;
    if (_data != null) {
      map["data"] = _data?.toJson();
    }
    return map;
  }

}

/// result : [{"id":63,"title":"anuncio 35","description":"Prueba 35","typeClass":"sequence","operation":0,"sizeAds":"standard","ads":[{"id":120,"defaultLogo":1,"lgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","adImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","vimeoUrl":"","pointsAds":"10","timeVisible":"10","pointsAdsuser":[],"questionAds":[{"id":22,"question":"Te gusta la gaseosa?","answersAds":[{"id":50,"answers":"Falso"},{"id":51,"answers":"Verdadero"}],"type":2},{"id":23,"question":"Cual es tu comida favorita?","answersAds":[{"id":52,"answers":""}],"type":1},{"id":24,"question":"Color favorito?","answersAds":[{"id":53,"answers":"Azul"},{"id":54,"answers":"Rojo"},{"id":55,"answers":"Amarillo"}],"type":3}],"formatValue":3}],"timeOperation":[{"id":1017,"hours":{"id":6},"day":{"id":8}}],"campaign":{"id":27}}]
/// courrentPage : 0
/// page : 3

class DataSL {
  List<ResultSL>? _result;
  int? _courrentPage;
  int? _page;

  List<ResultSL>? get result => _result;
  int? get courrentPage => _courrentPage;
  int? get page => _page;

  DataSL({
    List<ResultSL>? result,
    int? courrentPage,
    int? page}){
    _result = result;
    _courrentPage = courrentPage;
    _page = page;
  }

  DataSL.fromJson(dynamic json) {
    if (json["result"] != null) {
      _result = [];
      json["result"].forEach((v) {
        _result?.add(ResultSL.fromJson(v));
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

/// id : 63
/// title : "anuncio 35"
/// description : "Prueba 35"
/// typeClass : "sequence"
/// operation : 0
/// sizeAds : "standard"
/// ads : [{"id":120,"defaultLogo":1,"lgImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","adImages":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","vimeoUrl":"","pointsAds":"10","timeVisible":"10","pointsAdsuser":[],"questionAds":[{"id":22,"question":"Te gusta la gaseosa?","answersAds":[{"id":50,"answers":"Falso"},{"id":51,"answers":"Verdadero"}],"type":2},{"id":23,"question":"Cual es tu comida favorita?","answersAds":[{"id":52,"answers":""}],"type":1},{"id":24,"question":"Color favorito?","answersAds":[{"id":53,"answers":"Azul"},{"id":54,"answers":"Rojo"},{"id":55,"answers":"Amarillo"}],"type":3}],"formatValue":3}]
/// timeOperation : [{"id":1017,"hours":{"id":6},"day":{"id":8}}]
/// campaign : {"id":27}

class ResultSL {
  int? _id;
  String? _title;
  String? _description;
  String? _pointsAdditional;
  String? _typeClass;
  int? _operation;
  String? _sizeAds;
  List<Ads>? _ads;
  List<TimeOperation>? _timeOperation;
  Campaign? _campaign;

  int? get id => _id;
  String? get title => _title;
  String? get description => _description;
  String? get pointsAdditional => _pointsAdditional;
  String? get typeClass => _typeClass;
  int? get operation => _operation;
  String? get sizeAds => _sizeAds;
  List<Ads>? get ads => _ads;
  List<TimeOperation>? get timeOperation => _timeOperation;
  Campaign? get campaign => _campaign;

  ResultSL({
    int? id,
    String? title,
    String? description,
    String? pointsAdditional,
    String? typeClass,
    int? operation,
    String? sizeAds,
    List<Ads>? ads,
    List<TimeOperation>? timeOperation,
    Campaign? campaign}){
    _id = id;
    _title = title;
    _description = description;
    _pointsAdditional = pointsAdditional;
    _typeClass = typeClass;
    _operation = operation;
    _sizeAds = sizeAds;
    _ads = ads;
    _timeOperation = timeOperation;
    _campaign = campaign;
  }

  ResultSL.fromJson(dynamic json) {
    _id = json["id"];
    _title = json["title"];
    _description = json["description"];
    _pointsAdditional = json["pointsAdditional"];
    _typeClass = json["typeClass"];
    _operation = json["operation"];
    _sizeAds = json["sizeAds"];
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
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["title"] = _title;
    map["description"] = _description;
    map["pointsAdditional"] = _pointsAdditional;
    map["typeClass"] = _typeClass;
    map["operation"] = _operation;
    map["sizeAds"] = _sizeAds;
    if (_ads != null) {
      map["ads"] = _ads?.map((v) => v.toJson()).toList();
    }
    if (_timeOperation != null) {
      map["timeOperation"] = _timeOperation?.map((v) => v.toJson()).toList();
    }
    if (_campaign != null) {
      map["campaign"] = _campaign?.toJson();
    }
    return map;
  }

}

/// id : 27

class Campaign {
  int? _id;

  int? get id => _id;

  Campaign({
    int? id}){
    _id = id;
  }

  Campaign.fromJson(dynamic json) {
    _id = json["id"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    return map;
  }

}

/// id : 1017
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

/// id : 120
/// defaultLogo : 1
/// lgImages : "https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png"
/// adImages : "https://dev-kubo.s3-us-west-2.amazonaws.com/gn/ads/https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png"
/// vimeoUrl : ""
/// pointsAds : "10"
/// timeVisible : "10"
/// pointsAdsuser : []
/// questionAds : [{"id":22,"question":"Te gusta la gaseosa?","answersAds":[{"id":50,"answers":"Falso"},{"id":51,"answers":"Verdadero"}],"type":2},{"id":23,"question":"Cual es tu comida favorita?","answersAds":[{"id":52,"answers":""}],"type":1},{"id":24,"question":"Color favorito?","answersAds":[{"id":53,"answers":"Azul"},{"id":54,"answers":"Rojo"},{"id":55,"answers":"Amarillo"}],"type":3}]
/// formatValue : 3

class Ads {
  int? _id;
  int? _defaultLogo;
  String? _lgImages;
  String? _adImages;
  String? _vimeoUrl;
  String? _pointsAds;
  String? _url;
  String? _timeVisible;
  //List<dynamic>? _pointsAdsuser;
  List<QuestionAds>? _questionAds;
  int? _formatValue;

  int? get id => _id;
  int? get defaultLogo => _defaultLogo;
  String? get lgImages => _lgImages;
  String? get adImages => _adImages;
  String? get vimeoUrl => _vimeoUrl;
  String? get pointsAds => _pointsAds;
  String? get url => _url;
  String? get timeVisible => _timeVisible;
  //List<dynamic>? get pointsAdsuser => _pointsAdsuser;
  List<QuestionAds>? get questionAds => _questionAds;
  int? get formatValue => _formatValue;

  Ads({
    int? id,
    int? defaultLogo,
    String? lgImages,
    String? adImages,
    String? vimeoUrl,
    String? pointsAds,
    String? url,
    String? timeVisible,
    List<dynamic>? pointsAdsuser,
    List<QuestionAds>? questionAds,
    int? formatValue}){
    _id = id;
    _defaultLogo = defaultLogo;
    _lgImages = lgImages;
    _adImages = adImages;
    _vimeoUrl = vimeoUrl;
    _pointsAds = pointsAds;
    _url = url;
    _timeVisible = timeVisible;
    //_pointsAdsuser = pointsAdsuser;
    _questionAds = questionAds;
    _formatValue = formatValue;
  }

  Ads.fromJson(dynamic json) {
    _id = json["id"];
    _defaultLogo = json["defaultLogo"];
    _lgImages = json["lgImages"];
    _adImages = json["adImages"];
    _vimeoUrl = json["vimeoUrl"];
    _pointsAds = json["pointsAds"];
    _url = json["url"];
    _timeVisible = json["timeVisible"];
    /*if (json["pointsAdsuser"] != null) {
      _pointsAdsuser = [];
      json["pointsAdsuser"].forEach((v) {
        _pointsAdsuser?.add(dynamic.fromJson(v));
      });
    }*/
    if (json["questionAds"] != null) {
      _questionAds = [];
      json["questionAds"].forEach((v) {
        _questionAds?.add(QuestionAds.fromJson(v));
      });
    }
    _formatValue = json["formatValue"];
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
    map["timeVisible"] = _timeVisible;
    /*if (_pointsAdsuser != null) {
      map["pointsAdsuser"] = _pointsAdsuser?.map((v) => v.toJson()).toList();
    }*/
    if (_questionAds != null) {
      map["questionAds"] = _questionAds?.map((v) => v.toJson()).toList();
    }
    map["formatValue"] = _formatValue;
    return map;
  }

}

/// id : 22
/// question : "Te gusta la gaseosa?"
/// answersAds : [{"id":50,"answers":"Falso"},{"id":51,"answers":"Verdadero"}]
/// type : 2

class QuestionAds {
  int? _id;
  String? _question;
  List<AnswersAds>? _answersAds;
  int? _type;

  int? get id => _id;
  String? get question => _question;
  List<AnswersAds>? get answersAds => _answersAds;
  int? get type => _type;

  QuestionAds({
    int? id,
    String? question,
    List<AnswersAds>? answersAds,
    int? type}){
    _id = id;
    _question = question;
    _answersAds = answersAds;
    _type = type;
  }

  QuestionAds.fromJson(dynamic json) {
    _id = json["id"];
    _question = json["question"];
    if (json["answersAds"] != null) {
      _answersAds = [];
      json["answersAds"].forEach((v) {
        _answersAds?.add(AnswersAds.fromJson(v));
      });
    }
    _type = json["type"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["question"] = _question;
    if (_answersAds != null) {
      map["answersAds"] = _answersAds?.map((v) => v.toJson()).toList();
    }
    map["type"] = _type;
    return map;
  }

}

/// id : 50
/// answers : "Falso"

class AnswersAds {
  int? id;
  String? answers;
  List<Answersuser?>? answersuser  = [];

  AnswersAds({
    this.id,
    this.answers,
    this.answersuser,
  });
  AnswersAds.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json["id"]?.toString() ?? '');
    answers = json["answers"]?.toString();
    if (json["answersuser"] != null && (json["answersuser"] is List)) {
      final v = json["answersuser"];
      final arr0 = <Answersuser>[];
      v.forEach((v) {
        arr0.add(Answersuser.fromJson(v));
      });
      answersuser = arr0;
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["answers"] = answers;
    if (answersuser != null) {
      final v = answersuser;
      final arr0 = [];
      v!.forEach((v) {
        arr0.add(v!.toJson());
      });
      data["answersuser"] = arr0;
    }
    return data;
  }

}


class Answersuser {
/*
{
  "answer": "",
  "check": true
}
*/

  String? answer;
  bool? check;
  String? from = "End";

  Answersuser({
    this.answer,
    this.check,
    this.from,
  });
  Answersuser.fromJson(Map<String, dynamic> json) {
    answer = json["answer"]?.toString();
    check = json["check"];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["answer"] = answer;
    data["check"] = check;
    return data;
  }
}