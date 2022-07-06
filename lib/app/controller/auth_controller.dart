import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../utils/app_preferences.dart';

class AuthController extends ChangeNotifier {
  final AppPreferences appPreferences;
  String login = '';
  String senha = '';

  AuthController(this.appPreferences);

  void setLogin(String _login) {
    login = _login;
    notifyListeners();
  }

  void setSenha(String _senha) {
    senha = _senha;
    notifyListeners();
  }

  Future<bool> isAuth() async {
    String? auxLogin = await appPreferences.getValue('login');
    String? auxSenha = await appPreferences.getValue('senha');
    return await AppPreferences().getValue('isAuth').then((status) {
      if (status == null) {
        return false;
      }
      setLogin(auxLogin!);
      setSenha(auxSenha!);

      return true;
    });
  }

  Future<bool> executeLogin() async {
    await appPreferences.save('login', login);
    await appPreferences.save('senha', senha);
    await appPreferences.save('isAuth', 'true');
    Modular.to.pushReplacementNamed(
      '/webview',
      arguments: {
        'login': login,
        'senha': senha,
      },
    );
    return true;
  }
}
