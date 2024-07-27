import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gyeonggi_express/data/models/login_provider.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/models/user_role.dart';
import '../../data/repository/auth_repository.dart';

final class LoginState {
  final bool isLoading;

  LoginState({required this.isLoading});

  factory LoginState.initial() {
    return LoginState(isLoading: false);
  }

  LoginState copyWith({bool? isLoading}) {
    return LoginState(isLoading: isLoading ?? this.isLoading);
  }
}

sealed class LoginEvent { }
final class LoginButtonClicked extends LoginEvent { }

sealed class LoginSideEffect { }
final class LoginNavigateToHome extends LoginSideEffect { }
final class LoginNavigateToOnboarding extends LoginSideEffect { }
final class LoginShowError extends LoginSideEffect {
  final String message;

  LoginShowError(this.message);
}

class LoginBloc extends SideEffectBloc<LoginEvent, LoginState, LoginSideEffect> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;

  LoginBloc({
    required AuthRepository authRepository,
    required FlutterSecureStorage secureStorage,
  }) : _authRepository = authRepository,
        _storage = secureStorage,
        super(LoginState.initial()) {
    on<LoginButtonClicked>(_onLoginButtonClicked);
  }

  void _onLoginButtonClicked(
    LoginButtonClicked event,
    Emitter<LoginState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      final response = await _authRepository.socialLogin(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken ?? "",
        provider: LoginProvider.kakao,
      );

      await response.when(
        success: (data) async {
          emit(state.copyWith(isLoading: false));
          await _storage.write(
            key: Constants.ACCESS_TOKEN_KEY,
            value: data.token.accessToken,
          ).whenComplete(() {
            if (data.role == UserRole.roleUser) {
              produceSideEffect(LoginNavigateToHome());
            } else {
              produceSideEffect(LoginNavigateToOnboarding());
            }
          });
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(LoginShowError(errorMessage));
        }
      );
    } catch (error) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(LoginShowError(error.toString()));
    }
  }

  void login() {
    add(LoginButtonClicked());
  }
}
