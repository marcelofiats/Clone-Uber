import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uber/telas/cadastro.dart';
import 'package:uber/telas/painelMotorista.dart';
import 'package:uber/telas/login.dart';
import 'package:uber/telas/painelPassageiro.dart';

class Rotas {
  static Route<dynamic> gerarRotas(RouteSettings settings) {
    switch (settings.name) {
      case "/":
        return MaterialPageRoute(
          builder: (_) => Login(),
        );
      case "/cadastro":
        return MaterialPageRoute(
          builder: (_) => Cadastro(),
        );
      case "/motorista":
        return MaterialPageRoute(
          builder: (_) => PainelMotorista(),
        );
      case "/passageiro":
        return MaterialPageRoute(
          builder: (_) => PainelPassageiro(),
        );
      default:
        _erroRoute();
    }
  }

  static Route<dynamic> _erroRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
          appBar: AppBar(),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Pagina não encontrada"),
              ],
            ),
          ));
    });
  }
}
