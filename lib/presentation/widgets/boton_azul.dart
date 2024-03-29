import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  //  final Function()? onPressed;
  const BotonAzul({super.key,  required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          style: ButtonStyle(
            elevation: MaterialStateProperty.all(2),
            backgroundColor: MaterialStateProperty.all(
              onPressed != null ? const Color(0xff0575E6) : Colors.grey.withOpacity(0.5),
            ),
            shape: MaterialStateProperty.all(const StadiumBorder()),
          ),
          onPressed: onPressed,
          child:  SizedBox(
            width: double.infinity,
            height: 55,
            child: Center(
              child: Text(
                text ,
                style: const TextStyle(color: Colors.white, fontSize: 17),
              ),
            ),
          ),
        );
  }
}