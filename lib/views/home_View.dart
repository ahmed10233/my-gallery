import 'package:auth_task/cubit/upload_image_cubit/upload_image_cubit.dart';
import 'package:auth_task/main.dart';
import 'package:auth_task/views/login_view.dart';
import 'package:auth_task/widgets/Button.dart';
import 'package:auth_task/widgets/text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_task/cubit/fetch_image_cubit/fetch_image_cubit.dart';
import 'package:auth_task/widgets/custom_image_card.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart'; // Assuming you have a widget to show an image

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override

  Widget build(BuildContext context) {
        bool isLoading = false;
    void showImageSourceDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Select Image From'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  ElevatedButton(
                    child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Camera',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    onPressed: () {
                      context.read<FetchImageCubit>().pickImageFromCamera();
                      Navigator.pop(
                          context); // Close the dialog after selection
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: Container(
                        alignment: Alignment.center,
                        child: const Text(
                          'Gallery',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        )),
                    onPressed: () {
                      context.read<FetchImageCubit>().pickImageFromGallery();
                      Navigator.pop(
                          context); // Close the dialog after selection
                    },
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 245, 183, 248),
        body: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome",
                    style: TextStyle(
                      color: Color(0xff4A4A4A),
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Baloo Thambi 2",
                    ),
                  ),
                  Text(
                    "Ahmed",
                    style: TextStyle(
                      color: Color(0xff4A4A4A),
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Baloo Thambi 2",
                    ),
                  )
                ],
              ),
              const SizedBox(height: 37),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomTextButton(
                    iconColor: const Color(0xffC83B3B),
                    icon: Icons.exit_to_app,
                    buttonColor: const Color(0xffFFFFFF),
                    onPressed: () {
                      // Log out logic
                      sharedPref.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginView(),
                        ),
                      );
                    },
                    text: "Log out",
                  ),
                  CustomTextButton(
                    icon: Icons.cloud_upload_rounded,
                    iconColor: const Color(0xffFFEB38),
                    buttonColor: const Color(0xffFFFFFF),
                    onPressed: () {
                      showImageSourceDialog(); // Pick an image directly
                    },
                    text: "Upload",
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<FetchImageCubit, FetchImageState>(
                  builder: (context, state) {
                    if (state is FetchImagLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FetchImagFailure) {
                      return Center(
                        child:
                            Text('Failed to load images: ${state.errorMessage}'),
                      );
                    } else if (state is PickImagSuccess) {
                      // Show the selected image
                      return Column(
                        children: [
                          BlocListener<UploadImageCubit, UploadImageState>(
                            listener: (context, state) {
                              if (state is UploadImagSuccess) {
                               
                                context.read<FetchImageCubit>().fetchImages();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Color.fromARGB(255, 1, 185, 38),
                                      content:
                                          Text('Image uploaded successfully')),
                                );
                                 isLoading = false;
                              } else if (state is UploadImagFailure) {
                               
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          'Upload failed: ${state.errorMessage}')),
                                );
                                 isLoading =false;
                              }else if (state is UploadImagLoading) {
                                isLoading =true;
                              }
                            },
                            child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.file(state.images))),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Button(
                                buttonWidth: 110,
                                buttonColor:
                                    const Color.fromARGB(210, 174, 81, 228),
                                onPressed: () {
                                  context.read<FetchImageCubit>().fetchImages();
                                },
                                text: "Cancel",
                              ),
                              Button(
                                buttonWidth: 110,
                                buttonColor:
                                    const Color.fromARGB(210, 174, 81, 228),
                                onPressed: () {
                                  showImageSourceDialog();
                                },
                                text: 'New',
                              ),
                              Button(
                                buttonWidth: 110,
                                buttonColor:
                                    const Color.fromARGB(210, 174, 81, 228),
                                onPressed: () {
                                  final pickedImage = state.images; // Get the picked image file
                                  context.read<UploadImageCubit>().uploadImage(pickedImage);
                                  
                                },
                                text: "Upload",
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (state is FetchImagSuccess) {
                      if (state.images.isNotEmpty) {
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 24.0,
                            mainAxisSpacing: 24.0,
                          ),
                          itemCount: state.images.length,
                          itemBuilder: (context, index) {
                            return CustomImageCard(imageUrl: state.images[index]);
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('No images found.'),
                        );
                      }
                    }
                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // // Method to show dialog for choosing between Gallery and Camera
  // void showPickerDialog(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Select source'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               leading: const Icon(Icons.photo),
  //               title: const Text('Gallery'),
  //               onTap: () {
  //                 context.read<FetchImageCubit>().pickImageFromGallery();
  //                 Navigator.pop(context); // Close the dialog after selection
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.camera_alt),
  //               title: const Text('Camera'),
  //               onTap: () {
  //                 context.read<FetchImageCubit>().pickImageFromCamera();
  //                 Navigator.pop(context); // Close the dialog after selection
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
