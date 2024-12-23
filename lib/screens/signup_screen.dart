import 'dart:io';
import 'package:chat_app/screens/login_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:chat_app/widgets/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();

  var _username = '';
  var _email = '';
  var _password = '';
  File? _pickedImage;
  var _isLoading = false;

  void _submit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid || _pickedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Image field is Empty!!'),
        ),
      );
      return;
    }
    formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });
      final userCredential = await _firebase.createUserWithEmailAndPassword(
        email: _email,
        password: _password,
      );

      FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'username': _username,
        'email': _email,
      });

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ChatScreen(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.message ?? 'Authentication failed',
            ),
          ),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.primary,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                    left: 20,
                    right: 20,
                  ),
                  width: 200,
                  child: Image.asset('assets/images/chat.png'),
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            UserImagePicker(
                              onPickImage: (pickedImage) {
                                _pickedImage = pickedImage;
                              },
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill this field!';
                                } else if (value.length < 4) {
                                  return 'Name must be at least 2 characters long';
                                }
                                return null;
                              },
                              label: 'Username',
                              hintText: 'Enter name',
                              keyboard: TextInputType.emailAddress,
                              onSaved: (newValue) => _username = newValue,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill this field!';
                                }
                                final validEmailPattern = RegExp(
                                    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                                if (!validEmailPattern.hasMatch(value)) {
                                  return 'Please enter a valid email.';
                                }
                                return null;
                              },
                              label: 'Email Address',
                              hintText: 'Enter Email',
                              keyboard: TextInputType.emailAddress,
                              onSaved: (val) => _email = val,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill this field!';
                                } else if (value.length < 6) {
                                  return 'Password must be at least 6 characters long';
                                }
                                return null;
                              },
                              label: 'Password',
                              hintText: 'Enter password',
                              keyboard: TextInputType.text,
                              onSaved: (val) => _password = val,
                            ),
                            const SizedBox(height: 20),
                            if (_isLoading) const CircularProgressIndicator(),
                            if (!_isLoading)
                              ElevatedButton(
                                onPressed: _submit,
                                child: const Text('Create Your Account'),
                              ),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Already have an account?  ',
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontSize: 20,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
