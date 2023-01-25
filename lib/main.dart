import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:smartchat/routing/navigation.dart';
import 'package:smartchat/routing/router.dart';
import 'package:smartchat/routing/routes.dart';
import 'package:smartchat/utils/appConfig.dart';

import 'features/Chat/providers/chat_provider.dart';
import 'features/Chat/providers/profile_provider.dart';
import 'features/Home/providers/home_provider.dart';
import 'features/Registration/providers/auth_provider.dart';
import 'interceptors/di.dart';
import 'resources/all_resources.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize instances
  await init();

  sl<AppConfig>().loadData();

  // Device Status Bar Color
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark),
  );
  // Localization
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
          // Provider
          return MultiProvider(
            providers: [
              // Auth Provider
              ChangeNotifierProvider<AuthProvider>(
                  create: (_) => AuthProvider()),
              // Profile Provider
              Provider<ProfileProvider>(create: (_) => ProfileProvider()),
              // Home Provider
              Provider<HomeProvider>(create: (_) => HomeProvider()),
              // Chat Provider
              Provider<ChatProvider>(create: (_) => ChatProvider())
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
