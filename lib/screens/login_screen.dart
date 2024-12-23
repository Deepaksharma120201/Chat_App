import 'package:chat_app/screens/signup_screen.dart';
import 'package:chat_app/widgets/custom_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _firebase = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  var _email = '';
  var _password = '';
  var _isLoading = false;

  void _submit() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });
      // ignore: unused_local_variable
      final userCredential = await _firebase.signInWithEmailAndPassword(
        email: _email,
        password: _password,
      );
    } on FirebaseAuthException catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              e.message ?? 'Authentication failed',
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
                  margin: const EdgeInsets.all(15),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
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
                              onSaved: (newValue) => _email = newValue,
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
                              obscureText: _obscurePassword,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              label: 'Password',
                              hintText: 'Enter password',
                              keyboard: TextInputType.text,
                              onSaved: (newValue) => _password = newValue,
                            ),
                            const SizedBox(height: 30),
                            if (_isLoading) const CircularProgressIndicator(),
                            if (!_isLoading)
                              ElevatedButton(
                                onPressed: _submit,
                                child: const Text('Login'),
                              ),
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Doesn\'t have an account?  ',
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
                                            const SignupScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Signup',
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
