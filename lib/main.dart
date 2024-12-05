import 'package:bookieapp/app/app_routes.dart';
import 'package:bookieapp/app/injection_container.dart';
import 'package:bookieapp/ui/pages/splashscreen.dart';
import 'package:bookieapp/ui/store/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bookieapp/ui/Navigator/bottomtabs.dart';
import 'package:provider/provider.dart';
 

  
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {    
    await dotenv.load(fileName: ".env");    
  } catch (e) {
    print("Error al cargar .env: $e");  
  }
  await init();
  runApp(Provider(create: (_)=>MainStore(),child:const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
      ),
    );

    return MaterialApp(
      title: 'Flutter Bottom Tabs',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const BottomTabsNavigatorState(),
      // home: MainStore().authStore.hasSession
      //   ? const BottomTabsNavigatorState() // Si está logueado, vamos al BottomTabsNavigator
      //   : SplashScreen(), // Si no está logueado, mostramos SplashScreen (o LoginScreen según prefieras)
      initialRoute: "/splashScreen",
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}