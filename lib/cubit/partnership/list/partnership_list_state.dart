part of 'partnership_list_cubit.dart';

abstract class PartnershipListState extends Equatable {
  const PartnershipListState();

  @override
  List<Object> get props => [];
}

class PartnershipListStateInitial extends PartnershipListState {}

class PartnershipListStateLoading extends PartnershipListState {}

class PartnershipListStateLoaded extends PartnershipListState {
  final List<PartnershipListModel> requests;

  const PartnershipListStateLoaded(this.requests);

  @override
  List<Object> get props => [requests];
}

class PartnershipListStateError extends PartnershipListState {
  final String message;

  const PartnershipListStateError(this.message);

  @override
  List<Object> get props => [message];
}