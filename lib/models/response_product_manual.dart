class ResponseProductManual {
  int? id;
  String? createdAt;
  String? updatedAt;
  File? file;

  ResponseProductManual({this.id, this.createdAt, this.updatedAt, this.file});

  ResponseProductManual.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    file = json['file'] != null ? new File.fromJson(json['file']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.file != null) {
      data['file'] = this.file!.toJson();
    }
    return data;
  }
}

class File {
  int? id;
  String? extname;
  String? type;
  String? path;
  String? createdAt;
  String? updatedAt;
  String? url;

  File(
      {this.id,
      this.extname,
      this.type,
      this.path,
      this.createdAt,
      this.updatedAt,
      this.url});

  File.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    extname = json['extname'];
    type = json['type'];
    path = json['path'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['extname'] = this.extname;
    data['type'] = this.type;
    data['path'] = this.path;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['url'] = this.url;
    return data;
  }
}
