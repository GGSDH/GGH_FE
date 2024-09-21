import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/local_restaurant_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_destination_response.dart';
import 'package:gyeonggi_express/data/repository/favorite_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/lane_response.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/trip_repository.dart';

final class HomeState {
  final bool isInitialLoading;
  final bool isRefreshing;
  final String userName;
  final List<Lane> lanes;
  final List<LocalRestaurant> localRestaurants;
  final List<PopularDestination> popularDestinations;

  HomeState({
    required this.isInitialLoading,
    required this.isRefreshing,
    required this.userName,
    required this.lanes,
    required this.localRestaurants,
    required this.popularDestinations,
  });

  factory HomeState.initial() => HomeState(
        isInitialLoading: true,
        isRefreshing: false,
        userName: "",
        lanes: [],
        localRestaurants: [],
        popularDestinations: [],
      );

  HomeState copyWith({
    bool? isInitialLoading,
    bool? isRefreshing,
    String? userName,
    List<Lane>? lanes,
    List<LocalRestaurant>? localRestaurants,
    List<PopularDestination>? popularDestinations,
  }) {
    return HomeState(
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      userName: userName ?? this.userName,
      lanes: lanes ?? this.lanes,
      localRestaurants: localRestaurants ?? this.localRestaurants,
      popularDestinations: popularDestinations ?? this.popularDestinations,
    );
  }
}

sealed class HomeEvent {}

final class HomeInitialize extends HomeEvent {}

final class HomeLikeLane extends HomeEvent {
  final int laneId;

  HomeLikeLane(this.laneId);
}

final class HomeUnlikeLane extends HomeEvent {
  final int laneId;

  HomeUnlikeLane(this.laneId);
}

final class HomeLikeTourArea extends HomeEvent {
  final int tourAreaId;

  HomeLikeTourArea(this.tourAreaId);
}

final class HomeUnlikeTourArea extends HomeEvent {
  final int tourAreaId;

  HomeUnlikeTourArea(this.tourAreaId);
}

sealed class HomeSideEffect {}

final class HomeShowError extends HomeSideEffect {
  final String message;

  HomeShowError(this.message);
}

class HomeRefresh extends HomeEvent {}

class HomeBloc extends SideEffectBloc<HomeEvent, HomeState, HomeSideEffect> {
  final AuthRepository _authRepository;
  final TripRepository _tripRepository;
  final FavoriteRepository _favoriteRepository;

  HomeBloc({
    required AuthRepository authRepository,
    required TripRepository tripRepository,
    required FavoriteRepository favoriteRepository,
  })  : _authRepository = authRepository,
        _tripRepository = tripRepository,
        _favoriteRepository = favoriteRepository,
        super(HomeState.initial()) {
    on<HomeInitialize>(_onInitialize);
    on<HomeLikeLane>(_onLikeLane);
    on<HomeUnlikeLane>(_onUnlikeLane);
    on<HomeLikeTourArea>(_onLikeTourArea);
    on<HomeUnlikeTourArea>(_onUnlikeTourArea);
    on<HomeRefresh>(_onRefresh);
  }

