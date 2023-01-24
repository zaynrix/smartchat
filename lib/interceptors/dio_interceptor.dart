import 'package:dio/dio.dart';
import 'package:smartchat/utils/appConfig.dart';
// import 'package:bond_template/features/Home/homeProvider.dart';

class DioInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // sl<HomeProvider>().changeLoader(true);
    // sl<AuthProvider>().changeLoaderAuth(true);
    // options.headers['Authorization'] =
    //     "Bearer ${sl<SharedLocal>().getUser().accessToken}";
    // options.headers["lang"] = "${sl<SharedLocal>().getLanguage}";
    options.headers["Content-Type"] = "application/json";
    options.headers["X-Requested-With"] = "XMLHttpRequest";
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // sl<HomeProvider>().changeLoader(false);
    // sl<AuthProvider>().changeLoaderAuth(false);
    super.onResponse(response, handler);
  }

  @override
  onError(DioError err, ErrorInterceptorHandler handler) async {
    // sl<AuthProvider>().changeLoaderAuth(false);
    // sl<HomeProvider>().changeLoader(false);
    // sl<HomeProvider>().changeInit(false);
    AppConfig().showException(err);

    // super.onError(err, handler);
  }
}
