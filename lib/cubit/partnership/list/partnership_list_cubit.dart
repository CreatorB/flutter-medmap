import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import 'package:medmap/const.dart';
import 'package:medmap/route/app_routes.dart';
import 'package:medmap/utils.dart';
import 'package:omega_dio_logger/omega_dio_logger.dart';

part 'partnership_list_state.dart';

class PartnershipListCubit extends Cubit<PartnershipListState> {
  PartnershipListCubit() : super(PartnershipListStateInitial());

  Future<void> fetchPartnershipLists(BuildContext context) async {
    emit(PartnershipListStateLoading());
    try {
      final token = await Utils.getSpString(Const.TOKEN);
      final dio = Dio();
      dio.interceptors.add(const OmegaDioLogger());
      dio.options.headers["Authorization"] = "Bearer $token";

      final response = await dio.get(
        Const.API_PARTNERSHIP_LIST,
        options: Options(validateStatus: (status) => true),
      );

      print("cekPartnershipList: ${response.data}");

      if (response.statusCode == 200) {
        final data = response.data;
        final requests = (data['data'] as List)
            .map((e) => PartnershipListModel.fromJson(e))
            .toList();
        emit(PartnershipListStateLoaded(requests));
      } else if (response.statusCode == 401) {
        Fluttertoast.showToast(
          msg: "Session Expired, Please Login Again",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        await Utils.clearSp();
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.dashboard,
              (route) => false,
        );
      } else {
        emit(PartnershipListStateError('Failed to load partnership requests'));
      }
    } catch (e) {
      emit(PartnershipListStateError(e.toString()));
    }
  }
}

class PartnershipListModel {
  final int id;
  final String email;
  final String companyName;
  final String firstName;
  final String lastName;
  final String totalEmployee;
  final String phone;
  final String zipCode;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Product product;
  final Country country;
  final State state;
  final Manufacturer manufacturer;

  PartnershipListModel({
    required this.id,
    required this.email,
    required this.companyName,
    required this.firstName,
    required this.lastName,
    required this.totalEmployee,
    required this.phone,
    required this.zipCode,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
    required this.country,
    required this.state,
    required this.manufacturer,
  });

  factory PartnershipListModel.fromJson(Map<String, dynamic> json) {
    return PartnershipListModel(
      id: json['id'],
      email: json['email'],
      companyName: json['company_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      totalEmployee: json['total_employee'],
      phone: json['phone'],
      zipCode: json['zip_code'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      product: Product.fromJson(json['product']),
      country: Country.fromJson(json['country']),
      state: State.fromJson(json['state']),
      manufacturer: Manufacturer.fromJson(json['manufacturer']),
    );
  }
}

class Product {
  final int id;
  final String name;
  final String slug;
  final String description;
  final bool isPublished;
  final DateTime createdAt;
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.isPublished,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      slug: json['slug'],
      description: json['description'],
      isPublished: json['is_published'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
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

class State {
  final int id;
  final String name;
  final String stateCode;
  final int countryId;
  final DateTime createdAt;
  final DateTime updatedAt;

  State({
    required this.id,
    required this.name,
    required this.stateCode,
    required this.countryId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['id'],
      name: json['name'],
      stateCode: json['state_code'],
      countryId: json['country_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Manufacturer {
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

  Manufacturer({
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
  });

  factory Manufacturer.fromJson(Map<String, dynamic> json) {
    return Manufacturer(
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
    );
  }
}

class User {
  final int id;
  final int creatorId;
  final String email;
  final String username;
  final String? description;
  final bool isVerified;
  final String role;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.creatorId,
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
      creatorId: json['creator_id'],
      email: json['email'],
      username: json['username'],
      description: json['description'],
      isVerified: json['is_verified'],
      role: json['role'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}