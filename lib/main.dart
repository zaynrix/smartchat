import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smartchat/routing/navigation.dart';
import 'package:smartchat/routing/router.dart';
import 'package:smartchat/routing/routes.dart';

import 'features/Registration/providers/auth_provider.dart';
import 'interceptors/di.dart';
import 'resources/all_resources.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();

  // Device Status Bar Color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark),
  );

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('ar'),
      ],
      path: 'assets/translations',
      startLocale: Locale("en"),
      fallbackLocale: const Locale("en"),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(414, 896),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              // ChangeNotifierProvider.value(value: HomeNotifier()),
              // ChangeNotifierProvider.value(value: CallNotifier()),
              ChangeNotifierProvider<AuthProvider>(
                  create: (_) => AuthProvider(
                      // firebaseFirestore: firebaseFirestore,
                      // googleSignIn: GoogleSignIn(),
                      // firebaseAuth: FirebaseAuth.instance
                      //
                      )),
              // Provider<ProfileProvider>(
              //     create: (_) => ProfileProvider(
              //         prefs: prefs,
              //         firebaseFirestore: firebaseFirestore,
              //         firebaseStorage: firebaseStorage)),
              // Provider<HomeProvider>(
              //     create: (_) => HomeProvider(firebaseFirestore: firebaseFirestore)),
              // Provider<ChatProvider>(
              //     create: (_) => ChatProvider(
              //         prefs: prefs,
              //         firebaseStorage: firebaseStorage,
              //         firebaseFirestore: firebaseFirestore))
            ],
            child: MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              scaffoldMessengerKey: sl<NavigationService>().snackBarKey,
              debugShowCheckedModeBanner: false,
              title: 'Smart Chat',
              navigatorKey: sl<NavigationService>().navigatorKey,
              theme: getApplicationTheme(),
              initialRoute: Routes.splash,
              onGenerateRoute: RouterX.generateRoute,
            ),
          );
        });
  }
}
