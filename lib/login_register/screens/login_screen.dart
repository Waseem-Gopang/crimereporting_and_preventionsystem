import 'package:crimereporting_and_preventionsystem/login_register/components/header_widget.dart';
import 'package:crimereporting_and_preventionsystem/service/firebase.dart';
import 'package:crimereporting_and_preventionsystem/utils/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final double _headerHeight = 250;
  final Key _formKey = GlobalKey<FormState>();

  String email = "";
  String pass = "";
  bool _isObscure = true;
  String? uID;

  Map? userInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: _headerHeight,
              child: HeaderWidget(
                  _headerHeight), //let's create a common header widget
            ),
            SafeArea(
              child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  // This will be the login form
                  child: Column(
                    children: [
                      const Text(
                        'Welcome Back',
                        style: TextStyle(
                            fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        'Sign In to your account',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 30.0),
                      Form(
                          key: _formKey,
                          child: Column(children: [
                            getTextField(
                                prefixIcon: const Icon(Icons.email_outlined),
                                text: 'E-mail address',
                                hint: 'Enter your email',
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return 'Please enter your email';
                                  } else if ((val.isNotEmpty) &&
                                      !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                                          .hasMatch(val)) {
                                    return "Enter a valid email";
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                }),
                            getTextField(
                              prefixIcon: const Icon(Icons.fingerprint),
                              text: 'Password',
                              hint: 'Enter your password',
                              isObscure: _isObscure,
                              suffixIcon: IconButton(
                                  icon: Icon(_isObscure
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _isObscure = !_isObscure;
                                    });
                                  }),
                              valError: 'Please enter your password',
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Please enter the password";
                                } else if (val.length <= 5) {
                                  return "Password should be 6 characters or more";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  pass = value;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text.rich(
                                TextSpan(
                                  text: 'Forget Password?',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pushNamed(
                                          context, "/forget password");
                                    },
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.redAccent.shade700),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            getSignInButton(),
                            redirectToRegister(),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 25),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.5,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Text(
                                      'OR',
                                      style: TextStyle(
                                          color: Colors.grey.shade600),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      thickness: 0.8,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await signInWithFacebook();
                                  },
                                  icon: CircleAvatar(
                                    radius: 35,
                                    child: Image.asset(
                                        'assets/icons/facebook.png'),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    var user = await signInWithGoogle();
                                    if (user != null) {
                                      Get.snackbar("Congratulation!",
                                          "You have successfully Signed In.",
                                          duration: const Duration(seconds: 5),
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white);
                                      Get.offAllNamed('/home');
                                    }
                                  },
                                  icon: CircleAvatar(
                                    radius: 35,
                                    backgroundColor: Colors.transparent,
                                    child:
                                        Image.asset('assets/icons/google.png'),
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await githubLogin(context);
                                  },
                                  icon: CircleAvatar(
                                    radius: 35,
                                    child:
                                        Image.asset('assets/icons/github.png'),
                                  ),
                                ),
                              ],
                            )
                          ])),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }

  getTextField(
      {Icon? prefixIcon,
      String? text,
      String? hint,
      String? valError,
      IconButton? suffixIcon,
      Function(String)? onChanged,
      bool? isObscure,
      String? Function(String?)? validator}) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: ThemeHelper().inputBoxDecorationShaddow(),
      child: TextFormField(
        obscureText: isObscure ?? false,
        decoration: ThemeHelper()
            .textInputDecoration(prefixIcon!, text!, hint!, suffixIcon),
        onChanged: onChanged,
        validator: validator ??
            (val) {
              if (val!.isEmpty) {
                return valError;
              }
              return null;
            },
      ),
    );
  }

  redirectToRegister() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      //child: Text('Don\'t have an account? Create'),
      child: Text.rich(TextSpan(children: [
        const TextSpan(text: "Don't have an account? "),
        TextSpan(
          text: 'Create',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushNamed(context, "/register");
            },
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.redAccent.shade700),
        ),
      ])),
    );
  }

  getSignInButton() {
    return Container(
      decoration: ThemeHelper().buttonBoxDecoration(context),
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            'Sign In'.toUpperCase(),
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        onPressed: () async {
          var value = await signIn(email, pass);
          //check if user credentials are correct
          if (value != false) {
            //assign userID
            uID = value;
            //get userInfo from database
            // userInfo = await getUserData(uID!);
            //assign userID to global User instance
            //  Global.instance.user!.setUserInfo(uID!, userInfo!);
            Get.snackbar("Congratulation!", "You have successfully Signed In.",
                duration: const Duration(seconds: 5),
                backgroundColor: Colors.green,
                colorText: Colors.white);
            Get.offAllNamed("/home");
            // Navigator.of(context).pushNamedAndRemoveUntil(
            //     '/home', (Route<dynamic> route) => false);
          }
        },
      ),
    );
  }
}
