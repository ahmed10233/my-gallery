import 'dart:ui'; // Required for BackdropFilter
import 'package:auth_task/cubit/authcubit/authcubit_cubit.dart';
import 'package:auth_task/views/home_View.dart';
import 'package:auth_task/widgets/Button.dart';
import 'package:auth_task/widgets/CustomTextField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    TextEditingController email = TextEditingController();
    TextEditingController password = TextEditingController();

    return BlocConsumer<AuthCubit, AuthcubitState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginSuccess) {
          BlocProvider.of<AuthCubit>(context).login(email, password);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: ((context) => const HomeView()),
            ),
          );
          Fluttertoast.showToast(
            msg: 'Success ✅',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color.fromARGB(255, 1, 185, 38),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            fontSize: 16.0,
          );
          isLoading = false;
        } else if (state is LoginFailure) {
          Fluttertoast.showToast(
            msg: state.errorMessage,
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: const Color.fromARGB(255, 1, 185, 38),
            textColor: const Color.fromARGB(255, 196, 7, 70),
            fontSize: 16.0,
          );
          isLoading = false;
        }
      },
      builder: (context, state) {
        return ModalProgressHUD(
          inAsyncCall: isLoading,
          child: Scaffold(
            body: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      "assets/images/Screenshot 2024-09-11 190032.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: SingleChildScrollView(
                  // Enables scrolling
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16), // Adds some padding
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "My",
                        style: TextStyle(
                          color: Color(0xff4A4A4A),
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Segoe UI',
                        ),
                      ),
                      const Text(
                        "Gallery",
                        style: TextStyle(
                          color: Color(0xff4A4A4A),
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Segoe UI',
                        ),
                      ),
                      const SizedBox(height: 20),
                      // Blurred container
                      ClipRRect(
                        borderRadius: BorderRadius.circular(
                            32), // Match the container's border radius
                        child: BackdropFilter(
                          filter: ImageFilter.blur(
                              sigmaX: 10.0, sigmaY: 10.0), // Apply the blur
                          child: Container(
                            width: 345,
                            decoration: BoxDecoration(
                              color: Colors.white
                                  .withOpacity(0.4), // Semi-transparent white
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 38),
                                const Text(
                                  "LOG IN",
                                  style: TextStyle(
                                    color: Color(0xff4A4A4A),
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Segoe UI',
                                  ),
                                ),
                                const SizedBox(height: 38),
                                CustomTextField(
                                  contloller: email,
                                  hintText: "User Name",
                                ),
                                const SizedBox(height: 38),
                                CustomTextField(
                                  contloller: password,
                                  hintText: "Password",
                                ),
                                const SizedBox(height: 38),
                                Button(
                                  text: 'SUBMIT',
                                  buttonColor: const Color(0xff7BB3FF),
                                  onPressed: () {
                                    if (email.text.isNotEmpty &&
                                        password.text.isNotEmpty) {
                                      BlocProvider.of<AuthCubit>(context)
                                          .login(email, password);
                                    }else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please Enter your email and password'),
                        ),
                      );
                     
                    }
                                  },
                                ),
                                const SizedBox(height: 41),
                              ],
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
      },
    );
  }
}
