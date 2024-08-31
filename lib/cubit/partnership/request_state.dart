// import 'package:equatable/equatable.dart';

// abstract class RequestState extends Equatable {
//   const RequestState();

//   @override
//   List<Object> get props => [];
// }

part of 'request_cubit.dart';

abstract class RequestState {}
class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestSuccess extends RequestState {
  final String message;
  RequestSuccess({required this.message});
}

class RequestError extends RequestState {
  final String message;

  RequestError({required this.message});

  // @override
  // List<Object> get props => [message];
}

class CountriesLoading extends RequestState {}

class CountriesLoaded extends RequestState {
  final List<Country> countries;
  CountriesLoaded({required this.countries});
}

class StatesLoading extends RequestState {}

class StatesLoaded extends RequestState {
  final List<City> states;
  StatesLoaded({required this.states});
}

class CountrySelected extends RequestState {
  final String countryId;

  CountrySelected({required this.countryId});

  // @override
  // List<Object> get props => [countryId];
}

class StateSelected extends RequestState {
  final String stateId;

  StateSelected({required this.stateId});

  // @override
  // List<Object> get props => [stateId];
}
