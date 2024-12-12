import 'package:flutter/material.dart';

void openCustomModal(
    BuildContext context,
    String title,
    String content,
    int chapterNumber,
    String imageUrl,
    VoidCallback onStartRoute,
    VoidCallback onCancel) {
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
                // Row with photo and title/chapter - moved up more
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start, // Align to top
                  children: [
                    // Foto (cuadrado)
                    Container(
                      width: 130,
                      height: 140,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    // Espacio entre la foto y el contenido
                    SizedBox(width: 8),
                    // Título y Número de Capítulo a la derecha de la foto
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          "Capítulo: $chapterNumber",
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Rest of the code remains the same...
                SizedBox(height: 8),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 280, // Establece el ancho del botón
                            child: ElevatedButton(
                              onPressed: () {                                
                                onStartRoute();
                                Navigator.pop(context); // Cierra el modal
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(
                                    0xFF4261F9), // Color de fondo del botón
                                foregroundColor:
                                    Colors.white, // Color del texto
                                textStyle: TextStyle(
                                  fontSize: 15, // Ajusta el tamaño de la letra
                                ),
                              ),
                              child: Text("Comenzar Trayecto"),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 280, // Establece el ancho del botón
                            child: TextButton(
                              onPressed: () {
                                onCancel();
                                Navigator.pop(context);
                              },
                              style: TextButton.styleFrom(
                                side: BorderSide(
                                  color: Color(0xFF4261F9), // Color del borde
                                  width: 1, // Ancho del borde
                                ),
                              ),
                              child: Text(
                                "Cancelar",
                                style: TextStyle(color: Color(0xFF4261F9)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
