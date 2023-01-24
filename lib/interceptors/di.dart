import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartchat/api/endPoints.dart';
import 'package:smartchat/api/local/local_pref.dart';
import 'package:smartchat/interceptors/firebase_config.dart';
import 'package:smartchat/routing/navigation.dart';
import 'package:smartchat/utils/appConfig.dart';

import '../features/Registration/providers/auth_provider.dart';
import 'dio_interceptor.dart';
// import 'package:bond_template/api/endPoints.dart';
// import 'package:bond_template/utils/appConfig.dart';
// import 'package:bond_template/routing/navigation.dart';
// import 'package:bond_template/api/remote/auth_api.dart';
// import 'package:bond_template/api/local/local_pref.dart';
// import 'package:bond_template/features/Registration/homeProvider.dart';
// import 'package:bond_template/repository/home_repo/task_repo.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:bond_template/repository/user_repo/login_repo.dart';
// import 'package:bond_template/features/Registrations/auth_provider.dart';

import 'logger_interceptor.dart';

final sl = GetIt.instance;
final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
FirebaseAuth firebaseAuth = FirebaseAuth.instance;
final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

Future<void> init() async {
  Dio client = Dio(
    BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: 50000,
      receiveTimeout: 30000,
      responseType: ResponseType.json,
      baseUrl: '${Endpoints.baseUrl}',
      contentType: 'application/json',
    ),
  );
  sl.registerLazySingleton<Dio>(() => client);

  client
    ..interceptors
    ..interceptors.addAll([
      DioInterceptor(),
      if (kDebugMode) LoggerInterceptor(),
    ]);
  sl.registerLazySingleton(() => AppConfig());
  sl.registerLazySingleton(() => NavigationService());
  // sl.registerLazySingleton(() => LoginRepository());
  // sl.registerLazySingleton(() => SettingRepository());
  // sl.registerLazySingleton(() => HomeRepository());

  // sl.registerLazySingleton(() => HomeProvider());
  // sl.registerLazySingleton(() => SettingProvider());
  sl.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  sl.registerLazySingleton<GoogleSignIn>(() => googleSignIn);
  sl.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);

  sl.registerLazySingleton(() => AuthProvider(
      // firebaseFirestore: firebaseFirestore,
      // googleSignIn: GoogleSignIn(),
      // firebaseAuth: FirebaseAuth.instance
      //
      ));
  // sl.registerLazySingleton<HttpAuth>(() => HttpAuth(client: sl()));

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<SharedLocal>(
    () => SharedLocal(
      sharedPreferences: sl(),
    ),
  );
}
