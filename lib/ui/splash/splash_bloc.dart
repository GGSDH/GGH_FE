import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gyeonggi_express/data/repository/auth_repository.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/models/user_role.dart';

final class SplashState {
  final bool isLoading;

  SplashState({required this.isLoading});

  factory SplashState.initial() {
    return SplashState(isLoading: false);
  }

  SplashState copyWith({bool? isLoading}) {
    return SplashState(isLoading: isLoading ?? this.isLoading);
  }
}

sealed class SplashEvent { }
final class InitializeSplash extends SplashEvent { }

final class SplashSideEffect { }
final class SplashNavigateToMain extends SplashSideEffect { }
final class SplashNavigateToLogin extends SplashSideEffect { }

class SplashBloc extends SideEffectBloc<SplashEvent, SplashState, SplashSideEffect> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;

  SplashBloc({
    required AuthRepository authRepository,
    required FlutterSecureStorage storage,
  }) : _authRepository = authRepository,
       _storage = storage,
        super(SplashState.initial()) {
    on<InitializeSplash>(_onInitialize);
  }

  void _onInitialize(
    InitializeSplash event,
    Emitter<SplashState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final token = await _storage.read(key: Constants.ACCESS_TOKEN_KEY);
      if (token == null || token.isEmpty) {
        emit(state.copyWith(isLoading: false));
        produceSideEffect(SplashNavigateToLogin());
        return;
      }

      final response = await _authRepository.getProfileInfo();

      response.when(
          success: (data) {
            emit(state.copyWith(isLoading: false));
            final role = data.role;
            if (role == UserRole.roleUser) {
              produceSideEffect(SplashNavigateToMain());
            } else {
              produceSideEffect(SplashNavigateToLogin());
            }
          },
          apiError: (errorMessage, errorCode) {
            emit(state.copyWith(isLoading: false));
            produceSideEffect(SplashNavigateToLogin());
          }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(SplashNavigateToLogin());
    }
  }
}