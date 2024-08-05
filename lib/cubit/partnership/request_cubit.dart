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
import 'request_state.dart';

class RequestCubit extends Cubit<RequestState> {
  RequestCubit() : super(RequestInitial());

  String? selectedCountryId;

  String? selectedStateId;

  final Dio _dio = Dio();

void selectCountry(String countryId) {
    print('Selecting Country ID: $countryId');
    selectedCountryId = countryId;
    if (state is CountriesLoaded) {
      print('Emitting CountriesLoaded');
      emit(CountriesLoaded(countries: (state as CountriesLoaded).countries));
    }
    fetchStates(countryId);
  }

  void selectState(String stateId) {
    print('Selecting State ID: $stateId');
    selectedStateId = stateId;
    if (state is StatesLoaded) {
      print('Emitting StatesLoaded');
      emit(StatesLoaded(states: (state as StatesLoaded).states));
    }
  }

  // void selectCountry(String countryId) async {
  //   selectedCountryId = countryId;

  //   emit(CountrySelected(countryId: countryId));

  //   await fetchStates(countryId);
  // }

  // void selectState(String stateId) {
  //   selectedStateId = stateId;

  //   emit(StateSelected(stateId: stateId));
  // }

  Future<void> fetchCountries() async {
    emit(RequestLoading());

    try {
      final response =
          await _dio.get('${Const.URL_API}/countries?page=1&limit=9999');

      if (response.statusCode == 200) {
        emit(CountriesLoaded(countries: response.data['data']));
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
      final response = await _dio
          .get('${Const.URL_API}/countries/$countryId/states?page=1&limit=999');

      if (response.statusCode == 200) {
        emit(StatesLoaded(states: response.data['data']));
      } else {
        emit(RequestError(message: 'Failed to load states'));
      }
    } catch (e) {
      emit(RequestError(message: e.toString()));
    }
  }

  Future<void> submitForm(BuildContext context, id,Map<String, dynamic> formData) async {
    print("Form Data $id : $formData");

    emit(RequestLoading());

    try {
      final response = await _dio.post(
        '${Const.API_PRODUCTS}/$id/demo-request',
        data: formData,
      );
      print('cekResponse : ' + response.toString());
      if (response.statusCode == 200) {
        // emit(RequestSuccess(message: response.data['message']));
        Fluttertoast.showToast(
        msg: "Successfully Submitted",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
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
  print('cekCountryInit');
  if (state is CountriesLoaded) {
    print('State is CountriesLoaded');
    final country = (state as CountriesLoaded).countries.firstWhere(
      (country) => country['id'].toString() == selectedCountryId,
      orElse: () => null,
    );
    print('cekCountry: $country');
    return country != null ? country['name'] : '';
  }
  print('State is not CountriesLoaded');
  return '';
}

String getSelectedStateName() {
  print('cekStateInit');
  if (state is StatesLoaded) {
    print('State is StatesLoaded');
    final stateObj = (state as StatesLoaded).states.firstWhere(
      (state) => state['id'].toString() == selectedStateId,
      orElse: () => null,
    );
    print('cekState: $stateObj');
    return stateObj != null ? stateObj['name'] : '';
  }
  print('State is not StatesLoaded');
  return '';
}
}
