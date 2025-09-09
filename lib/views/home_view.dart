import 'dart:io';

import 'package:akashic_system_ver2/translator/interface/deepl_translate_pt.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:akashic_system_ver2/components/image_widget.dart';
import 'package:akashic_system_ver2/models/recognition_response.dart';
import 'package:akashic_system_ver2/recognizer/interface/text_recognizer.dart';
import 'package:akashic_system_ver2/recognizer/tesseract_text_recognizer.dart';
import 'package:akashic_system_ver2/translator/deepl_translate_mod.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late ImagePicker _picker;
  late ITextRecognizer _recognizer;
  late txtTranslate _translated;

  RecognitionResponse? _response;
  
  @override
  void initState() {
    super.initState();
    _picker = ImagePicker();

    /// Can be [MLKitTextRecognizer] or [TesseractTextRecognizer]
    // _recognizer = MLKitTextRecognizer();
    _recognizer = TesseractTextRecognizer();
    _translated = translateReconizetext();
  }

  void processImage(String imgPath) async {
    final recognizedText = await _recognizer.processImage(imgPath);
    final translatedtxt = await _translated.translated(recognizedText);
    setState(() {
      _response = RecognitionResponse(
        imgPath: imgPath,
        recognizedText: recognizedText,
        translatedtxt: translatedtxt,
      );
    });
  }

  Future<String?> obtainImage(ImageSource source) async {
    final file = await _picker.pickImage(source: source);
    return file?.path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Text Recognition'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => imagePickAlert(
              onCameraPressed: () async {
                final imgPath = await obtainImage(ImageSource.camera);
                if (imgPath == null) return;
                Navigator.of(context).pop();
                processImage(imgPath);
              },
              onGalleryPressed: () async {
                final imgPath = await obtainImage(ImageSource.gallery);
                if (imgPath == null) return;
                Navigator.of(context).pop();
                processImage(imgPath);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: _response == null
          ? const Center(
              child: Text('Pick image to continue'),
            )
          : ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(File(_response!.imgPath)),
                ),
                Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Recognized Text",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(
                                  ClipboardData(
                                      text: _response!.recognizedText),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Copied to Clipboard'),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.copy),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(_response!.recognizedText),
                        const SizedBox(height: 10),
                        Text(_response!.translatedtxt)
                      ],
                    )),
              ],
            ),
    );
  }
}