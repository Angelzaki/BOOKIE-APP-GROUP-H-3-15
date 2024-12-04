import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:bookieapp/ui/Navigator/bottomtabs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {    
    await dotenv.load(fileName: ".env");    
  } catch (e) {
    print("Error al cargar .env: $e");
  }

  runApp(const MyApp());
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
      home: const BottomTabsNavigatorState(),
    );
  }
}
