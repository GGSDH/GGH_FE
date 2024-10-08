import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/models/response/onboarding_response.dart';
import '../../data/repository/auth_repository.dart';

final class OnboardingState {
  final bool isLoading;
  final List<OnboardingTheme> themes;
  final List<String> selectedThemes;

  OnboardingState({
    required this.isLoading,
    required this.themes,
    required this.selectedThemes
  });

  factory OnboardingState.initial() {
    return OnboardingState(
      isLoading: false,
      themes: [],
      selectedThemes: []
    );
  }

  OnboardingState copyWith({
    bool? isLoading,
    List<OnboardingTheme>? themes,
    List<String>? selectedThemes
  }) {
    return OnboardingState(
      isLoading: isLoading ?? this.isLoading,
      themes: themes ?? this.themes,
      selectedThemes: selectedThemes ?? this.selectedThemes
    );
  }
}


sealed class OnboardingEvent { }
final class OnboardingInitialize extends OnboardingEvent { }
final class OnboardingSelectTheme extends OnboardingEvent {
  final String themeId;

  OnboardingSelectTheme(this.themeId);
}
final class OnboardingNextButtonClicked extends OnboardingEvent {
  OnboardingNextButtonClicked({ required this.selectedThemes });

  final List<String> selectedThemes;
}

sealed class OnboardingSideEffect { }
final class OnboardingComplete extends OnboardingSideEffect { }
final class OnboardingShowError extends OnboardingSideEffect {
  final String message;

  OnboardingShowError(this.message);
}

class OnboardingBloc extends SideEffectBloc<OnboardingEvent, OnboardingState, OnboardingSideEffect> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;

  OnboardingBloc({
    required AuthRepository authRepository,
    required FlutterSecureStorage secureStorage,
  }) : _authRepository = authRepository,
        _storage = secureStorage,
        super(OnboardingState.initial()) {
    on<OnboardingNextButtonClicked>(_onNextButtonClicked);
    on<OnboardingInitialize>(_onInitialize);
    on<OnboardingSelectTheme>(_onSelectTheme);

    add(OnboardingInitialize());
  }

  Future<void> _onNextButtonClicked(
    OnboardingNextButtonClicked event,
    Emitter<OnboardingState> emit
  ) async {
    if (event.selectedThemes.isEmpty) {
      produceSideEffect(OnboardingShowError('여행 테마를 선택해 주세요'));
      return;
    }

    try {
      final response = await _authRepository.setOnboardingInfo(themeIds: event.selectedThemes);

      response.when(
        success: (data) async {
          await refreshAccessToken();
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(OnboardingShowError(errorMessage));
        }
      );
    } catch (error) {
      produceSideEffect(OnboardingShowError(error.toString()));
    }
  }

  Future<void> refreshAccessToken() async {
    try {
      final response = await _authRepository.refreshAccessToken();

      response.when(
        success: (data) async {
          await _storage.write(
            key: Constants.ACCESS_TOKEN_KEY,
            value: data.token,
          ).whenComplete(() {
            produceSideEffect(OnboardingComplete());
          });
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(OnboardingShowError(errorMessage));
        }
      );
    } catch (error) {
      produceSideEffect(OnboardingShowError(error.toString()));
    }
  }

  Future<void> _onInitialize(
    OnboardingInitialize event,
    Emitter<OnboardingState> emit
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
          produceSideEffect(OnboardingShowError(errorMessage));
        }
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(OnboardingShowError(error.toString()));
    }
  }

  void _onSelectTheme(
    OnboardingSelectTheme event,
    Emitter<OnboardingState> emit
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
