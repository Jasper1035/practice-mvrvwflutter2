import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mvrvwflutter2/firebase_options.dart';
import 'package:mvrvwflutter2/main_page.dart';
// import 'package:mvrvwflutter2/sign_in.dart';
// import 'package:mvrvwflutter2/main_page.dart';
// import 'package:mvrvwflutter2/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyHomePage());
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffffffff)),
      ),

      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}
