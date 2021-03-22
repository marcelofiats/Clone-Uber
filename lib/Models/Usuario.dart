class Usuario {
  String _idUsuario;
  String _nome;
  String _email;
  String _senha;
  String _tipoUsuario;

  Usuario();

  String getTipoUsuario(bool usuario) {
    return usuario ? "Motorista" : "Passageiro";
  }

  String get idUsuario => this._idUsuario;

  set idUsuario(String value) => this._idUsuario = value;

  String get nome => this._nome;

  set nome(String value) => this._nome = value;

  String get email => this._email;

  set email(String value) => this._email = value;

  String get senha => this._senha;

  set senha(String value) => this._senha = value;

  String get tipoUsuario => this._tipoUsuario;

  set tipoUsuario(String value) => this._tipoUsuario = value;

  Map<String, dynamic> toMap() {
    return {
      'nome': _nome,
      'email': _email,
      'tipoUsuario': _tipoUsuario,
    };
  }
}
