import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uber/Models/Usuario.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  TextEditingController _controllerNome =
      TextEditingController(text: "Marcelo Fiats");
  TextEditingController _controllerEmail =
      TextEditingController(text: "marcelo@gmail.com");
  TextEditingController _controllerSenha =
      TextEditingController(text: "123456");
  TextEditingController _controllerRepetirSenha =
      TextEditingController(text: "123456");
  String _textError = "";
  bool _tipoUsuario = false;

  _validarCampos() {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;
    String repetirSenha = _controllerRepetirSenha.text;

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.length > 5 && senha == repetirSenha) {
          Usuario _usuario = Usuario();
          _usuario.nome = nome;
          _usuario.senha = senha;
          _usuario.email = email;
          _usuario.tipoUsuario = _usuario.getTipoUsuario(_tipoUsuario);

          _salvarUsuario(_usuario);
        } else {
          _textError =
              "Senhas não conferem ou muito curta( minimo 6 caracteres)";
        }
      } else {
        setState(() {
          _textError = "Digite um e-mail valido!";
        });
      }
    } else {
      setState(() {
        _textError = "O campo nome é Obrigatorio";
      });
    }
  }

  _salvarUsuario(Usuario usuario) async {
    FirebaseFirestore _db = FirebaseFirestore.instance;
    FirebaseAuth auth = FirebaseAuth.instance;
    auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.senha)
        .then((firebaseUser) {
      _db.collection("usuarios").doc(firebaseUser.user.uid).set(
            usuario.toMap(),
          );

      switch (usuario.tipoUsuario) {
        case "Motorista":
          Navigator.pushNamedAndRemoveUntil(
              context, "/motorista", (_) => false);
          break;
        case "Passageiro":
          Navigator.pushNamedAndRemoveUntil(
              context, "/passageiro", (_) => false);
          break;
        default:
      }
    }).catchError((e) {
      setState(() {
        _textError = "erro no cadastro confira os dados acima!";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double larguraTela = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        width: larguraTela,
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: Image.asset(
                      "assets/imagens/logo.png",
                      width: 150,
                      height: 100,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: _controllerNome,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        filled: true,
                        hintText: "Nome",
                        hintStyle: TextStyle(fontSize: 16),
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
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: _controllerEmail,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 10, 32, 10),
                        filled: true,
                        hintText: "E-mail",
                        hintStyle: TextStyle(fontSize: 16),
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
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: _controllerSenha,
                      obscureText: true,
                      obscuringCharacter: "*",
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        filled: true,
                        hintText: "Senha",
                        hintStyle: TextStyle(fontSize: 16),
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
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextField(
                      controller: _controllerRepetirSenha,
                      obscureText: true,
                      obscuringCharacter: "*",
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 10),
                        filled: true,
                        hintText: "Repetir Senha",
                        hintStyle: TextStyle(fontSize: 16),
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "Passageiro",
                        style: TextStyle(fontSize: 16),
                      ),
                      Switch(
                        //trackColor: MaterialStateProperty.all(Colors.white),
                        thumbColor: MaterialStateProperty.all(Colors.red),
                        activeColor: Colors.blue,
                        value: _tipoUsuario,
                        onChanged: (bool valor) {
                          setState(() {
                            _tipoUsuario = valor;
                          });
                        },
                      ),
                      Text(
                        "Motorista",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  RaisedButton(
                    color: Colors.blueAccent,
                    textColor: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: Text(
                        "Cadastrar",
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
                    padding: EdgeInsets.only(top: 10),
                    child: Center(
                      child: Text(
                        _textError,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
