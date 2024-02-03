import 'package:chat_app/presentation/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: checkLoginState(context),
        builder: (context, snapshot) {
          return Center(
            child: Text('Espere..'),
          );
        },
      ),
    );
  }

  Future checkLoginState(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();

    if (autenticado) {
      //TODO: Conectar al socket server
      context.push('/usuarios');
      // Navigator.pushReplacement(
      //   context, 
      //   PageRouteBuilder(
      //     pageBuilder: ( _, __, ___ ) => UsuariosScreen(),
      //     transitionDuration: Duration(milliseconds: 0)
      //   )
      // );
    }else{
        context.push('/login');
      //   Navigator.pushReplacement(
      //   context, 
      //   PageRouteBuilder(
      //     pageBuilder: ( _, __, ___ ) => LoadingScreen(),
      //     transitionDuration: Duration(milliseconds: 0)
      //   )
      // );
    }
  }
}


//LoadingScreen