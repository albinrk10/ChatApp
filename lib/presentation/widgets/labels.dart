import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Labels extends StatelessWidget {
  final String labelAsk;
  final String labelRoute;
  final String ruta;
  const Labels(
      {super.key,
      required this.ruta,
      required this.labelAsk,
      required this.labelRoute});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
             Text(
              // '¿No tienes Cuenta?',
              labelAsk,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                  color: Colors.black54),
            ),
            const SizedBox(
              height: 10,
            ),
            GestureDetector(
              child: Text(
                // 'Crea una ahora!',
                labelRoute,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600]),
              ),
              onTap: () {
                context.push(ruta);
              },
            ),
          ],
        ));
  }
}
