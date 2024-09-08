import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';
import '../../data/models/response/lane_response.dart';
import '../../data/repository/trip_repository.dart';
import '../../data/repository/favorite_repository.dart';

final class RecommendedLaneState {
  final bool isLoading;
  final List<Lane> lanes;
  final List<SigunguCode> selectedSigunguCodes;

  RecommendedLaneState(
      {required this.isLoading,
      required this.lanes,
      required this.selectedSigunguCodes});

  factory RecommendedLaneState.initial() => RecommendedLaneState(
        isLoading: true,
        lanes: [],
        selectedSigunguCodes: [],
      );

  RecommendedLaneState copyWith({
    bool? isLoading,
    List<Lane>? lanes,
    List<SigunguCode>? selectedSigunguCodes,
  }) {
    return RecommendedLaneState(
      isLoading: isLoading ?? this.isLoading,
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
    on<RecommendedLaneInitialize>(_onRecommendedLaneInitialize);
    on<SelectSigunguCodes>(_onSelectSigunguCodes);
    on<LikeLane>(_onLikeLane);
    on<UnlikeLane>(_onUnlikeLane);
  }

  void _onRecommendedLaneInitialize(
    RecommendedLaneInitialize event,
    Emitter<RecommendedLaneState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final response =
          await _tripRepository.getRecommendedLanes(state.selectedSigunguCodes);
      response.when(
        success: (data) {
          emit(state.copyWith(isLoading: false, lanes: data));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(RecommendedLaneShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(RecommendedLaneShowError(e.toString()));
    }
  }

  void _onSelectSigunguCodes(
    SelectSigunguCodes event,
    Emitter<RecommendedLaneState> emit,
  ) async {
    emit(state.copyWith(
        isLoading: true, selectedSigunguCodes: event.sigunguCodes));
    try {
      final response =
          await _tripRepository.getRecommendedLanes(event.sigunguCodes);
      response.when(
        success: (data) {
          emit(state.copyWith(isLoading: false, lanes: data));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(RecommendedLaneShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
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
      },
      apiError: (errorMessage, errorCode) {
        produceSideEffect(
            RecommendedLaneShowError('Failed to unlike lane: $errorMessage'));
      },
    );
  }
}
