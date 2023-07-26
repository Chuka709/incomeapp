import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:income/models/user.dart';
import 'package:income/provider/index.dart';
import 'package:income/screens/dashboard.dart';
// import 'dashboard_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  Future<String?> _onLogin(LoginData data) async {
    await DatabaseProvider.instance.init();
    final repo = DatabaseProvider.instance.userRepo;
    List<UserModel> users = UserModel.fromList(await repo?.getAll() ?? []);
    if (users.any((e) => e.email == data.name && e.password == data.password)) {
      return null;
    }
    return "Нууц үг эсвэл нэвтрэх нэр буруу байна!";
  }

  Future<String?> _onSignup(SignupData data) async {
    await DatabaseProvider.instance.init();
    final repo = DatabaseProvider.instance.userRepo;
    if (repo == null) {
      return "Can't connect database";
    }
    List<UserModel> users = UserModel.fromList(await repo.getAll());
    if (users.any((e) => e.email == data.name)) {
      return "Хэрэглэгч бүртгэлтэй байна.";
    }
    await repo.addOne(UserModel(id: -1, email: data.name ?? '', password: data.password ?? ''));
    return null;
  }

  Future<String?> _onRecover(String data) async {
    return null;
  }

  String? _userValidator(String? value) {
    return value == null || value.isEmpty ? "Утга хоосон байж болохгүй!" : null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ОРЛОГО',
      theme: LoginTheme(),
      logo: AssetImage('assets/logo.png'),
      onLogin: _onLogin,
      onSignup: _onSignup,
      hideForgotPasswordButton: true,
      userValidator: _userValidator,
      passwordValidator: _userValidator,
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => DashboardPage(),
        ));
      },
      onRecoverPassword: _onRecover,
      messages: LoginMessages(
        userHint: 'Цахим шуудан',
        passwordHint: 'Нууц үг',
        confirmPasswordHint: 'Нууц үг баталгаажуулах',
        loginButton: 'НЭВТРЭХ',
        signupButton: 'БҮРТГҮҮЛЭХ',
        forgotPasswordButton: 'Өө мартчихсан уу?',
        recoverPasswordButton: 'ТУСЛААРАЙ',
        goBackButton: 'БУЦАХ',
        confirmPasswordError: 'Тохирсонгүй!',
        recoverPasswordDescription: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
        recoverPasswordSuccess: 'Нууц үг амжилттай солигдлоо',
      ),
    );
  }
}
