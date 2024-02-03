import 'package:chat_app/infrastructure/infrastructure.dart';
import 'package:chat_app/presentation/providers/providers.dart';
import 'package:http/http.dart' as http;

import '../../config/config.dart';

class UsuarioService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get(Uri.parse('${Environment.apiUrl}/usuarios'),
       headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken() ?? ''
      });
      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
