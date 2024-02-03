import 'package:chat_app/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../infrastructure/infrastructure.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final usuarioService = UsuarioService();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<Usuario> usuarios = [];

  // final usuarios = [
  //  Usuario(online: true, email: 'albinrk@gmail.com', nombre: 'Albin', uid: '1'),
  //  Usuario(online: true, email: 'anthony@gmail.com', nombre: 'Anthony', uid: '2'),
  //  Usuario(online: false, email: 'thiago@gmail.com', nombre: 'Thiago', uid: '3'),
  // ];
  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            usuario?.nombre ?? 'Sin Nombre',
            style: const TextStyle(color: Colors.black87),
          ),
          centerTitle: true,
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.black87),
            onPressed: () {
              socketService.disconnect();
              AuthService.deleteToken();
              context.push('/login');
            },
          ),
          actions: [
            Container(
              margin: const EdgeInsets.only(right: 10),
              child: (socketService.serverStatus == ServerStatus.Online)
                  ? const Icon(Icons.check_circle, color: Colors.blue)
                  : const Icon(Icons.offline_bolt, color: Colors.red),
            )
          ],
        ),
        body: SmartRefresher(
          controller: _refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: const WaterDropHeader(
            complete: Icon(Icons.check, color: Colors.blue),
            waterDropColor: Colors.blue,
          ),
          child: _listViewUsuarios(),
        ));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, i) => _usuarioListTile(usuarios[i]),
      separatorBuilder: (_, i) => const Divider(),
      itemCount: usuarios.length,
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(usuario.nombre.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: usuario.online ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        context.push('/chat');
      },
    );
  }

  _cargarUsuarios() async {
    usuarios = await usuarioService.getUsuarios();
    setState(() {});
    // await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }
}
