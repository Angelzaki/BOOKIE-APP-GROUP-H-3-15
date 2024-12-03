import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:bookieapp/ui/store/main_store.dart';
import 'package:bookieapp/ui/pages/loginscreen.dart'; // Asegúrate de importar LoginScreen

class EditScreen extends StatefulWidget {
  const EditScreen({super.key});

  @override
  State<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context){
      final authStore = Provider.of<MainStore>(context).authStore;

      return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Screen'),
          automaticallyImplyLeading: false,
          actions: [
            // Mostrar el botón de logout solo si el usuario está logueado
            
            if (authStore.hasSession)
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () async {
                  await authStore.logOut(); // Llamar a logOut del AuthStore
                  
                  // Verificar si el widget aún está montado antes de realizar la navegación
                  if (!mounted) return; // Si el widget ha sido desmontado, no realizar la navegación
                  
                  // Verificar si el contexto sigue disponible para navegar
                  if (mounted) {
                    // Redirigir a LoginScreen después de hacer logout
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    );
                  }
                },
              ),
          ],
        ),
        body: const Center(
          child: Text('EditScreen'),
          ),
      );
    },);
  }
}
