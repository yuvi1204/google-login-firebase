import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebasedemo/Bloc/bloc/bloc.dart';
import 'package:flutter_firebasedemo/Bloc/event/event.dart';
import 'package:flutter_firebasedemo/Bloc/state/state.dart';
import 'package:flutter_firebasedemo/Deshbord/deshboard.dart';
import 'package:flutter_firebasedemo/SignUp/signup.dart';

import '../repo/auth_repo.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: EdgeInsets.all(20),
            child: SingleChildScrollView(
              reverse: true,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 38,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: "Email",
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return value != null &&
                                        !EmailValidator.validate(value)
                                    ? 'Enter a valid email'
                                    : null;
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              keyboardType: TextInputType.text,
                              controller: _passwordController,
                              decoration: const InputDecoration(
                                hintText: "Password",
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                return value != null && value.length < 6
                                    ? "Enter min. 6 characters"
                                    : null;
                              },
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text('Sign In'),
                              ),
                            )
                          ],
                        )),
                  ),
                  IconButton(
                      onPressed: () {
                        _authenticateWithGoogle(context);
                      },
                      icon: Image.asset(
                        "assets/images/google.png",
                        height: 30,
                        width: 30,
                      )),
                  Text("Don't have an account?"),
                  SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BlocProvider(
                                  create: (context) =>  AuthBloc( authRepository: AuthRepository()),
                                  child: SignUp(),
                                )),
                      );
                    },
                    child: Text("Sign Up"),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
   
      BlocProvider.of<AuthBloc>(context).add(
        SignInRequested(_emailController.text, _passwordController.text),
      );
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleSignInRequested(),
    );
  }
}

Widget build(BuildContext context) {
  return Scaffold(
    body: BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => Deshboard()));
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if (state is Loading) {
            
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is UnAuthenticated) {
            return Center(
              child: Text("ok"),
            );
          }
          return Container();
        },
      ),
    ),
  );
}
