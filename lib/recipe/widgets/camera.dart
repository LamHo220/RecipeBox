// import 'package:flutter/material.dart';
// import 'dart:async';
// import 'dart:io';

// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:recipe_box/common/constants/colors.dart';

// class Camera extends StatefulWidget {
//   final Widget? child;

//   Camera({required this.child});

//   @override
//   _CameraState createState() => _CameraState();
// }

// enum CameraState {
//   free,
//   picked,
//   cropped,
// }

// class _CameraState extends State<Camera> {
//   late CameraState state;
//   XFile? imageFile;

//   @override
//   void initState() {
//     super.initState();
//     state = CameraState.free;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         if (state == CameraState.free) _pickImage();
//         // else if (state == CameraState.picked)
//         //   _cropImage();
//         // else if (state == CameraState.cropped) _clearImage();
//       },
//       child:  widget.child,
//       ),
//     );
//   }

//   // Widget _buildButtonIcon() {
//   //   if (state == CameraState.free)
//   //     return Icon(Icons.add);
//   //   else if (state == CameraState.picked)
//   //     return Icon(Icons.crop);
//   //   else if (state == CameraState.cropped)
//   //     return Icon(Icons.clear);
//   //   else
//   //     return Container();
//   // }

//   Future _pickImage() async {
//     final _picker = ImagePicker();
//     imageFile = await _picker.pickImage(source: ImageSource.gallery);
//     print(132);
//     if (imageFile != null) {
//       setState(() {
//         print(123);
//         state = CameraState.picked;
//       });
//     }
//     // _cropImage();
//     setState(() {
//       state = CameraState.free;
//     });
//   }

//   Future _cropImage() async {
//     if (imageFile == null) {
//       return;
//     }
//     final _cropper = ImageCropper();
//     CroppedFile? croppedFile = await _cropper.cropImage(
//       sourcePath: imageFile!.path,
//       aspectRatioPresets: Platform.isAndroid
//           ? [
//               CropAspectRatioPreset.square,
//               CropAspectRatioPreset.ratio3x2,
//               CropAspectRatioPreset.original,
//               CropAspectRatioPreset.ratio4x3,
//               CropAspectRatioPreset.ratio16x9
//             ]
//           : [
//               CropAspectRatioPreset.original,
//               CropAspectRatioPreset.square,
//               CropAspectRatioPreset.ratio3x2,
//               CropAspectRatioPreset.ratio4x3,
//               CropAspectRatioPreset.ratio5x3,
//               CropAspectRatioPreset.ratio5x4,
//               CropAspectRatioPreset.ratio7x5,
//               CropAspectRatioPreset.ratio16x9
//             ],
//     );
//     if (croppedFile != null) {
//       imageFile = XFile(croppedFile.path);
//       setState(() {
//         state = CameraState.cropped;
//       });
//     }
//   }

//   void _clearImage() {
//     imageFile = null;
//     setState(() {
//       state = CameraState.free;
//     });
//   }
// }
