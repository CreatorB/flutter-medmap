import 'dart:convert';

DistributorResponse distributorResponseFromJson(String str) =>
    DistributorResponse.fromJson(json.decode(str));

String distributorResponseToJson(DistributorResponse data) =>
    json.encode(data.toJson());

class DistributorResponse {
  Meta? meta;
  List<Datum>? data;

  DistributorResponse({
    this.meta,
    this.data,
  });

  factory DistributorResponse.fromJson(Map<String, dynamic> json) =>
      DistributorResponse(
        meta: json["meta"] == null ? null : Meta.fromJson(json["meta"]),
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "meta": meta?.toJson(),
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  int? id;
  String? name;
  String? slug;
  String? address;
  String? website;
  String? overview;
  String? about;
  int? userId;
  String? contactName;
  String? contactEmail;
  String? contactMobile;
  String? contactUrl;
  DateTime? createdAt;
  DateTime? updatedAt;
  User? user;
  Logo? logo;
  List<DistributorCategoryTag>? distributorCategoryTags;
  Country? country;
  Logo? profileFile;

  Datum({
    this.id,
    this.name,
    this.slug,
    this.address,
    this.website,
    this.overview,
    this.about,
    this.userId,
    this.contactName,
    this.contactEmail,
    this.contactMobile,
    this.contactUrl,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.logo,
    this.distributorCategoryTags,
    this.country,
    this.profileFile,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        slug: json["slug"],
        address: json["address"],
        website: json["website"],
        overview: json["overview"],
        about: json["about"],
        userId: json["user_id"],
        contactName: json["contact_name"],
        contactEmail: json["contact_email"],
        contactMobile: json["contact_mobile"],
        contactUrl: json["contact_url"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        logo: json["logo"] == null ? null : Logo.fromJson(json["logo"]),
        distributorCategoryTags: json["distributor_category_tags"] == null
            ? []
            : List<DistributorCategoryTag>.from(
                json["distributor_category_tags"]!
                    .map((x) => DistributorCategoryTag.fromJson(x))),
        country:
            json["country"] == null ? null : Country.fromJson(json["country"]),
        profileFile: json["profile_file"] == null
            ? null
            : Logo.fromJson(json["profile_file"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "slug": slug,
        "address": address,
        "website": website,
        "overview": overview,
        "about": about,
        "user_id": userId,
        "contact_name": contactName,
        "contact_email": contactEmail,
        "contact_mobile": contactMobile,
        "contact_url": contactUrl,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "user": user?.toJson(),
        "logo": logo?.toJson(),
        "distributor_category_tags": distributorCategoryTags == null
            ? []
            : List<dynamic>.from(
                distributorCategoryTags!.map((x) => x.toJson())),
        "country": country?.toJson(),
        "profile_file": profileFile?.toJson(),
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

class DistributorCategoryTag {
  int? id;
  String? name;
  DateTime? createdAt;
  DateTime? updatedAt;

  DistributorCategoryTag({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  factory DistributorCategoryTag.fromJson(Map<String, dynamic> json) =>
      DistributorCategoryTag(
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

class Logo {
  int? id;
  Extname? extname;
  Type? type;
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

  factory Logo.fromJson(Map<String, dynamic> json) => Logo(
        id: json["id"],
        extname: extnameValues.map[json["extname"]]!,
        type: typeValues.map[json["type"]]!,
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
        "extname": extnameValues.reverse[extname],
        "type": typeValues.reverse[type],
        "path": path,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "url": url,
      };
}

enum Extname { PDF, PNG, WEBP }

final extnameValues =
    EnumValues({"pdf": Extname.PDF, "png": Extname.PNG, "webp": Extname.WEBP});

enum Type { APPLICATION, IMAGE }

final typeValues =
    EnumValues({"application": Type.APPLICATION, "image": Type.IMAGE});

class User {
  int? id;
  int? creatorId;
  String? email;
  String? username;
  dynamic description;
  bool? isVerified;
  Role? role;
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

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        creatorId: json["creator_id"],
        email: json["email"],
        username: json["username"],
        description: json["description"],
        isVerified: json["is_verified"],
        role: roleValues.map[json["role"]]!,
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
        "role": roleValues.reverse[role],
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

enum Role { DISTRIBUTOR }

final roleValues = EnumValues({"distributor": Role.DISTRIBUTOR});

class Meta {
  int? total;
  int? perPage;
  int? currentPage;
  int? lastPage;
  int? firstPage;
  String? firstPageUrl;
  String? lastPageUrl;
  String? nextPageUrl;
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

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
