import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:bookieapp/ui/store/main_store.dart';
import 'package:bookieapp/ui/store/auth/auth_store.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  late AuthStore authStore;

  @override
  Widget build(BuildContext context) {
    authStore = Provider.of<MainStore>(context).authStore;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Iniciar sesión', 
          style: TextStyle(
            fontSize: 40, 
            fontWeight: FontWeight.bold,
            color: Color(0xFFFFFFFF)
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF4261F9),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Observer(
          builder: (_) {
            if (authStore.loading) {
              return const CircularProgressIndicator();
            }

            // Si el usuario ha iniciado sesión, muestra el botón de cerrar sesión
            if (authStore.hasSession) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, "/splashScreen");
              });

              // return Column(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text('¡Bienvenido!'),
              //     ElevatedButton(
              //       onPressed: () {
              //         // Llama a la acción para cerrar sesión
              //         authStore.logOut();
              //       },
              //       child: const Text('Cerrar sesión'),
              //     ),
              //   ],
              // );
            }

            // Si no ha iniciado sesión, muestra el botón de inicio de sesión
            return ElevatedButton(
              onPressed: () async {
                await authStore.signInWithGoogle();
              },
              style: ElevatedButton.styleFrom(
                 backgroundColor: const Color(0xFFFFFFFF), // Establece el color de fondo del botón
              ),
              child: const Text(
                'Iniciar sesión con Google',
                style: TextStyle(
                  // fontSize: 0, 
                  fontWeight: FontWeight.bold,
                  // color: Color(0xFFFFFFFF)
                ),
              ),
              
              
            );
          },
        ),
      ),
    );
  }
}
