import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../../data/models/response/onboarding_response.dart';
import '../../../data/repository/auth_repository.dart';

final class AddPhotobookSelectThemeState {
  final bool isLoading;
  final List<OnboardingTheme> themes;
  final List<String> selectedThemes;

  AddPhotobookSelectThemeState({
    required this.isLoading,
    required this.themes,
    required this.selectedThemes
  });

  factory AddPhotobookSelectThemeState.initial() {
    return AddPhotobookSelectThemeState(
      isLoading: false,
      themes: [],
      selectedThemes: []
    );
  }

  AddPhotobookSelectThemeState copyWith({
    bool? isLoading,
    List<OnboardingTheme>? themes,
    List<String>? selectedThemes
  }) {
    return AddPhotobookSelectThemeState(
      isLoading: isLoading ?? this.isLoading,
      themes: themes ?? this.themes,
      selectedThemes: selectedThemes ?? this.selectedThemes
    );
  }
}

sealed class AddPhotobookSelectThemeEvent { }
final class AddPhotobookSelectThemeInitialize extends AddPhotobookSelectThemeEvent { }
final class AddPhotobookSelectThemeSelectTheme extends AddPhotobookSelectThemeEvent {
  final String themeId;

  AddPhotobookSelectThemeSelectTheme(this.themeId);
}
final class AddPhotobookSelectThemeNextButtonClicked extends AddPhotobookSelectThemeEvent {
  AddPhotobookSelectThemeNextButtonClicked({ required this.selectedThemes });

  final List<String> selectedThemes;
}

sealed class AddPhotobookSelectThemeSideEffect { }
final class AddPhotobookSelectThemeComplete extends AddPhotobookSelectThemeSideEffect { }
final class AddPhotobookSelectThemeShowError extends AddPhotobookSelectThemeSideEffect {
  final String message;

  AddPhotobookSelectThemeShowError(this.message);
}

class AddPhotobookSelectThemeBloc extends SideEffectBloc<AddPhotobookSelectThemeEvent, AddPhotobookSelectThemeState, AddPhotobookSelectThemeSideEffect> {
  final AuthRepository _authRepository;

  AddPhotobookSelectThemeBloc({
    required AuthRepository authRepository
  }) : _authRepository = authRepository,
        super(AddPhotobookSelectThemeState.initial()) {
    on<AddPhotobookSelectThemeNextButtonClicked>(_onNextButtonClicked);
    on<AddPhotobookSelectThemeInitialize>(_onInitialize);
    on<AddPhotobookSelectThemeSelectTheme>(_onSelectTheme);

    add(AddPhotobookSelectThemeInitialize());
  }

  Future<void> _onNextButtonClicked(
    AddPhotobookSelectThemeNextButtonClicked event,
    Emitter<AddPhotobookSelectThemeState> emit
  ) async {
    if (event.selectedThemes.isEmpty) {
      produceSideEffect(AddPhotobookSelectThemeShowError('여행 테마를 선택해 주세요'));
      return;
    }

    produceSideEffect(AddPhotobookSelectThemeComplete());
  }

  Future<void> _onInitialize(
    AddPhotobookSelectThemeInitialize event,
    Emitter<AddPhotobookSelectThemeState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _authRepository.getOnboardingThemes();

      response.when(
          success: (data) {
            emit(state.copyWith(isLoading: false, themes: data));
          },
          apiError: (errorMessage, errorCode) {
            emit(state.copyWith(isLoading: false));
            produceSideEffect(AddPhotobookSelectThemeShowError(errorMessage));
          }
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(AddPhotobookSelectThemeShowError(error.toString()));
    }
  }

  void _onSelectTheme(
    AddPhotobookSelectThemeSelectTheme event,
    Emitter<AddPhotobookSelectThemeState> emit
  ) {
    final selectedThemes = List<String>.from(state.selectedThemes);
    if (selectedThemes.contains(event.themeId)) {
      selectedThemes.remove(event.themeId);
    } else {
      selectedThemes.add(event.themeId);
    }

    emit(state.copyWith(selectedThemes: selectedThemes));
  }
}