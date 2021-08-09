import 'package:animated_splash_screen/home.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'animated_splash_screen',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _splashController;

  @override
  void initState() {
    super.initState();
    _splashController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: 650,
        ));
    WidgetsBinding.instance.addPostFrameCallback((_) => animateToHome(context));
  }

  Future<void> animateToHome(BuildContext context) async {
    await _splashController.forward();
    await _splashController.reverse();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => Home(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black54,
        child: Center(
          child: RotationTransition(
            turns: _splashController,
            child: Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/twitter_logo.png'))),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _splashController.dispose();
  }
}
