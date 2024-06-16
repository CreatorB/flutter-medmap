import 'dart:convert';

class rProfile {
  final int id;
  final String? name;
  final String? picName;
  final String? description;
  final String? address;
  final String? website;
  final String? video;
  final String? about;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final Logo? logo;
  final Type? type;
  final IndustryCategory? industryCategory;
  final Country? country;
  final ProfileFile? profileFile;
  final Category? categoryOne;
  final Category? categoryTwo;
  final Category? categoryOneService;
  final Category? categoryTwoService;

  rProfile({
    required this.id,
    this.name,
    this.picName,
    this.description,
    this.address,
    this.website,
    this.video,
    this.about,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    this.logo,
    this.type,
    this.industryCategory,
    this.country,
    this.profileFile,
    this.categoryOne,
    this.categoryTwo,
    this.categoryOneService,
    this.categoryTwoService,
  });

  factory rProfile.fromJson(Map<String, dynamic> json) {
    return rProfile(
      id: json['id'],
      name: json['name'],
      picName: json['pic_name'],
      description: json['description'],
      address: json['address'],
      website: json['website'],
      video: json['video'],
      about: json['about'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: User.fromJson(json['user']),
      logo: json['logo'] != null ? Logo.fromJson(json['logo']) : null,
      type: json['type'] != null ? Type.fromJson(json['type']) : null,
      industryCategory: json['industry_category'] != null ? IndustryCategory.fromJson(json['industry_category']) : null,
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
      profileFile: json['profile_file'] != null ? ProfileFile.fromJson(json['profile_file']) : null,
      categoryOne: json['category_one'] != null ? Category.fromJson(json['category_one']) : null,
      categoryTwo: json['category_two'] != null ? Category.fromJson(json['category_two']) : null,
      categoryOneService: json['category_one_service'] != null ? Category.fromJson(json['category_one_service']) : null,
      categoryTwoService: json['category_two_service'] != null ? Category.fromJson(json['category_two_service']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'pic_name': picName,
      'description': description,
      'address': address,
      'website': website,
      'video': video,
      'about': about,
      'user_id': userId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
      'logo': logo?.toJson(),
      'type': type?.toJson(),
      'industry_category': industryCategory?.toJson(),
      'country': country?.toJson(),
      'profile_file': profileFile?.toJson(),
      'category_one': categoryOne?.toJson(),
      'category_two': categoryTwo?.toJson(),
      'category_one_service': categoryOneService?.toJson(),
      'category_two_service': categoryTwoService?.toJson(),
    };
  }
}

class Logo {
  final int id;
  final String extname;
  final String type;
  final String path;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String url;

  Logo({
    required this.id,
    required this.extname,
    required this.type,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
    required this.url,
  });

  factory Logo.fromJson(Map<String, dynamic> json) {
    return Logo(
      id: json['id'],
      extname: json['extname'],
      type: json['type'],
      path: json['path'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'extname': extname,
      'type': type,
      'path': path,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'url': url,
    };
  }
}

class IndustryCategory{
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  IndustryCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IndustryCategory.fromJson(Map<String, dynamic> json) {
    return IndustryCategory(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Country {
  final int id;
  final String name;
  final String iso;
  final String phoneCode;
  final DateTime createdAt;
  final DateTime updatedAt;

  Country({
    required this.id,
    required this.name,
    required this.iso,
    required this.phoneCode,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
      iso: json['iso'],
      phoneCode: json['phone_code'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'iso': iso,
      'phone_code': phoneCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class ProfileFile {
  final int id;
  final String extname;
  final String type;
  final String path;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String url;

  ProfileFile({
    required this.id,
    required this.extname,
    required this.type,
    required this.path,
    required this.createdAt,
    required this.updatedAt,
    required this.url,
  });

  factory ProfileFile.fromJson(Map<String, dynamic> json) {
    return ProfileFile(
      id: json['id'],
      extname: json['extname'],
      type: json['type'],
      path: json['path'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'extname': extname,
      'type': type,
      'path': path,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'url': url,
    };
  }
}

class Category {
  final int id;
  final String name;
  final String? description;
  final int? categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Category({
    required this.id,
    required this.name,
    this.description,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryId: json['category_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category_id': categoryId,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class User {
  final int id;
  final int? creatorId;
  final String email;
  final String username;
  final String? description;
  final bool isVerified;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    this.creatorId,
    required this.email,
    required this.username,
    this.description,
    required this.isVerified,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      creatorId: json['creator_id'] ?? null,
      email: json['email'],
      username: json['username'],
      description: json['description'],
      isVerified: json['is_verified'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_id': creatorId,
      'email': email,
      'username': username,
      'description': description,
      'is_verified': isVerified,
      'role': role,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Type {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Type({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Type.fromJson(Map<String, dynamic> json) {
    return Type(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
