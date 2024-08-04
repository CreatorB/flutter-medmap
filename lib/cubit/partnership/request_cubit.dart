import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:medmap/const.dart';
import 'package:omega_dio_logger/omega_dio_logger.dart';
import 'package:equatable/equatable.dart';

import 'request_state.dart';
class RequestCubit extends Cubit<RequestState> {

  RequestCubit() : super(RequestInitial());



  String? selectedCountryId;

  String? selectedStateId;



  final Dio _dio = Dio();



  void selectCountry(String countryId) async {

    selectedCountryId = countryId;

    emit(CountrySelected(countryId: countryId));

    await fetchStates(countryId);

  }



  void selectState(String stateId) {

    selectedStateId = stateId;

    emit(StateSelected(stateId: stateId));

  }



  Future<void> fetchCountries() async {

    emit(RequestLoading());

    try {

      final response = await _dio.get('${Const.URL_API}/countries?page=1&limit=9999');

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

      final response = await _dio.get('${Const.URL_API}/countries/$countryId/states?page=1&limit=999');

      if (response.statusCode == 200) {

        emit(StatesLoaded(states: response.data['data']));

      } else {

        emit(RequestError(message: 'Failed to load states'));

      }

    } catch (e) {

      emit(RequestError(message: e.toString()));

    }

  }



  Future<void> submitForm(Map<String, dynamic> formData) async {

    print("Form Data: $formData");

    emit(RequestLoading());

    try {

      final response = await _dio.post(

        '${Const.URL_API}/submit', // replace with your actual endpoint

        data: formData,

      );

      if (response.statusCode == 200) {

        emit(RequestSuccess());

      } else {

        emit(RequestError(message: 'Failed to submit form'));

      }

    } catch (e) {

      emit(RequestError(message: e.toString()));

    }

  }

}