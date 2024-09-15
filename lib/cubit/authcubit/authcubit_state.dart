part of 'authcubit_cubit.dart';

abstract class AuthcubitState {}

class AuthcubitInitial extends AuthcubitState {}

class LoginLoading extends AuthcubitState {}

class LoginSuccess extends AuthcubitState {}

class LoginFailure extends AuthcubitState {
  final String errorMessage;
  LoginFailure({required this.errorMessage});
}
