import 'package:chat_app/infrastructure/infrastructure.dart';
import 'package:chat_app/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../config/config.dart';

class ChatService with ChangeNotifier {
  late Usuario usuarioPara;


  Future<List<Mensaje>> getChat(String usuarioID) async {
    final resp = await http
        .get(Uri.parse('${Environment.apiUrl}/mensajes/$usuarioID'), headers: {
      'Content-Type': 'application/json',
      'x-token': await AuthService.getToken() ?? ''
    });
    final mensajesResponse = mensajesResponseFromJson(resp.body);
    return mensajesResponse.mensajes;
  }
}
