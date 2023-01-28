import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smartchat/features/Registration/providers/auth_provider.dart';
import 'package:smartchat/interceptors/di.dart';
import 'package:smartchat/routing/navigation.dart';
import 'package:smartchat/routing/routes.dart';

class AppConfig extends ChangeNotifier {
  // Delay Function
  Future<Timer> loadData() async {
    return Timer(const Duration(seconds: 3), onDoneLoading);
  }

  // OnBoarding Function
  onDoneLoading() async {
    final authProvider = sl<AuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      sl<NavigationService>().navigateToAndRemove(Routes.home);
      return;
    } else {
      sl<NavigationService>().navigateToAndRemove(Routes.login);
    }
  }

// SnackBar Utilities
// static showSnakBar(String content, {bool Success = false}) {
//   return sl<NavigationService>()
//       .snackBarKey
//       .currentState
//       ?.showSnackBar(SnackBar(
//         content: Text(
//           content.trim(),
//         ),
//         backgroundColor: Success ? ColorManager.primary : ColorManager.red,
//         behavior: SnackBarBehavior.floating,
//       ));
// }
//
// // Exception Utility
// showException(DioError e) {
//   final errorMessage = DioExceptions.fromDioError(e).toString();
//   AppConfig.showSnakBar(
//       "${e.response != null && e.response!.data["message"] != "" ? e.message : errorMessage}",
//       Success: false);
// }
}
