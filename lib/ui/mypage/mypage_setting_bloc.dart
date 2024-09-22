import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:side_effect_bloc/side_effect_bloc.dart';

import '../../data/models/login_provider.dart';
import '../../data/repository/auth_repository.dart';
import '../../util/event_bus.dart';

final class MyPageSettingState {
  final bool isLoading;
  final String nickname;
  final LoginProvider loginType;

  MyPageSettingState({
    required this.isLoading,
    required this.nickname,
    required this.loginType
  });

  factory MyPageSettingState.initial() {
    return MyPageSettingState(
      isLoading: false,
      nickname: "",
      loginType: LoginProvider.kakao,
    );
  }

  MyPageSettingState copyWith({
    bool? isLoading,
    String? email,
    String? nickname,
    LoginProvider? loginType,
  }) {
    return MyPageSettingState(
      isLoading: isLoading ?? this.isLoading,
      nickname: nickname ?? this.nickname,
      loginType: loginType ?? this.loginType,
    );
  }
}

sealed class MyPageSettingEvent { }
final class MyPageSettingInitialize extends MyPageSettingEvent {
  final String nickname;
  final LoginProvider loginType;

  MyPageSettingInitialize({
    required this.nickname,
    required this.loginType
  });
}
final class MyPageSettingSaveButtonClicked extends MyPageSettingEvent {
  final String nickname;

  MyPageSettingSaveButtonClicked({
    required this.nickname,
  });
}
final class MyPageSettingNicknameChanged extends MyPageSettingEvent {
  final String nickname;

  MyPageSettingNicknameChanged(this.nickname);
}

sealed class MyPageSettingSideEffect { }
final class MyPageSettingNavigateToMyPage extends MyPageSettingSideEffect { }
final class MyPageSettingShowError extends MyPageSettingSideEffect {
  final String message;

  MyPageSettingShowError(this.message);
}

class MyPageSettingBloc extends SideEffectBloc<MyPageSettingEvent, MyPageSettingState, MyPageSettingSideEffect> {
  final AuthRepository _authRepository;

  MyPageSettingBloc({
    required AuthRepository authRepository,
  }) : _authRepository = authRepository,
        super(MyPageSettingState.initial()) {
    on<MyPageSettingInitialize>(_onInitialize);
    on<MyPageSettingSaveButtonClicked>(_onSaveButtonClicked);
    on<MyPageSettingNicknameChanged>(onNicknameChanged);
  }

  void _onInitialize(
    MyPageSettingInitialize event,
    Emitter<MyPageSettingState> emit,
  ) {
    emit(
      state.copyWith(
        nickname: event.nickname,
        loginType: event.loginType,
      )
    );
  }

  void _onSaveButtonClicked(
    MyPageSettingSaveButtonClicked event,
    Emitter<MyPageSettingState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final response = await _authRepository.updateNickname(
        nickname: event.nickname
      );

      response.when(
        success: (data) {
          emit(
            state.copyWith(
              isLoading: false,
              nickname: event.nickname,
            )
          );
          EventBus().fire(ChangeNicknameEvent(event.nickname));
          produceSideEffect(MyPageSettingNavigateToMyPage());
        },
        apiError: (errorMessage, errorCode) {
          emit(state.copyWith(isLoading: false));
          produceSideEffect(MyPageSettingShowError(errorMessage));
        }
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      produceSideEffect(MyPageSettingShowError(e.toString()));
    }
  }

  void onNicknameChanged(
    MyPageSettingNicknameChanged event,
    Emitter<MyPageSettingState> emit,
  ) {
    emit(state.copyWith(nickname: event.nickname));
  }

}