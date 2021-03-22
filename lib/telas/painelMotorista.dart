import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PainelMotorista extends StatefulWidget {
  @override
  _PainelMotoristaState createState() => _PainelMotoristaState();
}

class _PainelMotoristaState extends State<PainelMotorista> {
  //POSIÇÃO MAPA
  CameraPosition _cameraPosition =
      CameraPosition(target: LatLng(-22.804937, -47.309988), zoom: 18);
  //MENU USUARIO
  List<String> itensMenu = ["Configurações", "Deslogar"];
  //CONTROLLER GOOGLE MAP
  Completer<GoogleMapController> _controller = Completer();

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
      _cameraPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 18,
      );

      _movimentarCamera(_cameraPosition);
    });
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
        child: GoogleMap(
          mapType: MapType.normal,
          initialCameraPosition: _cameraPosition,
          onMapCreated: _onMapCreated,
          myLocationEnabled: true,
        ),
      ),
    );
  }
}
