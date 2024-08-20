import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/response/tour_area_response.dart';
import '../../data/models/sigungu_code.dart';
import '../../data/models/trip_theme.dart';
import '../../data/repository/trip_repository.dart';

final class CategoryDetailState {
  final bool isLoading;
  final List<TourArea> tourAreas;
  final TripTheme selectedCategory;
  final List<SigunguCode> selectedSigunguCodes;

  CategoryDetailState({
    required this.isLoading,
    required this.tourAreas,
    required this.selectedCategory,
    required this.selectedSigunguCodes,
  });

  factory CategoryDetailState.initial() => CategoryDetailState(
    isLoading: true,
    tourAreas: [],
    selectedCategory: TripTheme.NATURAL,
    selectedSigunguCodes: [],
  );

  CategoryDetailState copyWith({
    bool? isLoading,
    List<TourArea>? tourAreas,
    TripTheme? selectedCategory,
    List<SigunguCode>? selectedSigunguCodes,
  }) {
    return CategoryDetailState(
      isLoading: isLoading ?? this.isLoading,
      tourAreas: tourAreas ?? this.tourAreas,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedSigunguCodes: selectedSigunguCodes ?? this.selectedSigunguCodes,
    );
  }
}

sealed class CategoryDetailEvent { }
final class SelectCategory extends CategoryDetailEvent {
  final TripTheme tripTheme;

  SelectCategory(this.tripTheme);
}
final class SelectSigunguCodes extends CategoryDetailEvent {
  final List<SigunguCode> sigunguCodes;

  SelectSigunguCodes(this.sigunguCodes);
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
    on<SelectCategory>(_onSelectCategory);
    on<SelectSigunguCodes>(_onSelectSigunguCodes);
  }

  void _onSelectCategory(
    SelectCategory event,
    Emitter<CategoryDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedCategory: event.tripTheme));

    try {
      final response = await _tripRepository.getTourAreas(state.selectedSigunguCodes, state.selectedCategory);

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

  void _onSelectSigunguCodes(
    SelectSigunguCodes event,
    Emitter<CategoryDetailState> emit,
  ) async {
    emit(state.copyWith(isLoading: true, selectedSigunguCodes: event.sigunguCodes));

    try {
      final response = await _tripRepository.getTourAreas(event.sigunguCodes, state.selectedCategory);

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