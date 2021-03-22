import '../Models/Endereco.dart';
import '../Models/Usuario.dart';

class Requisicao {
  String _id;
  String _status;
  Usuario _passageiro;
  Usuario _motorista;
  Endereco _destino;

  Requisicao();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> dadosPassageiro = {
      "idUsuario": _passageiro.idUsuario,
      "nome": _passageiro.nome,
      "email": _passageiro.email,
      "tipoUsuario": _passageiro.tipoUsuario
    };

    Map<String, dynamic> dadosDestino = {
      "rua": this._destino.rua,
      "numero": this._destino.numero,
      "cidade": this._destino.cidade,
      "bairro": this._destino.bairro,
      "cep": this._destino.cep,
      "latitude": this._destino.latitude,
      "longitude": this._destino.longitude,
    };

    return {
      'id': _id,
      'status': _status,
      'passageiro': dadosPassageiro,
      'motorista': null,
      'destino': dadosDestino,
    };
  }

  get id => this._id;

  set id(value) => this._id = value;

  get status => this._status;

  set status(value) => this._status = value;

  get passageiro => this._passageiro;

  set passageiro(value) => this._passageiro = value;

  get motorista => this._motorista;

  set motorista(value) => this._motorista = value;

  get destino => this._destino;

  set destino(value) => this._destino = value;
}
