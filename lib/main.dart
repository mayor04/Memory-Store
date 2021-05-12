import 'package:flutter/material.dart';
import 'package:image_cloud_server/providers/auth_provider.dart';
import 'package:image_cloud_server/providers/media_provider.dart';
import 'package:image_cloud_server/screens/home.dart';
import 'package:image_cloud_server/screens/login.dart';
import 'package:image_cloud_server/screens/picture_display.dart';
import 'package:image_cloud_server/screens/picture_taker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider()),
        ChangeNotifierProvider<MediaProvider>(
            create: (context) => MediaProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => LoginScreen(),
          '/home': (context) => HomeScreen(),
          '/takePicture': (context) => TakePictureScreen(),
        },
        // home: LoginScreen(),
      ),
    );
  }
}
