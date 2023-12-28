class TenderResponse {
  final Meta meta;
  final List<TenderData> data;

  TenderResponse({required this.meta, required this.data});

  factory TenderResponse.fromJson(Map<String, dynamic> json) {
    return TenderResponse(
      meta: Meta.fromJson(json['meta']),
      data: List<TenderData>.from(
          json['data'].map((x) => TenderData.fromJson(x))),
    );
  }
}

class Meta {
  final int total;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final int firstPage;
  final String firstPageUrl;
  final String lastPageUrl;
  final String? nextPageUrl;
  final String? previousPageUrl;

  Meta({
    required this.total,
    required this.perPage,
    required this.currentPage,
    required this.lastPage,
    required this.firstPage,
    required this.firstPageUrl,
    required this.lastPageUrl,
    this.nextPageUrl,
    this.previousPageUrl,
  });

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      total: json['total'],
      perPage: json['per_page'],
      currentPage: json['current_page'],
      lastPage: json['last_page'],
      firstPage: json['first_page'],
      firstPageUrl: json['first_page_url'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      previousPageUrl: json['previous_page_url'],
    );
  }
}

class TenderData {
  final int id;
  final String refNo;
  final String title;
  final String authority;
  final String brief;
  final String detail;
  final DateTime openDate;
  final DateTime closeDate;
  final DateTime? awardedDate;
  final int healthcareId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int typeId;
  final dynamic tenderAward;
  final ProductCategory productCategory;
  final TenderType tenderType;
  final dynamic tenderValue;
  final dynamic attachment;
  final dynamic emd;
  final dynamic documentFee;
  final List<Tag> tags;
  final Healthcare healthcare;
  final StateInfo state;

  TenderData({
    required this.id,
    required this.refNo,
    required this.title,
    required this.authority,
    required this.brief,
    required this.detail,
    required this.openDate,
    required this.closeDate,
    this.awardedDate,
    required this.healthcareId,
    required this.createdAt,
    required this.updatedAt,
    required this.typeId,
    this.tenderAward,
    required this.productCategory,
    required this.tenderType,
    this.tenderValue,
    this.attachment,
    this.emd,
    this.documentFee,
    required this.tags,
    required this.healthcare,
    required this.state,
  });

  factory TenderData.fromJson(Map<String, dynamic> json) {
    return TenderData(
      id: json['id'],
      refNo: json['ref_no'],
      title: json['title'],
      authority: json['authority'],
      brief: json['brief'],
      detail: json['detail'],
      openDate: DateTime.parse(json['open_date']),
      closeDate: DateTime.parse(json['close_date']),
      awardedDate: json['awarded_date'] != null
          ? DateTime.parse(json['awarded_date'])
          : null,
      healthcareId: json['healthcare_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      typeId: json['type_id'],
      tenderAward: json['tender_award'],
      productCategory: ProductCategory.fromJson(json['product_category']),
      tenderType: TenderType.fromJson(json['tender_type']),
      tenderValue: json['tender_value'],
      attachment: json['attachment'],
      emd: json['emd'],
      documentFee: json['document_fee'],
      tags: List<Tag>.from(json['tags'].map((x) => Tag.fromJson(x))),
      healthcare: Healthcare.fromJson(json['healthcare']),
      state: StateInfo.fromJson(json['state']),
    );
  }
}

class ProductCategory {
  final int id;
  final String name;
  final dynamic description;
  final dynamic categoryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductCategory({
    required this.id,
    required this.name,
    this.description,
    this.categoryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      categoryId: json['category_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class TenderType {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  TenderType({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TenderType.fromJson(Map<String, dynamic> json) {
    return TenderType(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Tag {
  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  Tag({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'],
      name: json['name'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Healthcare {
  final int id;
  final dynamic name;
  final dynamic description;
  final dynamic countryId;
  final dynamic address;
  final int userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final dynamic typeId;
  final dynamic logo;
  final dynamic type;

  Healthcare({
    required this.id,
    this.name,
    this.description,
    this.countryId,
    this.address,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    this.typeId,
    this.logo,
    this.type,
  });

  factory Healthcare.fromJson(Map<String, dynamic> json) {
    return Healthcare(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      countryId: json['country_id'],
      address: json['address'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      typeId: json['type_id'],
      logo: json['logo'],
      type: json['type'],
    );
  }
}

class StateInfo {
  final int id;
  final String name;
  final String stateCode;
  final int countryId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Country country;

  StateInfo({
    required this.id,
    required this.name,
    required this.stateCode,
    required this.countryId,
    required this.createdAt,
    required this.updatedAt,
    required this.country,
  });

  factory StateInfo.fromJson(Map<String, dynamic> json) {
    return StateInfo(
      id: json['id'],
      name: json['name'],
      stateCode: json['state_code'],
      countryId: json['country_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      country: Country.fromJson(json['country']),
    );
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
}
