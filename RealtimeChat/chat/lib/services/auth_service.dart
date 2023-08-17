import 'dart:convert';

import 'package:chat/global/environmet.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/user.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  User? user;
  bool _autenticando = false;
  bool _creando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool val) {
    this._autenticando = val;
    notifyListeners();
  }

  bool get creando => this._creando;
  set creando(bool val) {
    this._creando = val;
    notifyListeners();
  }

  //GETTERS y SETTERS
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token ?? 'error';
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(resp.body);
    this.autenticando = false;

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      await this._safeToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future<String> register(String name, String email, String password) async {
    this._creando = true;

    final data = {'name': name, 'email': email, 'password': password};

    final uri = Uri.parse('${Environment.apiUrl}/login/new');

    final resp = await http.post(uri,
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});

    print(resp.body);
    this._creando = false;
    dynamic body = jsonDecode(resp.body);
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      await this._safeToken(loginResponse.token);
      return 'ok';
    } else {
      return body['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await this._storage.read(key: 'token');
    print(token);
    final uri = Uri.parse('${Environment.apiUrl}/login/renew');

    final resp = await http.get(uri, headers: {
      'Content-Type': 'application/json',
      'x-token': token ?? 'ERROR'
    });

    print(resp.body);

    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.user = loginResponse.user;

      await this._safeToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _safeToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // Delete value
    return await _storage.delete(key: 'token');
  }
}
