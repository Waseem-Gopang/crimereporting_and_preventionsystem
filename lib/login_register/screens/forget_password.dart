import 'package:crimereporting_and_preventionsystem/login_register/components/header_widget.dart';
import 'package:crimereporting_and_preventionsystem/utils/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final double _headerHeight = 250;

  final Key _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(children: [
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
            child: Column(children: [
              const Text(
                'Forget Password',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              const Text(
                'You can reset your Password here!',
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
                    ),
                    const SizedBox(height: 15.0),
                    getRecoverButton(),
                    const SizedBox(height: 15.0),
                    backToSignIn()
                  ]))
            ]),
          ))
        ])));
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

  getRecoverButton() {
    return Container(
      decoration: ThemeHelper().buttonBoxDecoration(context),
      child: ElevatedButton(
        style: ThemeHelper().buttonStyle(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
          child: Text(
            'Recover'.toUpperCase(),
            style: const TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        onPressed: () async {
          // var value = await signIn(email, pass);
          // //check if user credentials are correct
          // if (value != false) {
          //   //assign userID
          //   uID = value;
          //   //get userInfo from database
          //   userInfo = await getUserData(uID!);
          //   //assign userID to global User instance
          //   Global.instance.user!.setUserInfo(uID!, userInfo!);

          //   Fluttertoast.showToast(msg: "User Logged In Successfully");
          //   Navigator.of(context).pushNamedAndRemoveUntil(
          //       '/home', (Route<dynamic> route) => false);
          // }
        },
      ),
    );
  }

  backToSignIn() {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 20, 10, 20),
      //child: Text('Don\'t have an account? Create'),
      child: Text.rich(TextSpan(children: [
        const TextSpan(text: "Do you want to go back? "),
        TextSpan(
          text: 'Login',
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              Navigator.pushNamed(context, "/login");
            },
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.redAccent.shade700),
        ),
      ])),
    );
  }
}
