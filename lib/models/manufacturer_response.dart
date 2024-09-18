import 'dart:convert';

class ManufacturerResponse {
  Meta meta;
  List<ManufacturerData> data;

  ManufacturerResponse({
    required this.meta,
    required this.data,
  });

  factory ManufacturerResponse.fromRawJson(String str) =>
      ManufacturerResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ManufacturerResponse.fromJson(Map<String, dynamic> json) =>
      ManufacturerResponse(
        meta: Meta.fromJson(json["meta"]),
        data: List<ManufacturerData>.from(
            json["data"].map((x) => ManufacturerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ManufacturerData {
  int id;
  String? name;
  String? picName;
  String? description;
  String? address;
  String? website;
  String? video;
  String? about;
  int? userId;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Logo? logo;
  IndustryCategory? industryCategory;
  Country? country;
  Logo? profileFile;

  ManufacturerData({
    required this.id,
    this.name,
    this.picName,
    this.description,
    this.address,
    this.website,
    this.video,
    this.about,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.logo,
    this.industryCategory,
    this.country,
    this.profileFile,
  });

  factory ManufacturerData.fromRawJson(String str) =>
      ManufacturerData.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ManufacturerData.fromJson(Map<String, dynamic> json) =>
      ManufacturerData(
        id: json["id"],
        name: json["name"],
        picName: json["pic_name"],
        description: json["description"],
        address: json["address"],
        website: json["website"],
        video: json["video"],
        about: json["about"],
        userId: json["user_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        logo: json["logo"] == null ? null : Logo.fromJson(json["logo"]),
        industryCategory: json["industry_category"] == null
            ? null
            : IndustryCategory.fromJson(json["industry_category"]),
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
        profileFile: json["profile_file"] == null
            ? null
            : Logo.fromJson(json["profile_file"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pic_name": picName,
        "description": description,
        "address": address,
        "website": website,
        "video": video,
        "about": about,
        "user_id": userId,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "logo": logo?.toJson(),
        "industry_category": industryCategory?.toJson(),
        "country": country?.toJson(),
        "profile_file": profileFile?.toJson(),
      };
}

class IndustryCategory {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  IndustryCategory({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory IndustryCategory.fromRawJson(String str) =>
      IndustryCategory.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory IndustryCategory.fromJson(Map<String, dynamic> json) =>
      IndustryCategory(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Country {
  int? id;
  String? name;
  String? iso;
  String? phoneCode;
  DateTime? createdAt;
  DateTime? updatedAt;

  Country({
    this.id,
    this.name,
    this.iso,
    this.phoneCode,
    this.createdAt,
    this.updatedAt,
  });

  factory Country.fromRawJson(String str) => Country.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        id: json["id"],
        name: json["name"],
        iso: json["iso"],
        phoneCode: json["phone_code"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "iso": iso,
        "phone_code": phoneCode,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Logo {
  int? id;
  String? extname;
  String? type;
  String? path;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? url;

  Logo({
    this.id,
    this.extname,
    this.type,
    this.path,
    this.createdAt,
    this.updatedAt,
    this.url,
  });

  factory Logo.fromRawJson(String str) => Logo.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
        id: json["id"],
        extname: json["extname"],
        type: json["type"],
        path: json["path"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "extname": extname,
        "type": type,
        "path": path,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "url": url,
      };
}

class User {
  int? id;
  int? creatorId;
  String? email;
  String? username;
  dynamic description;
  bool? isVerified;
  String? role;
  DateTime? createdAt;
  DateTime? updatedAt;

  User({
    this.id,
    this.creatorId,
    this.email,
    this.username,
    this.description,
    this.isVerified,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromRawJson(String str) => User.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        creatorId: json["creator_id"],
        email: json["email"],
        username: json["username"],
        description: json["description"],
        isVerified: json["is_verified"],
        role: json["role"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "creator_id": creatorId,
        "email": email,
        "username": username,
        "description": description,
        "is_verified": isVerified,
        "role": role,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Meta {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  int? firstPage;
  String? firstPageUrl;
  String? lastPageUrl;
  dynamic nextPageUrl;
  dynamic previousPageUrl;

  Meta({
    this.total,
    this.perPage,
    this.currentPage,
    this.lastPage,
    this.firstPage,
    this.firstPageUrl,
    this.lastPageUrl,
    this.nextPageUrl,
    this.previousPageUrl,
  });

  factory Meta.fromRawJson(String str) => Meta.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Meta.fromJson(Map<String, dynamic> json) => Meta(
        total: json["total"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        lastPage: json["last_page"],
        firstPage: json["first_page"],
        firstPageUrl: json["first_page_url"],
        lastPageUrl: json["last_page_url"],
        nextPageUrl: json["next_page_url"],
        previousPageUrl: json["previous_page_url"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "per_page": perPage,
        "current_page": currentPage,
        "last_page": lastPage,
        "first_page": firstPage,
        "first_page_url": firstPageUrl,
        "last_page_url": lastPageUrl,
        "next_page_url": nextPageUrl,
        "previous_page_url": previousPageUrl,
      };
}