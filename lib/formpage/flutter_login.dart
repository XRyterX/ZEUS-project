import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:m06/auth.dart';
// import 'package:m06/home.dart';
import 'package:spons/formpage/auth.dart';
import 'package:spons/menu.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late AuthFirebase auth;

  @override
  void initState() {
    auth = AuthFirebase();
    auth.getUser().then((value) {
      MaterialPageRoute route;
      if (value != null) {
        route = MaterialPageRoute(
            builder: (context) => MyWidget()); //(wid: value.uid)
        Navigator.pushReplacement(context, route);
      }
    }).catchError((err) => print(err));
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      onLogin: _loginUser,
      onRecoverPassword: _recoverPassword,
      onSignup: _onSignUp,
      passwordValidator: (value) {
        if (value != null) {
          if (value.length < 6) {
            return "Password Must Be 6 Characters";
          }
        }
      },
      loginProviders: <LoginProvider>[
        LoginProvider(
            callback: _onLoginGoogle,
            icon: FontAwesomeIcons.google,
            label: 'Google')
      ],
      onSubmitAnimationCompleted: () {
        auth.getUser().then((value) {
          MaterialPageRoute route;
          if (value != null) {
            route = MaterialPageRoute(
                builder: (context) => MyWidget()); //wid: value.uid
          } else {
            route = MaterialPageRoute(builder: (context) => LoginScreen());
          }
          Navigator.pushReplacement(context, route);
        }).catchError((err) => print(err));
      },
    );
  }

  Future<String?>? _loginUser(LoginData data) {
    return auth.login(data.name, data.password).then((value) {
      if (value != null) {
        MaterialPageRoute(builder: (context) => MyWidget()); //wid: value
      } else {
        final snackbar = SnackBar(
          content: const Text('Login Failed, user not Found'),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  Future<String?>? _recoverPassword(String name) {
    return null;
  }

  Future<String?>? _onSignUp(SignupData data) {
    return auth.signUp(data.name!, data.password!).then((value) {
      final snackbar = SnackBar(
        content: const Text("Sign Up Successful"),
        action: SnackBarAction(label: 'OK', onPressed: () {}),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    });
  }

  Future<String?>? _onLoginGoogle() {
    return null;
  }
}
