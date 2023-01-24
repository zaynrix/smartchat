import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartchat/routing/navigation.dart';

import 'features/Registration/providers/auth_provider.dart';
import 'features/splashScreen.dart';
import 'interceptors/di.dart';
import 'resources/all_resources.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await init();
  // SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(
      // prefs: prefs,
      ));
}

class MyApp extends StatelessWidget {
  // final SharedPreferences prefs;

  MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        debugShowCheckedModeBanner: false,
        title: 'Smart Talk',
        navigatorKey: sl<NavigationService>().navigatorKey,
        theme: getApplicationTheme(),
        home: SplashScreen(),
      ),
    );
  }
}
