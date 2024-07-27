import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gyeonggi_express/data/models/login_provider.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/models/user_role.dart';
import '../../data/repository/auth_repository.dart';

sealed class LoginState { }
final class LoginInitial extends LoginState { }
final class LoginLoading extends LoginState { }
final class LoginSuccess extends LoginState { }
final class LoginFailure extends LoginState { }

sealed class LoginEvent { }
final class LoginButtonClicked extends LoginEvent { }

sealed class LoginSideEffect { }
final class LoginNavigateToHome extends LoginSideEffect { }
final class LoginNavigateToSignUp extends LoginSideEffect { }
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
        super(LoginInitial()) {
    on<LoginButtonClicked>(_onLoginButtonClicked);
  }

  void _onLoginButtonClicked(
    LoginButtonClicked event,
    Emitter<LoginState> emit
  ) async {
    emit(LoginLoading());

    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      final response = await _authRepository.socialLogin(
        accessToken: token.accessToken,
        refreshToken: token.refreshToken ?? "",
        provider: LoginProvider.kakao,
      );

      await response.when(
        success: (data) async {
          await _storage.write(
            key: Constants.ACCESS_TOKEN_KEY,
            value: data.token.accessToken,
          ).whenComplete(() {
            if (data.role == UserRole.roleUser) {
              produceSideEffect(LoginNavigateToHome());
            } else {
              produceSideEffect(LoginNavigateToSignUp());
            }
            emit(LoginSuccess());
          });
        },
        apiError: (errorMessage, errorCode) {
          produceSideEffect(LoginShowError(errorMessage));
          emit(LoginFailure());
        }
      );
    } catch (error) {
      produceSideEffect(LoginShowError(error.toString()));
      emit(LoginFailure());
    }
  }

  void login() {
    add(LoginButtonClicked());
  }
}
