

class RecognitionResponse {
  final String imgPath;
  final String recognizedText;
  final String translatedtxt;

  RecognitionResponse({
    required this.imgPath,
    required this.recognizedText,
    required this.translatedtxt
    
  });

  @override
  bool operator ==(covariant RecognitionResponse other) {
    if (identical(this, other)) return true;

    return other.imgPath == imgPath && other.recognizedText == recognizedText && other.translatedtxt == recognizedText;
  }

  @override
  int get hashCode => imgPath.hashCode ^ recognizedText.hashCode ^ translatedtxt.hashCode;
}