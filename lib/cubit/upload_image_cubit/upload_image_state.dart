part of 'upload_image_cubit.dart';

abstract class UploadImageState  {}

class UploadImageInitial extends UploadImageState {}

class UploadImagLoading extends UploadImageState {}

class UploadImagSuccess extends UploadImageState {}

class UploadImagFailure extends UploadImageState {
  final String errorMessage;

  UploadImagFailure({required this.errorMessage});
}
