import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ui/component/app/app_toast_message.dart';

class ToastUtil {
  static FToast? _fToast;
  static BuildContext? _previousContext;

  static void init(BuildContext context) {
    // context가 변경된 경우에만 초기화
    if (_fToast == null || _previousContext != context) {
      _fToast = FToast();
      _fToast?.init(context);
      _previousContext = context; // 현재 context 저장
    }
  }

  static void showToast(BuildContext context, String message, {double bottomPadding = 80}) {
    init(context); // 필요할 때만 초기화 호출
    cancelAllToast(); // 기존 토스트 제거
    _fToast?.showToast(
      child: AppToastMessage(
        message: message,
        bottomPadding: bottomPadding,
      ),
    );
  }

  static void cancelAllToast() {
    _fToast?.removeQueuedCustomToasts();
  }
}
