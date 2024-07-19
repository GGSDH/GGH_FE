import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../../data/repository/auth_repository.dart';

sealed class LoginState { }
final class LoginInitial extends LoginState { }
final class LoginLoading extends LoginState { }
final class LoginSuccess extends LoginState { }
final class LoginFailure extends LoginState {
  final String error;

  LoginFailure(this.error);
}

sealed class LoginEvent { }
final class LoginButtonClicked extends LoginEvent { }


class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository _authRepository;

  LoginBloc({
    required AuthRepository authRepository
  }) : _authRepository = authRepository, super(LoginInitial()) {
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
        provider: 'KAKAO',
      );

      response.when(
        success: (data) {
          emit(LoginSuccess());
        },
        apiError: (errorMessage, errorCode) {
          emit(LoginFailure(errorMessage));
        },
      );
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }

  void login() {
    add(LoginButtonClicked());
  }
}
