import 'package:bookieapp/ui/pages/editscreen.dart';
import 'package:bookieapp/ui/pages/favouritesscreen.dart';
import 'package:bookieapp/ui/pages/homescreen.dart';
import 'package:bookieapp/ui/pages/libraryscreen.dart';
import 'package:bookieapp/ui/pages/mapscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const LibraryScreen(),
    const MapScreen(),   
    const FavouritesScreen(),
    const EditScreen(),      
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(      
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(    
        height: 65,                         
        width: 250, // Aquí ajustas el ancho del contenedor
        margin: const EdgeInsets.symmetric(horizontal: 5), // Ajusta el margen si es necesario
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8.0,
              offset: Offset(0, -2),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(          
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color.fromRGBO(66, 97, 249, 1), // Color cuando está seleccionado
          unselectedItemColor: const Color.fromRGBO(228, 226, 226, 1), // Color cuando no está seleccionado   
          type:BottomNavigationBarType.fixed,   
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.transparent,
          elevation:0,
          iconSize: 30,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(              
              icon: Icon(Icons.home),              
              label: '',              
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.my_library_books_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.location_on_outlined),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mode_outlined),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}





