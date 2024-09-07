import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_related_lane.dart';
import 'package:gyeonggi_express/data/repository/tour_area_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/tour_area_response.dart';
import '../../data/models/sigungu_code.dart';
import '../../data/models/tour_content_type.dart';
import '../../data/models/trip_theme.dart';

final class StationDetailState {
  final bool isLoading;
  final TourAreaResponse tourArea;
  final List<TourAreaRelatedLane> lanes;
  final List<TourAreaResponse> otherTourAreas;

  StationDetailState({
    required this.isLoading,
    required this.tourArea,
    required this.lanes,
    required this.otherTourAreas,
  });

  factory StationDetailState.initial() => StationDetailState(
    isLoading: false,
    tourArea: TourAreaResponse(
      tourAreaId: 0,
      name: "",
      address: "",
      image: "",
      latitude: 0,
      longitude: 0,
      likeCount: 0,
      likedByMe: false,
      contentType: TourContentType.RESTAURANT,
      tripTheme: TripTheme.NATURAL,
      sigungu: SigunguCode.ANSAN,
    ),
    lanes: [],
    otherTourAreas: [],
  );

  StationDetailState copyWith({
    bool? isLoading,
    TourAreaResponse? tourArea,
    List<TourAreaRelatedLane>? lanes,
    List<TourAreaResponse>? otherTourAreas,
  }) {
    return StationDetailState(
      isLoading: isLoading ?? this.isLoading,
      tourArea: tourArea ?? this.tourArea,
      lanes: lanes ?? this.lanes,
      otherTourAreas: otherTourAreas ?? this.otherTourAreas,
    );
  }
}

sealed class StationDetailEvent { }
final class InitializeStationDetail extends StationDetailEvent {
  final int stationId;

  InitializeStationDetail(this.stationId);
}
final class LikeStation extends StationDetailEvent {
  final int stationId;

  LikeStation(this.stationId);
}
final class UnlikeStation extends StationDetailEvent {
  final int stationId;

  UnlikeStation(this.stationId);
}
final class LikeRecommendation extends StationDetailEvent {
  final int stationId;

  LikeRecommendation(this.stationId);
}
final class UnlikeRecommendation extends StationDetailEvent {
  final int stationId;

  UnlikeRecommendation(this.stationId);
}

sealed class StationDetailSideEffect { }
final class StationDetailShowError extends StationDetailSideEffect {
  final String message;

  StationDetailShowError(this.message);
}

class StationDetailBloc extends SideEffectBloc<StationDetailEvent, StationDetailState, StationDetailSideEffect> {
  final TourAreaRepository _tourAreaRepository;

  StationDetailBloc({
    required TourAreaRepository tourAreaRepository}
  ) : _tourAreaRepository = tourAreaRepository,
        super(StationDetailState.initial()) {
    on<InitializeStationDetail>(_onFetchStationDetail);
    on<LikeStation>(_onLikeStation);
    on<UnlikeStation>(_onUnlikeStation);
    on<LikeRecommendation>(_onLikeRecommendation);
    on<UnlikeRecommendation>(_onUnlikeRecommendation);
  }

  Future<void> _onFetchStationDetail(
    InitializeStationDetail event, Emitter<StationDetailState> emit
  ) async {
    emit(state.copyWith(isLoading: true));
    final response = await _tourAreaRepository.getTourAreaDetail(event.stationId);
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            isLoading: false,
            tourArea: data.tourArea,
            lanes: data.lanes,
            otherTourAreas: data.otherTourAreas
          )
        );
      },
      apiError: (errorMessage, errorCode) {
        state.copyWith(isLoading: false);
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }

  Future<void> _onLikeStation(
    LikeStation event, Emitter<StationDetailState> emit
  ) async {
    final response = await _tourAreaRepository.likeTourArea(event.stationId);
    response.when(
      success: (data) {
        emit(state.copyWith(tourArea: state.tourArea.copyWith(likedByMe: true)));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }

  Future<void> _onUnlikeStation(
    UnlikeStation event, Emitter<StationDetailState> emit
  ) async {
    final response = await _tourAreaRepository.unlikeTourArea(event.stationId);
    response.when(
      success: (data) {
        emit(state.copyWith(tourArea: state.tourArea.copyWith(likedByMe: false)));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }

  Future<void> _onLikeRecommendation(
    LikeRecommendation event, Emitter<StationDetailState> emit
  ) async {
    final response = await _tourAreaRepository.likeTourArea(event.stationId);
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            otherTourAreas: state.otherTourAreas
                .map((tourArea) =>
            tourArea.tourAreaId == event.stationId
                ? tourArea.copyWith(likedByMe: true, likeCount: tourArea.likeCount + 1)
                : tourArea
            ).toList(),
          ),
        );
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }

  Future<void> _onUnlikeRecommendation(
    UnlikeRecommendation event, Emitter<StationDetailState> emit
  ) async {
    final response = await _tourAreaRepository.unlikeTourArea(event.stationId);
    response.when(
      success: (data) {
        emit(
          state.copyWith(
            otherTourAreas: state.otherTourAreas
                .map((tourArea) =>
            tourArea.tourAreaId == event.stationId
                ? tourArea.copyWith(likedByMe: false, likeCount: tourArea.likeCount - 1)
                : tourArea
            ).toList(),
          ),
        );
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }
}
