import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket = IO.io('http://192.168.1.4:3000/', {
    'transports': ['websocket'],
    'autoConnect': true
  });

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    this._initConfig();
  }

  void _initConfig() {
    //Probar con http://localhost:3000 ó http//10.0.2.2:3000 o en ultimas http://IP_equipo:3000
    this._socket.onConnect((_) {
      print('connect to server');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    this._socket.onDisconnect((_) {
      print('disconnect to server');
      this._serverStatus = ServerStatus.Offline;
      notifyListeners();
    });

    // Para RECIBIR datos de un socket
    // socket.on('nuevo-mensaje', (payload) {
    //   print('nuevo-mensaje: ${payload}');
    //   print(payload.containsKey('id') ? 'ID: ${payload['id']}' : 'No tiene ID');
    //   print(payload.containsKey('name')
    //       ? 'name: ${payload['name']}'
    //       : 'No tiene name');
    //   print(payload.containsKey('votes')
    //       ? 'votes: ${payload['votes']}'
    //       : 'No tiene votes');
    // });
  }
}
