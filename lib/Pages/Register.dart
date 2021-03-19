import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_tools/AppBarBlur.dart';

import 'Home.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController loginController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController invitationController;

  @override
  void initState() {
    loginController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    invitationController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    loginController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        appBar: AppBarBlur(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            centerTitle: true,
          ),
        ),
        body: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 256.0 * 1.5),
            child: Form(
              child: Builder(
                builder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: invitationController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Invitation Token',
                        ),
                      ),
                    ),
                    SizedBox.fromSize(size: Size.fromHeight(32.0)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: loginController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Login',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Email',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: 'Password',
                        ),
                        obscureText: true,
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          onPressed: () async {
                            Form.of(context).validate();
                            try {
                              var credentials = await AlexandrioAPI().registerUser(invitationToken: invitationController.text, login: loginController.text, email: emailController.text, password: passwordController.text);
                              await Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) => HomePage(
                                  credentials: credentials,
                                ),
                              ));
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(e),
                                ),
                              );
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text('Register'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
