import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'config/config.dart';
import 'presentation/providers/providers.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme:AppTheme(selectedColor: 1).theme(),
        routerConfig: appRouter,
       
      ),
    );
  }
}