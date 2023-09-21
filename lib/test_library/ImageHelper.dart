import 'package:image_picker/image_picker.dart';

class ImageHelper{
  final ImagePicker _imagePicker;

  ImageHelper({ImagePicker? imagePicker
  })
      :
        _imagePicker =imagePicker ??  ImagePicker();
  Future<List<XFile>> pickImage(
  {
    ImageSource source=ImageSource.gallery,
    int imageQuality=100,
    bool multiple =false
  })
  async{
    if(multiple)
      {
        return await _imagePicker.pickMultiImage(imageQuality: imageQuality);
      }
   final file= await _imagePicker.pickImage(source: source,imageQuality: imageQuality);
   if(file !=null)  return [file];
   return [];
  }

}