import 'package:flutter/material.dart';
 
import '/login/session.dart';
import '/login/login.dart';
import '/model/customerFetch.dart';




Future<void>main() async{
 
  WidgetsFlutterBinding.ensureInitialized();
  Session session = new Session();
  final Future<String?> email = session.getSession();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home:email == null ?   CustomerCardScreen() : LoginPage(), ));
}

