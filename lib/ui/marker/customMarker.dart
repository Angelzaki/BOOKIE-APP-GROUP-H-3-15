import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<BitmapDescriptor> createCustomMarker(String imagePath) async {
  try {
    // Cargar la imagen desde los assets
    final ByteData imageData = await rootBundle.load(imagePath);
    final Uint8List bytes = imageData.buffer.asUint8List();

    // Decodificar la imagen a un formato de ui.Image
    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(bytes, (ui.Image img) {
      completer.complete(img);
    });

    final ui.Image image = await completer.future;

    // Convertir la imagen en bytes
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
    } else {
      throw Exception("No se pudo generar el marcador a partir de la imagen.");
    }
  } catch (e) {
    print("Error al crear el marcador personalizado: $e");
    throw e;
  }
}
