import 'package:animated_splash_screen/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([
    SystemUiOverlay.bottom,
    SystemUiOverlay.top,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'animated_splash_screen',
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
        milliseconds: 1000,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => animateToHome(context));
  }

  Future<void> animateToHome(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 500));
    await _splashController.forward();
    await _splashController.reverse();
    Navigator.of(context).pushReplacement(_splashRoute());
  }

  Route _splashRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Home(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var curve = Curves.ease;
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        final tween = Tween(begin: begin, end: end);
        final curvedAnimation =
            CurvedAnimation(parent: animation, curve: curve);
        return SlideTransition(
          position: tween.animate(curvedAnimation),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = MediaQuery.of(context).platformBrightness;
    bool darkMode = scheme == Brightness.dark;
    final tween = Tween<double>(begin: 250, end: 500);
    var animation = tween.animate(_splashController);
    return Scaffold(
      body: Container(
        color: darkMode ? Colors.black : Colors.white,
        child: Align(
          alignment: Alignment.center,
          child: RotationTransition(
            turns: _splashController,
            child: AnimatedBuilder(
              animation: _splashController,
              builder: (context, child) {
                return Container(
                  height: animation.value,
                  width: animation.value,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/images/splash.png'),
                    ),
                  ),
                );
              },
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
