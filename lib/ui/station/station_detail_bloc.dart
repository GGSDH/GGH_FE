import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_related_lane.dart';
import 'package:gyeonggi_express/data/repository/favorite_repository.dart';
import 'package:gyeonggi_express/data/repository/tour_area_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/tour_area_response.dart';
import '../../data/models/sigungu_code.dart';
import '../../data/models/tour_content_type.dart';
import '../../data/models/trip_theme.dart';
import '../../util/event_bus.dart';

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
      description: "",
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
final class LikeIncludingLane extends StationDetailEvent {
  final int laneId;

  LikeIncludingLane(this.laneId);
}
final class UnlikeIncludingLane extends StationDetailEvent {
  final int laneId;

  UnlikeIncludingLane(this.laneId);
}
final class LikeRecommendation extends StationDetailEvent {
  final int stationId;

  LikeRecommendation(this.stationId);
}
final class UnlikeRecommendation extends StationDetailEvent {
  final int stationId;

  UnlikeRecommendation(this.stationId);
}
final class LaneLikeStatusChanged extends StationDetailEvent {
  final int laneId;
  final bool isLiked;

  LaneLikeStatusChanged(this.laneId, this.isLiked);
}
final class StationLikeStatusChanged extends StationDetailEvent {
  final int stationId;
  final bool isLiked;

  StationLikeStatusChanged(this.stationId, this.isLiked);
}

sealed class StationDetailSideEffect { }
final class StationDetailShowError extends StationDetailSideEffect {
  final String message;

  StationDetailShowError(this.message);
}

class StationDetailBloc extends SideEffectBloc<StationDetailEvent, StationDetailState, StationDetailSideEffect> {
  final TourAreaRepository _tourAreaRepository;
  final FavoriteRepository _favoriteRepository;

  StationDetailBloc({
    required TourAreaRepository tourAreaRepository,
    required FavoriteRepository favoriteRepository,
  }) : _tourAreaRepository = tourAreaRepository,
        _favoriteRepository = favoriteRepository,
        super(StationDetailState.initial()) {
    EventBus().on<ChangeLaneLikeEvent>().listen((event) {
      add(LaneLikeStatusChanged(event.laneId, event.isLike));
    });
    EventBus().on<ChangeStationLikeEvent>().listen((event) {
      add(StationLikeStatusChanged(event.stationId, event.isLike));
    });

    on<InitializeStationDetail>(_onFetchStationDetail);
    on<LikeStation>(_onLikeStation);
    on<UnlikeStation>(_onUnlikeStation);
    on<LikeRecommendation>(_onLikeRecommendation);
    on<UnlikeRecommendation>(_onUnlikeRecommendation);
    on<LikeIncludingLane>(_onLikeIncludingLane);
    on<UnlikeIncludingLane>(_onUnlikeIncludingLane);
    on<LaneLikeStatusChanged>(_onLaneLikeStatusChanged);
    on<StationLikeStatusChanged>(_onStationLikeStatusChanged);
  }

  void _onLaneLikeStatusChanged(
    LaneLikeStatusChanged event, Emitter<StationDetailState> emit
  ) {
    emit(
      state.copyWith(
        lanes: state.lanes
            .map((lane) =>
        lane.laneId == event.laneId
            ? lane.copyWith(likedByMe: event.isLiked, likeCount: event.isLiked ? lane.likeCount + 1 : lane.likeCount - 1)
            : lane
        ).toList(),
      ),
    );
  }

  void _onStationLikeStatusChanged(
      StationLikeStatusChanged event, Emitter<StationDetailState> emit
  ) {
    emit(
        state.copyWith(
          tourArea: state.tourArea.copyWith(likedByMe: event.isLiked),
          otherTourAreas: state.otherTourAreas
              .map((tourArea) => tourArea.tourAreaId == event.stationId ? tourArea.copyWith(likedByMe: event.isLiked, likeCount: (event.isLiked) ? tourArea.likeCount + 1 : tourArea.likeCount - 1) : tourArea).toList()
        )
    );
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
    final response = await _favoriteRepository.addFavoriteTourArea(event.stationId);
    response.when(
      success: (data) {
        EventBus().fire(ChangeStationLikeEvent(event.stationId, true));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }

  Future<void> _onUnlikeStation(
    UnlikeStation event, Emitter<StationDetailState> emit
  ) async {
    final response = await _favoriteRepository.removeFavoriteTourArea(event.stationId);
    response.when(
      success: (data) {
        EventBus().fire(ChangeStationLikeEvent(event.stationId, false));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }

  Future<void> _onLikeIncludingLane(
    LikeIncludingLane event, Emitter<StationDetailState> emit
  ) async {
    final response = await _favoriteRepository.addFavoriteLane(event.laneId);
    response.when(
      success: (data) {
        EventBus().fire(ChangeLaneLikeEvent(event.laneId, true));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }

  Future<void> _onUnlikeIncludingLane(
    UnlikeIncludingLane event, Emitter<StationDetailState> emit
  ) async {
    final response = await _favoriteRepository.removeFavoriteLane(event.laneId);
    response.when(
      success: (data) {
        EventBus().fire(ChangeLaneLikeEvent(event.laneId, false));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }

  Future<void> _onLikeRecommendation(
    LikeRecommendation event, Emitter<StationDetailState> emit
  ) async {
    final response = await _favoriteRepository.addFavoriteTourArea(event.stationId);
    response.when(
      success: (data) {
        EventBus().fire(ChangeStationLikeEvent(event.stationId, true));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }

  Future<void> _onUnlikeRecommendation(
    UnlikeRecommendation event, Emitter<StationDetailState> emit
  ) async {
    final response = await _favoriteRepository.removeFavoriteTourArea(event.stationId);
    response.when(
      success: (data) {
        EventBus().fire(ChangeStationLikeEvent(event.stationId, false));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(StationDetailShowError(errorMessage));
      },
    );
  }
}
