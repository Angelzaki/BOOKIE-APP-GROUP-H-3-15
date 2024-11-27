import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bookieapp/ui/Navigator/bottomtabs.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.dark, // Íconos de la barra de estado en color negro
      statusBarColor: Colors.transparent, // Establecer el color de fondo de la barra de estado (opcional)
    ));
    return MaterialApp(
      title: 'Flutter Bottom Tabs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const BottomTabsNavigatorState(),
    );
  }
}







