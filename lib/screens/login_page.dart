import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/screens/home_screen.dart';
import "../utils/sign_in.dart";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlutterLogo(size: 150),
              SizedBox(height: 50),
              _signInButton(),
              emailField(),
              Container(margin: EdgeInsets.only(bottom: 25.0)),
              passwordField(),
              Container(margin: EdgeInsets.only(bottom: 25.0)),
              submitButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().then((result) {
          if (result != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return HomeScreen();
                },
              ),
            );
          }
        }).catchError((onError) {
          print(onError);
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

String email = '';
String password = '';

Widget emailField() {
  return Container(
    width: 200.0,
    child: TextFormField(
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'you@exmaple.com',
      ),
      onChanged: (text) {
        email = text;
      },
    ),
  );
}

Widget passwordField() {
  return Container(
      width: 200.0,
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
          labelText: 'Password',
          hintText: 'Password',
        ),
        onChanged: (text) {
          password = text;
        },
      ));
}

Widget submitButton(context) {
  return ElevatedButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed))
            return Theme.of(context).colorScheme.primary.withOpacity(0.5);
          return null; // Use the component's default.
        },
      ),
    ),
    child: Text('submit'),
    onPressed: () {
      print("Email:$email password: $password");
      signInWithEmailAndPassword(email, password).then((result) {
        if (result != null) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return HomeScreen();
              },
            ),
          );
        }
      });
      //Todo Validate the Login Info
    },
  );
}
