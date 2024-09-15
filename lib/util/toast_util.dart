import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../ui/component/app/app_toast_message.dart';

class ToastUtil {
  static FToast? _fToast;

  static void init(BuildContext context) {
    if (_fToast == null) {
      _fToast = FToast();
      _fToast?.init(context);
    }
  }

  static void showToast(BuildContext context, String message) {
    init(context);
    cancelAllToast();
    _fToast?.showToast(
      child: AppToastMessage(message: message),
    );
  }

  static void cancelAllToast() {
    _fToast?.removeQueuedCustomToasts();
  }
}