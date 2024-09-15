part of 'fetch_image_cubit.dart';

abstract class FetchImageState {}

class FetchImageInitial extends FetchImageState {}

class FetchImagLoading extends FetchImageState {}

class FetchImagSuccess extends FetchImageState {
  final List<String> images;

  FetchImagSuccess({required this.images});
}

class FetchImagFailure extends FetchImageState {
  final String errorMessage;

  FetchImagFailure({required this.errorMessage});
}

class PickImagLoading extends FetchImageState {}

class PickImagSuccess extends FetchImageState {
  final File images;

 PickImagSuccess({required this.images});
}

class PickImagFailure extends FetchImageState {
  final String errorMessage;

 PickImagFailure({required this.errorMessage});
}
