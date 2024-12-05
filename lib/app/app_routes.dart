

import 'package:bookieapp/app/transition.dart';
import 'package:bookieapp/ui/Navigator/bottomtabs.dart';
import 'package:bookieapp/ui/pages/homescreen.dart';
import 'package:bookieapp/ui/pages/loginscreen.dart';
import 'package:bookieapp/ui/pages/splashscreen.dart';

import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings){
    final args = settings.arguments;
    switch(settings.name){
      case "/splashScreen":
        return MaterialPageRoute(builder: (_)=>SplashScreen());
      case "/homeScreen":
        //Transicion con la clase creada en la clase anterior
        return TransitionsExample.fadeRoute(const HomeScreen());
      case "/loginScreen":
      //Transicion con la clase creada en la clase anterior
        return TransitionsExample.fadeRoute(LoginScreen());
      case "/bottomtabs":
      //Transicion con la clase creada en la clase anterior
        return TransitionsExample.fadeRoute(const BottomTabsNavigatorState());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(builder: (_){
      return const Scaffold(
        body:  Center(
          child:  Text(
            "error!! No se encontro la ventana"
          ),
        ),
      );
    });
  }
}