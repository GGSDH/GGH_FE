import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_detail_response.dart';
import 'package:gyeonggi_express/data/repository/tour_area_repository.dart';

@immutable
abstract class StationDetailEvent extends Equatable {
  const StationDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchStationDetail extends StationDetailEvent {
  final int stationId;

  const FetchStationDetail({required this.stationId});

  @override
  List<Object> get props => [stationId];
}

@immutable
abstract class StationDetailState extends Equatable {
  const StationDetailState();

  @override
  List<Object> get props => [];
}

class StationDetailInitial extends StationDetailState {}

class StationDetailLoading extends StationDetailState {}

class StationDetailLoaded extends StationDetailState {
  final TourAreaDetail data;
  const StationDetailLoaded({required this.data});
}

class StationDetailError extends StationDetailState {
  final String message;

  const StationDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

class StationDetailBloc extends Bloc<StationDetailEvent, StationDetailState> {
  final TourAreaRepository _tourAreaRepository;

  StationDetailBloc(this._tourAreaRepository) : super(StationDetailInitial()) {
    on<FetchStationDetail>(_onFetchStationDetail);
  }

  Future<void> _onFetchStationDetail(
      FetchStationDetail event, Emitter<StationDetailState> emit) async {
    emit(StationDetailLoading());
    final result = await _tourAreaRepository.getTourAreaDetail(event.stationId);
    result.when(
      success: (data) {
        emit(StationDetailLoaded(data: data));
      },
      apiError: (errorMessage, errorCode) {
        emit(StationDetailError(message: errorMessage));
      },
    );
  }


}
