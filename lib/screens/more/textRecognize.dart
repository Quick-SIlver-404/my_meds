// import 'package:google_ml_kit/google_ml_kit.dart';
// import 'package:image_picker/image_picker.dart';

// class ImageModel {
//   String? imagePath;
//   ImageModel({required this.imagePath});
// }


// class MediaService {
//   final ImagePicker _imagePicker = ImagePicker();
//   ImageModel? image;

//   Future<ImageModel?> pickImageFromGallery() async {
//     try {
//       final _image = await _imagePicker.pickImage(source: ImageSource.gallery);
//       final image = ImageModel(imagePath: _image!.path);
//       return image;
//     } catch (e) {
//       throw ImageNotSelectedException('Image not found');
//     }
//     // }
//   }
// }



// class MlService {
//   Future<List<RecognizedText>> getText(String path) async {
//     final inputImage = InputImage.fromFilePath(path);
//     final textDetector = GoogleMlKit.vision.textDetector();
//     final RecognisedText recognisedText =
//         await textDetector.processImage(inputImage);

//     List<RecognizedText> recognizedList = [];

//     for (TextBlock block in recognisedText.blocks) {
//       recognizedList.add(
//           RecognizedText(lines: block.lines, block: block.text.toLowerCase()));
//     }

//     return recognizedList;
//   }
// }


// class BaseException implements Exception {
//   String? message;
//   BaseException({this.message});
// }

// class ImageNotFoundException extends BaseException {
//   ImageNotFoundException(String message) : super(message: message);
// }

// class ImageNotSelectedException extends BaseException {
//   ImageNotSelectedException(String message) : super(message: message);
// }
