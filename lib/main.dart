// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:weather_app/homepage.dart';
import 'package:weather_app/signup.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: 'AIzaSyD9F00tpmwwCrXj37Eb-nFHV3Xt_8UHg2w',
       appId: '1:422210394844:android:1f66e6f2ca17c73e637219',
        messagingSenderId: '422210394844', 
        projectId: 'weatherapp-a72a0')
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // routes: {
      //   '/login': (context) => SignInPage(),
      //   '/signUp': (context) => SignUpPage(),
      //   '/home': (context) => Homepage(),
      // },    
      // initialRoute: "/login",
  
      debugShowCheckedModeBanner: false,
      home:  SignUpPage(),
    );
  }
}
