import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokerapps/core/constants/colors.dart';
import 'package:lokerapps/core/routes/constants.dart';
import 'package:lokerapps/core/routes/routes.dart';
import 'package:lokerapps/core/widgets/custom_dialog.dart';
import 'package:lokerapps/features/presentation/provider/password_vis_provider.dart';
import 'package:provider/provider.dart';

import '../cubit/auth/auth_cubit.dart';


class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignUpScreenState();

}

class _SignUpScreenState extends State<SignUpScreen>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                      "Daftar Akun Baru",
                      style: TextStyle(
                        fontSize: 40,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: LColors.primary.withOpacity(.2)
                    ),
                    child: TextFormField(
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 15
                      ),
                      controller: emailController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "username is required";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.email),
                        border: InputBorder.none,
                        hintText: "Email",
                      ),
                    ),
                  ),

                  //Password field
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: LColors.primary.withOpacity(.2)
                    ),
                    child: Consumer<PasswordVisibilityProvider>(
                        builder: (context, passwordVisibilityProvider, _) {
                          return TextFormField(
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontSize: 15
                            ),
                            controller: passwordController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "password is required";
                              }
                              return null;
                            },
                            obscureText: !passwordVisibilityProvider.obscureText,
                            decoration: InputDecoration(
                              icon: const Icon(Icons.lock),
                              border: InputBorder.none,
                              hintText: "Password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  passwordVisibilityProvider.toggleObscureText();
                                },
                                icon: Icon(passwordVisibilityProvider.obscureText
                                    ? Icons.visibility
                                    : Icons.visibility_off
                                ),
                              ),
                            ),
                          );
                        }
                    ),
                  ),

                  const SizedBox(height: 10),
                  //Login button
                  BlocConsumer<AuthCubit, AuthState>(
                    listener: (context, state) {
                      if (state is AuthSuccess) {
                        CustomShowDialog.showOnPressedDialog(
                            context,
                            title: "Sukses",
                            message: "Sukses Mendaftar",
                            isCancel: false,
                            onPressed: (){
                              AppRouter.router.go(Routes.controlScreenNamedPage);
                            }
                        );
                      } else if (state is AuthFailed) {
                        // NHelperFunctions.dismissKeyboard(context);
                        CustomShowDialog.showCustomDialog(
                            context,
                            title: "Error",
                            message: state.error,
                            isCancel: false
                        );
                      }
                      },
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return Container(
                        height: 55,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * .9,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: LColors.secondary
                        ),
                        child: TextButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                context.read<AuthCubit>().signUp(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }
                            },
                            child: const Text(
                              "DAFTAR",
                              style: TextStyle(color: Colors.white),
                            )),
                      );
                    },
                  ),
                  //Sign up button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Sudah punya akun?"),
                      TextButton(
                        onPressed: () {
                          AppRouter.router.go(Routes.rootSignInNamedPage);
                        },
                        child: const Text("LOGIN",
                          style: TextStyle(
                              color: LColors.secondary
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}