import 'dart:async';
import 'package:bookieapp/ui/marker/customMarker.dart';
import 'package:bookieapp/config/providers/routesMarkers.dart';
import 'package:bookieapp/ui/modal/openCustomModal.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _currentLocation;
  LatLng? _destination; // Agregado para almacenar el destino actual
  GoogleMapController? _mapController;
  List<Marker> _markers = [];
  List<Polyline> _polylines = [];
  int _markerIdCounter = 1;
  StreamSubscription<Position>? _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _listenToLocationChanges();
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

      // Mueve la cámara automáticamente al cambiar de posición
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(_currentLocation!),
        );
      }

      // Actualiza la ruta si hay un destino seleccionado
      if (_destination != null) {
        _drawRoute(_destination!);
      }
    });
  }

  void _addMarker(LatLng position) async {
    final markerId = MarkerId('marker_${_markerIdCounter++}');
    final customIcon = await createCustomMarker('lib/ui/assets/marker1.png');

    final marker = Marker(
      markerId: markerId,
      position: position,
      icon: customIcon, // Usar el ícono personalizado
      onTap: () {
        setState(() {
          _destination = position; // Establecer el destino actual
        });
        _drawRoute(position);
        openCustomModal(context);
      },
    );

    setState(() {
      _markers.add(marker);
    });
  }

  
  Future<void> _drawRoute(LatLng destination) async {
  if (_currentLocation == null) return;

  // Obtén la API key desde el archivo .env
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
              onMapCreated: (controller) {
                _mapController = controller;
                // Centrar la cámara una vez que el mapa esté listo
                if (_currentLocation != null) {
                  _mapController!.animateCamera(
                    CameraUpdate.newLatLng(_currentLocation!),
                  );
                }
              },
              markers: Set<Marker>.of(_markers),
              polylines: Set<Polyline>.of(_polylines),
            ),
      floatingActionButton: Stack(
        children: <Widget>[
          // Botón flotante inferior
          Positioned(
            bottom: 130.0,
            right: 16.0,
            child: GestureDetector(
              onTap: () => _addMarker(_currentLocation!),
              child: Container(
                width: 40, // Tamaño del círculo
                height: 40, // Tamaño del círculo
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo blanco para la imagen
                  shape: BoxShape.circle, // Hace el contenedor circular
                  border: Border.all(
                    color: Color(0xFF4261F9), // Color del borde azul
                    width: 1, // Grosor del borde
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Espaciado alrededor de la imagen
                  child: Image.asset(
                    'lib/ui/assets/addMarker.png', // Tu imagen personalizada
                    width: 40, // Tamaño de la imagen dentro del botón
                    height: 40, // Tamaño de la imagen dentro del botón
                  ),
                ),
              ),
            ),
          ),
          // Botón flotante superior
          Positioned(
            bottom:
                180.0, // Ajusta la distancia desde el fondo según lo necesites
            right: 16.0,
            child: GestureDetector(
              onTap: () {
                // Acción para centrar en la ubicación
                if (_currentLocation != null) {
                  _mapController?.animateCamera(
                    CameraUpdate.newLatLng(_currentLocation!),
                  );
                }
              },
              child: Container(
                width: 40, // Tamaño del círculo
                height: 40, // Tamaño del círculo
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo blanco para el icono
                  shape: BoxShape.circle, // Hace el contenedor circular
                  border: Border.all(
                    color: Color(0xFF4261F9), // Color del borde azul
                    width: 1, // Grosor del borde
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Espaciado alrededor de la imagen
                  child: Image.asset(
                    'lib/ui/assets/myUbication.png', // Tu imagen personalizada
                    width: 40, // Tamaño de la imagen dentro del botón
                    height: 40, // Tamaño de la imagen dentro del botón
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom:
                80.0, // Ajusta la distancia desde el fondo según lo necesites
            right: 16.0,
            child: GestureDetector(
              onTap: () {
                print("open modal");
              },
              child: Container(
                width: 40, // Tamaño del círculo
                height: 40, // Tamaño del círculo
                decoration: BoxDecoration(
                  color: Colors.white, // Fondo blanco para el icono
                  shape: BoxShape.circle, // Hace el contenedor circular
                  border: Border.all(
                    color: Color(0xFF4261F9), // Color del borde azul
                    width: 1, // Grosor del borde
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(
                      8.0), // Espaciado alrededor de la imagen
                  child: Image.asset(
                    'lib/ui/assets/book.png', // Tu imagen personalizada
                    width: 40, // Tamaño de la imagen dentro del botón
                    height: 40, // Tamaño de la imagen dentro del botón
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
