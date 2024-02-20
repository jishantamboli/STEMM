// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/Auth/firebase_auth.dart';
import 'package:weather_app/homepage.dart';
import 'package:weather_app/signup.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passcontroller = TextEditingController();

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            height: MediaQuery.sizeOf(context).height,
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              children: [
                SizedBox(height: 50,),
                Container(
                  height: 300,
                  width: 300,
                  // color: Colors.red,
                  child: Image.network("https://static.vecteezy.com/system/resources/previews/005/879/539/non_2x/cloud-computing-modern-flat-concept-for-web-banner-design-man-enters-password-and-login-to-access-cloud-storage-for-uploading-and-processing-files-illustration-with-isolated-people-scene-free-vector.jpg",fit: BoxFit.contain,),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Sign In",style: TextStyle(fontSize: 24),),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _emailcontroller,
                    decoration: InputDecoration(
                      disabledBorder: InputBorder.none,
                        hintText: "email",
                        contentPadding: EdgeInsets.only(left: 16),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(16))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    obscureText: true,
                    controller: _passcontroller,
                    decoration: InputDecoration(
                        hintText: "password",
                        contentPadding: EdgeInsets.only(left: 16),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16))),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text("Forget Password?", style: TextStyle(color: Colors.deepPurpleAccent, fontWeight: FontWeight.w600),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.90,
                    child: ElevatedButton(
                        onPressed: () {
                          // signin();
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Homepage()));
                        },
                        child: Text("Login")),
                  ),
                ),
                 Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUpPage()));
                },
                child: Text.rich(TextSpan(children: [
                  TextSpan(
                      text: "Don't have an account? ", style: TextStyle()),
                  TextSpan(
                      text: "SignUp",
                      style: TextStyle(fontWeight: FontWeight.w700, color: Colors.deepPurpleAccent))
                ])),
              ),
            )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void signin() async {
    String password = _emailcontroller.text;
    String email = _passcontroller.text;

    User? user = await _auth.signInWithEmailAndPassword(email, password);

    if (user != null) {
      print("User is successfully created");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Homepage()));
    } else {
      print("Some error while login");
    }
  }
}
