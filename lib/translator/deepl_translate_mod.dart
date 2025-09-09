import 'package:deepl_dart/deepl_dart.dart';
import 'interface/deepl_translate_pt.dart';

class translateReconizetext extends txtTranslate{
  Translator translator = Translator(authKey: '4f4dbb6f-6051-4c66-978c-974fe566dbf2:fx');
  @override
  Future <String> translated(String recog)async{
    final result =
      await translator.translateTextSingular(recog, 'en-US'); 
    String present= result.toString();
    
    print(present);
    return present;
  }
 
}