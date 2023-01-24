import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:smartchat/interceptors/di.dart';
import 'package:smartchat/interceptors/dio_exception.dart';
import 'package:smartchat/resources/color_manager.dart';
import 'package:smartchat/routing/navigation.dart';
// import 'package:bond_template/routing/routes.dart';
// import 'package:smartchat/routing/navigation.dart';
// import '../interceptors/dio_exception.dart';
// import 'package:bond_template/interceptors/di.dart';
// import 'package:bond_template/routing/navigation.dart';
// import 'package:bond_template/api/local/local_pref.dart';
// import 'package:bond_template/resources/color_manager.dart';
// import 'package:bond_template/features/Home/homeProvider.dart';
// import 'package:easy_localization/easy_localization.dart';

class AppConfig extends ChangeNotifier {
  // var shared = sl<SharedLocal>();

  Future<Timer> loadData() async {
    return Timer(const Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    // if (shared.firstIntro == true) {
    //   if (shared.getUser().accessToken == null) {
    //     sl<NavigationService>().navigateToAndRemove(Routes.login);
    //   } else {
    //     sl<HomeProvider>().getHome();
    //     sl<NavigationService>().navigateToAndRemove(Routes.home);
    //   }
    // } else {
    //   sl<SharedLocal>().firstIntro = true;
    //   sl<NavigationService>().navigateToAndRemove(Routes.intro);
    // }
  }

  TextTheme getTextContext(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  static showSnakBar(String content, {bool Success = false}) {
    return sl<NavigationService>()
        .snackBarKey
        .currentState
        ?.showSnackBar(SnackBar(
          content: Text(
            content.trim(),
          ),
          backgroundColor: Success ? ColorManager.primary : ColorManager.red,
          behavior: SnackBarBehavior.floating,
        ));
  }

  showException(DioError e) {
    final errorMessage = DioExceptions.fromDioError(e).toString();
    AppConfig.showSnakBar(
        "${e.response != null && e.response!.data["message"] != "" ? e.message : errorMessage}",
        Success: false);
  }
}
