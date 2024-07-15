import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

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
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonClicked>(_onLoginButtonClicked);
  }

  void _onLoginButtonClicked(
    LoginButtonClicked event,
    Emitter<LoginState> emit
  ) async {
    emit(LoginLoading());
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      emit(LoginSuccess());
      print(token.accessToken);
    } catch (error) {
      emit(LoginFailure(error.toString()));
    }
  }

  void login() {
    add(LoginButtonClicked());
  }
}
