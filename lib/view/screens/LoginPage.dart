import 'package:flutter/material.dart';

import '../../helper/firebase_helper.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? email;
  String? password;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: const EdgeInsets.all(15),
          alignment: Alignment.center,
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                Color(0xff263961),
                Color(0xff3b4c70),
                Color(0xff516080),
              ])),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 110,
                  ),
                  Image.asset(
                    'assets/image/logo.png',
                    color: Colors.white,
                    width: 200,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Form(
                    key: signInFormKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter your email first......";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            setState(() {
                              email = emailController.text;
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Email",
                              labelText: "Email",
                              hintStyle: TextStyle(color: Colors.grey),
                              labelStyle: TextStyle(color: Colors.grey)),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          validator: (val) {
                            if (val!.isEmpty) {
                              return "Enter your password first......";
                            }
                            return null;
                          },
                          onSaved: (val) {
                            setState(() {
                              password = passwordController.text;
                            });
                          },
                          style: const TextStyle(color: Colors.white),
                          controller: passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password",
                              labelText: "Password",
                              suffixIcon: Icon(
                                Icons.remove_red_eye_rounded,
                                color: Colors.grey,
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              labelStyle: TextStyle(color: Colors.grey)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 145, vertical: 10)),
                      onPressed: () async {
                        if (signInFormKey.currentState!.validate()) {
                          signInFormKey.currentState!.save();

                          Map<String, dynamic> res = await FirebaseAuthHelper
                              .firebaseAuthHelper
                              .signIn(email: email!, password: password!);

                          if (res['user'] != null) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Login In Successful....."),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Color(0xff263961),
                            ));
                            Navigator.of(context).pushReplacementNamed('/',
                                arguments: res['user']);
                          } else if (res['error'] != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(res['error']),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Color(0xff263961),
                            ));
                          } else {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("Login In Failed....."),
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Color(0xff263961),
                            ));
                          }
                        }
                        setState(() {
                          emailController.clear();
                          passwordController.clear();
                          email = null;
                          password = null;
                        });
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "-------------------------- OR --------------------------",
                    style: TextStyle(color: Colors.white),
                  ),
                  TextButton(
                      onPressed: () async {
                        Map<String, dynamic> res = await FirebaseAuthHelper
                            .firebaseAuthHelper
                            .logInWithAnonymously();

                        if (res['user'] != null) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Login Successful....."),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xff263961),
                          ));
                          Navigator.of(context).pushReplacementNamed('/',
                              arguments: res['user']);
                        } else if (res['error'] != null) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(res['error']),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xff263961),
                          ));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(
                            content: Text("Login Failed....."),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Color(0xff263961),
                          ));
                        }
                      },
                      child: const Text(
                        "Guest Account",
                        style: TextStyle(color: Colors.white, fontSize: 15),
                      )),
                  GestureDetector(
                    onTap: () async {
                      Map<String, dynamic> res = await FirebaseAuthHelper
                          .firebaseAuthHelper
                          .signInWithGoogle();
                      if (res['user'] != null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Login Successful With Google....."),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xff263961),
                        ));
                        Navigator.of(context)
                            .pushReplacementNamed('/', arguments: res['user']);
                      } else if (res['error'] != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(res['error']),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xff263961),
                        ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Login Failed With Google....."),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xff263961),
                        ));
                      }
                    },
                    child: Container(
                      height: 50,
                      width: 345,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white.withOpacity(0.8), width: 2),
                          borderRadius: BorderRadius.circular(40)),
                      child: Row(
                        children: [
                          const SizedBox(
                            width: 50,
                          ),
                          Image.asset('assets/image/goggle.png'),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "Login With Goggle ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('signup');
                    },
                    child: const Text(
                      "Create new Account ?",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
