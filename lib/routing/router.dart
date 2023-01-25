import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartchat/features/Home/screens/homeScreen.dart';
import 'package:smartchat/features/Registration/providers/auth_provider.dart';
import 'package:smartchat/features/Registration/screens/loginScreen.dart';
import 'package:smartchat/features/splashScreen.dart';
import 'package:smartchat/interceptors/di.dart';
import 'package:smartchat/routing/routes.dart';
import 'package:smartchat/utils/appConfig.dart';
// import 'package:bond_template/routing/routes.dart';
// import 'package:bond_template/interceptors/di.dart';
// import 'package:bond_template/utils/appConfig.dart';
// import 'package:bond_template/features/splashScreen.dart';
// import 'package:bond_template/features/Registration/homeScreen.dart';
// import 'package:bond_template/features/onBoardingScreen.dart';
// import 'package:bond_template/features/Registrations/loginScreen.dart';
// import 'package:bond_template/features/Registrations/signUpScreen.dart';
// import 'package:bond_template/features/Registrations/auth_provider.dart';
// import 'package:bond_template/features/Registrations/forgetPasswordScreen.dart';
// import 'package:bond_template/features/Registrations/createNewPasswordScreen.dart';

class RouterX {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {

      // ------------- Splash Screen ---------------

      case Routes.splash:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: sl<AppConfig>(),
            child: SplashScreen(),
          ),
        );

      // ------------- Introduction Screens ---------------
      case Routes.intro:
      //   return MaterialPageRoute(
      //     builder: (_) => const Introduction(),
      //   );
      //
      // // ------------- Login Screen ---------------
      case Routes.login:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: sl<AuthProvider>(),
            child: LoginPage(),
          ),
        );

      // // ------------- Forget Password Screen ---------------
      // case Routes.forgetPassword:
      //   return MaterialPageRoute(
      //     builder: (_) => ChangeNotifierProvider.value(
      //       value: sl<AuthProvider>(),
      //       child: ForgetPassword(),
      //     ),
      //   );
      //
      // // ------------- Create Password Screen ---------------
      //
      // case Routes.createNewPassword:
      //   return MaterialPageRoute(
      //     builder: (_) => ChangeNotifierProvider.value(
      //       value: sl<AuthProvider>(),
      //       child: CreateNewPassword(),
      //     ),
      //   );
      //
      // // ------------- Signup Screen ---------------
      //
      // case Routes.signUp:
      //   return MaterialPageRoute(
      //     builder: (_) => ChangeNotifierProvider.value(
      //       value: sl<AuthProvider>(),
      //       child: Signup(),
      //     ),
      //   );
      //
      // // ------------- Home Screen ---------------
      //
      case Routes.home:
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );

      //

      // ------------- Default Route ---------------
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
