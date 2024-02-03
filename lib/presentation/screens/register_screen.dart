import 'package:chat_app/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../widgets/widgets.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: SizedBox(
            // height: MediaQuery.of(context).size.height * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Logo(
                  titulo: 'Registrar',
                ),
                _Form(),
                const Labels(
                  labelAsk: '¿Ya tienes cuenta?',
                  labelRoute: 'Ingresa ahora!',
                  ruta: '/login',
                ),
                const Text(
                  'Términos y condiciones de uso',
                  style: TextStyle(fontWeight: FontWeight.w200),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final socketService = Provider.of<SocketService>(context);
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
              icon: Icons.perm_identity,
              placeholder: 'Nombre',
              keyboardType: TextInputType.emailAddress,
              textController: nameCtrl),
          CustomInput(
              icon: Icons.mail_outline,
              placeholder: 'Correo',
              keyboardType: TextInputType.emailAddress,
              textController: emailCtrl),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Contraseña',
            keyboardType: TextInputType.text,
            textController: passwordCtrl,
            isPassword: true,
          ),
          //Crear boton
          BotonAzul(
              text: 'Crear cuenta',
              onPressed: authService.autenticando
                  ? null
                  : () async {
                      FocusScope.of(context).unfocus();
                      print(nameCtrl.text);
                      print(emailCtrl.text);
                      print(passwordCtrl.text);

                      final registerOk = await authService.register(
                          nameCtrl.text.trim(),
                          emailCtrl.text.trim(),
                          passwordCtrl.text.trim());
                          
                      if (registerOk == true) {
                        socketService.connect();
                        //Navegar a otra pantalla go router
                        context.push('/usuarios');
                      } else {
                        //Mostrar alerta
                        // mostrarAlerta(context, 'Registro incorrecto', registerOk);
                        mostrarAlerta(context, 'Registro incorrecto', 'Ya existe un usuario con ese correo o llene los campos correctamente');
                        // context.push('/login');
                      }
                    })
        ],
      ),
    );
  }
}
