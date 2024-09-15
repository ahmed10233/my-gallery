import 'dart:convert';
import 'package:auth_task/constant/constant.dart';
import 'package:auth_task/main.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
part 'authcubit_state.dart';

class AuthCubit extends Cubit<AuthcubitState> {
  AuthCubit() : super(AuthcubitInitial());
 String? baseUrl = Constants.baseUrl;
  Future<void> login(TextEditingController emailController, TextEditingController passwordController) async {
    emit(LoginLoading());
    final url = Uri.parse('$baseUrl/login');

    // Extract text from the controllers
    String email = emailController.text;
    String password = passwordController.text;

    try {
      final response = await http.post(
        url,
        body: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);

        if (data.containsKey('error_message')) {
          // This is a failure response
          emit(LoginFailure(errorMessage: 'invaled email or password'));
        } else if (data.containsKey('user')) {
          sharedPref.setString("token", data["token"]);
          Constants.userToken = data["token"];
          emit(LoginSuccess());
        } else {
          // Handle unexpected response structure
          emit(LoginFailure(errorMessage: 'Unexpected response from the server'));
        }
      } else {
        // Handle non-200 responses (e.g., network errors, server errors)
        emit(LoginFailure(errorMessage: 'An error occurred: ${response.statusCode}'));
      }
    } catch (error) {
      // Emit failure state if there is an error
      emit(LoginFailure(errorMessage: 'An error occurred: $error'));
    }
  }
}
