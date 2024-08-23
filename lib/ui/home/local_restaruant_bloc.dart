import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/sigungu_code.dart';
import 'package:gyeonggi_express/data/repository/trip_repository.dart';
import 'package:gyeonggi_express/ui/ext/throttle_util.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/local_restaurant_response.dart';

final class LocalRestaurantState {
  final bool isLoading;
  final bool isInitial;
  final List<LocalRestaurant> localRestaurants;
  final List<SigunguCode> lastSelectedSigunguCodes;
  final List<SigunguCode> selectedSigunguCodes;
  final bool isReachedEnd;

  LocalRestaurantState({
    required this.isLoading,
    required this.isInitial,
    required this.localRestaurants,
    required this.lastSelectedSigunguCodes,
    required this.selectedSigunguCodes,
    required this.isReachedEnd,
  });

  factory LocalRestaurantState.initial() => LocalRestaurantState(
    isLoading: true,
    isInitial: true,
    localRestaurants: [],
    lastSelectedSigunguCodes: [],
    selectedSigunguCodes: [],
    isReachedEnd: false,
  );

  LocalRestaurantState copyWith({
    bool? isLoading,
    bool? isInitial,
    List<LocalRestaurant>? localRestaurants,
    List<SigunguCode>? lastSelectedSigunguCodes,
    List<SigunguCode>? selectedSigunguCodes,
    bool? isReachedEnd,
  }) {
    return LocalRestaurantState(
      isLoading: isLoading ?? this.isLoading,
      isInitial: isInitial ?? this.isInitial,
      localRestaurants: localRestaurants ?? this.localRestaurants,
      lastSelectedSigunguCodes: lastSelectedSigunguCodes ?? this.lastSelectedSigunguCodes,
      selectedSigunguCodes: selectedSigunguCodes ?? this.selectedSigunguCodes,
      isReachedEnd: isReachedEnd ?? this.isReachedEnd,
    );
  }
}

sealed class LocalRestaurantEvent extends Equatable {
  @override
  List<Object> get props => [];
}
final class SelectSigunguCodes extends LocalRestaurantEvent {
  final List<SigunguCode> sigunguCodes;

  SelectSigunguCodes(this.sigunguCodes);
}
final class LocalRestaurantFetched extends LocalRestaurantEvent { }

sealed class LocalRestaurantSideEffect { }
final class LocalRestaurantShowError extends LocalRestaurantSideEffect {
  final String message;

  LocalRestaurantShowError(this.message);
}

class LocalRestaurantBloc extends SideEffectBloc<LocalRestaurantEvent, LocalRestaurantState, LocalRestaurantSideEffect> {
  final TripRepository _tripRepository;

  LocalRestaurantBloc({
    required TripRepository tripRepository,
  }) : _tripRepository = tripRepository, super(LocalRestaurantState.initial()) {
    on<LocalRestaurantFetched>(
      _onLocalRestaurantFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<SelectSigunguCodes>(
      _onSelectSigunguCodes,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  void _onLocalRestaurantFetched(
    LocalRestaurantFetched event,
    Emitter<LocalRestaurantState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _tripRepository.getLocalRestaurants(state.selectedSigunguCodes);

      response.when(
        success: (data) {
          emit(
            state.copyWith(
              isLoading: false,
              isInitial: false,
              localRestaurants: List.of(state.localRestaurants)..addAll(data),
              selectedSigunguCodes: state.selectedSigunguCodes,
            )
          );
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(LocalRestaurantShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(LocalRestaurantShowError(e.toString()));
    }
  }

  void _onSelectSigunguCodes(
    SelectSigunguCodes event,
    Emitter<LocalRestaurantState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedSigunguCodes: event.sigunguCodes));

    try {
      final response = await _tripRepository.getLocalRestaurants(event.sigunguCodes);

      response.when(
        success: (data) {
          emit(
            state.copyWith(
              isLoading: false,
              localRestaurants: data,
              lastSelectedSigunguCodes: event.sigunguCodes,
            ),
          );
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(LocalRestaurantShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(LocalRestaurantShowError(e.toString()));
    }
  }
}