// import 'package:bond_template/api/endPoints.dart';
// import 'package:bond_template/interceptors/di.dart';
// import 'package:bond_template/models/loginModel.dart';
// import 'package:bond_template/api/local/local_pref.dart';
// import 'package:bond_template/api/remote/auth_api.dart';
//
// class LoginRepository {
//
//   // ------------------ User Login ------------------
//   Future<LoginResponse> userLogin({
//     required String email,
//     required String password,
//   }) async {
//     final response = await sl<HttpAuth>().postData(
//       url:  Endpoints.userAuth+Endpoints.login,
//       data: {
//         'email': email,
//         'password': password,
//       },
//     );
//
//     LoginResponse loginResponse = LoginResponse.fromJson(response.data);
//     if (loginResponse.status == true) {
//       return loginResponse;
//     }
//     throw '${loginResponse.message}';
//   }
//
//   // ------------------ User Signup ------------------
//   Future<LoginResponse> userSignup({
//     required String name,
//     required String email,
//     required String gender,
//     required String password,
//   }) async {
//     final response = await sl<HttpAuth>().postData(
//       url: Endpoints.userAuth+Endpoints.signUp,
//       data: {
//         'email': email,
//         'password': password,
//         'full_name': name,
//         'gender': gender.toUpperCase(),
//       },
//     );
//     LoginResponse loginResponse = LoginResponse.fromJson(response.data);
//     if (loginResponse.status == true) {
//       return loginResponse;
//     }
//     throw '${loginResponse.message}';
//   }
//
//   // ------------------ User Forget Password ------------------
//   Future<LoginResponse> userForgetPassword({
//     required String email,
//   }) async {
//     final response = await sl<HttpAuth>().postData(
//       url: Endpoints.userAuth+Endpoints.forgetPassword,
//       data: {
//         'email': email,
//       },
//     );
//     LoginResponse loginResponse = LoginResponse.fromJson(response.data);
//     if (loginResponse.status == true) {
//       return loginResponse;
//     }
//     throw '${loginResponse.message}';
//   }
//
//   // ------------------ User Change Password ------------------
//
//   Future<LoginResponse> changePassword(
//       {String? currentPassword, String? newPassword}) async {
//     final response = await sl<HttpAuth>().postData(
//       url: Endpoints.userAuth+Endpoints.resetPassword,
//       data: {
//         "email": "${sl<SharedLocal>().getSignUpTempo()}",
//         "code": "${sl<SharedLocal>().geCode}",
//         "password": "$currentPassword",
//         "password_confirmation": "$newPassword",
//       },
//     );
//
//     LoginResponse users = LoginResponse.fromJson(response.data);
//     if (users.status == true) {
//       return users;
//     }
//
//     throw '${users.message}';
//   }
// }
