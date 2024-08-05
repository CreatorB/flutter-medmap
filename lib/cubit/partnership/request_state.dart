import 'package:equatable/equatable.dart';

abstract class RequestState extends Equatable {
  const RequestState();

  @override
  List<Object> get props => [];
}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestSuccess extends RequestState {
  final String message;
  const RequestSuccess({required this.message});
}

class RequestError extends RequestState {
  final String message;

  const RequestError({required this.message});

  @override
  List<Object> get props => [message];
}

class CountriesLoading extends RequestState {}

class CountriesLoaded extends RequestState {
  final List<dynamic> countries;

  const CountriesLoaded({required this.countries});

  @override
  List<Object> get props => [countries];
}

class StatesLoading extends RequestState {}

class StatesLoaded extends RequestState {
  final List<dynamic> states;

  const StatesLoaded({required this.states});

  @override
  List<Object> get props => [states];
}

class CountrySelected extends RequestState {
  final String countryId;

  const CountrySelected({required this.countryId});

  @override
  List<Object> get props => [countryId];
}

class StateSelected extends RequestState {
  final String stateId;

  const StateSelected({required this.stateId});

  @override
  List<Object> get props => [stateId];
}
