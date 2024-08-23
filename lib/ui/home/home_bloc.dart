import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/response/local_restaurant_response.dart';
import 'package:gyeonggi_express/data/models/response/popular_destination_response.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/lane_response.dart';
import '../../data/repository/auth_repository.dart';
import '../../data/repository/trip_repository.dart';

final class HomeState {
  final bool isLoading;
  final String userName;
  final List<Lane> lanes;
  final List<LocalRestaurant> localRestaurants;
  final List<PopularDestination> popularDestinations;

  HomeState({
    required this.isLoading,
    required this.userName,
    required this.lanes,
    required this.localRestaurants,
    required this.popularDestinations,
  });

  factory HomeState.initial() => HomeState(
    isLoading: true,
    userName: "",
    lanes: [],
    localRestaurants: [],
    popularDestinations: [],
  );

  HomeState copyWith({
    bool? isLoading,
    String? userName,
    List<Lane>? lanes,
    List<LocalRestaurant>? localRestaurants,
    List<PopularDestination>? popularDestinations,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      userName: userName ?? this.userName,
      lanes: lanes ?? this.lanes,
      localRestaurants: localRestaurants ?? this.localRestaurants,
      popularDestinations: popularDestinations ?? this.popularDestinations,
    );
  }
}

sealed class HomeEvent { }
final class HomeInitialize extends HomeEvent { }

sealed class HomeSideEffect { }
final class HomeShowError extends HomeSideEffect {
  final String message;

  HomeShowError(this.message);
}

class HomeBloc extends SideEffectBloc<HomeEvent, HomeState, HomeSideEffect> {
  final AuthRepository _authRepository;
  final TripRepository _tripRepository;

  HomeBloc({
    required AuthRepository authRepository,
    required TripRepository tripRepository,
  }) : _authRepository = authRepository,
      _tripRepository = tripRepository,
      super(HomeState.initial()) {
    on<HomeInitialize>(_onInitialize);
  }

  void _onInitialize(
    HomeInitialize event,
    Emitter<HomeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _authRepository.getProfileInfo();

      response.when(
          success: (data) {
            emit(
                state.copyWith(
                    isLoading: false,
                    userName: data.nickname
                )
            );
          },
          apiError: (errorMessage, errorCode) {
            emit(state.copyWith(isLoading: false));
            produceSideEffect(HomeShowError(errorMessage));
          }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(HomeShowError(e.toString()));
    }

    try {
      final response = await _tripRepository.getRecommendedLanes([]);

      response.when(
        success: (data) {
          emit(
              state.copyWith(
                  isLoading: false,
                  lanes: data.sublist(0, 3)
              )
          );
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(HomeShowError(errorMessage));
        }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(HomeShowError(e.toString()));
    }

    try {
      final response = await _tripRepository.getPopularDestinations();

      response.when(
        success: (data) {
          emit(
            state.copyWith(
              isLoading: false,
              popularDestinations: data.sublist(0, 10)
            )
          );
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(HomeShowError(errorMessage));
        }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(HomeShowError(e.toString()));
    }

    try {
      final response = await _tripRepository.getLocalRestaurants([]);

      response.when(
        success: (data) {
          emit(
            state.copyWith(
              isLoading: false,
              localRestaurants: data.sublist(0, 10)
            )
          );
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(HomeShowError(errorMessage));
        }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(HomeShowError(e.toString()));
    }
  }
}