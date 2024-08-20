import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/tour_area_response.dart';
import '../../data/models/sigungu_code.dart';
import '../../data/models/trip_theme.dart';
import '../../data/repository/trip_repository.dart';

final class CategoryDetailState {
  final bool isLoading;
  final List<TourArea> tourAreas;

  CategoryDetailState({
    required this.isLoading,
    required this.tourAreas,
  });

  factory CategoryDetailState.initial() => CategoryDetailState(
    isLoading: true,
    tourAreas: [],
  );

  CategoryDetailState copyWith({
    bool? isLoading,
    List<TourArea>? tourAreas,
  }) {
    return CategoryDetailState(
      isLoading: isLoading ?? this.isLoading,
      tourAreas: tourAreas ?? this.tourAreas,
    );
  }
}

sealed class CategoryDetailEvent { }
final class CategoryDetailFetched extends CategoryDetailEvent {
  final TripTheme tripTheme;
  final List<SigunguCode> sigunguCodes;

  CategoryDetailFetched({
    required this.tripTheme,
    required this.sigunguCodes,
  });
}

sealed class CategoryDetailSideEffect { }
final class CategoryDetailShowError extends CategoryDetailSideEffect {
  final String message;

  CategoryDetailShowError(this.message);
}

class CategoryDetailBloc extends SideEffectBloc<CategoryDetailEvent, CategoryDetailState, CategoryDetailSideEffect> {
  final TripRepository _tripRepository;

  CategoryDetailBloc({
    required TripRepository tripRepository,
  }) : _tripRepository = tripRepository,
       super(CategoryDetailState.initial()) {
    on<CategoryDetailFetched>(_onCategoryDetailFetched);
  }

  void _onCategoryDetailFetched(
    CategoryDetailFetched event,
    Emitter<CategoryDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _tripRepository.getTourAreas(event.sigunguCodes, event.tripTheme);

      response.when(
        success: (tourAreas) {
          emit(state.copyWith(isLoading: false, tourAreas: tourAreas));
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(CategoryDetailShowError(errorMessage));
        },
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(CategoryDetailShowError(e.toString()));
    }
  }
}