import 'dart:io';
import 'package:auth_task/constant/constant.dart';
import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';  // For filename extraction

part 'upload_image_state.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageInitial());
    String? token = Constants.userToken;
     String? baseUrl = Constants.baseUrl;
  Future<void> uploadImage(File imageFile, ) async {
    emit(UploadImagLoading());
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload'),
      );
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json', 
      });

      // Prepare the image for uploading
      request.files.add(
        await http.MultipartFile.fromPath(
          'img', 
          imageFile.path,
          filename: basename(imageFile.path), // Extracting the filename
        ),
      );

      var response = await request.send();

      if (response.statusCode == 200) {
        emit(UploadImagSuccess());
      } else {
        emit(UploadImagFailure(errorMessage: 'Failed to upload image.'));
      }
    } catch (e) {
      emit(UploadImagFailure(errorMessage: e.toString()));
    }
  }
}
