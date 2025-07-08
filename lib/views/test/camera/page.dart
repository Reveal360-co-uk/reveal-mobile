
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:reveal/configs/layout.dart';
import 'package:reveal/services/file_service.dart';

class CameraTestPage extends StatefulWidget {
  const CameraTestPage({super.key});

  @override
  State<CameraTestPage> createState() => _CameraTestPageState();
}

class _CameraTestPageState extends State<CameraTestPage> {
  late CameraController cameraController;
  String refImageUrl = "assets/images/ref-01.jpg";
  String ref2ImageUrl = "assets/images/ref-02.jpg";
  FileService fileService = FileService();
  //File? matchingImage;

  @override
  void initState() {
    // fileService.getImageFileFromAssets(refImageUrl).then((refImage) {
    //   matchingImage = refImage;
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ARAppLayout(children: [compareImage()]);
  }

  Widget compareImage() {
    // fileService.getImageFileFromAssets(refImageUrl).then((refImage) {
    //   fileService.getImageFileFromAssets(ref2ImageUrl).then((ref2Image) {
    //     compareImages(src1: refImage, src2: ref2Image).then((value) {
    //       print(value);
    //       setState(() {
    //         matchingImage = refImage;
    //       });
    //     });
    //   });
    // });
    // String currentDirectory = "";

    // var a = Image.asset(refImageUrl);
    // var b = Image.asset(refImageUrl);

    // compareImages(src1: a, src2: b).then((value) {
    //   print(value);
    // });

    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      // child:
      //     matchingImage != null
      //         ? Image(image: FileImage(matchingImage!))
      //         : null,
    );
  }

  Future<void> inistialiseCameraAndStartTakingPhotos() async {
    final cameras = await availableCameras();

    final CameraDescription front = cameras.firstWhere(
      (element) => element.lensDirection == CameraLensDirection.front,
    );

    cameraController = CameraController(front, ResolutionPreset.low);
    await cameraController.initialize();

    cameraController.startImageStream((cameraImage) async {
      // Feed image into ML
    });
  }
}
