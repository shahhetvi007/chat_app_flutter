import 'package:chat_app/helper/auth_helper.dart';
import 'package:chat_app/screens/homePage.dart';
import 'package:chat_app/screens/signup_page.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Log In',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (val) {
                setState(() {
                  email = val;
                });
              },
              decoration: const InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12))),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              onChanged: (value) {
                setState(() {
                  password = value;
                });
              },
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              decoration: const InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  print("$email,$password");
                  AuthHelper().signIn(email, password).then((value) {
                    if (value == null) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => HomePage()));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value)));
                    }
                  });
                },
                child: const Text('Log In')),
            const SizedBox(height: 20),
            InkWell(
              child: const Text('Not yet Signed Up? Sign Up'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => SignUpPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
