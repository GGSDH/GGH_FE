import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/lane_detail_response.dart';
import 'package:gyeonggi_express/data/repository/favorite_repository.dart';
import 'package:gyeonggi_express/data/repository/lane_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/trip_theme.dart';

final class LaneDetailState {
  final bool isLoading;
  final bool isLikedByMe;
  final LaneDetail laneDetail;

  const LaneDetailState({
    required this.isLoading,
    required this.isLikedByMe,
    required this.laneDetail,
  });

  factory LaneDetailState.initial() {
    return LaneDetailState(
      isLoading: false,
      isLikedByMe: false,
      laneDetail: LaneDetail(
        id: 0,
        days: 0,
        laneName: '',
        image: '',
        laneDescription: '',
        category: TripTheme.RESTAURANT,
        laneSpecificResponses: [],
      ),
    );
  }

  LaneDetailState copyWith({
    bool? isLoading,
    bool? isLikedByMe,
    LaneDetail? laneDetail,
  }) {
    return LaneDetailState(
      isLoading: isLoading ?? this.isLoading,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      laneDetail: laneDetail ?? this.laneDetail,
    );
  }
}

sealed class LaneDetailEvent { }
final class LaneDetailInitialize extends LaneDetailEvent {
  final int laneId;

  LaneDetailInitialize({
    required this.laneId,
  });
}
final class LaneDetailLike extends LaneDetailEvent {
  final int laneId;

  LaneDetailLike({
    required this.laneId,
  });
}
final class LaneDetailUnlike extends LaneDetailEvent {
  final int laneId;

  LaneDetailUnlike({
    required this.laneId,
  });
}

sealed class LaneDetailSideEffect { }
final class LaneDetailShowError extends LaneDetailSideEffect {
  final String message;

  LaneDetailShowError(this.message);
}

class LaneDetailBloc extends SideEffectBloc<LaneDetailEvent, LaneDetailState, LaneDetailSideEffect> {
  final LaneRepository _laneRepository;
  final FavoriteRepository _favoriteRepository;

  LaneDetailBloc({
    required LaneRepository laneRepository,
    required FavoriteRepository favoriteRepository,
  }) : _laneRepository = laneRepository,
       _favoriteRepository = favoriteRepository,
       super(LaneDetailState.initial()) {
    on<LaneDetailInitialize>(_onInitialize);
    on<LaneDetailLike>(_onLikeLane);
    on<LaneDetailUnlike>(_onUnlikeLane);
  }

  void _onInitialize(
    LaneDetailInitialize event,
    Emitter<LaneDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _laneRepository.getLaneDetail(event.laneId);
      response.when(
        success: (data) => emit(state.copyWith(laneDetail: data)),
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(LaneDetailShowError(errorMessage));
        }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(LaneDetailShowError(e.toString()));
    }
  }

  void _onLikeLane(
    LaneDetailLike event,
    Emitter<LaneDetailState> emit,
  ) async {
    try {
      final response = await _favoriteRepository.addFavoriteLane(event.laneId);
      response.when(
        success: (data) {
          emit(state.copyWith(isLikedByMe: true));
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(LaneDetailShowError(errorMessage));
        }
      );
    } catch (e) {
      produceSideEffect(LaneDetailShowError(e.toString()));
    }
  }

  void _onUnlikeLane(
    LaneDetailUnlike event,
    Emitter<LaneDetailState> emit,
  ) async {
    try {
      final response = await _favoriteRepository.removeFavoriteLane(event.laneId);
      response.when(
        success: (data) {
          emit(state.copyWith(isLikedByMe: false));
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(LaneDetailShowError(errorMessage));
        }
      );
    } catch (e) {
      produceSideEffect(LaneDetailShowError(e.toString()));
    }
  }
}
