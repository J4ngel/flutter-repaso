import 'package:chat/global/environmet.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket = IO.io(Environment.socketUrl, {
    'transports': ['websocket'],
    'autoConnect': true,
    'forceNew': true
  });

  ServerStatus get serverStatus => this._serverStatus;
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;

  SocketService() {
    this.connect();
  }

  void connect() {
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
  }

  void disconnect() {
    this._socket.disconnect();
  }
}
