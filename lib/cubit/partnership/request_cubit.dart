import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medmap/const.dart';
import 'package:medmap/route/app_routes.dart';
import 'package:omega_dio_logger/omega_dio_logger.dart';
import 'package:equatable/equatable.dart';
import 'package:go_router/go_router.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:meta/meta.dart';
import 'dart:convert';
part 'request_state.dart';

class Country {
  final int id;
  final String name;

  Country({required this.id, required this.name});

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      id: json['id'],
      name: json['name'],
    );
  }
}

class City {
  final int id;
  final String name;
  final int countryId;

  City({required this.id, required this.name, required this.countryId});

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['id'],
      name: json['name'],
      countryId: json['country_id'],
    );
  }
}

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(RequestInitial());

  String? selectedCountryId;
  String? selectedStateId;
  final Dio _dio = Dio();

  void selectCountry(String countryId) {
    selectedCountryId = countryId;
    if (state is CountriesLoaded) {
      emit(CountriesLoaded(countries: (state as CountriesLoaded).countries));
    }
    fetchStates(countryId);
  }

  void selectState(String stateId) {
    selectedStateId = stateId;
    if (state is StatesLoaded) {
      emit(StatesLoaded(states: (state as StatesLoaded).states));
    }
  }

  Future<void> fetchCountries() async {
    emit(RequestLoading());

    try {
      final response = await _dio.get('${Const.URL_API}/countries?page=1&limit=9999');

      if (response.statusCode == 200) {
        List<Country> countries = (response.data['data'] as List)
            .map((country) => Country.fromJson(country))
            .toList();
        emit(CountriesLoaded(countries: countries));
      } else {
        emit(RequestError(message: 'Failed to load countries'));
      }
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  Future<void> fetchStates(String countryId) async {
    emit(RequestLoading());

    try {
      final response = await _dio.get('${Const.URL_API}/countries/$countryId/states?page=1&limit=999');

      if (response.statusCode == 200) {
        List<City> states = (response.data['data'] as List)
            .map((state) => City.fromJson(state))
            .toList();
        emit(StatesLoaded(states: states));
      } else {
        emit(RequestError(message: 'Failed to load states'));
      }
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  Future<void> submitForm(BuildContext context, String id, Map<String, dynamic> formData) async {
    // print('cekFormData : ' + formData.toString());
    emit(RequestLoading());
    try {
      final response = await _dio.post('${Const.API_PRODUCTS}/$id/demo-request', data: formData);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(
          msg: "Successfully Submitted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Future.delayed(Duration(seconds: 1), () {
          context.go(AppRoutes.home);
        });
      } else {
        emit(RequestError(message: 'Failed to submit form'));
      }
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  String getSelectedCountryName() {
    if (state is CountriesLoaded && selectedCountryId != null) {
      final country = (state as CountriesLoaded)
          .countries
          .firstWhere((country) => country.id.toString() == selectedCountryId, orElse: () => Country(id: 0, name: ''));
      return country.name;
    }
    return '';
  }

  String getSelectedStateName() {
    if (state is StatesLoaded && selectedStateId != null) {
      final city = (state as StatesLoaded)
          .states
          .firstWhere((state) => state.id.toString() == selectedStateId, orElse: () => City(id: 0, name: '', countryId: 0));
      return city.name;
    }
    return '';
  }
}
