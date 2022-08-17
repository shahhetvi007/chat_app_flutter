import 'package:chat_app/helper/auth_helper.dart';
import 'package:chat_app/helper/login_page.dart';
import 'package:chat_app/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = '';
  String password = '';
  String username = '';

  TextEditingController passwordController = TextEditingController();

  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Sign Up',
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
              controller: passwordController,
              keyboardType: TextInputType.text,
              obscureText: true,
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
            TextFormField(
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value != passwordController.text) {
                  return 'Password do not match';
                }
                return null;
              },
              obscureText: true,
              onChanged: (val) {
                print(val);
                if (val == passwordController.text) {
                  setState(() {
                    password = val;
                  });
                }
              },
              decoration: const InputDecoration(
                  hintText: 'Confirm Password',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12))),
            ),
            const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter username';
                }
                return null;
              },
              onChanged: (val) {
                print(val);
                setState(() {
                  username = val;
                });
              },
              decoration: const InputDecoration(
                  hintText: 'Username',
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12))),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () {
                  print("$email,$password");
                  AuthHelper().signUp(email, password).then((value) {
                    if (value == null) {
                      addUserToDb();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => HomePage()));
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(value)));
                    }
                  });
                },
                child: const Text('Sign Up')),
            const SizedBox(height: 20),
            InkWell(
              child: const Text('Already Signed Up? Log In'),
              onTap: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (ctx) => const LoginPage()));
              },
            ),
          ],
        ),
      ),
    );
  }

  Future addUserToDb() async {
    try {
      await _firestore.collection('users').doc(AuthHelper().user.uid).set({
        'email': email,
        'id': AuthHelper().user.uid,
        'username': username,
      });
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }
}
