import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber/Models/Usuario.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _controllerEmail =
      TextEditingController(text: "marcelo@gmail.com");
  TextEditingController _controllerSenha =
      TextEditingController(text: "123456");
  String _textError = "";

  _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email != "" && email.contains("@")) {
      if (senha != "") {
        String email = _controllerEmail.text;
        String senha = _controllerSenha.text;

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _verificarUsuario(usuario);
      } else {
        _textError = "Digite a senha";
      }
    } else {
      setState(() {
        _textError = "Digite um e-mail valido!";
      });
    }
  }

  _verificarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      //
      _redirecionarUsuarioPorTipo(firebaseUser.user.uid);
    }).catchError((e) {
      setState(() {
        _textError =
            "Erro na autenticação de usuário, verifique e-mail e senha e tente novamente!";
      });
    });
  }

  _redirecionarUsuarioPorTipo(String idUsuario) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    DocumentSnapshot usuarioLogado =
        await _db.collection("usuarios").doc(idUsuario).get();
    Map<String, dynamic> dados = usuarioLogado.data();
    if (usuarioLogado != null) {
      if (dados["tipoUsuario"] == "Motorista") {
        Navigator.pushNamedAndRemoveUntil(context, "/motorista", (_) => false);
      } else {
        Navigator.pushNamedAndRemoveUntil(context, "/passageiro", (_) => false);
      }
    }
  }

  _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;
    if (usuarioLogado != null) {
      String idUsuarioLogado = usuarioLogado.uid;
      _redirecionarUsuarioPorTipo(idUsuarioLogado);
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        width: larguraTela,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/imagens/fundo.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(22),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 32),
                    child: Image.asset(
                      "assets/imagens/logo.png",
                      width: 200,
                      height: 150,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: TextField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        hintText: "E-mail",
                        hintStyle: TextStyle(fontSize: 18),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 16),
                    child: TextField(
                      controller: _controllerSenha,
                      obscureText: true,
                      obscuringCharacter: "*",
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        hintText: "Senha",
                        hintStyle: TextStyle(fontSize: 18),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    onPressed: () {
                      _validarCampos();
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 15),
                    child: Center(
                      child: GestureDetector(
                        child: Text(
                          "Não tem conta? Cadastre-se!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, "/cadastro");
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      _textError,
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
