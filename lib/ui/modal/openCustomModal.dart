import 'package:flutter/material.dart';

void openCustomModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,  // Permite controlar la altura del modal
    backgroundColor: Colors.transparent,  // Fondo transparente, pero sin oscurecer la app
    barrierColor: Colors.transparent,  // Evita el fondo oscuro detrás del modal
    builder: (BuildContext context) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 80.0), // Ajusta la distancia desde el fondo
        child: Container(
          width: 347,
          height: 380, // Ajusta la altura del modal
          decoration: BoxDecoration(
            color: Colors.white, // Fondo blanco para el modal
            borderRadius: BorderRadius.all(Radius.circular(20.0)), // Bordes redondeados en todos los lados
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),  // Color de la sombra
                spreadRadius: 1,  // Expande un poco la sombra
                blurRadius: 4,    // Difusa la sombra
                offset: Offset(0, 4), // Desplazamiento de la sombra (puedes ajustarlo)
              ),
            ],
          ),
          child: Center(
            child: Text(
              "modal",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
    },
  );
}