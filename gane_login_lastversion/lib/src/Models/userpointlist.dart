/// code : 100
/// message : ""
/// status : true
/// data : {"result":[{"id":"24","points":"100","options":{"createdAt":"2021-11-12T18:06:53.355Z"},"category":"","ads":"","sequenceAds":"177","color":"","title":"Bono adicional por completar la secuencia Secuencia prueba 2.","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5e3b196f81fd7e3318d614faf7018031ab7f1762-1636508789582.png"},{"id":"23","points":"10","options":{"createdAt":"2021-11-12T18:06:53.260Z"},"category":"","ads":"207","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5e3b196f81fd7e3318d614faf7018031ab7f1762-1636508789582.png","title":"Visualizaste el anuncio de la secuencia Secuencia prueba 2."},{"id":"15","points":"10","options":{"createdAt":"2021-11-12T15:10:58.905Z"},"category":"","ads":"152","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/886eec41da56a77a1f6bafcc65ff58e1c8f43614-1634698276914.jpg","title":"Visualizaste el anuncio de la secuencia Prueba sequece ."},{"id":"14","points":"300","options":{"createdAt":"2021-11-12T15:10:52.467Z"},"category":"","ads":"","sequenceAds":"79","color":"","title":"Bono adicional por completar la secuencia prueba encuesta detalle.","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/06086b46e6c964cb7da3ac12595b4d09e60905ad-1632516864200.png"},{"id":"13","points":"200","options":{"createdAt":"2021-11-12T15:10:44.292Z"},"category":"","ads":"103","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/7673bcaaefde9451dd11e50534ad2aaf79c0ee5d-1632241034222.png","title":"Visualizaste el anuncio de la secuencia Secuencia prueba 2."},{"id":"12","points":"10","options":{"createdAt":"2021-11-12T15:10:34.365Z"},"category":"","ads":"126","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/16f2c886b5fd6ad32336571f035e80c630cd6f2f-1632844628525.png","title":"Visualizaste el anuncio de la secuencia esta es una nueva secuencia."},{"id":"11","points":"10","options":{"createdAt":"2021-11-12T15:10:27.112Z"},"category":"","ads":"127","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/9d48515e24c797cf534906f15b10acac98ba9383-1632932519929.png","title":"Visualizaste el anuncio de la secuencia esta es una nueva secuencia."},{"id":"10","points":"10","options":{"createdAt":"2021-11-12T15:10:11.361Z"},"category":"","ads":"163","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/4e457b00565b4245e46eafea091a67eed0e2c665-1634827021965.png","title":"Visualizaste el anuncio de la secuencia koas."},{"id":"7","points":"100","options":{"createdAt":"2021-11-12T03:36:11.055Z"},"category":"","ads":"","sequenceAds":"79","color":"","title":"Bono adicional por completar la secuencia prueba encuesta detalle.","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/06086b46e6c964cb7da3ac12595b4d09e60905ad-1632516864200.png"},{"id":"6","points":"10","options":{"createdAt":"2021-11-12T03:31:37.632Z"},"category":"","ads":"129","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","title":"Visualizaste el anuncio de la secuencia prueba encuesta detalle."}],"page":2}

class Userpointlist {
  int? _code;
  String? _message;
  bool? _status;
  DataLUP? _data;

  int? get code => _code;
  String? get message => _message;
  bool? get status => _status;
  DataLUP? get data => _data;

  Userpointlist({
      int? code, 
      String? message, 
      bool? status,
    DataLUP? data}){
    _code = code;
    _message = message;
    _status = status;
    _data = data;
}