  void _onInitialize(HomeInitialize event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isInitialLoading: true));
    await _fetchAllData(emit);
    emit(state.copyWith(isInitialLoading: false));
  }

  void _onRefresh(HomeRefresh event, Emitter<HomeState> emit) async {
    emit(state.copyWith(isRefreshing: true));
    await _fetchAllData(emit);
    emit(state.copyWith(isRefreshing: false));
  }

  Future<void> _fetchAllData(Emitter<HomeState> emit) async {
    try {
      final profileResponse = await _authRepository.getProfileInfo();
      profileResponse.when(
        success: (profileData) {
          emit(state.copyWith(userName: profileData.nickname));
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(HomeShowError(errorMessage));
        },
      );

      final lanesResponse = await _tripRepository.getRecommendedLanes([]);
      lanesResponse.when(
        success: (lanesData) {
          emit(state.copyWith(lanes: lanesData.sublist(0, 3)));
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(HomeShowError(errorMessage));
        },
      );

      final destinationsResponse =
          await _tripRepository.getPopularDestinations();
      destinationsResponse.when(
        success: (destinationsData) {
          emit(state.copyWith(
              popularDestinations: destinationsData.sublist(0, 10)));
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(HomeShowError(errorMessage));
        },
      );

      final restaurantsResponse = await _tripRepository.getLocalRestaurants([]);
      restaurantsResponse.when(
        success: (restaurantsData) {
          emit(
              state.copyWith(localRestaurants: restaurantsData.sublist(0, 10)));
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(HomeShowError(errorMessage));
        },
      );
    } catch (e) {
      produceSideEffect(HomeShowError(e.toString()));
    }
  }

  void _onLikeLane(HomeLikeLane event, Emitter<HomeState> emit) async {
    try {
      final response = await _favoriteRepository.addFavoriteLane(event.laneId);
      response.when(success: (data) {
        final updatedLanes = state.lanes.map((lane) {
          if (lane.laneId == event.laneId) {
            return lane.copyWith(
                likedByMe: true, likeCount: lane.likeCount + 1);
          }
          return lane;
        }).toList();
        emit(state.copyWith(lanes: updatedLanes));
      }, apiError: (errorMessage, errorCode) {
        produceSideEffect(HomeShowError("Failed to like lane"));
      });
    } catch (e) {
      produceSideEffect(HomeShowError(e.toString()));
    }
  }

  void _onUnlikeLane(HomeUnlikeLane event, Emitter<HomeState> emit) async {
    try {
      final response =
          await _favoriteRepository.removeFavoriteLane(event.laneId);
      response.when(success: (data) {
        final updatedLanes = state.lanes.map((lane) {
          if (lane.laneId == event.laneId) {
            return lane.copyWith(
                likedByMe: false, likeCount: lane.likeCount - 1);
          }
          return lane;
        }).toList();
        emit(state.copyWith(lanes: updatedLanes));
      }, apiError: (errorMessage, errorCode) {
        produceSideEffect(HomeShowError("Failed to unlike lane"));
      });
    } catch (e) {
      produceSideEffect(HomeShowError(e.toString()));
    }
  }

  void _onLikeTourArea(HomeLikeTourArea event, Emitter<HomeState> emit) async {
    try {
      final response =
          await _favoriteRepository.addFavoriteTourArea(event.tourAreaId);

      response.when(success: (data) {
        final updatedTourAreas = state.localRestaurants.map((restaurant) {
          if (restaurant.tourAreaId == event.tourAreaId) {
            return restaurant.copyWith(
                likedByMe: true, likeCount: restaurant.likeCount + 1);
          }
          return restaurant;
        }).toList();

        emit(state.copyWith(localRestaurants: updatedTourAreas));
      }, apiError: (errorMessage, errorCode) {
        produceSideEffect(HomeShowError("Failed to like tour area"));
      });
    } catch (e) {
      produceSideEffect(HomeShowError(e.toString()));
    }
  }

  void _onUnlikeTourArea(
    HomeUnlikeTourArea event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final response =
          await _favoriteRepository.removeFavoriteTourArea(event.tourAreaId);

      response.when(success: (data) {
        final updatedTourAreas = state.localRestaurants.map((restaurant) {
          if (restaurant.tourAreaId == event.tourAreaId) {
            return restaurant.copyWith(
                likedByMe: false, likeCount: restaurant.likeCount - 1);
          }
          return restaurant;
        }).toList();

        emit(state.copyWith(localRestaurants: updatedTourAreas));
      }, apiError: (errorMessage, errorCode) {
        produceSideEffect(HomeShowError("Failed to unlike tour area"));
      });
    } catch (e) {
      produceSideEffect(HomeShowError(e.toString()));
    }
  }
}
