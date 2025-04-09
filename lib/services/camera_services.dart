import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> takePhoto() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      return await _picker.pickImage(source: ImageSource.camera);
    } else {
      throw Exception('Camera permission denied');
    }
  }
}
