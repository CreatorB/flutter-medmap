part of 'request_cubit.dart';

abstract class RequestState {}

class RequestInitial extends RequestState {}

class RequestLoading extends RequestState {}

class RequestSuccess extends RequestState {
  final dynamic data;

  RequestSuccess(this.data);
}

class RequestFailure extends RequestState {
  final String errorMessage;

  RequestFailure(this.errorMessage);
}

class DataFetched extends RequestState {
  final List<Country> countries;
  final List<State> states;

  DataFetched({required this.countries, required this.states});
}

class ErrorState extends RequestState {
  final String errorMessage;

  ErrorState(this.errorMessage);
}