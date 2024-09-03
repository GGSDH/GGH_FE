import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/repository/favorite_repository.dart';
import 'package:gyeonggi_express/data/models/response/lane_response.dart';
import 'package:gyeonggi_express/data/models/response/tour_area_summary_response.dart';

// Events (unchanged)
abstract class FavoritesEvent {}

class LoadFavorites extends FavoritesEvent {}

class LikeLane extends FavoritesEvent {
  final int laneId;
  LikeLane(this.laneId);
}

class UnlikeLane extends FavoritesEvent {
  final int laneId;
  UnlikeLane(this.laneId);
}

class LikeTourArea extends FavoritesEvent {
  final int tourAreaId;
  LikeTourArea(this.tourAreaId);
}

class UnlikeTourArea extends FavoritesEvent {
  final int tourAreaId;
  UnlikeTourArea(this.tourAreaId);
}

// States
class FavoritesState {
  final bool isLoading;
  final List<Lane> lanes;
  final List<TourAreaSummary> tourAreas;
  final String? error;

  FavoritesState({
    required this.isLoading,
    required this.lanes,
    required this.tourAreas,
    this.error,
  });

  FavoritesState copyWith({
    bool? isLoading,
    List<Lane>? lanes,
    List<TourAreaSummary>? tourAreas,
    String? error,
  }) {
    return FavoritesState(
      isLoading: isLoading ?? this.isLoading,
      lanes: lanes ?? this.lanes,
      tourAreas: tourAreas ?? this.tourAreas,
      error: error ?? this.error,
    );
  }
}

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoriteRepository repository;

  FavoritesBloc({required this.repository})
      : super(FavoritesState(isLoading: true, lanes: [], tourAreas: [])) {
    on<LoadFavorites>(_onLoadFavorites);
    on<LikeLane>(_onLikeLane);
    on<UnlikeLane>(_onUnlikeLane);
    on<LikeTourArea>(_onLikeTourArea);
    on<UnlikeTourArea>(_onUnlikeTourArea);
  }

  void _onLoadFavorites(
      LoadFavorites event, Emitter<FavoritesState> emit) async {
    emit(state.copyWith(isLoading: true));
    final lanesResult = await repository.getFavoriteLanes();
    final tourAreasResult = await repository.getFavoriteTourAreas();

    lanesResult.when(
      success: (lanes) {
        tourAreasResult.when(
          success: (tourAreas) {
            emit(state.copyWith(
              isLoading: false,
              lanes: lanes,
              tourAreas: tourAreas,
              error: null,
            ));
          },
          apiError: (errorMessage, errorCode) {
            emit(state.copyWith(
              isLoading: false,
              error: 'Failed to load tour areas: $errorMessage',
            ));
          },
        );
      },
      apiError: (errorMessage, errorCode) {
        emit(state.copyWith(
          isLoading: false,
          error: 'Failed to load lanes: $errorMessage',
        ));
      },
    );
  }

  void _onLikeLane(LikeLane event, Emitter<FavoritesState> emit) async {
    final result = await repository.addFavoriteLane(event.laneId);
    result.when(
      success: (_) {
        final updatedLanes = state.lanes.map((lane) {
          if (lane.laneId == event.laneId) {
            return lane.copyWith(likeCount: lane.likeCount + 1);
          }
          return lane;
        }).toList();
        emit(state.copyWith(lanes: updatedLanes, error: null));
      },
      apiError: (errorMessage, errorCode) {
        emit(state.copyWith(error: 'Failed to like lane: $errorMessage'));
      },
    );
  }

  void _onUnlikeLane(UnlikeLane event, Emitter<FavoritesState> emit) async {
    final result = await repository.removeFavoriteLane(event.laneId);
    result.when(
      success: (_) {
        final updatedLanes = state.lanes.map((lane) {
          if (lane.laneId == event.laneId) {
            return lane.copyWith(likeCount: lane.likeCount - 1);
          }
          return lane;
        }).toList();
        emit(state.copyWith(lanes: updatedLanes, error: null));
      },
      apiError: (errorMessage, errorCode) {
        emit(state.copyWith(error: 'Failed to unlike lane: $errorMessage'));
      },
    );
  }

  void _onLikeTourArea(LikeTourArea event, Emitter<FavoritesState> emit) async {
    final result = await repository.addFavoriteTourArea(event.tourAreaId);
    result.when(
      success: (_) {
        final updatedTourAreas = state.tourAreas.map((tourArea) {
          if (tourArea.tourAreaId == event.tourAreaId) {
            return tourArea.copyWith(
                likeCnt: tourArea.likeCnt + 1, likedByMe: true);
          }
          return tourArea;
        }).toList();
        emit(state.copyWith(tourAreas: updatedTourAreas, error: null));
      },
      apiError: (errorMessage, errorCode) {
        emit(state.copyWith(error: 'Failed to like tour area: $errorMessage'));
      },
    );
  }

  void _onUnlikeTourArea(
      UnlikeTourArea event, Emitter<FavoritesState> emit) async {
    final result = await repository.removeFavoriteTourArea(event.tourAreaId);
    result.when(
      success: (_) {
        final updatedTourAreas = state.tourAreas.map((tourArea) {
          if (tourArea.tourAreaId == event.tourAreaId) {
            return tourArea.copyWith(
                likeCnt: tourArea.likeCnt - 1, likedByMe: false);
          }
          return tourArea;
        }).toList();
        emit(state.copyWith(tourAreas: updatedTourAreas, error: null));
      },
      apiError: (errorMessage, errorCode) {
        emit(
            state.copyWith(error: 'Failed to unlike tour area: $errorMessage'));
      },
    );
  }
}
