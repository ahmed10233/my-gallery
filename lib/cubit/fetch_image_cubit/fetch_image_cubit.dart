import 'dart:convert';
import 'dart:io';
import 'package:auth_task/constant/constant.dart';
import 'package:auth_task/models/image_model.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart'; 

part 'fetch_image_state.dart';

class FetchImageCubit extends Cubit<FetchImageState> {
  FetchImageCubit() : super(FetchImageInitial());
  
  final ImagePicker picker = ImagePicker();
   late File selectedImage;  // To store the selected image
  
  String? token = Constants.userToken;
   String? baseUrl = Constants.baseUrl;

  Future<void> fetchImages() async {
    emit(FetchImagLoading());

    final url = Uri.parse('$baseUrl/my-gallery');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',  // Optional, helps specify the format
        },
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        ImageModel imageModel = ImageModel.fromJson(jsonResponse);

        if (imageModel.status == 'success' && imageModel.data != null) {
          emit(FetchImagSuccess(images: imageModel.data!.images!));
        } else {
          emit(FetchImagFailure(errorMessage: imageModel.message ?? 'Failed to load images'));
        }
      } else {
        emit(FetchImagFailure(errorMessage: 'Error: ${response.statusCode}'));
      }
    } catch (error) {
      emit(FetchImagFailure(errorMessage: 'An error occurred: $error'));
    }
  }

  // Pick image from Gallery
  Future<void> pickImageFromGallery() async {
    try {
      var pickedImage = await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        selectedImage = File(pickedImage.path);
        emit(PickImagSuccess(images: selectedImage));  // Emit success state with the image path
      } else {
        emit(PickImagFailure(errorMessage: 'No image selected'));
      }
    } catch (e) {
      emit(PickImagFailure(errorMessage: 'Error selecting image: $e'));
    }
  }

  // Pick image from Camera
  Future<void> pickImageFromCamera() async {
    try {
      var pickedImage = await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        selectedImage = File(pickedImage.path);
        emit(PickImagSuccess(images: selectedImage));  // Emit success state with the image path
      } else {
        emit(PickImagFailure(errorMessage: 'No image captured'));
      }
    } catch (e) {
      emit(PickImagFailure(errorMessage: 'Error capturing image: $e'));
    }
  }
}
