import 'package:bookieapp/ui/pages/editscreen.dart';
import 'package:bookieapp/ui/pages/favouritesscreen.dart';
import 'package:bookieapp/ui/pages/homescreen.dart';
import 'package:bookieapp/ui/pages/libraryscreen.dart';
import 'package:bookieapp/ui/pages/mapscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BottomTabsNavigatorState extends StatefulWidget {
  const BottomTabsNavigatorState({super.key});

  @override
  State<BottomTabsNavigatorState> createState() => _NavigatorState();
}

class _NavigatorState extends State<BottomTabsNavigatorState> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const LibraryScreen(),
    MapScreen(),
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
      body: Stack(
        children: [
          // El mapa como fondo
          Positioned.fill(
            child: _screens[_selectedIndex],
          ),
          // El BottomNavigationBar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 65,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(0, -2),
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                selectedItemColor: const Color.fromRGBO(66, 97, 249, 1),
                unselectedItemColor: const Color.fromRGBO(228, 226, 226, 1),
                type: BottomNavigationBarType.fixed,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Colors.transparent,
                elevation: 0,
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
          ),
        ],
      ),
    );
  }
}
