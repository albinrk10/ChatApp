import 'dart:convert';
import 'package:chat_app/config/config.dart';
import 'package:chat_app/infrastructure/infrastructure.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService with ChangeNotifier {
  Usuario? usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => _autenticando;
  set autenticando(bool value) {
    _autenticando = value;
    notifyListeners();
  }

  // Getters del token de forma estática
  static Future<String?> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    autenticando = true;
    final data = {
      'email': email,
      'password': password,
    };
    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        });
    print(resp.body);
    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      //TODO: Guardar token en lugar seguro
      await _guardarToken(loginResponse.token);

      return true;
    } else {
      // final respBody = jsonDecode(resp.body);
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    autenticando = true;

    final data = {
      'nombre': nombre,
      'email': email,
      'password': password,
    };
    final resp = await http.post(Uri.parse('${Environment.apiUrl}/login/new'),
        body: jsonEncode(data),
        headers: {
          'Content-Type': 'application/json',
        });
    print(resp.body);
    autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;

      //TODO: Guardar token en lugar seguro
      await _guardarToken(loginResponse.token);

      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await _storage.read(key: 'token') ?? '';

     final resp = await http.get(Uri.parse('${Environment.apiUrl}/login/renew'),
     
        headers: {
          'Content-Type': 'application/json',
          'x-token': token ,
        });
    print(resp.body);
    
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      usuario = loginResponse.usuario;
      await _guardarToken(loginResponse.token);

      return true;

    } else {
      logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    await _storage.delete(key: 'token');
  }
}
