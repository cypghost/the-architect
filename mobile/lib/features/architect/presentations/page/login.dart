import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_bloc.dart';
import '../widget/loading_indicator.dart';
import 'home.dart';
import 'signup.dart'; // Import the SignUp widget from the same directory.

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();

  static const String name = '/login';
}

class _LoginState extends State<Login> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late bool _isObscure = true;
  bool _isEmailValid = false;
  bool _isPasswordValid = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _emailController.addListener(_onEmailChanged);
    _passwordController.addListener(_onPasswordChanged);
  }

  void _onEmailChanged() {
    final email = _emailController.text;
    setState(() {
      _isEmailValid = email.contains('@');
    });
    _onFormChanged();
  }

  void _onPasswordChanged() {
    final password = _passwordController.text;
    setState(() {
      _isPasswordValid = password.length >= 6;
    });
    _onFormChanged();
  }

  void _onFormChanged() {
    setState(() {
      _isFormValid = _isEmailValid && _isPasswordValid;
    });
  }

  void _onLoginButtonPressed(BuildContext context) {
    if (_isFormValid) {
      final email = _emailController.text;
      final password = _passwordController.text;
      BlocProvider.of<AuthBloc>(context).add(AuthLoginEvent(
        email: email,
        password: password,
      ));
    }
  }

  void _onToggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void showAboutDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Center(child: Text('Invalid email or password')),
        backgroundColor: Colors.red,
      ),
    );
  }

  bool _errorDisplayed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 80),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Center(
                          child:
                              Image.asset('assets/images/logo.png', width: 120),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'The ArchiTect',
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'email',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(),
                    errorText: _isEmailValid || _emailController.text.isEmpty
                        ? null
                        : 'Invalid email',
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.email,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        _emailController.clear();
                      },
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscure,
                  autofillHints: const [AutofillHints.password],
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'password',
                    border: const OutlineInputBorder(),
                    errorText:
                        _isPasswordValid || _passwordController.text.isEmpty
                            ? null
                            : 'Invalid password',
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    labelStyle: const TextStyle(color: Colors.black),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: _onToggleObscure,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (cxt, state) {
                    if (state is Authenticated) {
                      Navigator.push(
                        cxt,
                        MaterialPageRoute(
                          builder: (context) => const HomePage(),
                        ),
                      );
                    }
                    if (state is AuthError) {
                      showAboutDialog(context);
                    }
                  },
                  builder: (cotx, state) {
                    if (state is AuthLoading) {
                      return const SizedBox(
                        child: LoadingIndicator(),
                      );
                    } else {
                      return Column(
                        children: [
                          const SizedBox(height: 32),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                              onPressed: () {
                                _onLoginButtonPressed(context);
                                _errorDisplayed = !_errorDisplayed;
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Don\'t have an account?',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const SignUp(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
