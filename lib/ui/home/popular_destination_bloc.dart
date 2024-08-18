import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/popular_destination_response.dart';
import '../../data/repository/trip_repository.dart';

final class PopularDestinationState {
  final bool isLoading;
  final List<PopularDestination> popularDestinations;

  PopularDestinationState({
    required this.isLoading,
    required this.popularDestinations,
  });

  factory PopularDestinationState.initial() => PopularDestinationState(
    isLoading: true,
    popularDestinations: [],
  );

  PopularDestinationState copyWith({
    bool? isLoading,
    List<PopularDestination>? popularDestinations,
  }) {
    return PopularDestinationState(
      isLoading: isLoading ?? this.isLoading,
      popularDestinations: popularDestinations ?? this.popularDestinations,
    );
  }
}

sealed class PopularDestinationEvent { }
final class PopularDestinationFetched extends PopularDestinationEvent { }

sealed class PopularDestinationSideEffect { }
final class PopularDestinationShowError extends PopularDestinationSideEffect {
  final String message;

  PopularDestinationShowError(this.message);
}

class PopularDestinationBloc extends SideEffectBloc<PopularDestinationEvent, PopularDestinationState, PopularDestinationSideEffect> {
  final TripRepository _tripRepository;

  PopularDestinationBloc({
    required TripRepository tripRepository,
  }) : _tripRepository = tripRepository,
      super(PopularDestinationState.initial()) {
    on<PopularDestinationFetched>(_onPopularDestinationFetched,);
  }

  void _onPopularDestinationFetched(
    PopularDestinationFetched event,
    Emitter<PopularDestinationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _tripRepository.getPopularDestinations();

      response.when(
        success: (popularDestinations) {
          emit(state.copyWith(
            isLoading: false,
            popularDestinations: popularDestinations,
          ));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(PopularDestinationShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(PopularDestinationShowError(e.toString()));
    }
  }
}
