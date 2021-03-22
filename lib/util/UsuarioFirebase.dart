import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Models/Usuario.dart';

class UsuarioFirebse {
  static Future<User> getUsuarioAtual() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser;
    return usuarioLogado;
  }

  static Future<Usuario> getDadosUsuarioLogado() async {
    User user = await getUsuarioAtual();
    String idUsuario = user.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;

    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(idUsuario).get();

    Map<String, dynamic> dados = snapshot.data();
    String tipoUsuario = dados["tipoUsuario"];
    String nome = dados["nome"];
    String email = dados["email"];

    Usuario usuario = Usuario();

    usuario.idUsuario = idUsuario;
    usuario.nome = nome;
    usuario.email = email;
    usuario.tipoUsuario = tipoUsuario;

    return usuario;
  }
}
