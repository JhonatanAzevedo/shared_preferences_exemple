import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../controller/auth_controller.dart';
import '../widgets/buttom/buttom/buttom_widget.dart';
import '../widgets/text_form_field/text_form_field.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends ModularState<AuthPage, AuthController> {
  final _formKey = GlobalKey<FormState>();
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  @override
  void initState() {
    initConnectivity();
    controller.setLogin('');
    controller.setSenha('');
    controller.isAuth().then((status) {
      if (status) {
        Modular.to.pushReplacementNamed('/webview', arguments: {
          'login': controller.login,
          'senha': controller.senha,
        });
      }
    });
    super.initState();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;

    result = await _connectivity.checkConnectivity();

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login  ${_connectionStatus.toString()}')),
      body: _connectionStatus.toString() != 'ConnectivityResult.none'
          ? AnimatedBuilder(
              animation: controller,
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormFieldWidget(
                          label: 'Login',
                          onChanged: (login) {
                            controller.setLogin(login);
                          },
                          validator: (_loginValidate) {
                            if (_loginValidate == null ||
                                _loginValidate.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormFieldWidget(
                          label: 'Senha',
                          onChanged: (senha) {
                            controller.setSenha(senha);
                          },
                          validator: (_senhaValidate) {
                            if (_senhaValidate == null ||
                                _senhaValidate.isEmpty) {
                              return 'Please enter some text';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        ButtomWidget(
                          onPressed: () async {
                            if (!_formKey.currentState!.validate()) {
                              _showError('Processing Data');
                            } else {
                              await controller.executeLogin();
                            }
                          },
                          text: 'ENTRAR',
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : const AlertDialog(
              title: Text("Sem Internet"),
              actions: [],
            ),
    );
  }

  _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(msg),
      ),
    );
  }
}
