import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../utils/app_preferences.dart';

class WebViewPage extends StatefulWidget {
  final String login;
  final String senha;
  const WebViewPage({
    Key? key,
    required this.login,
    required this.senha,
  }) : super(key: key);

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  AppPreferences appPreferences = AppPreferences();
  String? auxLogin;
  String status = '';
  bool isConected = false;
  Future<void> getLoginCache() async {
    auxLogin = await appPreferences.getValue('login');
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        log(result.toString());
        if (result == ConnectivityResult.none) {
          setState(
            () {
              status = 'offline';
            },
          );
        } else {
          setState(
            () {
              status = 'online';
            },
          );
        }
      },
    );
    initConnectivity();
    getLoginCache();
  }

  Future<void> _logout() async {
    Modular.get<AppPreferences>().removeAll();
    Modular.to.pushReplacementNamed('/');
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
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text('QR code'),
                onTap: () {
                  Modular.to.pushNamed("/carterinha");
                },
              ),
             
            ],
          ),
        ),
        appBar: status == 'offline'
            ? AppBar(
                backgroundColor: Colors.red,
                title: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        'Sem conexao com a internet',
                        textScaleFactor:
                            MediaQuery.of(context).textScaleFactor * 0.90,
                      ),
                      const Icon(
                        Icons.wifi_off,
                      )
                    ],
                  ),
                ),
                actions: [
                  IconButton(
                    onPressed: () => _logout(),
                    icon: const Icon(Icons.logout),
                  ),
                ],
              )
            : AppBar(
                title: Center(
                  child: Text('$auxLogin'),
                ),
                actions: [
                  IconButton(
                    onPressed: () => _logout(),
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
        body: _connectionStatus.toString() != 'ConnectivityResult.none'
            ? const WebView(
                initialUrl: 'https://www.tiktok.com/foryou?is_copy_url=1&is_from_webapp=v1',
                javascriptMode: JavascriptMode.unrestricted,
              )
            : const AlertDialog(
                title: Text("Sem Internet"),
              ),
      ),
    );
  }
}
