class SiteModel {
  String? quality;
  String? link;

  SiteModel({this.quality, this.link});

  SiteModel.fromJson(Map<String, dynamic> json) {
    quality = json['quality'];
    link = json['link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['quality'] = this.quality;
    data['link'] = this.link;
    return data;
  }
}