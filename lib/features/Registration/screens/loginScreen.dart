import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smartchat/features/Home/screens/homeScreen.dart';
import 'package:smartchat/resources/all_resources.dart';

import '../../../utils/enums.dart';
import '../providers/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    switch (authProvider.status) {
      case Status.authenticateError:
        Fluttertoast.showToast(msg: 'Sign in failed');
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: 'Sign in cancelled');
        break;
      case Status.authenticated:
        Fluttertoast.showToast(msg: 'Sign in successful');
        break;
      default:
        break;
    }

    return Scaffold(
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(
              vertical: Sizes.dimen_30,
              horizontal: Sizes.dimen_20,
            ),
            children: [
              vertical50,
              Center(
                  child: Image.asset(
                'assets/images/logo.png',
                width: MediaQuery.of(context).size.width * 0.2,
              )),
              vertical30,
              const Text(
                'Log In Now',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Sizes.dimen_40,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.fontColor),
              ),
              const Text(
                'Please Log in to continue using our app',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: Sizes.dimen_16,
                    fontWeight: FontWeight.normal,
                    color: ColorManager.fontColor),
              ),
              vertical70,
              vertical70,
              vertical70,
              GestureDetector(
                onTap: () async {
                  bool isSuccess = await authProvider.handleGoogleSignIn();
                  if (isSuccess) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()));
                  }
                },
                child:
                    Image.asset('assets/images/google_login.png', height: 90),
              ),
            ],
          ),
          Center(
            child: authProvider.status == Status.authenticating
                ? const CircularProgressIndicator(
                    color: ColorManager.lightGrey,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
