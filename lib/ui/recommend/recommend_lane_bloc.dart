import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/data/repository/trip_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/recommended_lane_response.dart';
import '../../data/models/trip_theme.dart';
import '../../data/repository/favorite_repository.dart';

final class RecommendLaneState {
  final bool isLoading;
  final bool isLikedByMe;
  final RecommendedLaneResponse laneData;

  RecommendLaneState({
    required this.isLoading,
    required this.isLikedByMe,
    required this.laneData,
  });

  factory RecommendLaneState.initial() {
    return RecommendLaneState(
      isLoading: false,
      isLikedByMe: false,
      laneData: RecommendedLaneResponse(
        title: '',
        description: '',
        days: [],
        id: 0,
        sigunguCode: [],
      ),
    );
  }

  RecommendLaneState copyWith({
    bool? isLoading,
    bool? isLikedByMe,
    RecommendedLaneResponse? laneData,
  }) {
    return RecommendLaneState(
      isLoading: isLoading ?? this.isLoading,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      laneData: laneData ?? this.laneData,
    );
  }
}

sealed class RecommendLaneEvent {}

final class RecommendLaneInitialize extends RecommendLaneEvent {
  final int selectedDays;
  final List<SigunguCode> selectedSigunguCodes;
  final List<TripTheme> selectedTripThemes;

  RecommendLaneInitialize({
    required this.selectedDays,
    required this.selectedSigunguCodes,
    required this.selectedTripThemes,
  });
}

final class RecommendLaneLike extends RecommendLaneEvent {
  final int laneId;

  RecommendLaneLike(this.laneId);
}

final class RecommendLaneUnlike extends RecommendLaneEvent {
  final int laneId;

  RecommendLaneUnlike(this.laneId);
}

final class StationLike extends RecommendLaneEvent {
  final int stationId;

  StationLike(this.stationId);
}

final class StationUnlike extends RecommendLaneEvent {
  final int stationId;

  StationUnlike(this.stationId);
}

sealed class RecommendLaneSideEffect {}

final class RecommendLaneShowError extends RecommendLaneSideEffect {
  final String message;

  RecommendLaneShowError(this.message);
}

class RecommendLaneBloc extends SideEffectBloc<RecommendLaneEvent,
    RecommendLaneState, RecommendLaneSideEffect> {
  final TripRepository _tripRepository;
  final FavoriteRepository _favoriteRepository;

  RecommendLaneBloc({
    required TripRepository tripRepository,
    required FavoriteRepository favoriteRepository,
  })  : _tripRepository = tripRepository,
        _favoriteRepository = favoriteRepository,
        super(RecommendLaneState.initial()) {
    on<RecommendLaneInitialize>(_onInitialize);
    on<RecommendLaneLike>(_onLikeAiLane);
    on<RecommendLaneUnlike>(_onUnlikeAiLane);
    on<StationLike>(_onLikeStation);
    on<StationUnlike>(_onUnlikeStation);
  }

  void _onInitialize(
    RecommendLaneInitialize event,
    Emitter<RecommendLaneState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _tripRepository.getRecommendedLane(
        days: event.selectedDays,
        sigunguCodes: event.selectedSigunguCodes,
        tripThemes: event.selectedTripThemes,
      );

      response.when(
        success: (data) {
          emit(state.copyWith(isLoading: false, laneData: data));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(RecommendLaneShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(RecommendLaneShowError(e.toString()));
    }
  }

  void _onLikeAiLane(
      RecommendLaneLike event, Emitter<RecommendLaneState> emit) async {
    try {
      final response =
          await _favoriteRepository.addFavoriteAiLane(event.laneId);

      response.when(
        success: (data) {
          emit(state.copyWith(isLikedByMe: true));
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(RecommendLaneShowError(errorMessage));
        },
      );
    } catch (e) {
      produceSideEffect(RecommendLaneShowError(e.toString()));
    }
  }

  void _onUnlikeAiLane(
      RecommendLaneUnlike event, Emitter<RecommendLaneState> emit) async {
    try {
      final response =
          await _favoriteRepository.removeFavoriteAiLane(event.laneId);

      response.when(
        success: (data) {
          emit(state.copyWith(isLikedByMe: false));
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(RecommendLaneShowError(errorMessage));
        },
      );
    } catch (e) {
      produceSideEffect(RecommendLaneShowError(e.toString()));
    }
  }

  void _onLikeStation(
    StationLike event,
    Emitter<RecommendLaneState> emit,
  ) async {
    try {
      final response = await _favoriteRepository.addFavoriteTourArea(event.stationId);
      response.when(
        success: (data) {
          emit(state.copyWith(laneData: state.laneData.updateLikeStatusOfStation(event.stationId, true)));
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(RecommendLaneShowError(errorMessage));
        }
      );
    } catch (e) {
      produceSideEffect(RecommendLaneShowError(e.toString()));
    }
  }

  void _onUnlikeStation(
    StationUnlike event,
    Emitter<RecommendLaneState> emit,
  ) async {
    try {
      final response = await _favoriteRepository.removeFavoriteTourArea(event.stationId);
      response.when(
        success: (data) {
          emit(state.copyWith(laneData: state.laneData.updateLikeStatusOfStation(event.stationId, false)));
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(RecommendLaneShowError(errorMessage));
        }
      );
    } catch (e) {
      produceSideEffect(RecommendLaneShowError(e.toString()));
    }
  }
}
