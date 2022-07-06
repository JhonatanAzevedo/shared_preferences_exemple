import 'dart:developer';

import 'package:flutter/material.dart';

import '../utils/app_preferences.dart';

class Carterinha extends StatefulWidget {
  const Carterinha({Key? key}) : super(key: key);

  @override
  State<Carterinha> createState() => _CarterinhaState();
}

class _CarterinhaState extends State<Carterinha> {
  AppPreferences appPreferences = AppPreferences();
  String? auxLogin;
  Future<void> getLoginCache() async {
    auxLogin = await appPreferences.getValue('login');
    setState(() {});
  }

  @override
  void initState() {
    getLoginCache();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var image =
        'https://chart.googleapis.com/chart?chs=200x200&cht=qr&chl=$auxLogin';
    log(image.toString());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carterinha'),
      ),
      body: Center(
        child: Image.network(
          image,
          frameBuilder: (_, image, loadingBuilder, __) {
            if (loadingBuilder == null) {
              return const SizedBox(
                height: 300,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return image;
          },
        ),
      ),
    );
  }
}
