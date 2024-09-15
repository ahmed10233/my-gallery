import 'package:auth_task/cubit/authcubit/authcubit_cubit.dart';
import 'package:auth_task/cubit/fetch_image_cubit/fetch_image_cubit.dart';
import 'package:auth_task/cubit/upload_image_cubit/upload_image_cubit.dart';
import 'package:auth_task/views/home_View.dart';
import 'package:auth_task/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

late SharedPreferences sharedPref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide AuthCubit

        BlocProvider(
          create: (context) => AuthCubit(),
        ),
        // Provide FetchImageCubit
        BlocProvider(
          create: (context) => FetchImageCubit()..fetchImages(),
        ),
         BlocProvider(
          create: (context) => UploadImageCubit(),
        ),
      
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: sharedPref.getString("token") == null
            ? const LoginView()
            : const HomeView(),
      ),
    );
  }
}
