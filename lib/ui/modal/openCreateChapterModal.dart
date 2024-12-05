import 'package:flutter/material.dart';
import 'package:bookieapp/domain/models/Chapter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart'; // Importar esto si necesitas usar LatLng

// Refactorizamos para aceptar parámetros como capítulos y funciones necesarias
void showAddChapterModal(
  BuildContext context,
  List<Chapter> chapters, // Lista de capítulos
  Function(LatLng) addMarker, // Función para agregar marcador en el mapa
  Function setState, // setState para actualizar la UI
  double latitud, // LatLng que se usa como coordenada para el capítulo
  double longitud, // LatLng que se usa como coordenada para el capítulo
) {
  // Controladores de los campos de texto
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.transparent,
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: Container(
          width: 347,
          height: 380,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 4,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Agregar Nuevo Capítulo",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 16),
                // Título
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(labelText: "Título"),
                ),
                SizedBox(height: 8),
                // Contenido
                TextField(
                  controller: contentController,
                  decoration: InputDecoration(labelText: "Contenido"),
                  maxLines: 4,
                ),
                SizedBox(height: 16),
                // Botón para agregar el capítulo
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // Crear el nuevo capítulo con los datos ingresados
                      final newChapter = Chapter(
                        storyId: chapters.length + 1,
                        title: titleController.text,
                        content: contentController.text,
                        latitude: latitud, // Usamos la latitud de la ubicación actual
                        longitude: longitud, // Usamos la longitud de la ubicación actual
                        numberChapter: chapters.length + 1,
                      );

                      // Agregar el nuevo capítulo a la lista
                      setState(() {
                        chapters.add(newChapter);
                      });
                      LatLng currentLocation = LatLng(latitud, longitud);
                      // Añadir marcador en el mapa
                      addMarker(currentLocation); // Pasamos la ubicación actual como marcador

                      // Cerrar el modal
                      Navigator.pop(context);
                    },
                    child: Text("Agregar Capítulo"),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
