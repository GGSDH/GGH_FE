import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gyeonggi_express/data/models/login_provider.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

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
final class MyPageSettingButtonClicked extends MyPageEvent { }

sealed class MyPageSideEffect { }
final class MyPageNavigateToSetting extends MyPageSideEffect { }
final class MyPageShowError extends MyPageSideEffect {
  final String message;

  MyPageShowError(this.message);
}

class MyPageBloc extends SideEffectBloc<MyPageEvent, MyPageState, MyPageSideEffect> {
  final AuthRepository _authRepository;

  MyPageBloc({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository,
        super(MyPageState.initial()) {
    on<MyPageInitialize>(_onMyPageInitialize);
    on<MyPageSettingButtonClicked>(_onMyPageSettingButtonClicked);

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
    produceSideEffect(MyPageNavigateToSetting());
  }
}
