import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/util/event_bus.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/lane_response.dart';
import '../../data/repository/favorite_repository.dart';
import '../../data/repository/trip_repository.dart';

final class RecommendedLaneState {
  final bool isInitialLoading;
  final bool isRefreshing;
  final List<Lane> lanes;
  final List<SigunguCode> selectedSigunguCodes;

  RecommendedLaneState({
    required this.isInitialLoading,
    required this.isRefreshing,
    required this.lanes,
    required this.selectedSigunguCodes,
  });

  factory RecommendedLaneState.initial() => RecommendedLaneState(
        isInitialLoading: true,
        isRefreshing: false,
        lanes: [],
        selectedSigunguCodes: [],
      );

  RecommendedLaneState copyWith({
    bool? isInitialLoading,
    bool? isRefreshing,
    List<Lane>? lanes,
    List<SigunguCode>? selectedSigunguCodes,
  }) {
    return RecommendedLaneState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      lanes: lanes ?? this.lanes,
      selectedSigunguCodes: selectedSigunguCodes ?? this.selectedSigunguCodes,
    );
  }
}

sealed class RecommendedLaneEvent {}

final class RecommendedLaneInitialize extends RecommendedLaneEvent {}

final class SelectSigunguCodes extends RecommendedLaneEvent {
  final List<SigunguCode> sigunguCodes;
  SelectSigunguCodes(this.sigunguCodes);
}
final class LikeLane extends RecommendedLaneEvent {
  final int laneId;
  LikeLane(this.laneId);
}
final class UnlikeLane extends RecommendedLaneEvent {
  final int laneId;
  UnlikeLane(this.laneId);
}
final class LaneLikeStatusChanged extends RecommendedLaneEvent {
  final int laneId;
  final bool isLiked;
  LaneLikeStatusChanged(this.laneId, this.isLiked);
}
final class RecommendedLaneRefresh extends RecommendedLaneEvent {}

sealed class RecommendedLaneSideEffect {}
final class RecommendedLaneShowError extends RecommendedLaneSideEffect {
  final String message;
  RecommendedLaneShowError(this.message);
}

class RecommendedLaneBloc extends SideEffectBloc<RecommendedLaneEvent,
    RecommendedLaneState, RecommendedLaneSideEffect> {
  final TripRepository _tripRepository;
  final FavoriteRepository _favoriteRepository;

  RecommendedLaneBloc({
    required TripRepository tripRepository,
    required FavoriteRepository favoriteRepository,
  })  : _tripRepository = tripRepository,
        _favoriteRepository = favoriteRepository,
        super(RecommendedLaneState.initial()) {
    EventBus().on<ChangeLaneLikeEvent>().listen((event) {
      add(LaneLikeStatusChanged(event.laneId, event.isLike));
    });

    on<RecommendedLaneInitialize>(_onRecommendedLaneInitialize);
    on<SelectSigunguCodes>(_onSelectSigunguCodes);
    on<LikeLane>(_onLikeLane);
    on<UnlikeLane>(_onUnlikeLane);
    on<RecommendedLaneRefresh>(_onRecommendedLaneRefresh);
    on<LaneLikeStatusChanged>(_onLaneLikeStatusChanged);
  }

  void _onLaneLikeStatusChanged(
    LaneLikeStatusChanged event,
    Emitter<RecommendedLaneState> emit,
  ) {
    final updatedLanes = state.lanes.map((lane) {
      if (lane.laneId == event.laneId) {
        return lane.copyWith(likedByMe: event.isLiked);
      }
      return lane;
    }).toList();
    emit(state.copyWith(lanes: updatedLanes));
  }

  void _onRecommendedLaneInitialize(
    RecommendedLaneInitialize event,
    Emitter<RecommendedLaneState> emit,
  ) async {
    emit(state.copyWith(isInitialLoading: true));
    try {
      final response =
          await _tripRepository.getRecommendedLanes(state.selectedSigunguCodes);
      response.when(
        success: (data) {
          emit(state.copyWith(isInitialLoading: false, lanes: data));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isInitialLoading: false));
          produceSideEffect(RecommendedLaneShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isInitialLoading: false));
      produceSideEffect(RecommendedLaneShowError(e.toString()));
    }
  }

  void _onSelectSigunguCodes(
    SelectSigunguCodes event,
    Emitter<RecommendedLaneState> emit,
  ) async {
    emit(state.copyWith(
        isInitialLoading: true, selectedSigunguCodes: event.sigunguCodes));
    try {
      final response =
          await _tripRepository.getRecommendedLanes(event.sigunguCodes);
      response.when(
        success: (data) {
          emit(state.copyWith(isInitialLoading: false, lanes: data));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isInitialLoading: false));
          produceSideEffect(RecommendedLaneShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isInitialLoading: false));
      produceSideEffect(RecommendedLaneShowError(e.toString()));
    }
  }

  void _onRecommendedLaneRefresh(
    RecommendedLaneRefresh event,
    Emitter<RecommendedLaneState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true));
    try {
      final response =
          await _tripRepository.getRecommendedLanes(state.selectedSigunguCodes);
      response.when(
        success: (data) {
          emit(state.copyWith(isRefreshing: false, lanes: data));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isRefreshing: false));
          produceSideEffect(RecommendedLaneShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isRefreshing: false));
      produceSideEffect(RecommendedLaneShowError(e.toString()));
    }
  }

  void _onLikeLane(
    LikeLane event,
    Emitter<RecommendedLaneState> emit,
  ) async {
    final result = await _favoriteRepository.addFavoriteLane(event.laneId);
    result.when(
      success: (_) {
        final updatedLanes = state.lanes.map((lane) {
          if (lane.laneId == event.laneId) {
            return lane.copyWith(
                likeCount: lane.likeCount + 1, likedByMe: true);
          }
          return lane;
        }).toList();
        emit(state.copyWith(lanes: updatedLanes));
        EventBus().fire(ChangeLaneLikeEvent(event.laneId, true));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(
            RecommendedLaneShowError('Failed to like lane: $errorMessage'));
      },
    );
  }

  void _onUnlikeLane(
    UnlikeLane event,
    Emitter<RecommendedLaneState> emit,
  ) async {
    final result = await _favoriteRepository.removeFavoriteLane(event.laneId);
    result.when(
      success: (_) {
        final updatedLanes = state.lanes.map((lane) {
          if (lane.laneId == event.laneId) {
            return lane.copyWith(
                likeCount: lane.likeCount - 1, likedByMe: false);
          }
          return lane;
        }).toList();
        emit(state.copyWith(lanes: updatedLanes));
        EventBus().fire(ChangeLaneLikeEvent(event.laneId, false));
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(
            RecommendedLaneShowError('Failed to unlike lane: $errorMessage'));
      },
    );
  }
}
