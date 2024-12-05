import 'dart:async';
import 'package:bookieapp/ui/marker/customMarker.dart';
import 'package:bookieapp/config/providers/routesMarkers.dart';
import 'package:bookieapp/ui/modal/fakeData.dart';
import 'package:bookieapp/ui/modal/openCreateChapterModal.dart';
import 'package:bookieapp/ui/modal/openCustomModal.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';

import '../../domain/models/Chapter.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;
  LatLng? _destination;
  GoogleMapController? _mapController;
  List<Chapter> _chapters=[];
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  int _markerIdCounter = 1;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isRouteCleared = false; // Bandera para controlar el redibujo de la ruta

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _listenToLocationChanges();
    _initializeMapRenderer();
    _loadChaptersAndAddMarkers();
  }

  void _loadChaptersAndAddMarkers() {
  setState(() {
    _chapters = chaptersData; // Asignar la lista fake a _chapters
  });

  for (var chapter in _chapters) {
    _addMarker(LatLng(chapter.latitude, chapter.longitude));
  }
}

  void _initializeMapRenderer() {
    final GoogleMapsFlutterPlatform mapsImplementation =
        GoogleMapsFlutterPlatform.instance;
    if (mapsImplementation is GoogleMapsFlutterAndroid) {
      mapsImplementation.useAndroidViewSurface = true;
    }
  }

  // Función para limpiar la ruta actual
  void _clearRoute() {
    setState(() {
      _polylines.clear(); // Elimina las polilíneas actuales
      _isRouteCleared = true; // Marcar que la ruta está borrada
    });
  }

  Future _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Por favor, habilita los servicios de ubicación.')),
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Permisos de ubicación denegados.')),
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Los permisos están denegados permanentemente.')),
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      print('Error obteniendo ubicación: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error obteniendo ubicación: $e')),
      );
    }
  }

  void _listenToLocationChanges() {
    _positionStreamSubscription = Geolocator.getPositionStream(
            locationSettings:
                const LocationSettings(accuracy: LocationAccuracy.high))
        .listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });

      // Evitar redibujar la ruta si ya está borrada
      if (!_isRouteCleared && _destination != null) {
        _drawRoute(_destination!);
      }

      // if (_mapController != null) {
      //   _mapController!.animateCamera(
      //     CameraUpdate.newLatLng(_currentLocation!),
      //   );
      // }
    });
  }

  void _addMarker(LatLng position) async {
  final markerId = MarkerId('marker_${_markerIdCounter++}');
  final customIcon = await createCustomMarker('lib/ui/assets/marker1.png');

  final chapter = _chapters.firstWhere(
    (ch) => ch.latitude == position.latitude && ch.longitude == position.longitude,
    orElse: () => Chapter(
      storyId: 0,
      title: "Desconocido",
      content: "",
      latitude: position.latitude,
      longitude: position.longitude,
      numberChapter: 0,
    ),
  );

  final marker = Marker(
    markerId: markerId,
    position: position,
    icon: customIcon,
    onTap: () {
      setState(() {
        _destination = position;
      });
      _drawRoute(position);
      openCustomModal(context, chapter.title, chapter.content,chapter.numberChapter,"https://mundosdepinceladas.net/wp-content/uploads/pintura-impresionante-paisaje-sereno-1.webp"); // Pasar información al modal
    },
  );

  setState(() {
    _markers.add(marker);
  });
}


  Future<void> _drawRoute(LatLng destination) async {
    if (_currentLocation == null) return;

    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      print('API key no encontrada');
      return;
    }

    final url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${_currentLocation!.latitude},${_currentLocation!.longitude}&destination=${destination.latitude},${destination.longitude}&key=$apiKey&mode=driving';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['routes'].isNotEmpty) {
          final List<LatLng> routePoints = [];
          for (var step in data['routes'][0]['legs'][0]['steps']) {
            final stepPolyline = step['polyline']['points'];
            routePoints.addAll(decodePolyline(stepPolyline));
          }

          setState(() {
            _polylines = [
              Polyline(
                polylineId: const PolylineId('route'),
                points: routePoints,
                color: Color(0xFF4261F9),
                width: 6,
                patterns: [PatternItem.dot, PatternItem.gap(10)],
              ),
            ];
          });
        }
      } else {
        print('Error en la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      print('Error obteniendo la ruta: $e');
    }
  }

  void _resetRoute() {
    setState(() {
      _isRouteCleared = false; // Restablecer la bandera
    });

    if (_destination != null) {
      _drawRoute(_destination!); // Redibujar la ruta con el destino actual
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: _currentLocation!,
                zoom: 17.0,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: false,
              compassEnabled: false,
              onMapCreated: (controller) {
                _mapController = controller;
                if (_currentLocation != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLng(_currentLocation!),
                  );
                }
              },
              markers: Set<Marker>.of(_markers),
              polylines: Set<Polyline>.of(_polylines),
              onTap: (_) {
                // Limpiar la ruta al tocar cualquier parte del mapa
                _clearRoute();
              },
            ),
      floatingActionButton: Stack(
        children: <Widget>[
          Positioned(
            bottom: 130.0,
            right: 16.0,
            child: GestureDetector(
              onTap: () => showAddChapterModal(context, _chapters, _addMarker, setState,_currentLocation?.latitude??0, _currentLocation?.longitude??0),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF4261F9),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'lib/ui/assets/addMarker.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 180.0,
            right: 16.0,
            child: GestureDetector(
              onTap: () {
                if (_currentLocation != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(_currentLocation!),
                  );
                }
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF4261F9),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'lib/ui/assets/myUbication.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80.0,
            right: 16.0,
            child: GestureDetector(
              onTap: () {
                print("open modal");
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Color(0xFF4261F9),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    'lib/ui/assets/book.png',
                    width: 40,
                    height: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
