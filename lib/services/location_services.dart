import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  Future<Position> getCurrentLocation() async {
    final permission = await Permission.location.status;
    if (!permission.isGranted) {
      final newPermission = await Permission.location.request();
      if (!newPermission.isGranted) {
        throw Exception('Izin lokasi tidak diberikan');
      }
    }

    return await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.best,
    );
  }
}
