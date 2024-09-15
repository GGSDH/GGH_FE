import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:gyeonggi_express/data/models/login_provider.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../constants.dart';
import '../../data/repository/auth_repository.dart';

final class MyPageState {
  final bool isLoading;
  final LoginProvider loginProvider;
  final String nickname;
  final String email;

  MyPageState({
    required this.isLoading,
    required this.loginProvider,
    required this.nickname,
    required this.email,
  });

  factory MyPageState.initial() {
    return MyPageState(
      isLoading: false,
      loginProvider: LoginProvider.kakao,
      nickname: "",
      email: "",
    );
  }

  MyPageState copyWith({
    bool? isLoading,
    LoginProvider? loginProvider,
    String? nickname,
    String? email,
  }) {
    return MyPageState(
      isLoading: isLoading ?? this.isLoading,
      loginProvider: loginProvider ?? this.loginProvider,
      nickname: nickname ?? this.nickname,
      email: email ?? this.email,
    );
  }
}

sealed class MyPageEvent { }
final class MyPageInitialize extends MyPageEvent { }
final class MyPageSettingButtonClicked extends MyPageEvent {
  final String email;
  final String nickname;
  final LoginProvider loginType;

  MyPageSettingButtonClicked({
    required this.email,
    required this.nickname,
    required this.loginType,
  });
}
final class MyPageLogOutButtonClicked extends MyPageEvent { }
final class MyPageWithdrawalButtonClicked extends MyPageEvent { }

sealed class MyPageSideEffect { }
final class MyPageNavigateToSetting extends MyPageSideEffect {
  final String email;
  final String nickname;
  final LoginProvider loginType;

  MyPageNavigateToSetting({
    required this.email,
    required this.nickname,
    required this.loginType,
  });
}
final class MyPageNavigateToLogin extends MyPageSideEffect { }
final class MyPageShowError extends MyPageSideEffect {
  final String message;

  MyPageShowError(this.message);
}

class MyPageBloc extends SideEffectBloc<MyPageEvent, MyPageState, MyPageSideEffect> {
  final AuthRepository _authRepository;
  final FlutterSecureStorage _storage;

  MyPageBloc({
    required AuthRepository authRepository,
    required FlutterSecureStorage secureStorage,
  }) : _authRepository = authRepository,
        _storage = secureStorage,
        super(MyPageState.initial()) {
    on<MyPageInitialize>(_onMyPageInitialize);
    on<MyPageSettingButtonClicked>(_onMyPageSettingButtonClicked);
    on<MyPageLogOutButtonClicked>(_onLogOut);
    on<MyPageWithdrawalButtonClicked>(_onWithdrawal);

    add(MyPageInitialize());
  }

  void _onMyPageInitialize(
    MyPageInitialize event,
    Emitter<MyPageState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _authRepository.getProfileInfo();

      response.when(
        success: (data) {
          emit(
            state.copyWith(
              isLoading: false,
              loginProvider: data.memberIdentificationType,
              nickname: data.nickname,
              email: "",
            )
          );
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(MyPageShowError(errorMessage));
        }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(MyPageShowError(e.toString()));
    }
  }

  void _onMyPageSettingButtonClicked(
    MyPageSettingButtonClicked event,
    Emitter<MyPageState> emit
  ) {
    produceSideEffect(
      MyPageNavigateToSetting(
        email: event.email,
        nickname: event.nickname,
        loginType: event.loginType,
      )
    );
  }

  void _onLogOut(
    MyPageLogOutButtonClicked event,
    Emitter<MyPageState> emit
  ) async {
    try {
      await _storage.delete(key: Constants.ACCESS_TOKEN_KEY);
      produceSideEffect(MyPageShowError("로그아웃 되었습니다."));
      Future.delayed(const Duration(milliseconds: 500), () => produceSideEffect(MyPageNavigateToLogin()));
    } catch (e) {
      produceSideEffect(MyPageShowError("로그아웃 중 오류가 발생했습니다: ${e.toString()}"));
    }
  }

  void _onWithdrawal(
    MyPageWithdrawalButtonClicked event,
    Emitter<MyPageState> emit
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _authRepository.withdrawal();

      response.when(
        success: (data) async {
          emit(state.copyWith(isLoading: false));

          if (data) {
            await _storage.delete(key: Constants.ACCESS_TOKEN_KEY);
            produceSideEffect(MyPageShowError("탈퇴되었습니다"));
            produceSideEffect(MyPageNavigateToLogin());
          } else {
            produceSideEffect(MyPageShowError("탈퇴에 실패했습니다"));
          }
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(MyPageShowError(errorMessage));
        }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(MyPageShowError(e.toString()));
    }
  }
}
