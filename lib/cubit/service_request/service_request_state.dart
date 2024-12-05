part of 'service_request_cubit.dart';

@immutable
abstract class ServiceRequestState {}

class ServiceRequestInitial extends ServiceRequestState {}

class ServiceRequestLoading extends ServiceRequestState {}

class ServiceRequestLoaded extends ServiceRequestState {}

// class ServiceRequestLoaded extends ServiceRequestState {
//   final String requestTitle;
//   final String fullDescription;
//   final String selectedCurrency;
//   final String estimateBudget;
//   final String selectedPriceType;

//   ServiceRequestLoaded({
//     required this.requestTitle,
//     required this.fullDescription,
//     required this.selectedCurrency,
//     required this.estimateBudget,
//     required this.selectedPriceType,
//   });
// }

class ServiceRequestError extends ServiceRequestState {
  final String message;

  ServiceRequestError(this.message);
}
