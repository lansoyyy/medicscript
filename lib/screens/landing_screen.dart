import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mediscript/screens/history_screen.dart';
import 'package:mediscript/screens/result_screen.dart';
import 'package:mediscript/utils/colors.dart';
import 'package:mediscript/widgets/text_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  var hasLoaded = false;

  bool textScanning = false;

  XFile? imageFile1;

  String scannedText = "";

  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;

  late String fileName = '';

  late File imageFile;

  late String imageURL = '';

  // Future<void> uploadPicture(String inputSource) async {
  //   final picker = ImagePicker();
  //   XFile pickedImage;

  //   pickedImage = (await picker.pickImage(
  //       source:
  //           inputSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
  //       maxWidth: 1920))!;

  //   fileName = path.basename(pickedImage.path);
  //   imageFile = File(pickedImage.path);

  //   try {
  //     showDialog(
  //       context: context,
  //       barrierDismissible: false,
  //       builder: (BuildContext context) => Padding(
  //         padding: const EdgeInsets.only(left: 30, right: 30),
  //         child: AlertDialog(
  //             title: Row(
  //           children: const [
  //             CircularProgressIndicator(
  //               color: Colors.black,
  //             ),
  //             SizedBox(
  //               width: 20,
  //             ),
  //             Text(
  //               'Loading . . .',
  //               style: TextStyle(
  //                   color: Colors.black,
  //                   fontWeight: FontWeight.bold,
  //                   fontFamily: 'QRegular'),
  //             ),
  //           ],
  //         )),
  //       ),
  //     );

  //     // await firebase_storage.FirebaseStorage.instance
  //     //     .ref('CoverPhoto/$fileName')
  //     //     .putFile(imageFile);
  //     // imageURL = await firebase_storage.FirebaseStorage.instance
  //     //     .ref('CoverPhoto/$fileName')
  //     //     .getDownloadURL();

  //     setState(() {
  //       hasLoaded = true;
  //     });

  //     Navigator.of(context)
  //         .push(MaterialPageRoute(builder: (context) => ResultScreen()));
  //     // } on firebase_storage.FirebaseException catch (error) {
  //     //   if (kDebugMode) {
  //     //     print(error);
  //     //   }
  //     // }
  //   } catch (err) {
  //     if (kDebugMode) {
  //       print(err);
  //     }
  //   }
  // }

  final stt.SpeechToText speech = stt.SpeechToText();
  String _text = '';

  @override
  void initState() {
    super.initState();
    initSpeechState();
  }

  Future<bool> initSpeechState() async {
    bool available = await speech.initialize(
      onStatus: (status) => print('onStatus: $status'),
      onError: (error) => print('onError: $error'),
    );
    return available;
  }

  void startListening() {
    if (!speech.isAvailable) {
      print('Speech recognition not available');
      return;
    }
    if (!speech.isListening) {
      speech.listen(
        onResult: (result) => setState(() {
          _text = result.recognizedWords;
        }),
      );
    }
  }

  void stopListening() {
    if (speech.isListening) {
      speech.stop();
    }
  }

  void getImage(ImageSource source) async {
    List<String> meds = [];
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile1 = pickedImage;

        CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: imageFile1!.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
            AndroidUiSettings(
                toolbarTitle: 'Cropper',
                toolbarColor: Colors.deepOrange,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            IOSUiSettings(
              title: 'Cropper',
            ),
            WebUiSettings(
              context: context,
            ),
          ],
        );

        final inputImage = InputImage.fromFilePath(croppedFile!.path);
        final textDetector = GoogleMlKit.vision.textDetector();
        RecognisedText recognisedText =
            await textDetector.processImage(inputImage);

        await textDetector.close();
        scannedText = "";

        for (TextBlock block in recognisedText.blocks) {
          for (TextLine line in block.lines) {
            List<String> words = line.text.split(' ');
            for (String word in words) {
              meds.add(word);
            }
          }
        }
        // for (TextBlock block in recognisedText.blocks) {
        //   for (TextLine line in block.lines) {
        //     setState(() {
        //       scannedText = "$scannedText${line.text}";
        //     });
        //   }
        // }

        print(meds);
        textScanning = false;

        await Future.delayed(const Duration(seconds: 2));

        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ResultScreen(
                  meds: meds,
                )));
      }
    } catch (e) {
      textScanning = false;
      imageFile1 = null;
      scannedText = "Error occured while scanning";

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => Padding(
          padding: const EdgeInsets.only(left: 30, right: 30),
          child: AlertDialog(
              title: Text(e.toString(),
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'QRegular'))),
        ),
      );
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
                    getImage(ImageSource.camera);
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
                    getImage(ImageSource.gallery);
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
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: (() {
                    // getImage(ImageSource.gallery);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HistoryScreen()));
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.history,
                        size: 54,
                        color: Colors.white,
                      ),
                      TextBold(
                          text: 'History', fontSize: 18, color: Colors.white),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    // getImage(ImageSource.gallery);
                    // Navigator.of(context).push(MaterialPageRoute(
                    //     builder: (context) => HistoryScreen()));
                    showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              title: TextBold(
                                  text: 'Result: $_text',
                                  fontSize: 18,
                                  color: Colors.black),
                              content: SizedBox(
                                height: 150,
                                child: Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.green),
                                      child: IconButton(
                                          onPressed: () {
                                            startListening();
                                          },
                                          icon: const Icon(
                                            Icons.start_rounded,
                                            color: Colors.white,
                                          )),
                                    ),
                                    const SizedBox(
                                      height: 30,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: Colors.red),
                                      child: IconButton(
                                          onPressed: () {
                                            stopListening();
                                          },
                                          icon: const Icon(
                                            Icons.stop_circle_rounded,
                                            color: Colors.white,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {},
                                    child: TextBold(
                                        text: 'Continue',
                                        fontSize: 18,
                                        color: Colors.blue))
                              ],
                            );
                          });
                        });
                  }),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.voice_chat,
                        size: 54,
                        color: Colors.white,
                      ),
                      TextBold(
                          text: 'Speech to Text',
                          fontSize: 12,
                          color: Colors.white),
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
