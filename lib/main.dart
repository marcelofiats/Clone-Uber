import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:uber/splashScreen.dart';
import 'package:uber/telas/routes.dart';

final ThemeData themeData = ThemeData(
  primaryColor: Color(0xff37474f),
  accentColor: Color(0xff546e7a),
);
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "Uber",
    theme: themeData,
    debugShowCheckedModeBanner: false,
    initialRoute: "/",
    onGenerateRoute: Rotas.gerarRotas,
    home: SplashScreen(),
  ));
}
