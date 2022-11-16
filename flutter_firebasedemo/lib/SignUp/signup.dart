import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebasedemo/Bloc/bloc/bloc.dart';
import 'package:flutter_firebasedemo/Bloc/event/event.dart';
import 'package:flutter_firebasedemo/Bloc/state/state.dart';
import 'package:flutter_firebasedemo/Deshbord/deshboard.dart';
import 'package:flutter_firebasedemo/SignIn/signin.dart';

import '../repo/auth_repo.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
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
                  "Sign Up",
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
                            height: 20,
                          ),
                          TextFormField(
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
                            height: 20,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.3,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Sign Up'),
                            ),
                          )
                        ],
                      )),
                ),
                SizedBox(
                  height: 10,
                ),
                Text("Already have an account?"),
                SizedBox(
                  height: 10,
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BlocProvider(
                                create: (context) =>  AuthBloc( authRepository: AuthRepository()),
                                child: SignIn(),
                              )),
                    );
                  },
                  child: Text("Sign In"),
                ),
                Text("Or"),
                IconButton(
                    onPressed: () {
                      _authenticateWithGoogle(context);
                    },
                    icon: Image.asset(
                      "assets/images/google.png",
                      height: 30,
                      width: 30,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        SignUpRequested(_emailController.text, _passwordController.text),
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
    appBar: AppBar(
      title: const Text("SignUp"),
    ),
    body: BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => Deshboard(),
            ),
          );
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error)));
        }
      },
      builder: (context, state) {
        if (state is Loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is UnAuthenticated) {
          return Center(child: Text("okk"));
        }
        return Container();
      },
    ),
  );
}