  Userpointlist.fromJson(dynamic json) {
    _code = json["code"];
    _message = json["message"];
    _status = json["status"];
    _data = json["data"] != null ? DataLUP.fromJson(json["data"]) : null;
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

/// result : [{"id":"24","points":"100","options":{"createdAt":"2021-11-12T18:06:53.355Z"},"category":"","ads":"","sequenceAds":"177","color":"","title":"Bono adicional por completar la secuencia Secuencia prueba 2.","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5e3b196f81fd7e3318d614faf7018031ab7f1762-1636508789582.png"},{"id":"23","points":"10","options":{"createdAt":"2021-11-12T18:06:53.260Z"},"category":"","ads":"207","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5e3b196f81fd7e3318d614faf7018031ab7f1762-1636508789582.png","title":"Visualizaste el anuncio de la secuencia Secuencia prueba 2."},{"id":"15","points":"10","options":{"createdAt":"2021-11-12T15:10:58.905Z"},"category":"","ads":"152","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/886eec41da56a77a1f6bafcc65ff58e1c8f43614-1634698276914.jpg","title":"Visualizaste el anuncio de la secuencia Prueba sequece ."},{"id":"14","points":"300","options":{"createdAt":"2021-11-12T15:10:52.467Z"},"category":"","ads":"","sequenceAds":"79","color":"","title":"Bono adicional por completar la secuencia prueba encuesta detalle.","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/06086b46e6c964cb7da3ac12595b4d09e60905ad-1632516864200.png"},{"id":"13","points":"200","options":{"createdAt":"2021-11-12T15:10:44.292Z"},"category":"","ads":"103","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/7673bcaaefde9451dd11e50534ad2aaf79c0ee5d-1632241034222.png","title":"Visualizaste el anuncio de la secuencia Secuencia prueba 2."},{"id":"12","points":"10","options":{"createdAt":"2021-11-12T15:10:34.365Z"},"category":"","ads":"126","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/16f2c886b5fd6ad32336571f035e80c630cd6f2f-1632844628525.png","title":"Visualizaste el anuncio de la secuencia esta es una nueva secuencia."},{"id":"11","points":"10","options":{"createdAt":"2021-11-12T15:10:27.112Z"},"category":"","ads":"127","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/9d48515e24c797cf534906f15b10acac98ba9383-1632932519929.png","title":"Visualizaste el anuncio de la secuencia esta es una nueva secuencia."},{"id":"10","points":"10","options":{"createdAt":"2021-11-12T15:10:11.361Z"},"category":"","ads":"163","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/4e457b00565b4245e46eafea091a67eed0e2c665-1634827021965.png","title":"Visualizaste el anuncio de la secuencia koas."},{"id":"7","points":"100","options":{"createdAt":"2021-11-12T03:36:11.055Z"},"category":"","ads":"","sequenceAds":"79","color":"","title":"Bono adicional por completar la secuencia prueba encuesta detalle.","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/06086b46e6c964cb7da3ac12595b4d09e60905ad-1632516864200.png"},{"id":"6","points":"10","options":{"createdAt":"2021-11-12T03:31:37.632Z"},"category":"","ads":"129","sequenceAds":"","color":"","images":"https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5cb11dce0881031383761bb0101d236043e60cd7-1632256527798.png","title":"Visualizaste el anuncio de la secuencia prueba encuesta detalle."}]
/// page : 2

class DataLUP {
  List<ResultLUP>? _result;
  int? _page;

  List<ResultLUP>? get result => _result;
  int? get page => _page;

  DataLUP({
      List<ResultLUP>? result,
      int? page}){
    _result = result;
    _page = page;
}

  DataLUP.fromJson(dynamic json) {
    if (json["result"] != null) {
      _result = [];
      json["result"].forEach((v) {
        _result?.add(ResultLUP.fromJson(v));
      });
    }
    _page = json["page"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    if (_result != null) {
      map["result"] = _result?.map((v) => v.toJson()).toList();
    }
    map["page"] = _page;
    return map;
  }

}

/// id : "24"
/// points : "100"
/// options : {"createdAt":"2021-11-12T18:06:53.355Z"}
/// category : ""
/// ads : ""
/// sequenceAds : "177"
/// color : ""
/// title : "Bono adicional por completar la secuencia Secuencia prueba 2."
/// images : "https://dev-kubo.s3-us-west-2.amazonaws.com/gn/adverts/5e3b196f81fd7e3318d614faf7018031ab7f1762-1636508789582.png"

class ResultLUP {
  String? _id;
  String? _points;
  Options? _options;
  String? _category;
  String? _ads;
  String? _sequenceAds;
  String? _color;
  String? _title;
  String? _images;

  String? get id => _id;
  String? get points => _points;
  Options? get options => _options;
  String? get category => _category;
  String? get ads => _ads;
  String? get sequenceAds => _sequenceAds;
  String? get color => _color;
  String? get title => _title;
  String? get images => _images;

  ResultLUP({
      String? id, 
      String? points, 
      Options? options, 
      String? category, 
      String? ads, 
      String? sequenceAds, 
      String? color, 
      String? title, 
      String? images}){
    _id = id;
    _points = points;
    _options = options;
    _category = category;
    _ads = ads;
    _sequenceAds = sequenceAds;
    _color = color;
    _title = title;
    _images = images;
}

  ResultLUP.fromJson(dynamic json) {
    _id = json["id"];
    _points = json["points"];
    _options = json["options"] != null ? Options.fromJson(json["options"]) : null;
    _category = json["category"];
    _ads = json["ads"];
    _sequenceAds = json["sequenceAds"];
    _color = json["color"];
    _title = json["title"];
    _images = json["images"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["id"] = _id;
    map["points"] = _points;
    if (_options != null) {
      map["options"] = _options?.toJson();
    }
    map["category"] = _category;
    map["ads"] = _ads;
    map["sequenceAds"] = _sequenceAds;
    map["color"] = _color;
    map["title"] = _title;
    map["images"] = _images;
    return map;
  }

}

/// createdAt : "2021-11-12T18:06:53.355Z"

class Options {
  String? _createdAt;

  String? get createdAt => _createdAt;

  Options({
      String? createdAt}){
    _createdAt = createdAt;
}

  Options.fromJson(dynamic json) {
    _createdAt = json["createdAt"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["createdAt"] = _createdAt;
    return map;
  }

}