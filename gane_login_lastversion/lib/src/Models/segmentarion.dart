class SegmentationCustom {
  int? code;
  String? message;
  bool? status;
  DataSegmentationCustom? data;

  SegmentationCustom({this.code, this.message, this.status, this.data});

  SegmentationCustom.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new DataSegmentationCustom.fromJson(json['data']) : null;
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

class DataSegmentationCustom {
  Styles? styles;

  DataSegmentationCustom({this.styles});

  DataSegmentationCustom.fromJson(Map<String, dynamic> json) {
    styles =
    json['styles'] != null ? new Styles.fromJson(json['styles']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.styles != null) {
      data['styles'] = this.styles!.toJson();
    }
    return data;
  }
}

class Styles {
  int? id;
  String? splash;
  String? logoHeader;
  String? colorHeader;
  Options? options;
  Segmentation? segmentation;

  Styles(
      {this.id,
        this.splash,
        this.logoHeader,
        this.colorHeader,
        this.options,
        this.segmentation});

  Styles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    splash = json['splash'];
    logoHeader = json['logoHeader'];
    colorHeader = json['colorHeader'];
    options =
    json['options'] != null ? new Options.fromJson(json['options']) : null;
    segmentation = json['segmentation'] != null
        ? new Segmentation.fromJson(json['segmentation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['splash'] = this.splash;
    data['logoHeader'] = this.logoHeader;
    data['colorHeader'] = this.colorHeader;
    if (this.options != null) {
      data['options'] = this.options!.toJson();
    }
    if (this.segmentation != null) {
      data['segmentation'] = this.segmentation!.toJson();
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

class Segmentation {
  int? dayExchange;

  Segmentation({this.dayExchange});

  Segmentation.fromJson(Map<String, dynamic> json) {
    dayExchange = json['dayExchange'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['dayExchange'] = this.dayExchange;
    return data;
  }
}