class Endereco {
  String _rua;
  String _numero;
  String _bairro;
  String _cidade;
  String _uf;
  String _cep;
  double _latitude;
  double _longitude;

  Endereco();

  String get rua => this._rua;

  set rua(String value) => this._rua = value;

  String get numero => this._numero;

  set numero(String value) => this._numero = value;

  String get bairro => this._bairro;

  set bairro(String value) => this._bairro = value;

  String get cidade => this._cidade;

  set cidade(String value) => this._cidade = value;

  String get uf => this._uf;

  set uf(String value) => this._uf = value;

  String get cep => this._cep;

  set cep(String value) => this._cep = value;

  double get latitude => this._latitude;

  set latitude(double value) => this._latitude = value;

  double get longitude => this._longitude;

  set longitude(double value) => this._longitude = value;

  Map<String, dynamic> toMap() {
    return {
      'rua': _rua,
      'numero': _numero,
      'bairro': _bairro,
      'cidade': _cidade,
      'uf': _uf,
      'cep': _cep,
      'latitude': _latitude,
      'longitude': _longitude,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Endereco &&
        other._rua == _rua &&
        other._numero == _numero &&
        other._bairro == _bairro &&
        other._cidade == _cidade &&
        other._uf == _uf &&
        other._cep == _cep &&
        other._latitude == _latitude &&
        other._longitude == _longitude;
  }

  @override
  int get hashCode {
    return _rua.hashCode ^
        _numero.hashCode ^
        _bairro.hashCode ^
        _cidade.hashCode ^
        _uf.hashCode ^
        _cep.hashCode ^
        _latitude.hashCode ^
        _longitude.hashCode;
  }
}
