import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:preferences_app/app/views/carterinha_page.dart';

import 'controller/auth_controller.dart';
import 'utils/app_preferences.dart';
import 'views/auth_page.dart';
import 'views/web_view_page.dart';

class AppModule extends Module {
  @override
  List<Bind> get binds => [
        Bind(((i) => Dio())),
        Bind(((i) => AppPreferences())),
        Bind(((i) => AuthController(i()))),
      ];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const AuthPage(),
        ),
        ChildRoute(
          '/webview',
          child: (context, args) => WebViewPage(
            login: args.data['login'],
            senha: args.data['senha'],
          ),
        ),
        ChildRoute(
          '/carterinha',
          child: (context, args) => const Carterinha(),
        ),
      ];
}
