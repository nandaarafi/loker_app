import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lokerapps/core/constants/colors.dart';
import 'package:lokerapps/core/routes/constants.dart';
import 'package:lokerapps/core/routes/routes.dart';
import 'package:lokerapps/core/widgets/custom_dialog.dart';
import 'package:provider/provider.dart';

import '../cubit/auth/auth_cubit.dart';
import '../provider/password_vis_provider.dart';


class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignInScreenState();
  
}

class _SignInScreenState extends State<SignInScreen>{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "Hai Selamat Datang",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "Harap Login Untuk Melanjutkan",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.left,
                  ),
              emailTextField(),
              PasswordTextField(passwordController: passwordController),
              SizedBox(height: 15),
              ButtonLogin(formKey: formKey, emailController: emailController, passwordController: passwordController),
              DaftarButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container emailTextField() {
    return Container(
              margin: const EdgeInsets.all(8),
              padding:
              const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: LColors.primary.withOpacity(0.2)
              ),
              child: TextFormField(
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15
                ),
                controller: emailController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "email is required";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  icon: const Icon(Icons.email),
                  border: InputBorder.none,
                  labelText: "Email",
                  labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15
                  )
                ),
              ),

            );
  }
}

class DaftarButton extends StatelessWidget {
  const DaftarButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Tidak Punya Akun?"),
        TextButton(
            onPressed: () {
            AppRouter.router.go(Routes.signUpNamedPage);
              },
            child: const Text("DAFTAR",
              style: TextStyle(
                  color: LColors.secondary
              ),
            )
        )
      ],
    );
  }
}

class ButtonLogin extends StatelessWidget {
  const ButtonLogin({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          AppRouter.router.go(Routes.controlScreenNamedPage);
          // Get.to(Routes.homeNamedPage);
        } else if (state is AuthFailed) {
          // DHelperFunctions.dismissKeyboard(context);
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
          width: MediaQuery.of(context).size.width * .9,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: LColors.secondary
          ),
          child: TextButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  context.read<AuthCubit>().signInRole(
                    email: emailController.text,
                    password: passwordController.text,
                  );
                }
              },
              child: const Text(
                "LOGIN",
                style: TextStyle(color: Colors.white),
              )),
        );
      },
    );
  }
}

class PasswordTextField extends StatelessWidget {
  const PasswordTextField({
    super.key,
    required this.passwordController,
  });

  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding:
      const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: LColors.primary.withOpacity(0.2)
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
                  labelText: "Password",
                  labelStyle: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 15
                  ),
                  suffixIcon: IconButton(
                      onPressed: () {
                        passwordVisibilityProvider.toggleObscureText();
                      },
                      icon: Icon(passwordVisibilityProvider.obscureText
                          ? Icons.visibility
                          : Icons.visibility_off))),
            );
          }
      ),
    );
  }
}