
import 'package:bookieapp/ui/Navigator/bottomtabs.dart';
import 'package:bookieapp/ui/pages/homescreen.dart';
import 'package:bookieapp/ui/pages/loginscreen.dart';
import 'package:bookieapp/ui/store/main_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => SplashScreenState();

}

class SplashScreenState extends State<SplashScreen>with TickerProviderStateMixin{
  double turns = 0.0;
  late AnimationController animationController;


  @override
  void initState() {
    super.initState();
    
    animationController =  AnimationController(vsync: this, duration: Duration(seconds: 2))..repeat(reverse: true);

    MainStore mainStore = Provider.of<MainStore>(context, listen: false);
    mainStore.authStore.checkLoginStatus().then((_){
      if (mainStore.authStore.hasSession) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const BottomTabsNavigatorState()),
          );
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => LoginScreen()),
          );
        });
      }
    });
  }
   @override
  void dispose() {
    // Asegurarse de detener el AnimationController y liberar los recursos
    animationController.dispose();
    super.dispose(); // Llamar a dispose del super para limpiar el estado del widget.
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        body: Center(child:RotationTransition(
          turns: animationController,
          child: Icon(Icons.settings_sharp,size: 200,color: Colors.purple.withOpacity(0.7),),
          alignment: Alignment.center,
        ),
        ));
  }

}