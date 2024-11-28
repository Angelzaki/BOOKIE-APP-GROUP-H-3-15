import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? _currentLocation;
  final List<LatLng> _markers = [];
  double _currentZoom = 13.0;
  bool _hasUserMovedMap = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _listenLocationUpdates();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, habilita los servicios de ubicación.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
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
        const SnackBar(content: Text('Los permisos están denegados permanentemente.')),
      );
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
      _markers.clear();
      _markers.add(_currentLocation!);
      _mapController.move(_currentLocation!, _currentZoom);
    });
  }

  void _listenLocationUpdates() {
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _markers[0] = _currentLocation!;
        if (!_hasUserMovedMap) {
          _mapController.move(_currentLocation!, _mapController.camera.zoom);
        }
      });
    });
  }

  void _addMarkerAtCurrentLocation() {
    if (_currentLocation != null) {
      setState(() {
        _markers.add(_currentLocation!);
      });
    }
  }

  void _onMarkerTapped(LatLng position) {
    _showMarkerModal(context, position);
  }

  void _showMarkerModal(BuildContext context, LatLng position) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información del Marcador',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text('Latitud: ${position.latitude.toStringAsFixed(6)}'),
              Text('Longitud: ${position.longitude.toStringAsFixed(6)}'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cerrar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    body: SizedBox.expand( // Asegura que el mapa ocupe toda la pantalla
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialZoom: _currentZoom,
          onPositionChanged: (position, hasGesture) {
            if (hasGesture) {
              setState(() {
                _hasUserMovedMap = true;
                _currentZoom = position.zoom;
              });
            }
          },
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          ),
          MarkerLayer(
            markers: _markers.map((position) {
              return Marker(
                point: position,
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () => _onMarkerTapped(position),
                  child: position == _currentLocation
                      ? const Icon(
                          Icons.location_on,
                          color: Colors.blue,
                          size: 35,
                        )
                      : const Icon(
                          Icons.location_on,
                          color: Colors.red,
                          size: 30,
                        ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ),
    floatingActionButton: Padding(
      padding: const EdgeInsets.only(bottom: 65.0), // Ajusta este valor según sea necesario
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _hasUserMovedMap = false;
              });
              _getCurrentLocation();
            },
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            onPressed: _addMarkerAtCurrentLocation,
            child: const Icon(Icons.pin_drop),
          ),
        ],
      ),
    ),
  );
}

}
