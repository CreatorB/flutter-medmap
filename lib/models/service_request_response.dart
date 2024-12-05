class ServiceRequestResponse {
  Meta? meta;
  List<Data>? data;

  ServiceRequestResponse({this.meta, this.data});

  ServiceRequestResponse.fromJson(Map<String, dynamic> json) {
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Meta {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  int? firstPage;
  String? firstPageUrl;
  String? lastPageUrl;
  String? nextPageUrl;
  String? previousPageUrl;

  Meta(
      {this.total,
      this.perPage,
      this.currentPage,
      this.lastPage,
      this.firstPage,
      this.firstPageUrl,
      this.lastPageUrl,
      this.nextPageUrl,
      this.previousPageUrl});

  Meta.fromJson(Map<String, dynamic> json) {
    total = json['total'] ?? 0;
    perPage = json['per_page'] ?? 0;
    currentPage = json['current_page'] ?? 0;
    lastPage = json['last_page'] ?? 0;
    firstPage = json['first_page'] ?? 0;
    firstPageUrl = json['first_page_url'] ?? '';
    lastPageUrl = json['last_page_url'] ?? '';
    nextPageUrl = json['next_page_url'] ?? '';
    previousPageUrl = json['previous_page_url'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this.total;
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    data['first_page'] = this.firstPage;
    data['first_page_url'] = this.firstPageUrl;
    data['last_page_url'] = this.lastPageUrl;
    data['next_page_url'] = this.nextPageUrl;
    data['previous_page_url'] = this.previousPageUrl;
    return data;
  }
}

class Data {
  int? id;
  String? title;
  String? description;
  String? currency;
  int? budget;
  String? priceType;
  String? createdAt;
  String? updatedAt;
  Image? image;
  Submitter? submitter;

  Data(
      {this.id,
      this.title,
      this.description,
      this.currency,
      this.budget,
      this.priceType,
      this.createdAt,
      this.updatedAt,
      this.image,
      this.submitter});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    currency = json['currency'];
    budget = json['budget'];
    priceType = json['price_type'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    image = json['image'] != null ? new Image.fromJson(json['image']) : null;
    submitter = json['submitter'] != null
        ? new Submitter.fromJson(json['submitter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    data['currency'] = this.currency;
    data['budget'] = this.budget;
    data['price_type'] = this.priceType;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.image != null) {
      data['image'] = this.image!.toJson();
    }
    if (this.submitter != null) {
      data['submitter'] = this.submitter!.toJson();
    }
    return data;
  }
}

class Image {
  int? id;
  String? extname;
  String? type;
  String? path;
  String? createdAt;
  String? updatedAt;
  String? url;

  Image(
      {this.id,
      this.extname,
      this.type,
      this.path,
      this.createdAt,
      this.updatedAt,
      this.url});

  Image.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? 0;
    extname = json['extname'] ?? 0;
    type = json['type'] ?? 0;
    path = json['path'] ?? 0;
    createdAt = json['created_at'] ?? '';
    updatedAt = json['updated_at'] ?? '';
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

class Submitter {
  int? id;
  int? creatorId;
  String? email;
  String? username;
  Null description;
  bool? isVerified;
  String? role;
  String? createdAt;
  String? updatedAt;

  Submitter(
      {this.id,
      this.creatorId,
      this.email,
      this.username,
      this.description,
      this.isVerified,
      this.role,
      this.createdAt,
      this.updatedAt});

  Submitter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    creatorId = json['creator_id'];
    email = json['email'];
    username = json['username'];
    description = json['description'];
    isVerified = json['is_verified'];
    role = json['role'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['creator_id'] = this.creatorId;
    data['email'] = this.email;
    data['username'] = this.username;
    data['description'] = this.description;
    data['is_verified'] = this.isVerified;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
