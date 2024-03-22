import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_3/components/CustomButton.dart';
import 'package:flutter_application_3/components/TextFormfield.dart';
import 'package:flutter_application_3/components/customlogoauth.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController ads = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;
  Future signInWithGoogle() async {
    isLoading = true;
    setState(() {});
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return 0;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    isLoading = false;
    setState(() {});
    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.amber),
            ))
          : Container(
              padding: const EdgeInsets.all(20),
              child: ListView(children: [
                Form(
                  key: formState,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50,
                      ),
                      const CustomLogoAuth(),
                      Container(
                        height: 40,
                      ),
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        height: 5,
                      ),
                      const Text(
                        "Login to continue using the app",
                        style: TextStyle(color: Colors.grey),
                      ),
                      Container(
                        height: 20,
                      ),
                      const Text(
                        'Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Container(
                        height: 10,
                      ),
                      CustomTextFormField(
                        hinttext: "Enter your Email",
                        mycontroller: email,
                        validator: (val) {
                          if (val == "") {
                            return "Can't be Empty";
                          }
                          return null;
                        },
                      ),
                      Container(
                        height: 10,
                      ),
                      const Text('Password',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      Container(
                        height: 10,
                      ),
                      CustomTextFormField(
                          validator: (val) {
                            if (val == "") {
                              return "Can't be Empty";
                            }
                            return null;
                          },
                          hinttext: "Enter your Password",
                          mycontroller: password),
                      InkWell(
                        onTap: () async {
                          if (email.text == "") {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'Error',
                              desc:
                                  'Please enter you email before clicking "Forget Password"',
                            ).show();
                            return;
                          }
                          try {
                            await FirebaseAuth.instance
                                .sendPasswordResetEmail(email: email.text);
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.success,
                              animType: AnimType.rightSlide,
                              title: 'success',
                              desc: 'Check your mailbox to reset password !',
                            ).show();
                          } catch (e) {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.error,
                              animType: AnimType.rightSlide,
                              title: 'warning',
                              desc: 'The Email is not registered',
                            ).show();
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(top: 10, bottom: 20),
                          alignment: Alignment.centerRight,
                          child: const Text(
                            'Forget Password',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.right,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Builder(builder: (context) {
                  return CustomButton(
                      title: "Login",
                      onPressed: () async {
                        if (formState.currentState!.validate()) {
                          try {
                            Future.delayed(Duration(seconds: 1));

                            final credential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: email.text, password: password.text);

                            if (credential.user!.emailVerified) {
                              Navigator.of(context)
                                  .pushReplacementNamed("homepage");
                            } else {
                              AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.error,
                                      animType: AnimType.rightSlide,
                                      title: 'Error',
                                      desc: 'verify email')
                                  .show();
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == e.code) {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.rightSlide,
                                title: 'Error',
                                desc: 'Wrong Email or password !',
                              ).show();
                            } else {
                              print('Not valid000000000000000000000');
                            }
                          }
                        }
                      });
                }),
                Container(
                  height: 20,
                ),
                MaterialButton(
                  height: 40,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  color: const Color.fromARGB(255, 254, 53, 53),
                  onPressed: () {
                    signInWithGoogle();
                  },
                  textColor: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Login With Google"),
                      Image.asset(
                        'images/google.png',
                        width: 30,
                      )
                    ],
                  ),
                ),
                Container(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacementNamed("signup");
                  },
                  child: const Center(
                    child: Text.rich(TextSpan(children: [
                      TextSpan(text: "Don't have An Account ?"),
                      TextSpan(
                          text: " Register",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 255, 174, 0)))
                    ])),
                  ),
                )
              ])),
    );
  }
}
