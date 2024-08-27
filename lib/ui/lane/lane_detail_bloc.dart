import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/lane_detail_response.dart';
import 'package:gyeonggi_express/data/models/response/lane_specific_response.dart';
import 'package:gyeonggi_express/data/models/response/lane_tour_area_response.dart';
import 'package:gyeonggi_express/data/repository/lane_repository.dart';

abstract class LaneDetailEvent extends Equatable {
  const LaneDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchLaneDetail extends LaneDetailEvent {
  final int laneId;

  const FetchLaneDetail(this.laneId);

  @override
  List<Object> get props => [laneId];
}

abstract class LaneDetailState extends Equatable {
  const LaneDetailState();

  @override
  List<Object> get props => [];
}

class LaneDetailInitial extends LaneDetailState {}

class LaneDetailLoading extends LaneDetailState {}

class LaneDetailLoaded extends LaneDetailState {
  final LaneDetail laneDetail;

  const LaneDetailLoaded(this.laneDetail);

  @override
  List<Object> get props => [laneDetail];
}

class LaneDetailError extends LaneDetailState {
  final String message;

  const LaneDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class LaneDetailBloc extends Bloc<LaneDetailEvent, LaneDetailState> {
  final LaneRepository laneRepository;

  LaneDetailBloc(this.laneRepository) : super(LaneDetailInitial()) {
    on<FetchLaneDetail>(_onFetchLaneDetail);
  }

  Future<void> _onFetchLaneDetail(
    FetchLaneDetail event,
    Emitter<LaneDetailState> emit,
  ) async {
    emit(LaneDetailLoading());
    try {
      final result = await laneRepository.getLaneDetail(event.laneId);
      result.when(
        success: (data) => emit(LaneDetailLoaded(data)),
        apiError: (errorMessage, errorCode) =>
            emit(LaneDetailError(errorMessage)),
      );
    } catch (e) {
      emit(LaneDetailError(e.toString()));
    }
  }
}
