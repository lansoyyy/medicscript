import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mediscript/screens/result_screen.dart';
import 'package:mediscript/utils/colors.dart';
import 'package:mediscript/widgets/text_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class LandingScreen extends StatefulWidget {
  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  var hasLoaded = false;

  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  Future<void> uploadPicture(String inputSource) async {
    final picker = ImagePicker();
    XFile pickedImage;

    pickedImage = (await picker.pickImage(
        source:
            inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
        maxWidth: 1920))!;

    fileName = path.basename(pickedImage.path);
    imageFile = File(pickedImage.path);

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: AlertDialog(
              title: Row(
            children: const [
              CircularProgressIndicator(
                color: Colors.black,
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                'Loading . . .',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'QRegular'),
              ),
            ],
          )),
        ),
      );

      // await firebase_storage.FirebaseStorage.instance
      //     .ref('CoverPhoto/$fileName')
      //     .putFile(imageFile);
      // imageURL = await firebase_storage.FirebaseStorage.instance
      //     .ref('CoverPhoto/$fileName')
      //     .getDownloadURL();

      setState(() {
        hasLoaded = true;
      });

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ResultScreen()));
      // } on firebase_storage.FirebaseException catch (error) {
      //   if (kDebugMode) {
      //     print(error);
      //   }
      // }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset('assets/images/logo.jpg')),
            const SizedBox(
              height: 20,
            ),
            TextBold(text: 'MediScript', fontSize: 48, color: Colors.white),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (() {
                    uploadPicture('camera');
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.camera_alt_outlined,
                        size: 54,
                        color: Colors.white,
                      ),
                      TextBold(
                          text: 'Camera', fontSize: 18, color: Colors.white),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    uploadPicture('gallery');
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image_outlined,
                        size: 54,
                        color: Colors.white,
                      ),
                      TextBold(
                          text: 'Gallery', fontSize: 18, color: Colors.white),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
