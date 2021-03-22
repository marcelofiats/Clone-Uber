import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/Models/Endereco.dart';
import 'package:uber/Models/Requisicao.dart';
import 'package:uber/Models/Usuario.dart';
import 'package:uber/util/StatusRequisicao.dart';
import 'package:uber/util/UsuarioFirebase.dart';

class PainelPassageiro extends StatefulWidget {
  @override
  _PainelPassageiroState createState() => _PainelPassageiroState();
}

class _PainelPassageiroState extends State<PainelPassageiro> {
  //POSIÇÃO MAPA
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-22.804937, -47.309988), zoom: 18);
  //MENU USUARIO
  List<String> itensMenu = ["Configurações", "Sair"];
  //CONTROLLER GOOGLE MAP
  Completer<GoogleMapController> _controller = Completer();
  //CONTROLLERS TEXTFILDS
  TextEditingController _controllerPartida = TextEditingController();
  TextEditingController _controllerDestino =
      TextEditingController(text: "Av. Paulista, 807");
  //MARCADOR MAPA
  Set<Marker> _marcadores = {};

  _deslogarUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();

    Navigator.pushNamedAndRemoveUntil(context, "/", (route) => false);
  }

  _escolhaMenuItem(String escolha) {
    switch (escolha) {
      case "Sair":
        _deslogarUsuario();
        break;
      case "Configurações":
        //
        break;
      default:
    }
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  _recuperarLocalizacaoAtual() async {
    Position position = await Geolocator()
        .getLastKnownPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      if (position != null) {
        _exibirMarcadorPassageiro(position);
        _cameraPosition = CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 18,
        );

        _movimentarCamera(_cameraPosition);
      }
    });
  }

  _movimentarCamera(CameraPosition cameraPosition) async {
    GoogleMapController googleMapController = await _controller.future;
    googleMapController.moveCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
  }

  _adicionarListenerLocalizacao() {
    var geolocator = Geolocator();
    var locationOption = LocationOptions(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );
    geolocator.getPositionStream(locationOption).listen((Position position) {
      _exibirMarcadorPassageiro(position);
      _cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 18,
      );

      _movimentarCamera(_cameraPosition);
    });
  }

  _exibirMarcadorPassageiro(Position position) async {
    double pixelRadio = MediaQuery.of(context).devicePixelRatio;

    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(devicePixelRatio: pixelRadio),
            "assets/imagens/passageiro.png")
        .then((BitmapDescriptor icon) {
      Marker marcadorPassageiro = Marker(
        markerId: MarkerId("marcador-passageiro"),
        position: LatLng(position.latitude, position.longitude),
        infoWindow: InfoWindow(
          title: "Meu Local",
        ),
        icon: icon,
      );

      setState(() {
        _marcadores.add(marcadorPassageiro);
      });
    });
  }

  _chamarUber() async {
    String destino = _controllerDestino.text;
    if (destino.isNotEmpty) {
      List<Placemark> listaEnderecos =
          await Geolocator().placemarkFromAddress(destino);
      if (listaEnderecos != null && listaEnderecos.length > 0) {
        Placemark destino = listaEnderecos[0];
        Endereco endereco = Endereco();
        endereco.rua = destino.thoroughfare.toString();
        endereco.numero = destino.subThoroughfare.toString();
        endereco.bairro = destino.subLocality.toString();
        endereco.cidade = destino.subAdministrativeArea.toString();
        endereco.cep = destino.postalCode.toString();
        endereco.latitude = destino.position.latitude;
        endereco.longitude = destino.position.longitude;

        String enderecoConfimacao;
        enderecoConfimacao = "\n Cidade: " + endereco.cidade;
        enderecoConfimacao +=
            "\n Rua: " + endereco.rua + ", " + endereco.numero;
        enderecoConfimacao += "\n Bairro: " + endereco.bairro;
        enderecoConfimacao += "\n CEP: " + endereco.cep;

        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text("Confirmação endereço"),
                content: Text(enderecoConfimacao),
                contentPadding: EdgeInsets.all(16),
                actions: [
                  FlatButton(
                    child: Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.red),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  FlatButton(
                    child: Text(
                      "Confirmar",
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      _salvarRequisicao(endereco);
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            });
      }
    } else {}
  }

  _salvarRequisicao(Endereco endereco) async {
    Usuario passageiro = await UsuarioFirebse.getDadosUsuarioLogado();

    Requisicao requisicao = Requisicao();
    requisicao.destino = endereco;
    requisicao.passageiro = passageiro;
    requisicao.status = StatusRequisicao.AGUARDANDO;

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("requisicoes").add(requisicao.toMap());
  }

  @override
  void initState() {
    super.initState();
    _recuperarLocalizacaoAtual();
    _adicionarListenerLocalizacao();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uber - Passageiro"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              return itensMenu.map((String item) {
                return PopupMenuItem(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        child: Stack(
          children: [
            //mapa
            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _cameraPosition,
              onMapCreated: _onMapCreated,
              //myLocationEnabled: true,
              markers: _marcadores,
              myLocationButtonEnabled: false,
            ),
            //inputs
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _controllerPartida,
                    readOnly: true,
                    decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          width: 10,
                          height: 25,
                          child: Icon(
                            Icons.location_on,
                            color: Colors.green,
                          ),
                        ),
                        hintText: "Meu Local",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 15, bottom: 10)),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 55,
              left: 0,
              right: 0,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(3),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: _controllerDestino,
                    decoration: InputDecoration(
                        icon: Container(
                          margin: EdgeInsets.only(left: 10, right: 10),
                          width: 10,
                          height: 25,
                          child: Icon(
                            Icons.local_taxi,
                            color: Colors.black,
                          ),
                        ),
                        hintText: "Digite o destino",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(top: 15, bottom: 10)),
                  ),
                ),
              ),
            ),
            //Botão
            Positioned(
                bottom: Platform.isIOS ? 25 : 5,
                left: 5,
                right: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RaisedButton(
                      padding: EdgeInsets.fromLTRB(25, 16, 25, 16),
                      color: Colors.blueAccent,
                      textColor: Colors.white,
                      child: Text(
                        "Chamar Uber",
                        style: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        _chamarUber();
                      },
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
