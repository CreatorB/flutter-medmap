import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:medmap/api.dart';
import 'package:medmap/models/analysis_response.dart' as analysis;
import 'package:medmap/models/affair_response.dart' as affair;

class DashboardCubit extends Cubit<DashboardState> {
  final Api api;

  DashboardCubit(this.api) : super(DashboardInitial());

  Future<void> getAnalysis({int page = 1, required BuildContext context}) async {
    try {
      emit(DashboardLoading());
      final response = await api.fetchData(context, 'cases-analysis?page=$page&limit=3');
      if (response != null) {
        final analysisResponse = analysis.AnalysisResponse.fromJson(response);
        emit(DashboardAnalysisLoaded(analysisResponse.data ?? []));
      } else {
        emit(DashboardError('Failed to load data'));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> getAffairs({int page = 1, required BuildContext context}) async {
    try {
      emit(DashboardLoading());
      final response = await api.fetchData(context, 'gov-affairs?sort=created_at&order=desc&page=$page&limit=3');
      if (response != null) {
        final affairResponse = affair.AffairResponse.fromJson(response);
        emit(DashboardAffairLoaded(affairResponse.data ?? []));
      } else {
        emit(DashboardError('Failed to load data'));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardAnalysisLoaded extends DashboardState {
  final List<analysis.Data> data;

  DashboardAnalysisLoaded(this.data);
}

class DashboardAffairLoaded extends DashboardState {
  final List<affair.Data> data;

  DashboardAffairLoaded(this.data);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}