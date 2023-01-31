import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartchat/api/local/local_pref.dart';
import 'package:smartchat/interceptors/firebase_config.dart';
import 'package:smartchat/routing/navigation.dart';
import 'package:smartchat/utils/appConfig.dart';

import '../features/Registration/providers/auth_provider.dart';

final sl = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Dio client = Dio(
  //   BaseOptions(
  //     receiveDataWhenStatusError: true,
  //     connectTimeout: 50000,
  //     receiveTimeout: 30000,
  //     responseType: ResponseType.json,
  //     baseUrl: '${Endpoints.baseUrl}',
  //     contentType: 'application/json',
  //   ),
  // );
  // sl.registerLazySingleton<Dio>(() => client);
  sl.registerLazySingleton(() => AppConfig());
  sl.registerLazySingleton(() => NavigationService());
  sl.registerLazySingleton(() => AuthProvider());

  sl.registerLazySingleton<FirebaseAuth>(() => firebaseAuth);
  sl.registerLazySingleton<FirebaseStorage>(() => firebaseStorage);
  sl.registerLazySingleton<GoogleSignIn>(() => googleSignIn);
  sl.registerLazySingleton<FirebaseFirestore>(() => firebaseFirestore);
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton<SharedLocal>(
    () => SharedLocal(
      sharedPreferences: sl(),
    ),
  );
}
