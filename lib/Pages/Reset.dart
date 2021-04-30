import 'package:alexandrio_app/API/Alexandrio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ui_tools/AppBarBlur.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPage extends StatefulWidget {
  @override
  _ResetPageState createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
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
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: AppLocalizations.of(context).emailField,
                        ),
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
                              await AlexandrioAPI().requestRecoveryEmail(email: emailController.text);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(AppLocalizations.of(context).sendEmailCodeSnack),
                                ),
                              );
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
                            child: Text(AppLocalizations.of(context).sendEmailCodeButton),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 32.0),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: codeController,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: AppLocalizations.of(context).resetCodeField,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          labelText: AppLocalizations.of(context).newPasswordField,
                        ),
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
                              await AlexandrioAPI().accountRecovery(
                                email: emailController.text,
                                code: codeController.text,
                                password: passwordController.text,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(AppLocalizations.of(context).accountRecoveredSnack),
                                ),
                              );
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
                            child: Text(AppLocalizations.of(context).resetPasswordButton),
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
